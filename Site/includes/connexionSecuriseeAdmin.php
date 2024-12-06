<?php
require_once 'config.php';
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
if(isset($securePage) && $securePage === true){
    if (!isset($_SESSION['user'])) {
        header("Location: " . BASE_URL . "login.php");
        exit();
    }
    elseif ($_SESSION['user']['IDROLE'] != '1') {
        header("Location: " . BASE_URL . "index.php");
        exit();
    }
}
?>