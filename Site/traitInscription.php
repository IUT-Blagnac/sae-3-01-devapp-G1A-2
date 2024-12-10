<?php
    include("connect.inc.php");
    var_dump($_POST);
    if (isset($_POST['nom']) && isset($_POST['prenom']) && isset($_POST['password']) && isset($_POST['email']) && isset($_POST['telephone']) && isset($_POST['dateNaissance'])) {
        echo "2";
        $nom = htmlentities($_POST['nom']);
        $prenom = htmlentities($_POST['prenom']);
        $mdp = htmlentities($_POST['password']);
        $mdp = password_hash($mdp, PASSWORD_ARGON2ID);
        $email = htmlentities($_POST['email']);
        $email = strtolower(string: $email);
        $tel = htmlentities($_POST['telephone']);
        $dtn = htmlentities($_POST['dateNaissance']);
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            header("Location: inscription.php?erreur=email");
            exit();
        }
        if (!preg_match("/^0[1-9][0-9]{8}$/", $tel)) {
            header("Location: inscription.php?erreur=tel");
            exit();
        }

        $dateNaissance = new DateTime($dtn);
        $aujourdhui = new DateTime();
        $age = $aujourdhui->diff($dateNaissance)->y;

        if ($dateNaissance > $aujourdhui){
            header("Location: inscription.php?erreur=age-not-exist");
            exit();
        }

        if ($age < 13) {
            header("Location: inscription.php?erreur=age");
            exit();
        }

        $checkEmail = $conn->prepare("SELECT COUNT(*) FROM UTILISATEUR WHERE EMAIL = :email");
        $checkEmail->bindParam(':email', $email);
        $checkEmail->execute();
        $emailExists = $checkEmail->fetchColumn();

        if ($emailExists > 0) {
            header("Location: inscription.php?erreur=email_exist");
            exit();
        }

        // Préparation et exécution de l'insertion d'un utilisateur
        $creaCompte = $conn->prepare("INSERT INTO UTILISATEUR (IDUTILISATEUR, IDROLE, NOM, PRENOM, EMAIL, PASSWORD, TELEPHONE, DATENAISSANCE, DATEINSCRIPTION) 
                                    VALUES (NULL, 2, :nom, :prenom, :email, :pwd, :tel, :dtn, NOW())");
        $creaCompte->bindParam(':nom', $nom);
        $creaCompte->bindParam(':prenom', $prenom);
        $creaCompte->bindParam(':email', $email);
        $creaCompte->bindParam(':pwd', $mdp);
        $creaCompte->bindParam(':tel', $tel);
        $creaCompte->bindParam(':dtn', $dtn);

        if ($creaCompte->execute()) {
        echo "Nouvel utilisateur ajouté. ";

        // Récupération de l'IDUTILISATEUR inséré
        $idUtilisateur = $conn->lastInsertId();

        // Préparation et exécution de l'insertion dans le panier
        $creaPanier = $conn->prepare("INSERT INTO PANIER (IDPANIER, IDUTILISATEUR, DATECREA) 
                                    VALUES (NULL, :idUtilisateur, NOW())");
        $creaPanier->bindParam(':idUtilisateur', $idUtilisateur);

        if ($creaPanier->execute()) {
            echo "Panier client créé.";
            header("Location: login.php");
            exit();
        } else {
            echo "Erreur lors de la création du panier.";
        }
        } else {
        echo "Erreur lors de l'ajout de l'utilisateur.";
        }
    }
?>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription</title>
</head>

<body>

</body>

</html>