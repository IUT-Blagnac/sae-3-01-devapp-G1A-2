<?php 
require_once 'connect.inc.php';
require_once 'includes/connexionSecurisee.php';

$idProduit = $_GET['idProduit'] ?? null;
$couleur = $_GET['couleur'] ?? null;
$taille = $_GET['taille'] ?? null;

// Vérification que les paramètres sont bien fournis
if (!$idProduit || !$couleur || !$taille) {
    die("Erreur: Il manque des paramètres requis (idProduit, couleur, taille).");
}

echo "ID Produit : " . htmlspecialchars($idProduit) . "\n";
echo "Couleur : " . htmlspecialchars($couleur) . "\n";
echo "Taille : " . htmlspecialchars($taille) . "\n";

try {
    // 1. Récupérer l'idCouleur à partir du nom de la couleur
    $stmtCouleur = $conn->prepare("SELECT IDCOULEUR FROM COULEUR WHERE COULEUR = :couleur LIMIT 1");
    $stmtCouleur->bindParam(':couleur', $couleur, PDO::PARAM_STR);
    $stmtCouleur->execute();
    $idCouleur = $stmtCouleur->fetchColumn();

    if (!$idCouleur) {
        die("Erreur: La couleur '$couleur' n'existe pas dans la base de données.");
    }

    // 2. Récupérer l'idTaille à partir du nom de la taille
    $stmtTaille = $conn->prepare("SELECT IDTAILLE FROM TAILLE WHERE TAILLE = :taille LIMIT 1");
    $stmtTaille->bindParam(':taille', $taille, PDO::PARAM_STR);
    $stmtTaille->execute();
    $idTaille = $stmtTaille->fetchColumn();

    if (!$idTaille) {
        die("Erreur: La taille '$taille' n'existe pas dans la base de données.");
    }

    echo "ID Couleur : " . $idCouleur . "\n";
    echo "ID Taille : " . $idTaille . "\n";

    // 3. Récupérer l'idProduitAttr
    $conn->exec("SET @idProduitAttr = NULL");
    $stmt = $conn->prepare("CALL GetIdProduitAttr(:idProduit, :idCouleur, :idTaille, @idProduitAttr)");
    $stmt->bindParam(':idProduit', $idProduit, PDO::PARAM_INT);
    $stmt->bindParam(':idCouleur', $idCouleur, PDO::PARAM_INT);
    $stmt->bindParam(':idTaille', $idTaille, PDO::PARAM_INT);
    $stmt->execute();

    // Récupérer la valeur de l'idProduitAttr depuis la variable de sortie
    $result = $conn->query("SELECT @idProduitAttr AS idProduitAttr");
    $idProduitAttr = $result->fetchColumn();

    if ($idProduitAttr) {
        echo "ID Produit Attr : " . htmlspecialchars($idProduitAttr) . "\n";
    } else {
        echo "Aucun produit trouvé pour ces critères.\n";
    }

    // 4. Récupérer l'idPanier de l'utilisateur
    $idUser = $_SESSION['user']['IDUTILISATEUR'];
    $conn->exec("SET @idPanier = NULL");
    $stmtPanier = $conn->prepare("CALL GetPanier(:idUtilisateur, @idPanier)");
    $stmtPanier->bindParam(':idUtilisateur', $idUser, PDO::PARAM_INT);
    $stmtPanier->execute();
    $resultPanier = $conn->query("SELECT @idPanier AS idPanier");
    $idPanier = $resultPanier->fetchColumn();

    if ($idPanier) {
        echo "ID Panier : " . htmlspecialchars($idPanier) . "\n";
    } else {
        die("Erreur: Impossible de récupérer l'ID du panier de l'utilisateur.");
    }

    // 5. Supprimer le produit du panier
    $stmtSuppr = $conn->prepare("CALL SupprimerProduitPanier(:idPanier, :idProduitAttr)");
    $stmtSuppr->bindParam(':idProduitAttr', $idProduitAttr, PDO::PARAM_INT);
    $stmtSuppr->bindParam(':idPanier', $idPanier, PDO::PARAM_INT);
    $stmtSuppr->execute();

    header("Location: panier.php");

} catch (PDOException $e) {
    echo "Erreur lors de l'exécution de la procédure : " . $e->getMessage();
}
?>
