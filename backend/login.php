<?php

header("Content-Type: application/json");


require_once "db.php";

if($_SERVER["REQUEST_METHOD"] != "POST"){
    echo json_encode([
        "success" => false,
        "message" => "method not allowed",
    ]);

    exit;

}

$data = json_decode(
    file_get_contents("php://input"),
    true
);

$email = trim($data["email"] ?? "");
$password = $data["password"] ?? "";

//cek field kosong
if($email === "" || $password === ""){
    echo json_encode([
        "success" => false,
        "message" => "email and password are required"
    ]);
    exit;
}

// mencari nama user bedasarkaan email
$stmt = $conn->prepare(
    "SELECT id, username , email, password, role
    FROM users
    WHERE email = ? "
);

if (!$stmt) {
    echo json_encode([
        "success" => false,
        "message" => $conn->error
    ]);
    exit;
}

$stmt->bind_param("s", $email);
$stmt->execute();

$result = $stmt->get_result();

//kalau email nya ga ada
if($result->num_rows === 0){
    echo json_encode([
        "success" => false,
        "message" => "invalid email"
    ]);
    exit;
}

$user = $result->fetch_assoc();

//cek pw
if(!password_verify($password, $user["password"])){
    echo json_encode([
        "success" => false,
        "message" => "invalid password"
    ]);
    exit;
}

//login berhasil 
echo json_encode([
    "success" => true,
    "message" => "login successful", 
    "user" => [
        "id" => $user["id"],
        "username" => $user["username"],
        "email" => $user["email"],
        "role" =>$user["role"]
    ]
]);

$stmt->close();
$conn->close();