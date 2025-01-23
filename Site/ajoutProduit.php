<?php
require_once 'connect.inc.php';
$securePage = true;
require_once 'includes/connexionSecurisee.php';

// Tables nécessaires : Utilisateur, ProduitPanier, Panier 

$idProduit = $_POST['idProduit'] ?? null;
$idCouleur = $_POST['idCouleur'] ?? null;
$idTaille = $_POST['idTaille'] ?? null;
$quantite = $_POST['quantite'] ?? null;

try {
    // Initialiser la variable de sortie
    $conn->exec("SET @idProduitAttr = NULL");

    // Préparer et exécuter l'appel de la procédure
    $stmt = $conn->prepare("CALL GetIdProduitAttr(:idProduit, :idCouleur, :idTaille, @idProduitAttr)");
    $stmt->bindParam(':idProduit', $idProduit, PDO::PARAM_INT);
    $stmt->bindParam(':idCouleur', $idCouleur, PDO::PARAM_INT);
    $stmt->bindParam(':idTaille', $idTaille, PDO::PARAM_INT);
    $stmt->execute();

    // Récupérer la valeur de la variable de sortie
    $result = $conn->query("SELECT @idProduitAttr AS idProduitAttr");
    $idProdAttr = $result->fetchColumn();

    // Récupérer l'ID du panier actif de l'utilisateur
    $idUtilisateur = $_SESSION['user']['IDUTILISATEUR'];
    $conn->exec("SET @idPanier = NULL");
    $stmt = $conn->prepare("CALL GetPanier(:idUtilisateur, @idPanier)");
    $stmt->bindParam(':idUtilisateur', $idUtilisateur, PDO::PARAM_INT);
    $stmt->execute();
    $result = $conn->query("SELECT @idPanier AS idPanier");
    $idPanier = $result->fetchColumn();

    // Insérer le produit dans le panier
    $stmt = $conn->prepare("CALL InsertProduitDansPanier(:idProduitAttr, :quantite, :idPanier)");
    $stmt->bindParam(':idPanier', $idPanier, PDO::PARAM_INT);
    $stmt->bindParam(':quantite', $quantite, PDO::PARAM_INT);
    $stmt->bindParam(':idProduitAttr', $idProdAttr, PDO::PARAM_INT);
    $stmt->execute();
    
    header("Location: panier.php");
} catch (PDOException $e) {
    echo "Erreur : " . $e->getMessage();
}
?>
