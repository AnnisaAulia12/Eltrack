<?php

header("Content-Type: application/json");

require_once "../db.php";

$data = json_decode(file_get_contents("php://input"), true);

$user_id = $data["user_id"] ?? null;
$article_id = $data["article_id"] ?? null;
$article_title = $data["article_title"] ?? null;
$article_url = $data["article_url"] ?? null;
$category = $data["category"] ?? null;

if (
    !$user_id ||
    !$article_id ||
    !$article_title ||
    !$article_url ||
    !$category
) {
    echo json_encode([
        "success" => false,
        "message" => "missing required data"
    ]);
    exit;
}

$allowedCategories = [
    "organic",
    "non_organic",
    "k3"
];

if (!in_array($category, $allowedCategories)) {
    echo json_encode([
        "success" => false,
        "message" => "invalid category"
    ]);
    exit;
}



$check = $conn->prepare("
    SELECT id
    FROM user_article_reads
    WHERE user_id = ?
    AND article_id = ?
");

$check->bind_param(
    "is",
    $user_id,
    $article_id
);

$check->execute();

$result = $check->get_result();

if ($result->num_rows > 0) {
    echo json_encode([
        "success" => true,
        "already_read" => true,
        "message" => "article already completed"
    ]);
    exit;
}



$insert = $conn->prepare("
    INSERT INTO user_article_reads
    (
        user_id,
        article_id,
        article_title,
        article_url,
        category,
        points_awarded
    )
    VALUES (?, ?, ?, ?, ?, 0)
");

$insert->bind_param(
    "issss",
    $user_id,
    $article_id,
    $article_title,
    $article_url,
    $category
);

if (!$insert->execute()) {
    echo json_encode([
        "success" => false,
        "message" => "failed to save article read"
    ]);
    exit;
}



$missionCheck = $conn->prepare("
    SELECT
        um.id AS user_mission_id,
        um.progress,
        um.is_completed,
        um.reward_claimed,
        m.target_value,
        m.reward_points
    FROM user_missions um
    JOIN missions m
        ON um.mission_id = m.id
    WHERE um.user_id = ?
      AND um.mission_date = CURDATE()
      AND m.mission_type = 'read_article'
      AND m.target_category = ?
      AND um.is_completed = 0
");

$missionCheck->bind_param(
    "is",
    $user_id,
    $category
);

$missionCheck->execute();

$missionResult = $missionCheck->get_result();

echo json_encode([
    "success" => true,
    "already_read" => false,
    "message" => "article marked as read"
]);

while ($mission = $missionResult->fetch_assoc()) {

    $newProgress = $mission["progress"] + 1;

    if ($newProgress >= $mission["target_value"]) {

        $newProgress = $mission["target_value"];

        $updateMission = $conn->prepare("
            UPDATE user_missions
            SET
                progress = ?,
                is_completed = 1,
                completed_at = NOW()
            WHERE id = ?
        ");

        $updateMission->bind_param(
            "ii",
            $newProgress,
            $mission["user_mission_id"]
        );

        $updateMission->execute();

    } else {

        $updateMission = $conn->prepare("
            UPDATE user_missions
            SET progress = ?
            WHERE id = ?
        ");

        $updateMission->bind_param(
            "ii",
            $newProgress,
            $mission["user_mission_id"]
        );

        $updateMission->execute();
    }

    $rewardPoints = $mission["reward_points"];

    $updatePoints = $conn->prepare("
        UPDATE users
        SET points = points + ?
        WHERE id = ?
    ");

    $updatePoints->bind_param(
        "ii",
        $rewardPoints,
        $user_id
    );

    $updatePoints->execute();

    $description = "Completed article mission";

    $pointTransaction = $conn->prepare("
        INSERT INTO point_transactions
        (
            user_id,
            points,
            transaction_type,
            description
        )
        VALUES (?, ?, 'earned', ?)
    ");

    $pointTransaction->bind_param(
        "iis",
        $user_id,
        $rewardPoints,
        $description
    );

    $pointTransaction->execute();
    
    $claimReward = $conn->prepare("
        UPDATE user_missions
        SET reward_claimed = 1
        WHERE id = ?
    ");

    $claimReward->bind_param(
        "i",
        $mission["user_mission_id"]
    );

    $claimReward->execute();
}