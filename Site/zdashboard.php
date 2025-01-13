<?php
$securePage = true;

require_once 'connect.inc.php';
require_once 'includes/connexionSecuriseeAdmin.php';
require_once 'includes/headerDashboard.php';
require_once 'ztraitProduitDashboard.php';
?>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord</title>
    <!-- Inclure les fichiers CSS de Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclure les fichiers CSS personnalisés -->
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/button.css">
    <link rel="stylesheet" href="css/dashboard.css">
</head>

<body>
    <center>
        <h1 style="margin-bottom:30px;">Liste des produits disponibles</h1>
    </center>
    <?php
    // test récupération de la recherche dans la barre de recherche (cf. name="barreRecherche dans headerDashboard.php)
    if (!empty($_POST['barreRecherche'])) {
        $motCleRecherche = htmlspecialchars($_POST['barreRecherche']);
        $tabProducts = list_products_filtered($conn, $motCleRecherche);
        //var_dump($tabProducts);
    } else {
        // sinon on affiche tous les produits 
        $tabProducts = list_products($conn); // appel à la fonction de traitProduitDashboard qui retourne la liste de tous les produits
        //var_dump($tabProducts);
    }
    if (!empty($tabProducts)) {
        echo '<div class="row">';
        foreach ($tabProducts as $prod) {

            echo '<div class="col-sm-6 col-md-4 col-lg-3 mb-4">
            <div class="card shadow-sm h-100 d-flex flex-column justify-content-between">
    
                <div class="card-img-top" style="background: url(\'' . $prod['URL'] . '\') no-repeat center; background-size: cover; height: 200px; border: 2px solid #ddd; border-radius: 8px;"></div>
    
                <div class="card-body text-center d-flex flex-column justify-content-between">
                    <h5 class="card-title">' . htmlspecialchars($prod['NOMPRODUIT']) . '</h5>
                    <a href="zmodifierProduit.php?idProduit=' . urlencode($prod["IDPRODUIT"]) .  '" class="btnlinkadmin">
                    <button class="btn btn-primary btn-sm" style="margin-bottom:10px;" data-product-id="' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                        Modifier
                    </button>
                    </a>
                    <a href="supprProdAdmin.php?idProduit=' . urlencode($prod["IDPRODUIT"]) .  '" class="btnlinkadmin">
                    <button class="btn btn-primary btn-sm" data-product-id="' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                        Supprimer
                    </button>
                    </a>
                </div>
            </div>
          </div>';
        }
        echo '</div>';
    } else {
        echo "AUCUN PRODUIT TROUVE";
    }

    ?>
    <!-- Inclure jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Inclure les fichiers JavaScript de Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>