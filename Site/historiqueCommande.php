<?php
require_once 'includes/header.php';
require_once 'connect.inc.php';
$securePage = true;
require_once 'includes/connexionSecurisee.php';

$userId = $_SESSION['user']['IDUTILISATEUR'];
$commandes = [];

try {
    // Récupère les commandes de l'utilisateur
    $stmt = $conn->prepare("CALL GetCommandesUtilisateurs(:userId)");
    $stmt->bindParam(':userId', $userId, PDO::PARAM_INT);
    $stmt->execute();
    $commandes = $stmt->fetchAll(PDO::FETCH_ASSOC);
    // Ressemble à ca : IDCOMMANDE, IDADRLIVRAISON, IDADRFACTURATION, IDSTATUT, DESCSTATUT, IDMODEPAIEMENT, DATECOMMANDE, IDPANIER

    // Récupère la description du statut de la commande
    foreach ($commandes as $key => $commande) {
        $stmt = $conn->prepare("SELECT DESCSTATUT FROM STATUTCOMMANDE WHERE IDSTATUT = :idStatut");
        $stmt->bindParam(':idStatut', $commande['IDSTATUT'], PDO::PARAM_INT);
        $stmt->execute();
        $commandes[$key]['DESCSTATUT'] = $stmt->fetchColumn();
    }

    // Récupère l'adresse de livraison
    foreach ($commandes as $key => $commande) {
        $stmt = $conn->prepare("SELECT NOM, PRENOM, ADRESSE, VILLE, CODEPOSTAL, PAYS, TELEPHONE FROM ADRESSE WHERE IDADRESSE = :idAdresse");
        $stmt->bindParam(':idAdresse', $commande['IDADRLIVRAISON'], PDO::PARAM_INT);
        $stmt->execute();
        $commandes[$key]['LIVRAISON'] = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Récupère l'adresse de facturation
    foreach ($commandes as $key => $commande) {
        $stmt = $conn->prepare("SELECT NOM, PRENOM, ADRESSE, VILLE, CODEPOSTAL, PAYS, TELEPHONE FROM ADRESSE WHERE IDADRESSE = :idAdresse");
        $stmt->bindParam(':idAdresse', $commande['IDADRFACTURATION'], PDO::PARAM_INT);
        $stmt->execute();
        $commandes[$key]['FACTURATION'] = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Récupère le mode de paiement
    foreach ($commandes as $key => $commande) {
        $stmt = $conn->prepare("SELECT DESCPAIEMENT FROM MODEPAIEMENT WHERE IDMODEPAIEMENT = :idModePaiement");
        $stmt->bindParam(':idModePaiement', $commande['IDMODEPAIEMENT'], PDO::PARAM_INT);
        $stmt->execute();
        $commandes[$key]['IDMODEPAIEMENT'] = $stmt->fetchColumn();
    }

    // Récupère les produits de chaque commande en utilisant la procédure stockée GetProduitDetailsByPanier
    foreach ($commandes as $key => $commande) {
        $stmt = $conn->prepare("CALL GetProduitDetailsByPanier(:idPanier)");
        $stmt->bindParam(':idPanier', $commande['IDPANIER'], PDO::PARAM_INT);
        $stmt->execute();
        $commandes[$key]['PRODUITS'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Calcule le total de chaque commande
    foreach ($commandes as $key => $commande) {
        $total = 0;
        foreach ($commande['PRODUITS'] as $product) {
            $total += $product['PRIX'] * $product['QTEPP'];
        }
        $commandes[$key]['TOTAL'] = $total;
    }
} catch (PDOException $e) {
    echo "<p class='text-danger'>Erreur SQL : " . $e->getMessage() . "</p>";
}
?>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/historiqueCommande.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <title>Historique des commandes</title>
</head>

<body>
    <div class="container py-5">
        <h1 class="text-center mb-4">Historique de vos commandes</h1>
        <div class="row justify-content-center">
            <?php if (empty($commandes)) : ?>
                <div class="col-12">
                    <div class="alert alert-info text-center" role="alert">
                        Vous n'avez pas encore passé de commande.
                    </div>
                </div>
            <?php else : ?>
                <div class="col-12 col-md-8">
                    <?php foreach ($commandes as $commande) : ?>
                        <div class="card mb-4 shadow-sm">
                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0">
                                    Commande passée le : <?= htmlspecialchars($commande['DATECOMMANDE']) ?>
                                </h5>
                            </div>
                            <div class="card-body">
                                <p class="card-text"><strong>Statut :</strong> <?= htmlspecialchars($commande['DESCSTATUT'] ?? 'Inconnu') ?></p>
                                <p class="card-text">
                                    <strong>Adresse de livraison :</strong>
                                    <?= isset($commande['LIVRAISON'])
                                        ? htmlspecialchars(implode(', ', $commande['LIVRAISON']))
                                        : 'Non spécifiée' ?>
                                </p>
                                <p class="card-text">
                                    <strong>Adresse de facturation :</strong>
                                    <?= isset($commande['FACTURATION'])
                                        ? htmlspecialchars(implode(', ', $commande['FACTURATION']))
                                        : 'Non spécifiée' ?>
                                </p>
                                <p class="card-text"><strong>Mode de paiement :</strong> <?= htmlspecialchars($commande['IDMODEPAIEMENT'] ?? 'Non spécifié') ?></p>
                                <p class="card-text"><strong>Produits :</strong></p>
                                <ul>
                                    <?php foreach ($commande['PRODUITS'] as $product) : ?>
                                        <li>
                                            <a href="detailProduit.php?idProduit=<?= htmlspecialchars($product['IDPRODUIT']) ?>">
                                                <?= htmlspecialchars($product['NOMPRODUIT']) ?>
                                            </a> x <?= htmlspecialchars($product['QTEPP']) ?> - <?= htmlspecialchars(number_format($product['PRIXACHAT'], 2)) ?> €
                                            (Taille: <?= htmlspecialchars($product['TAILLE']) ?>, Couleur: <?= htmlspecialchars($product['COULEUR']) ?>)
                                        </li>
                                    <?php endforeach; ?>
                                </ul>
                                <p class="card-text"><strong>Total :</strong> <?= htmlspecialchars(number_format($commande['TOTAL'], 2)) ?> €</p>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </div>
    </div>
</body>

</html>