

<?php

$host = "localhost";
$username = "root";
$password = "";
$database = "eltrack";


$conn = new mysqli($host, $username, $password, $database);

if($conn->connect_error){
    die("connected failed : ". $conn->connect_error);
}

$conn->set_charset("utf8mb4");

?>