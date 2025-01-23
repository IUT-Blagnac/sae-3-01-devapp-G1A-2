<?php
$securePage = true;
require_once 'connect.inc.php';
require_once 'includes/header.php';
require_once 'includes/connexionSecurisee.php';

$idUtilisateur = $_SESSION['user']['IDUTILISATEUR'];
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
        $detailsUser = $conn->prepare("CALL GetUtilisateurById(:IDUTILISATEUR)");
        $detailsUser->execute(["IDUTILISATEUR" => $_SESSION['user']['IDUTILISATEUR']]);
        $detUser = $detailsUser->fetch();
        $detailsUser->closeCursor();
        if ($detUser) {
        ?>
        <div class="container">
            <div class="card personal-info">
                <table class="userTable">
                    <h2>Informations personnelles</h2>
                    <tr>
                        <td class="userInfo">Nom :</td>
                        <td class="userValue"><?php echo $_SESSION['user']["NOM"]; ?></td>
                    </tr>
                    <tr>
                        <td class="userInfo">Prénom :</td>
                        <td class="userValue"><?php echo htmlentities($_SESSION['user']["PRENOM"]); ?></td>
                    </tr>
                    <tr>
                        <td class="userInfo">Email :</td>
                        <td class="userValue"><?php echo htmlentities($_SESSION['user']["EMAIL"]); ?></td>
                    </tr>
                    <tr>
                        <td class="userInfo">Telephone :</td>
                        <td class="userValue"><?php echo htmlentities($_SESSION['user']["TELEPHONE"]); ?></td>
                    </tr>
                    <tr>
                        <td class="userInfo">Date de naissance :</td>
                        <td class="userValue"><?php echo htmlentities($_SESSION['user']["DATENAISSANCE"]); ?></td>
                    </tr>
                    <tr>
                        <td class="userInfo">Date d'inscription :</td>
                        <td class="userValue"> <?php echo htmlentities($_SESSION['user']["DATEINSCRIPTION"]); ?></td>
                    </tr>

                </table>
                <br><br>
                <a href="modifCompte.php" class="btn edit-btn">Modifier mes informations personnelles</a>
                <br>
                <a href="modifPassWord.php" class="btn editPwd-btn">Changer mon mot de passe</a>
                <br>
                <a href="javascript:confirmSuppr(<?php echo htmlentities($_SESSION['user']['IDUTILISATEUR']); ?>)"
                    class="btn delete-btn">Supprimer mon compte</a>

            </div>
            <?php
        }
        //Récupération des addresses 
        try {
            $requete = $conn->prepare("CALL GetAdressesUtilisateurInComptes(:idUtilisateur)");
            $requete->bindParam(':idUtilisateur', $idUtilisateur);
            $requete->execute();
            $adresses = $requete->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            error_log("Erreur PDO : " . $e->getMessage());
            echo "<p class='text-danger'>Erreur lors de la récupération des adresses.</p>";
        }
            ?>

            <div class="card adress">
                <h2>Adresse</h2>
                <label for="adresseExistante" class="form-label">Vos Adresses</label>
                <select id="adresseExistante" name="adresseExistante" class="form-control" onchange="afficherAdresse()">
                <option value="">Selectionner une adresse</option>
                        <?php
                        if (!empty($adresses)) {
                            foreach ($adresses as $adresse) {
                                echo '<option value="' . htmlspecialchars($adresse['IDADRESSE']) . '" '
                                    . 'nom="' . htmlspecialchars($adresse['NOM']) . '" '
                                    . 'prenom="' . htmlspecialchars($adresse['PRENOM']) . '" '
                                    . 'adresse="' . htmlspecialchars($adresse['ADRESSE']) . '" '
                                    . 'ville="' . htmlspecialchars($adresse['VILLE']) . '" '
                                    . 'codepostal="' . htmlspecialchars($adresse['CODEPOSTAL']) . '" '
                                    . 'pays="' . htmlspecialchars($adresse['PAYS']) . '" '
                                    . 'region="' . htmlspecialchars($adresse['NOMREGION']) . '" '
                                    . 'telephone="' . htmlspecialchars($adresse['TELEPHONE']) . '">'
                                    . htmlspecialchars($adresse['NOM']) . ' ' . htmlspecialchars($adresse['PRENOM']) . ' - '
                                    . htmlspecialchars($adresse['ADRESSE']) . ', ' . htmlspecialchars($adresse['VILLE']) . '</option>';
                            }
                        }
                        ?>
                </select>

                <form id="adresseForm" style="display: none;">
    <div class="mb-3">
        <label for="nom" class="form-label">Nom :</label>
        <input type="text" id="nom" name="nom" class="form-control">
    </div>
    <div class="mb-3">
        <label for="prenom" class="form-label">Prénom :</label>
        <input type="text" id="prenom" name="prenom" class="form-control">
    </div>
    <div class="mb-3">
        <label for="adresse" class="form-label">Adresse :</label>
        <input type="text" id="adresse" name="adresse" class="form-control">
    </div>
    <div class="mb-3">
        <label for="ville" class="form-label">Ville :</label>
        <input type="text" id="ville" name="ville" class="form-control">
    </div>
    <div class="mb-3">
        <label for="codePostal" class="form-label">Code postal :</label>
        <input type="text" id="codePostal" name="codePostal" class="form-control">
    </div>
    <div class="mb-3">
        <label for="pays" class="form-label">Pays :</label>
        <input type="text" id="pays" name="pays" class="form-control">
    </div>
    <div class="mb-3">
        <label for="region" class="form-label">Région :</label>
        <input type="text" id="region" name="region" class="form-control">
    </div>
    <div class="mb-3">
        <label for="telephone" class="form-label">Téléphone :</label>
        <input type="text" id="telephone" name="telephone" class="form-control">
    </div>
</form>
                <a href="creeAdresse.php?from=compte"> Nouvelle adresse</a>
            </div>

            <div class="card order-info">
                <h2>Informations Commande</h2>
                <a href="historiqueCommande.php" class="btn">Voir l'historique de vos commandes </a>
            </div>
        </div>
    </div>
    <script>
function afficherAdresse() {
    var select = document.getElementById('adresseExistante');
    var selectedOption = select.options[select.selectedIndex];

    if (select.value !== "") {
        document.getElementById('nom').value = selectedOption.getAttribute('nom');
        document.getElementById('prenom').value = selectedOption.getAttribute('prenom');
        document.getElementById('adresse').value = selectedOption.getAttribute('adresse');
        document.getElementById('ville').value = selectedOption.getAttribute('ville');
        document.getElementById('codePostal').value = selectedOption.getAttribute('codepostal');
        document.getElementById('pays').value = selectedOption.getAttribute('pays');
        document.getElementById('region').value = selectedOption.getAttribute('region');
        document.getElementById('telephone').value = selectedOption.getAttribute('telephone');
        document.getElementById('adresseForm').style.display = 'block';
    } else {
        document.getElementById('adresseForm').style.display = 'none';
    }
}
</script>   
</body>
<footer>
    <?php
    require_once 'includes/footer.php';
    ?>

</footer>

</html>



<!-- <?php
                        //foreach ($adresses as $adresse) {
                            //echo "<option value='" . $adresse['IDADRESSE'] . "'>" . $adresse['NOM'] . " " . $adresse['PRENOM'] . " - " . $adresse['ADRESSE'] . " " . $adresse['VILLE'] . " " . $adresse['CODEPOSTAL'] . " " . $adresse['PAYS'] . "</option>";
                        //}
                        ?> -->