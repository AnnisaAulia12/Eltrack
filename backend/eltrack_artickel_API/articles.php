<?php

header("Content-Type: application/json");

$category = $_GET["category"] ?? "organic";

//bebas pakai dr mana aja  , aku dr GNEWS
$apiKey = "api new kamu , bebas dr mana";

switch ($category) {
    case "organic":
        $query = "organic waste OR composting OR food waste";
        break;

    case "non_organic":
        $query = "plastic recycling OR glass recycling OR metal waste";
        break;

    case "k3":
        $query = '"hazardous waste" OR "battery disposal" OR "electronic waste" OR "chemical waste" OR "medical waste"';
        break;

    default:
        echo json_encode([
            "success" => false,
            "message" => "invalid category"
        ]);
        exit;
}

$url = "https://gnews.io/api/v4/search?"
    . "q=" . urlencode($query)
    . "&lang=en"
    . "&max=10"
    . "&apikey=" . $apiKey;

$response = file_get_contents($url);

if ($response === false) {
    echo json_encode([
        "success" => false,
        "message" => "failed to fetch articles"
    ]);
    exit;
}

$data = json_decode($response, true);

echo json_encode([
    "success" => true,
    "category" => $category,
    "articles" => $data["articles"] ?? []
]);
