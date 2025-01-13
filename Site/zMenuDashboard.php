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
    <!-- Inclurele Javascript de Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
    <!-- Inclure les fichiers CSS de Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <!-- Inclure les fichiers CSS personnalisés -->
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/button.css">
    <link rel="stylesheet" href="css/menuAdminDashboard.css">
</head>
<html>

<body>
    <center>
        <h1>Menu du dashboard administrateur</h1>
    </center>
    <div class="container">
        <div class="row">
            <div class="col-sm-6 col-md-4 col-lg-3 mb-4">
                <a href="zdashboard.php" class="card-link">
                    <div class="card shadow-sm custom-card">
                        <!-- <img class="card-img-top" src="..." alt="Card image cap"> -->
                        <div class="card-body">
                            <h5 class="card-title">Voir les produits disponibles</h5>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-sm-6 col-md-4 col-lg-3 mb-4">
                <a href="zproduitDeleted.php" class="card-link">
                    <div class="card shadow-sm custom-card">
                        <!-- <img class="card-img-top" src="..." alt="Card image cap"> -->
                        <div class="card-body">
                            <h5 class="card-title">Voir les produits non disponibles (statut supprimé)</h5>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-sm-6 col-md-4 col-lg-3 mb-4">
                <a href="zAjouterProduitAdmin.php" class="card-link">
                    <div class="card shadow-sm custom-card">
                        <!-- <img class="card-img-top" src="..." alt="Card image cap"> -->
                        <div class="card-body">
                            <h5 class="card-title">+ Ajouter un produit</h5>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</body>

</html>