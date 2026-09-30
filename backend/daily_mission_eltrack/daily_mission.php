<?php

header("Content-Type: application/json");
require_once "../db.php";

$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    echo json_encode([
        "success" => false,
        "message" => "method not allowed"
    ]);
    exit;
}

$user_id = $data["user_id"] ?? null;

if (!$user_id) {
    echo json_encode([
        "success" => false,
        "message" => "user_id is required"
    ]);
    exit;
}



$stmt = $conn->prepare("
    SELECT 
        um.id AS user_mission_id,
        um.progress,
        um.is_completed,
        um.reward_claimed,
        m.id AS mission_id,
        m.title,
        m.description,
        m.mission_type,
        m.target_category,
        m.target_item,
        m.target_value,
        m.reward_points
    FROM user_missions um
    JOIN missions m ON um.mission_id = m.id
    WHERE um.user_id = ?
      AND um.mission_date = CURDATE()
");

$stmt->bind_param("i", $user_id);
$stmt->execute();

$result = $stmt->get_result();

$missions = [];

while ($row = $result->fetch_assoc()) {
    $row["is_completed"] = (bool)$row["is_completed"];
    $row["reward_claimed"] = (bool)$row["reward_claimed"];

    $missions[] = $row;
}


if (count($missions) === 0) {

    $randomResult = $conn->query("
        SELECT id
        FROM missions
        WHERE is_active = 1
        ORDER BY RAND()
        LIMIT 3
    ");

    while ($mission = $randomResult->fetch_assoc()) {

        $mission_id = $mission["id"];

        $insert = $conn->prepare("
            INSERT INTO user_missions
            (
                user_id,
                mission_id,
                mission_date,
                progress,
                is_completed,
                reward_claimed
            )
            VALUES (?, ?, CURDATE(), 0, 0, 0)
        ");

        $insert->bind_param(
            "ii",
            $user_id,
            $mission_id
        );

        $insert->execute();
    }

    $stmt = $conn->prepare("
        SELECT 
            um.id AS user_mission_id,
            um.progress,
            um.is_completed,
            um.reward_claimed,
            m.id AS mission_id,
            m.title,
            m.description,
            m.mission_type,
            m.target_category,
            m.target_item,
            m.target_value,
            m.reward_points
        FROM user_missions um
        JOIN missions m ON um.mission_id = m.id
        WHERE um.user_id = ?
          AND um.mission_date = CURDATE()
    ");

    $stmt->bind_param("i", $user_id);
    $stmt->execute();

    $result = $stmt->get_result();

    $missions = [];

    while ($row = $result->fetch_assoc()) {
        $row["is_completed"] = (bool)$row["is_completed"];
        $row["reward_claimed"] = (bool)$row["reward_claimed"];

        $missions[] = $row;
    }
}

echo json_encode([
    "success" => true,
    "missions" => $missions
]);

$conn->close();