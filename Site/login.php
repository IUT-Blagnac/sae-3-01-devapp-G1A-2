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
    <link rel="stylesheet" href="css/button.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"> <!-- Icônes de Bootstrap -->
    <title>Connexion</title>
</head>

<body>
    <div class="login-form">
        <h1>Connexion</h1>
        <form action="traitLogin.php" method="post">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" id="email" name="email" class="form-control" required
                    value="<?php echo isset($_COOKIE['email']) ? $_COOKIE['email'] : ''; ?>">
            </div>
            <div class="mb-3">
            <label for="password" class="form-label">Mot de passe</label>
                <div class="input-group">
                    <input type="password" id="password" name="password" class="form-control" required>
                    <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                    <i class="bi bi-eye-slash" id="eyeIcon"></i>
                    </button>
                </div>
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
    <script>
        // Lorsque le bouton est cliqué, on bascule entre afficher et masquer le mot de passe
        document.getElementById("togglePassword").addEventListener("click", function() {
            const passwordField = document.getElementById("password");
            const eyeIcon = document.getElementById("eyeIcon");

            // Si le type est 'password', on le change en 'text' pour afficher le mot de passe
            if (passwordField.type === "password") {
                passwordField.type = "text";
                eyeIcon.classList.remove("bi-eye-slash");
                eyeIcon.classList.add("bi-eye");
            } else {
                // Sinon, on revient au type 'password' pour masquer le mot de passe
                passwordField.type = "password";
                eyeIcon.classList.remove("bi-eye");
                eyeIcon.classList.add("bi-eye-slash");
            }
        });
    </script>
</body>

</html>
