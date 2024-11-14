<?php
try {
    $user = 'G1A2';
    $pass = '1234';
    $conn = new PDO('mysql:host=mysql;dbname=SAE301;charset=UTF8', $user, $pass, array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
} catch (PDOException $e) {
    echo "Erreur: " . $e->getMessage() . "<br>";
    die();
}
?>
