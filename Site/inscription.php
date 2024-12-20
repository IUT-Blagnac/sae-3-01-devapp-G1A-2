<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="css/button.css">
</head>

<body >
<div class="login-form">
                <h1>Créer un compte</h1>
                <form action="traitInscription.php" method="post">
                    <!-- Nom -->
                    <div class="mb-3">
                        <label for="nom" class="form-label">Nom</label>
                        <input type="text" id="nom" name="nom" class="form-control" placeholder="Ex : Joel"
                            required>
                    </div>

                    <!-- Prénom -->
                    <div class="mb-3">
                        <label for="prenom" class="form-label">Prénom</label>
                        <input type="text" id="prenom" name="prenom" class="form-control" placeholder="Ex : Mention"
                            required>
                    </div>

                    <!-- Mot de passe -->
                    <div class="mb-3">
                        <label for="password" class="form-label">Mot de passe</label>
                        <input type="password" id="password" name="password" class="form-control" required>
                    </div>

                    <!-- Email -->
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" id="email" name="email" class="form-control"
                            placeholder="Ex : JoelMention@gmail.com" required>
                    </div>

                    <!-- Téléphone -->
                    <div class="mb-3">
                        <label for="telephone" class="form-label">Numéro de téléphone</label>
                        <input type="tel" id="telephone" name="telephone" class="form-control"
                            placeholder="Ex : 0601020304" minlength="10" maxlength="10" required>
                    </div>

                    <!-- Date de naissance -->
                    <div class="mb-3">
                        <label for="dateNaissance" class="form-label">Date de naissance</label>
                        <input type="date" id="dateNaissance" name="dateNaissance" class="form-control"
                            value="2000-01-01" required>
                    </div>

                    <!-- Bouton de validation -->
                    <button type="submit" class="btn btn-primary w-100">Valider</button>
                </form>

                <br>
                <center><a href="login.php">Vous avez déjà un compte ? </a></center>
                <center><a href="index.php">Retourner a l'accueil en tant qu'invité</a></center>

                <!-- Alertes d'erreurs -->
                <?php if (isset($_GET["erreur"])): ?>
                    <div class="alert alert-danger mt-3" role="alert">
                        <?php
                        if ($_GET["erreur"] == "email") {
                            echo "<p style='color:red;'>Format adresse mail invalide</p>";        
                        } elseif ($_GET["erreur"] == "tel") {
                            echo"<p style='color:red;'>Format numéro de téléphone invalide</p>";   
                        }
                        elseif ($_GET["erreur"] == "age") {
                            echo"<p style='color:red;'>L'utilisateur doit avoir minimum 13 ans pour crée un compte</p>";   
                        }
                        elseif ($_GET["erreur"] == "age-not-exist") {
                        echo"<p style='color:red;'>La date de naissance doit être inférieur a l'année en cours</p>";   
                       }
                        elseif ($_GET["erreur"] == "email_exist") {
                            echo"<p style='color:red;'>Ce mail est déjà associé a un compte</p>";   
                        }
                        else {
                            echo "Erreur lors de l'inscription.";
                        }
                        ?>
                    </div>
                <?php endif; ?>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>