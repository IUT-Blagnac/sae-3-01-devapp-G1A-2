<?php
require_once 'includes/header.php';
require_once 'connect.inc.php';
$securePage = true;
require_once 'includes/connexionSecurisee.php';

$idUtilisateur = $_SESSION['user']['IDUTILISATEUR'];

// Récupérer les informations du panier
try {
    $requete = $conn->prepare("CALL GetPanier(:idUtilisateur, @panierId)");
    $requete->bindParam(':idUtilisateur', $idUtilisateur);
    $requete->execute();
    $idPanier = $conn->query("SELECT @panierId AS PanierActif")->fetch()['PanierActif'];

    $requete = $conn->prepare("CALL GetProduitsPanier(:idPanier)");
    $requete->bindParam(':idPanier', $idPanier);
    $requete->execute();
    $produitsPanier = $requete->fetchAll(PDO::FETCH_ASSOC);

    if (empty($produitsPanier)) {
        echo "<p class='text-danger'>Votre panier est vide.</p>";
        exit();
    }
} catch (PDOException $e) {
    error_log("Erreur PDO : " . $e->getMessage());
    echo "<p class='text-danger'>Erreur lors de la récupération du panier.</p>";
    exit();
}

// Récupérer les adresses existantes de l'utilisateur
try {
    $requete = $conn->prepare("CALL GetAdressesUtilisateur(:idUtilisateur)");
    $requete->bindParam(':idUtilisateur', $idUtilisateur);
    $requete->execute();
    $adresses = $requete->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    error_log("Erreur PDO : " . $e->getMessage());
    echo "<p class='text-danger'>Erreur lors de la récupération des adresses.</p>";
}

// Récupérer les modes de paiement disponibles
try {
    $requete = $conn->prepare("SELECT * FROM MODEPAIEMENT");
    $requete->execute();
    $modesPaiement = $requete->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    error_log("Erreur PDO : " . $e->getMessage());
    echo "<p class='text-danger'>Erreur lors de la récupération des modes de paiement.</p>";
    exit();
}

$modePaiementSelectionne = isset($_POST['modePaiement']) ? $_POST['modePaiement'] : '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['ValideCommande'])) {

    // Vérifier que les stocks sont suffisants
    try {
        $stockSuffisant = true;
        foreach ($produitsPanier as $produit) {
            $requete = $conn->prepare("CALL GetStock(:idProduitAttr, @stock)");
            $requete->bindParam(':idProduitAttr', $produit['IDPRODUIT_ATTR']);
            $requete->execute();
            $stock = $conn->query("SELECT @stock AS stock")->fetch()['stock'];

            if ($stock < $produit['QTEPP']) {
                $stockSuffisant = false;
                break;
            }

            echo "Stock : " . $stock . " QTEPP : " . $produit['QTEPP'] . "<br>";
        }

        // if (!$stockSuffisant) {
        //     echo "<p class='text-danger'>Stock insuffisant pour un ou plusieurs produits de votre commande.</p>";
        //     exit();
        // }
    } catch (PDOException $e) {
        error_log("Erreur PDO : " . $e->getMessage());
        echo "<p class='text-danger'>Erreur lors de la vérification des stocks.</p>";
        exit();
    }

    // Valider la commande
    try {
        // Récupère l'id du mode de paiement
        $requete = $conn->prepare("SELECT IDMODEPAIEMENT FROM MODEPAIEMENT WHERE NOMPAIEMENT = :modePaiement");
        $requete->bindParam(':modePaiement', $modePaiementSelectionne);
        $requete->execute();
        $idModePaiement = $requete->fetch()['IDMODEPAIEMENT'];

        echo "ID Panier : " . $idPanier . "<br>";
        echo "Adresse Livraison : " . $_POST['adresseLivraison'] . "<br>";
        echo "Adresse Facturation : " . $_POST['adresseFacturation'] . "<br>";
        echo "Mode Paiement : " . $idModePaiement . "<br>";
        echo "ID Utilisateur : " . $idUtilisateur . "<br>";

        $adresseLivraison = $_POST['adresseLivraison'];
        $adresseFacturation = $_POST['adresseFacturation'];

        echo($idModePaiement);
        error_log("Mode Paiement récupéré : " . $idModePaiement);


        $requete = $conn->prepare("CALL ValiderCommande(:idPanier, :adresseLivraison, :adresseFacturation, :idUtilisateur, :modePaiement)");
        $requete->bindParam(':idPanier', $idPanier);
        $requete->bindParam(':adresseLivraison', $adresseLivraison);
        $requete->bindParam(':adresseFacturation', $adresseFacturation);
        $requete->bindParam(':idUtilisateur', $idUtilisateur);
        $requete->bindParam(':modePaiement', $idModePaiement);
        $requete->execute();

        echo "<script>window.location.href = 'historiqueCommande.php';</script>";
        exit();
    } catch (PDOException $e) {
        error_log("Erreur PDO : " . $e->getMessage());
        echo "<p class='text-danger'>Erreur lors de la validation de la commande.</p>";
        echo $e->getMessage();
        echo $e->getTraceAsString();
    }
}

// Récupérer les adresses existantes de l'utilisateur (mise à jour après ajout)
try {
    $requete = $conn->prepare("CALL GetAdressesUtilisateur(:idUtilisateur)");
    $requete->bindParam(':idUtilisateur', $idUtilisateur);
    $requete->execute();
    $adresses = $requete->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    error_log("Erreur PDO : " . $e->getMessage());
    echo "<p class='text-danger'>Erreur lors de la récupération des adresses.</p>";
}
?>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/panier.css">
    <link rel="stylesheet" href="css/button.css">
    <link rel="stylesheet" href="css/valideCommande.css">
</head>

<body>
    <div class="container py-5">
        <div class="form-container">
            <h1 class="mb-4">Validation de la commande</h1>
            <!-- Formulaire de validation de la commande -->
            <form action="commande.php" method="POST">
                <!-- Adresse de livraison -->
                <div class="mb-3">
                    <label for="adresseLivraison" class="form-label">Adresse de livraison</label>
                    <select id="adresseLivraison" name="adresseLivraison" class="form-control" onchange="if (this.value === 'new') { window.location.href = 'creeAdresse.php?from=commande'; }">
                        <option value="">Sélectionner une adresse</option>
                        <?php
                        foreach ($adresses as $adresse) {
                            $selected = (isset($_POST['adresseLivraison']) && $_POST['adresseLivraison'] == $adresse['IDADRESSE']) || ($adresseAjouteeId && $adresseAjouteeId == $adresse['IDADRESSE']) ? 'selected' : '';
                            echo '<option value="' . htmlspecialchars($adresse['IDADRESSE']) . '" ' . $selected . '>' . htmlspecialchars($adresse['ADRESSE']) . ', ' . htmlspecialchars($adresse['VILLE']) . ', ' . htmlspecialchars($adresse['CODEPOSTAL']) . ', ' . htmlspecialchars($adresse['PAYS']) . '</option>';
                        }
                        ?>
                        <option value="new">Ajouter une nouvelle adresse</option>
                    </select>
                </div>
                <!-- Adresse de facturation -->
                <div class="mb-3">
                    <label for="adresseFacturation" class="form-label">Adresse de facturation</label>
                    <select id="adresseFacturation" name="adresseFacturation" class="form-control" onchange="if (this.value === 'new') { window.location.href = 'creeAdresse.php?from=commande'; }" required>
                        <option value="">Sélectionner une adresse</option>
                        <?php
                        foreach ($adresses as $adresse) {
                            $selected = (isset($_POST['adresseFacturation']) && $_POST['adresseFacturation'] == $adresse['IDADRESSE']) || ($adresseAjouteeId && $adresseAjouteeId == $adresse['IDADRESSE']) ? 'selected' : '';
                            echo '<option value="' . htmlspecialchars($adresse['IDADRESSE']) . '" ' . $selected . '>' . htmlspecialchars($adresse['ADRESSE']) . ', ' . htmlspecialchars($adresse['VILLE']) . ', ' . htmlspecialchars($adresse['CODEPOSTAL']) . ', ' . htmlspecialchars($adresse['PAYS']) . '</option>';
                        }
                        ?>
                        <option value="new">Ajouter une nouvelle adresse</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="modePaiement" class="form-label">Mode de Paiement</label>
                    <select id="modePaiement" name="modePaiement" class="form-control" onchange="this.form.submit()" required>
                        <option value="">Sélectionner un mode de paiement</option>
                        <?php
                        foreach ($modesPaiement as $mode) {
                            $selected = ($modePaiementSelectionne == $mode['NOMPAIEMENT']) ? 'selected' : '';
                            echo '<option value="' . htmlspecialchars($mode['NOMPAIEMENT']) . '" ' . $selected . '>' . htmlspecialchars($mode['NOMPAIEMENT']) . '</option>';
                        }
                        ?>
                    </select>
                </div>

                <!-- Afficher le formulaire de carte de crédit ou PayPal en fonction du mode de paiement sélectionné -->
                <?php if ($modePaiementSelectionne == 'Carte de crédit'): ?>
                    <div id="formCarte">
                        <div class="mb-3">
                            <label for="numeroCarte" class="form-label">Numéro de Carte</label>
                            <input type="text" id="numeroCarte" name="numeroCarte" class="form-control" minlength="12" maxlength="12" required>
                        </div>
                        <div class="mb-3">
                            <label for="dateExpiration" class="form-label">Date d'Expiration</label>
                            <input type="text" id="dateExpiration" name="dateExpiration" class="form-control" placeholder="MM/AA" minlength="5" maxlength="5" required>
                        </div>
                        <div class="mb-3">
                            <label for="cvv" class="form-label">CVV</label>
                            <input type="text" id="cvv" name="cvv" class="form-control" required>
                        </div>
                    </div>
                <?php elseif ($modePaiementSelectionne == 'PayPal'): ?>
                    <div id="formPayPal">
                        <div class="mb-3">
                            <label for="emailPayPal" class="form-label">Email PayPal</label>
                            <input type="email" id="emailPayPal" name="emailPayPal" class="form-control" required>
                        </div>
                    </div>
                <?php endif; ?>
                <input type="hidden" name="idPanier" value="<?php echo htmlspecialchars($idPanier); ?>">
                <button type="submit" class="btn btn-primary" name="ValideCommande">Valider la commande</button>
            </form>
        </div>

        <!-- Récapitulatif de la commande -->
        <div class="summary-container">
            <h2 class="mb-4">Récapitulatif de la commande</h2>
            <?php
            $prixTotal = 0;
            foreach ($produitsPanier as $produit) {
                $prixTotal += $produit['PRIXACHAT'] * $produit['QTEPP'];
                echo '<div class="mb-3">
                        <h6>' . htmlspecialchars($produit['NOMPRODUIT'], ENT_QUOTES) . '</h6>
                        <p>Quantité: ' . htmlspecialchars($produit['QTEPP'], ENT_QUOTES) . '</p>
                        <p>Prix: ' . number_format($produit['PRIXACHAT'], 2, ',', ' ') . '€</p>
                      </div>';
            }
            ?>
            <hr>
            <h4>Total: <?php echo number_format($prixTotal, 2, ',', ' '); ?>€</h4>
        </div>
    </div>
</body>

</html>

<?php
require_once 'includes/footer.php';
?>