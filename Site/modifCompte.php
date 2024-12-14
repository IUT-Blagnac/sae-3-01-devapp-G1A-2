<?php
session_start();
$securePage = true;
require_once 'includes/connexionSecurisee.php';
require_once 'connect.inc.php';
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="css/button.css">
    <title> Modifier information personnelles</title>
</head>

<body>
<div class="login-form">
    <?php
    $idUtilisateur = $_SESSION['user']['IDUTILISATEUR'];
    $modifCompte = $conn->prepare("SELECT * FROM UTILISATEUR WHERE IDUTILISATEUR = :IDUTILISATEUR");
    $modifCompte->execute(['IDUTILISATEUR' => $idUtilisateur]);
    
        ?>
       
                    <h1>Modifier mes informations personnelles</h1>
                    <form action="" method="post">
                        <!-- Nom -->
                        <div class="mb-3">
                            <label for="nom" class="form-label">Nom</label>
                            <input type="text" id="nom" name="nom" class="form-control"
                                value="<?php echo $_SESSION['user']['NOM']; ?>" placeholder="Ex : Montagné" required>
                        </div>

                        <!-- Prénom -->
                        <div class="mb-3">
                            <label for="prenom" class="form-label">Prénom</label>
                            <input type="text" id="prenom" name="prenom" class="form-control"
                                value="<?php echo $_SESSION['user']['PRENOM']; ?>" placeholder="Ex : Gilbert" required>
                        </div>

                        <!-- Mot de passe -->
                        <div class="mb-3">
                            <label for="password" class="form-label">Mot de passe</label>
                            <input type="password" id="password" name="password"
                                value="" class="form-control" required>
                        </div>

                        <!-- Téléphone -->
                        <div class="mb-3">
                            <label for="telephone" class="form-label">Numéro de téléphone</label>
                            <input type="tel" id="telephone" name="telephone"
                                value="<?php echo $_SESSION['user']['TELEPHONE']; ?>" class="form-control"
                                placeholder="Ex : 0601020304" minlength="10" maxlength="10" required>
                        </div>

                        <!-- Date de naissance -->
                        <div class="mb-3">
                            <label for="dateNaissance" class="form-label">Date de naissance</label>
                            <input type="date" id="dateNaissance" name="dateNaissance"
                                value="<?php echo $_SESSION['user']['DATENAISSANCE']; ?>" class="form-control"
                                value="2000-01-01" required>
                        </div>

                        <!-- Bouton de validation -->
                        <button type="submit" class="btn btn-primary w-100">Valider</button>
                    </form>
                    <br><br>
                    <center><a href="compte.php">Retourner sur mon compte</a></center>


                    <?php
    
    if (isset($_POST['nom']) && isset($_POST['prenom']) && isset($_POST['password']) && isset($_POST['email']) && isset($_POST['telephone']) && isset($_POST['dateNaissance'])) {
        $nom = htmlentities($_POST['nom']);
        $prenom = htmlentities($_POST['prenom']);
        $mdp = htmlentities($_POST['password']);
        $mdp = password_hash($mdp, PASSWORD_ARGON2ID);
        $tel = htmlentities($_POST['telephone']);
        $dtn = htmlentities($_POST['dateNaissance']);
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            echo "<p style='color:red;'>Format adresse mail invalide</p>"; 
            exit();       
        }
        if (!preg_match("/^[0-9]{10}$/", $tel)) {
            echo "<p style='color:red;'>Format numéro de téléphone invalide</p>";        
            exit();
        }
        $updateCompte = $conn->prepare("UPDATE UTILISATEUR SET NOM = :nom, PRENOM = :prenom, EMAIL = :email, PASSWORD = :pwd, TELEPHONE = :tel, DATENAISSANCE = :dtn WHERE IDUTILISATEUR = :idUtilisateur");
        $updateCompte->bindParam(':nom', $nom);
        $updateCompte->bindParam(':prenom', $prenom);
        $updateCompte->bindParam(':pwd', $mdp);
        $updateCompte->bindParam(':tel', $tel);
        $updateCompte->bindParam(':dtn', $dtn);
        $updateCompte->bindParam(':idUtilisateur', $idUtilisateur);
        if ($updateCompte->execute()) {
            $_SESSION['user']['NOM'] = $nom;
                $_SESSION['user']['PRENOM'] = $prenom;
                $_SESSION['user']['EMAIL'] = $email;
                $_SESSION['user']['TELEPHONE'] = $tel;
                $_SESSION['user']['DATENAISSANCE'] = $dtn;
            header("Location: compte.php"); 
            exit();
        }
    }
    ?>
        
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>