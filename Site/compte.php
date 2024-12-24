<?php
$securePage = true;
require_once 'connect.inc.php';
require_once 'includes/header.php';
require_once 'includes/connexionSecurisee.php';
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/compte.css">
    <title>Compte personnelles</title>
    <script>
        // Cette fonction permettra de demander confirmation avant la suppression d'un produit
        function confirmSuppr(idCLient) {
            if (confirm("Etes vous sur de  vouloir supprimer votre compte ?")) {
                document.location.href = "suprCompte.php?pIdCLient=" + idCLient;
            } else {
                alert("Suppression annulée");
                return false;
            }
        }
    </script>
</head>

<body>
<div class="main-content">
    <?php
    $detailsUser = $conn->prepare("SELECT * FROM UTILISATEUR WHERE IDUTILISATEUR = :IDUTILISATEUR");
    $detailsUser->execute(["IDUTILISATEUR" => $_SESSION['user']['IDUTILISATEUR']]);
    $detUser = $detailsUser->fetch();

    if ($detUser) {
        ?>
       <div class="container">
        <div class="perso">
            <table class="userTable">
                <h2>Informations personnelles</h2>
                <tr>
                    <td class="userInfo">Nom :</td>
                    <td class="userValue"><?php echo $detUser["NOM"]; ?></td>
                </tr>
                <tr>
                    <td class="userInfo">Prénom :</td>
                    <td class="userValue"><?php echo $detUser["PRENOM"]; ?></td>
                </tr>
                <tr>
                    <td class="userInfo">Email :</td>
                    <td class="userValue"><?php echo $detUser["EMAIL"]; ?></td>
                </tr>
                <tr>
                    <td class="userInfo">Telephone :</td>
                    <td class="userValue"><?php echo $detUser["TELEPHONE"]; ?></td>
                </tr>
                <tr>
                    <td class="userInfo">Date de naissance :</td>
                    <td class="userValue"><?php echo $detUser["DATENAISSANCE"]; ?></td>
                </tr>
                <tr>
                    <td class="userInfo">Date d'inscription :</td>
                    <td class="userValue"> <?php echo $detUser["DATEINSCRIPTION"]; ?></td>
                </tr>

            </table>
            <br><br>
            <a href="modifCompte.php" class="button-mod">Modifier ses informations personnelles</a>
            <br>
            <a href="javascript:confirmSuppr(<?php echo htmlentities($_SESSION['user']['IDUTILISATEUR']); ?>)" class="button-supr">Supprimer mon compte</a>

        </div>
        <?php
    }
    ?>

    <div class="addresse">
        <h2>A faire </h2>
        adrrese livraison
        <br>
        addresse facturation
    </div>
 
    <div class="commande">
        <h2>Informations Commande</h2>
        <br><br>
        <a href="commande.php" class="button">Suivre ma commande </a>
        <br>
        <a href="historiqueCommande.php" class="button">Voir l'historique de vos commandes </a>
    </div>
 </div>
</div>
</body>
<footer>
    <?php
    require_once 'includes/footer.php';
    ?>

</footer>

</html>