<?php
session_start();

$login_correct = "Achille";
$password_correct = "Talon";

$login_value = ""; 
$password_value = ""; 

$erreur = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $login = htmlentities($_POST['login']);
    $password = htmlentities($_POST['password']);

    if ($login == $login_correct && $password == $password_correct) {
        $_SESSION['loggedin'] = true;
        header("Location: index.php");
        exit;
    } else {
        if ($login != $login_correct && $password != $password_correct) {
            $erreur = "Identifiant et mot de passe incorrects.";
        } elseif ($login != $login_correct) {
            $erreur = "Identifiant incorrect.";
        } elseif ($password != $password_correct) {
            $erreur = "Mot de passe incorrect.";
        }
        $login_value = htmlentities($_POST['login']);
        $password_value = htmlentities($_POST['password']);
    }
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page de connexion</title>
</head>
<body>
    <h2>Connexion</h2>
    <?php if (!empty($erreur)): ?>
        <p style="color:red;"><?php echo $erreur; ?></p>
    <?php endif; ?>
    <form action="identification.php" method="post">
        <label for="login">Login :</label>
        <input type="text" name="login" id="login" value="<?php echo $login_value; ?>" required><br><br>
        <label for="password">Password :</label>
        <input type="password" name="password" id="password" value="<?php echo $password_value; ?>" required><br><br>
        <button type="submit">Se connecter</button>
    </form>
</body>
</html>