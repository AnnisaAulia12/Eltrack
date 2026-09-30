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

$user_mission_id = $data["user_mission_id"] ?? null;
$activity_type = $data["activity_type"] ?? null;
$category = $data["category"] ?? null;
$item = $data["item"] ?? null;

if (!$user_mission_id) {
    echo json_encode([
        "success" => false,
        "message" => "user_mission_id is required"
    ]);
    exit;
}

$stmt = $conn->prepare("
    SELECT
        um.id,
        um.user_id,
        um.progress,
        um.is_completed,
        um.reward_claimed,

        m.title,
        m.mission_type,
        m.target_category,
        m.target_item,
        m.target_value,
        m.reward_points

    FROM user_missions um
    JOIN missions m
        ON um.mission_id = m.id
    WHERE um.id = ?
");

$stmt->bind_param("i", $user_mission_id);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode([
        "success" => false,
        "message" => "mission not found"
    ]);
    exit;
}

$mission = $result->fetch_assoc();
if ($mission["mission_type"] !== $activity_type) {
    echo json_encode([
        "success" => false,
        "mission_match" => false,
        "message" => "activity type does not match mission"
    ]);
    exit;
}

if (
    $mission["target_category"] !== null &&
    $mission["target_category"] !== $category
) {
    echo json_encode([
        "success" => true,
        "mission_match" => false,
        "message" => "activity category does not match mission"
    ]);
    exit;
}

if (
    $mission["target_item"] !== null &&
    $mission["target_item"] !== $item
) {
    echo json_encode([
        "success" => true,
        "mission_match" => false,
        "message" => "item does not match mission"
    ]);
    exit;
}


if ($mission["is_completed"] == 1) {
    echo json_encode([
        "success" => true,
        "message" => "mission already completed",
        "already_completed" => true
    ]);
    exit;
}

$user_id = $mission["user_id"];

$new_progress = $mission["progress"] + 1;

$is_completed = 0;

if ($new_progress >= $mission["target_value"]) {
    $new_progress = $mission["target_value"];
    $is_completed = 1;
}



if ($is_completed == 0) {

    $update = $conn->prepare("
        UPDATE user_missions
        SET progress = ?
        WHERE id = ?
    ");

    $update->bind_param(
        "ii",
        $new_progress,
        $user_mission_id
    );

    $update->execute();

    echo json_encode([
        "success" => true,
        "message" => "mission progress updated",
        "progress" => $new_progress,
        "target_value" => (int)$mission["target_value"],
        "is_completed" => false
    ]);

    exit;
}



$conn->begin_transaction();

try {

    /*
    | Update mission
    */

    $updateMission = $conn->prepare("
        UPDATE user_missions
        SET
            progress = ?,
            is_completed = 1,
            reward_claimed = 1,
            completed_at = NOW()
        WHERE id = ?
          AND reward_claimed = 0
    ");

    $updateMission->bind_param(
        "ii",
        $new_progress,
        $user_mission_id
    );

    $updateMission->execute();


    $reward = (int)$mission["reward_points"];

    $updatePoint = $conn->prepare("
        UPDATE users
        SET points = points + ?
        WHERE id = ?
    ");

    $updatePoint->bind_param(
        "ii",
        $reward,
        $user_id
    );

    $updatePoint->execute();


    $description = "Completed mission: " . $mission["title"];

    $transaction = $conn->prepare("
        INSERT INTO point_transactions
        (
            user_id,
            points,
            transaction_type,
            description
        )
        VALUES (?, ?, 'earned', ?)
    ");

    $transaction->bind_param(
        "iis",
        $user_id,
        $reward,
        $description
    );

    $transaction->execute();

    $conn->commit();

    echo json_encode([
        "success" => true,
        "message" => "mission completed",
        "progress" => $new_progress,
        "target_value" => (int)$mission["target_value"],
        "is_completed" => true,
        "points_earned" => $reward
    ]);

} catch (Exception $e) {

    $conn->rollback();

    echo json_encode([
        "success" => false,
        "message" => "failed to complete mission"
    ]);
}

$conn->close();