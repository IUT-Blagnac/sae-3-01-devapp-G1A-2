<?php
session_start();
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/login.css">
    <title>Connexion</title>
</head>

<body>
    <div class="login-form">
        <h1>Connexion</h1>
        <form action="traitementLogin.php" method="post">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" id="email" name="email" class="form-control" required
                    value="<?php echo isset($_COOKIE['email']) ? $_COOKIE['email'] : ''; ?>">
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Mot de passe</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>
            <div class="form-check mb-3">
                <input type="checkbox" id="remember" name="remember" class="form-check-input"
                    <?php echo isset($_COOKIE['email']) ? 'checked' : ''; ?>>
                <label for="remember" class="form-check-label">Se souvenir de moi</label>
            </div>
            <button type="submit" class="btn btn-primary">Connexion</button>
        </form>

        <a href="inscription.php">Pas encore inscrit ?</a>

        <a href="index.php">Se connecter en tant qu'invité</a>

        <?php
        if (isset($_SESSION["is_logged_in"]) && $_POST["logout"] == "true") {
            session_destroy();
            echo '<div class="alert alert-success mt-3" role="alert">Vous avez été déconnecté.</div>';
        }
        if (isset($_GET["erreur"])) {
            echo '<div class="alert alert-danger mt-3" role="alert">';
            if ($_GET["erreur"] == "email") {
                echo "Cet email n'est pas enregistré.";
                echo '<a href="inscription.php" class="alert-link">Inscrivez-vous</a>';
            } elseif ($_GET["erreur"] == "motdepasse") {
                echo "Mot de passe incorrect.";
            } else {
                echo "Erreur de connexion.";
            }
            echo '</div>';
        }
        ?>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>