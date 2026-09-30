<?php

header("Content-Type: application/json");

require_once __DIR__ . "/../gemini/gemini_config.php";
require_once __DIR__ . "/../db.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    echo json_encode([
        "success" => false,
        "message" => "POST method required"
    ]);
    exit;
}

if (!isset($_FILES["image"])) {
    echo json_encode([
        "success" => false,
        "message" => "Image is required"
    ]);
    exit;
}

$image = $_FILES["image"];

if ($image["error"] !== UPLOAD_ERR_OK) {
    echo json_encode([
        "success" => false,
        "message" => "Image upload failed"
    ]);
    exit;
}

$itemResult = $conn->query("
    SELECT DISTINCT item_name, waste_category
    FROM recycling_ideas
");

$dbItems = [];

while ($row = $itemResult->fetch_assoc()) {
    $dbItems[] = [
        "item_name" => $row["item_name"],
        "waste_category" => $row["waste_category"]
    ];
}

if (empty($dbItems)) {
    echo json_encode([
        "success" => false,
        "message" => "No recycling items available in database"
    ]);
    exit;
}


$candidateLines = [];

foreach ($dbItems as $item) {
    $candidateLines[] =
        $item["item_name"] .
        " (" .
        $item["waste_category"] .
        ")";
}

$candidateText = implode("\n", $candidateLines);

$imagePath = $image["tmp_name"];

$imageData = file_get_contents($imagePath);

if ($imageData === false) {
    echo json_encode([
        "success" => false,
        "message" => "Failed to read image"
    ]);
    exit;
}

$mimeType = mime_content_type($imagePath);

$base64Image = base64_encode($imageData);


$prompt = <<<PROMPT

Analyze the main waste object in this image.

First, identify the object naturally.

Then determine whether it matches one of the recycling
items currently available in the application's database.

Available database items:

$candidateText

Return JSON only using this structure:

{
  "object": "natural name of detected object",
  "material": "main material",
  "category": "organic, non_organic, k3, or unknown",
  "matched_item": "database item_name or null"
}

Rules:

- Identify the real object visible in the image.
- Do not restrict object recognition to the database list.
- "object" should be a natural human-readable name.

- "material" should describe the main material.

- "category" must be one of:
  organic
  non_organic
  k3
  unknown

- For matched_item:
  choose ONLY an item_name from the database list above.

- If the detected object reasonably corresponds to one
  of the database items, return that exact item_name.

- If no database item reasonably matches,
  matched_item must be null.

- Do not invent item names.

- Do not include markdown.

- Return valid JSON only.

PROMPT;

$requestBody = [
    "contents" => [
        [
            "parts" => [
                [
                    "text" => $prompt
                ],
                [
                    "inline_data" => [
                        "mime_type" => $mimeType,
                        "data" => $base64Image
                    ]
                ]
            ]
        ]
    ]
];

$model = "gemini-3.6-flash";

$url =
    "https://generativelanguage.googleapis.com/v1beta/models/" .
    $model .
    ":generateContent?key=" .
    urlencode($GEMINI_API_KEY);

$ch = curl_init($url);

curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST => true,

    CURLOPT_HTTPHEADER => [
        "Content-Type: application/json"
    ],

    CURLOPT_POSTFIELDS => json_encode($requestBody),

    CURLOPT_CONNECTTIMEOUT => 10,
    CURLOPT_TIMEOUT => 45,

    CURLOPT_IPRESOLVE => CURL_IPRESOLVE_V4
]);

$response = curl_exec($ch);

if ($response === false) {

    $curlError = curl_error($ch);

    curl_close($ch);

    echo json_encode([
        "success" => false,
        "message" => "Gemini request failed",
        "error" => $curlError
    ]);

    exit;
}

$httpCode =
    curl_getinfo(
        $ch,
        CURLINFO_HTTP_CODE
    );

curl_close($ch);

$geminiResponse =
    json_decode($response, true);

if ($httpCode !== 200) {

    echo json_encode([
        "success" => false,
        "message" => "Gemini API returned an error",
        "status_code" => $httpCode,
        "api_response" => $geminiResponse
    ]);

    exit;
}

$text =
    $geminiResponse["candidates"][0]
    ["content"]["parts"][0]["text"]
    ?? null;

if ($text === null) {

    echo json_encode([
        "success" => false,
        "message" => "Gemini returned no recognition result"
    ]);

    exit;
}

$text = trim($text);

$text = preg_replace(
    '/^```json\s*|\s*```$/i',
    '',
    $text
);

$recognition =
    json_decode($text, true);

if (!is_array($recognition)) {

    echo json_encode([
        "success" => false,
        "message" => "Invalid recognition response",
        "raw_result" => $text
    ]);

    exit;
}

$objectDetected =
    $recognition["object"]
    ?? "unknown";

$materialDetected =
    $recognition["material"]
    ?? "unknown";

$categoryDetected =
    $recognition["category"]
    ?? "unknown";

$matchedItem =
    $recognition["matched_item"]
    ?? null;

$validItemNames = [];

foreach ($dbItems as $item) {
    $validItemNames[] = $item["item_name"];
}

if (
    $matchedItem !== null &&
    !in_array(
        $matchedItem,
        $validItemNames,
        true
    )
) {
    $matchedItem = null;
}

$ideas = [];

if ($matchedItem !== null) {

    $ideaStmt = $conn->prepare("
        SELECT
            id,
            item_name,
            waste_category,
            title,
            materials,
            tools,
            steps,
            difficulty,
            estimated_minutes,
            image_url,
            reward_points
        FROM recycling_ideas
        WHERE item_name = ?
    ");

    $ideaStmt->bind_param(
        "s",
        $matchedItem
    );

    $ideaStmt->execute();

    $ideaResult =
        $ideaStmt->get_result();

    while (
        $row =
        $ideaResult->fetch_assoc()
    ) {
        $ideas[] = $row;
    }

    $ideaStmt->close();
}

echo json_encode([
    "success" => true,

    "recognition" => [
        "object" => $objectDetected,
        "material" => $materialDetected,
        "category" => $categoryDetected
    ],

    "matched_item" => $matchedItem,

    "ideas" => $ideas
]);

$conn->close();

?>