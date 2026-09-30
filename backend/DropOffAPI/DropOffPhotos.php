<?php

$photoName = $_GET["name"] ?? null;

if (!$photoName) {
    http_response_code(400);
    exit;
}


// aku pake yg gratisan jadi terbatas untuk request nya 
$apiKey = "API_KEY_GOOGLE_PLACES";

$url =
    "https://places.googleapis.com/v1/" .
    $photoName .
    "/media?maxWidthPx=600&maxHeightPx=400&key=" .
    $apiKey;

$ch = curl_init($url);

curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);

$image = curl_exec($ch);

$contentType = curl_getinfo(
    $ch,
    CURLINFO_CONTENT_TYPE
);

$httpCode = curl_getinfo(
    $ch,
    CURLINFO_HTTP_CODE
);

curl_close($ch);

if ($httpCode !== 200 || !$image) {
    http_response_code(404);
    exit;
}

header(
    "Content-Type: " .
    ($contentType ?: "image/jpeg")
);

echo $image;