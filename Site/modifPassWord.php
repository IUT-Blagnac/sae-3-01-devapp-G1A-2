<?php
// filepath: /home/R2024SAE3009/public_html/modifPassWord.php
require_once 'connect.inc.php';
require_once 'includes/headerVide.php';
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
    <title>Changer le mot de passe</title>
</head>

<body>
    <div class="login-form">
        <h2>Changer le mot de passe</h2>
        <form method="post" action="traitModPassWord.php">
            <div class="mb-3">
                <label for="passwordActuel" class="form-label">Mot de passe actuel :</label>
                <div class="input-group">
                <input type="password" id="passwordActuel" name="passwordActuel" class="form-control" required>
                <button class="btn btn-outline-secondary" type="button" id="toggleCurrentPassword" style="height: 38px;">
                <i class="bi bi-eye-slash" id="eyeIconNew"></i>
                </button>
            </div>
            </div>

            <div class="mb-3">
                <label for="nouveauPassword" class="form-label">Nouveau mot de passe :</label>
                <div class="input-group">
                    <input type="password" id="nouveauPassword" name="nouveauPassword" class="form-control" required>
                    <button class="btn btn-outline-secondary" type="button" id="toggleNewPassword" style="height: 38px;">
                        <i class="bi bi-eye-slash" id="eyeIconNew"></i>
                    </button>
                </div>
            </div>

            <div class="mb-3">
                <label for="confirmePassword" class="form-label">Confirmer le nouveau mot de passe :</label>
                <div class="input-group">
                    <input type="password" id="confirmePassword" name="confirmePassword" class="form-control" required>
                    <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword" style="height: 38px;">
                        <i class="bi bi-eye-slash" id="eyeIconConfirm"></i>
                    </button>
                </div>
            </div>

            <button type="submit" class="btn btn-primary w-100">Valider</button>
            <center><a href="compte.php">Retourner sur mon compte</a></center>
        </form>

    <?php if (isset($_GET["erreur"])) { ?>
        <div class="alert alert-danger mt-3" role="alert">
            <?php
            if ($_GET["erreur"] == "mdpIdentique") {
                echo "<p>Le nouveau mot de passe doit être différent de l'ancien</p>";
            } elseif ($_GET["erreur"] == "erreur") {
                echo "<p>Erreur lors de la modification du mot de passe</p>";
            } elseif ($_GET["erreur"] == "mdpdifférent") {
                echo "<p>Le nouveau mot de passe et le mot de passe de confirmation sont différents</p>";
            } elseif ($_GET["erreur"] == "mauvaismdp") {
                echo "<p>Mot de passe actuel incorrect</p>";
            }
            ?>
        </div>
    <?php } ?>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            document.getElementById("toggleCurrentPassword").addEventListener("click", function() {
                const passwordField = document.getElementById("passwordActuel");
                const eyeIcon = document.getElementById("eyeIconConfirm");

                if (passwordField.type === "password") {
                    passwordField.type = "text";
                    eyeIcon.classList.remove("bi-eye-slash");
                    eyeIcon.classList.add("bi-eye");
                } else {
                    passwordField.type = "password";
                    eyeIcon.classList.remove("bi-eye");
                    eyeIcon.classList.add("bi-eye-slash");
                }
            });
        });

            document.getElementById("toggleNewPassword").addEventListener("click", function() {
                const passwordField = document.getElementById("nouveauPassword");
                const eyeIcon = document.getElementById("eyeIconNew");

                if (passwordField.type === "password") {
                    passwordField.type = "text";
                    eyeIcon.classList.remove("bi-eye-slash");
                    eyeIcon.classList.add("bi-eye");
                } else {
                    passwordField.type = "password";
                    eyeIcon.classList.remove("bi-eye");
                    eyeIcon.classList.add("bi-eye-slash");
                }
            });

            document.getElementById("toggleConfirmPassword").addEventListener("click", function() {
                const passwordField = document.getElementById("confirmePassword");
                const eyeIcon = document.getElementById("eyeIconConfirm");

                if (passwordField.type === "password") {
                    passwordField.type = "text";
                    eyeIcon.classList.remove("bi-eye-slash");
                    eyeIcon.classList.add("bi-eye");
                } else {
                    passwordField.type = "password";
                    eyeIcon.classList.remove("bi-eye");
                    eyeIcon.classList.add("bi-eye-slash");
                }
            });
    </script>
</body>

</html>