<?php
try {
    $user = 'R2024MYSAE3009';
    $pass = 'Abwmu43F6Nh7W3';
    $conn = new PDO('mysql:host=localhost;dbname=R2024MYSAE3009;charset=UTF8', $user, $pass, array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
} catch (PDOException $e) {
    echo "Erreur: " . $e->getMessage() . "<br>";
    die();
}
?>
