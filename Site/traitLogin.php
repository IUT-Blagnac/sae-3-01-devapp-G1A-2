<?php
if (isset($_POST["email"]) && isset($_POST["password"])) {
    $email = htmlentities($_POST["email"]);
    $email = strtolower($email);

    // En base de données
    require_once("connect.inc.php");
    $verifLogs = $conn->prepare("SELECT * FROM UTILISATEUR WHERE email = :email");
    $verifLogs->bindParam(":email", $email);
    $verifLogs->execute();
    $user = $verifLogs->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        // Vérifiez le mot de passe en le comparant à celui stocké
        if (password_verify($_POST["password"], $user["PASSWORD"])) {
            session_start();
            $_SESSION["is_logged_in"] = true;
            $_SESSION["user"] = $user;
            if (isset($_POST["remember"])) {
                setcookie("email", $email, time() + 3600 * 24 * 365);
            } else {
                setcookie("email", "", time() - 3600);
            }
            header("Location: index.php");
        } else {
            header("Location: login.php?erreur=motdepasse");
        }
    } else {
        header("Location: login.php?erreur=email");
    }
}

?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
</html>