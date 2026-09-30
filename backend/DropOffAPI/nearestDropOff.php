<?php

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

$latitude = $data["latitude"] ?? null;
$longitude = $data["longitude"] ?? null;

if ($latitude === null || $longitude === null) {
    echo json_encode([
        "success" => false,
        "message" => "latitude and longitude are required"
    ]);
    exit;
}


$apiKey = "GOOGLE API KAMUUUU";

$queries = [
    "bank sampah",
    "recycling center",
    "waste disposal",
    "waste collection point",
    "scrap yard"
];

$allPlaces = [];

foreach ($queries as $query) {

    $url = "https://places.googleapis.com/v1/places:searchText";

    $requestBody = [
        "textQuery" => $query,

        "maxResultCount" => 10,

        "locationBias" => [
            "circle" => [
                "center" => [
                    "latitude" => (float) $latitude,
                    "longitude" => (float) $longitude
                ],
                "radius" => 10000.0
            ]
        ],

        "languageCode" => "id"
    ];

    $headers = [
        "Content-Type: application/json",
        "X-Goog-Api-Key: " . $apiKey,
        "X-Goog-FieldMask: places.id,places.displayName,places.formattedAddress,places.location,places.rating,places.photos"
    ];

    $ch = curl_init($url);

    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt(
        $ch,
        CURLOPT_POSTFIELDS,
        json_encode($requestBody)
    );

    $response = curl_exec($ch);

    $httpCode = curl_getinfo(
        $ch,
        CURLINFO_HTTP_CODE
    );

    curl_close($ch);

    if ($httpCode !== 200 || !$response) {
        continue;
    }

    $result = json_decode($response, true);

    $places = $result["places"] ?? [];

    foreach ($places as $place) {

        if (!isset($place["id"])) {
            continue;
        }

        // ID digunakan supaya tempat yang sama
        // tidak masuk berkali-kali
        $allPlaces[$place["id"]] = $place;
    }
}



function calculateDistance(
    $lat1,
    $lon1,
    $lat2,
    $lon2
) {
    $earthRadius = 6371;

    $latDelta =
        deg2rad($lat2 - $lat1);

    $lonDelta =
        deg2rad($lon2 - $lon1);

    $a =
        sin($latDelta / 2) *
        sin($latDelta / 2) +

        cos(deg2rad($lat1)) *
        cos(deg2rad($lat2)) *

        sin($lonDelta / 2) *
        sin($lonDelta / 2);

    $c =
        2 * atan2(
            sqrt($a),
            sqrt(1 - $a)
        );

    return $earthRadius * $c;
}



$placesWithDistance = [];

foreach ($allPlaces as $place) {

    if (
        !isset($place["location"]["latitude"]) ||
        !isset($place["location"]["longitude"])
    ) {
        continue;
    }

    $placeLatitude =
        $place["location"]["latitude"];

    $placeLongitude =
        $place["location"]["longitude"];

    $distance = calculateDistance(
        $latitude,
        $longitude,
        $placeLatitude,
        $placeLongitude
    );



    if ($distance <= 10) {

        $place["distance_km"] =
            round($distance, 2);

        $placesWithDistance[] =
            $place;
    }
}



usort(
    $placesWithDistance,
    function ($a, $b) {
        return $a["distance_km"]
            <=> $b["distance_km"];
    }
);



$placesWithDistance =
    array_slice(
        $placesWithDistance,
        0,
        10
    );


echo json_encode([
    "success" => true,
    "total_before_filter" => count($allPlaces),
    "count" => count($placesWithDistance),
    "places" => $placesWithDistance
]);