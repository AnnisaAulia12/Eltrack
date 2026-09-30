<?php

// ini buat reset aja  , soalnya kmrn aku lupa pw nya 
require_once "../db.php";

$userId = 1;
$newPassword = "Test12345";

$hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

$stmt = $conn->prepare("
    UPDATE users
    SET password = ?
    WHERE id = ?
");

$stmt->bind_param(
    "si",
    $hashedPassword,
    $userId
);

if ($stmt->execute()) {
    echo "Password berhasil diganti";
} else {
    echo "Password gagal diganti";
}