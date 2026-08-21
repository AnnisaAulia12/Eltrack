<?php
header("Content-Type: application/json");

require_once "db.php";

if($_SERVER["REQUEST_METHOD"] !== "POST"){
    echo json_encode([
        "success" => false,
        "message" => "method not allowed"
    ]);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);

//ini untuk users aja

$name = trim($data["name"] ?? "");
$phone = trim($data["phone"] ?? "");
$email = trim($data["email"] ?? "");
$password = trim($data["password"] ?? "");
$role = trim($data["role"] ?? "");

//cek field

if(
    $name === "" ||
    $phone === "" ||
    $email === "" ||
    $password === "" ||
    $role === "" 
) {
    echo json_encode([
        "success" => false,
        "message" => "please fill in all required fields"
    ]);
    exit;
}

// buat role
if($role !== "personal" && $role !== "business"){
    echo json_encode([
        "success" => false, 
        "message" => "invalid role"
    ]);

    exit;
}

//cek format email
if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
    echo json_encode([
        "success" => false,
        "message" => "invalid email"
    ]);

    exit;
}

//cek apahkah udh ada emual yang di pakai
$checkEmail = $conn->prepare(
    "SELECT id FROM users WHERE email = ?"
);

$checkEmail->bind_param("s", $email);
$checkEmail->execute();

$emailResult = $checkEmail->get_result();

//ini kalau email udh terdaftar brow
if($emailResult->num_rows > 0){
    echo json_encode([
        "success" => false,
        "message" => "email already registered"
    ]);

    exit;
}

//kalau pasword di simpan dalam hash 
//user masukin pasword -> disimpan dalam hash di db , jdi ga disimpan dalam bentuk password alsi awal gt
$passwordHash = password_hash(
    $password, PASSWORD_DEFAULT
);

//MULAI
$conn->begin_transaction();

try{
    //awal masukin ke user dulu ( ini general sblm milih role)
    $userStmt = $conn->prepare(
        "INSERT INTO users (
        username, 
        phone, 
        email, 
        password, 
        role
        ) 
        VALUES (?, ?, ?, ?, ?)"
    );

    $userStmt->bind_param(
        "sssss", $name, $phone, $email, $passwordHash, $role
    );

    $userStmt->execute();


    //kl ada user baru ada id yg baru di buat
    $userId = $conn->insert_id;

    //kalau role nya  bissnis , jdi awal masuk sebagai user biasa , kl dia pilih role bisnis ya masuk
    // ke pilihan bisnis
    if($role == "business"){
        $businessName = trim($data["business_name"] ?? "");

        $nib = trim($data["nib"] ?? "");

    $addressText = trim($data["address_text"] ?? "");

    $latitude = $data["latitude"] ?? null;
    $longitude = $data["longitude"] ?? null;

    $vehicleType = $data["vehicle_type"] ?? "";

    $pickupRadius = $data["pickup_radius"] ?? null;

    $openingTime = $data["opening_time"] ?? "";
    $closingTime = $data["closing_time"] ?? "";

    //buat memvalidasi 
    if($businessName === "" || $nib === "" || $addressText === "" || $vehicleType === "" ||
        $pickupRadius === null|| $openingTime === "" || $closingTime === ""
    ){
        throw new Exception(
            "Incomplete information"
        );
    }

    //kendaraan nya  cuma ada dua jenis motor dan mobil
    if($vehicleType !== "motorcycle" && $vehicleType !== "car"){
        throw new Exception ("invalid vehicle Type");
    }

    //masukin data nya
    $businessStmt = $conn->prepare(
        "INSERT INTO user_business (
        user_id, 
        business_name , 
        NIB, 
        address_text, 
        latitude, 
        longitude, 
        vehicle_type, 
        pickup, 
        Opening_Time, 
        closing_time
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"
    );

    $businessStmt->bind_param(
        "isssddsdss",
        $userId, $businessName, $nib, 
        $addressText, $latitude, $longitude, 
        $vehicleType, $pickupRadius, 
        $openingTime, $closingTime
    );

    $businessStmt->execute();
    $businessStmt->close();
    }

    // kl udh sukses semua
    $conn->commit();

    echo json_encode([
        "success" => true,
        "message" => "Registration successful",
        "user_id" => $userId,
        "role" => $role
    ]);

}catch (Throwable $e){
    // kalau ada yg gagal ya batal semua ga bisa lanjut
    $conn->rollback();

    echo json_encode([
        "success" =>false,
        "message" => $e->getMessage()
    ]);
}
$checkEmail->close();
if(isset($userStmt)){
    $userStmt->close();
}
$conn->close();



