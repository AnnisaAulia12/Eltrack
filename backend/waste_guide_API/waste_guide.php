<?php

header("Content-Type: application/json");

require_once "../db.php";

$category = $_GET["category"] ?? "";
$typeName = $_GET["type_name"] ?? "";

if (empty($category) || empty($typeName)) {
    echo json_encode([
        "success" => false,
        "message" => "category and type_name are required"
    ]);
    exit;
}

$stmt = $conn->prepare("
    SELECT
        id,
        category,
        type_name,
        what_is_it,
        common_items,
        why_it_matters,
        how_to_sort,
        best_handling,
        what_to_avoid,
        sustainable_action
    FROM waste_guides
    WHERE category = ?
      AND type_name = ?
    LIMIT 1
");

$stmt->bind_param(
    "ss",
    $category,
    $typeName
);

$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode([
        "success" => false,
        "message" => "Waste guide not found"
    ]);
    exit;
}

$guide = $result->fetch_assoc();

echo json_encode([
    "success" => true,
    "guide" => $guide
]);

$stmt->close();
$conn->close();
?>