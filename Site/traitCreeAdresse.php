<?php
$securePage = true;
require_once 'includes/connexionSecurisee.php';
require_once 'connect.inc.php';
require("includes/headerVide.php");
// var_dump($_SESSION);
var_dump($_POST);
$idUtilisateur = $_SESSION['user']['IDUTILISATEUR'];

if (isset($_POST['nom']) && isset($_POST['prenom']) && isset($_POST['adresse']) && isset($_POST['ville']) && isset($_POST['codePostal']) && isset($_POST['pays']) && isset($_POST['region']) && isset($_POST['telephone']) && isset($_POST['from'])) {

    if (!preg_match("/^0[1-9][0-9]{8}$/", $_POST['telephone'])) {
        header("Location: creeAdresse.php?erreur=tel");
        exit();
    }

    if (!preg_match("/^[0-9]{5}$/", $_POST['codePostal'])) {
        header("Location: creeAdresse.php?erreur=codepostal");
        exit();
    }


try {
    $requete = $conn->prepare("CALL AjouterAdresse(:nom, :prenom, :adresse, :ville, :codePostal, :pays, :idRegion, :telephone, :idUtilisateur)");
    $requete->bindParam(':nom', $_POST['nom']);
    $requete->bindParam(':prenom', $_POST['prenom']);
    $requete->bindParam(':adresse', $_POST['adresse']);
    $requete->bindParam(':ville', $_POST['ville']);
    $requete->bindParam(':codePostal', $_POST['codePostal']);
    $requete->bindParam(':pays', $_POST['pays']);
    $requete->bindParam(':idRegion', $_POST['region']);
    $requete->bindParam(':telephone', $_POST['telephone']);
    $requete->bindParam(':idUtilisateur', $idUtilisateur);
    $requete->execute();

    // Récupérer l'ID de la nouvelle adresse ajoutée
    $adresseAjouteeId = $conn->lastInsertId();
    echo "<p class='text-success'>Adresse ajoutée avec succès.</p>";

    if ($_POST['from'] == "commande") {
        header("Location: commande.php");
        exit();
    }
        header("Location: compte.php");
        exit();
} catch (PDOException $e) {
    error_log("Erreur PDO : " . $e->getMessage());
    echo "<p class='text-danger'>Erreur lors de l'ajout de la nouvelle adresse.</p>";
}
}