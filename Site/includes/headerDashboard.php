<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
require_once("./connect.inc.php");
require_once("connexionSecurisee.php");
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Style et Semelle</title>
    <!-- Boostrap style et classes -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Lien vers le CSS de Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/footer.css">
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/button.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="icon" type="images/iconEntreprise.ico" href="images/iconEntreprise.ico">
</head>

<body>
    <header>
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container-fluid d-flex justify-content-between">
                <!-- Logo et nom de l'entreprise alignés à droite -->
                <div class="d-flex align-items-center">
                    <img src="images/iconEntreprise.png" class="img-fluid d-inline-block align-top me-2" alt="Logo"
                        style="height: 50px; width: auto;">
                    <a class="navbar-brand mb-0" style="font-weight: 700; color: rgb(2, 164, 21);"
                        href="index.php">Style et Semelle.</a>
                </div>

                <!-- Barre de recherche centrée -->
                <div class="search-container d-flex align-items-center flex-grow-1 justify-content-center"
                    style="flex-basis: 300px; max-width: 600px;">
                    <!-- Formulaire de recherche -->
                    <form action="zdashboard.php" method="POST" class="d-flex w-100">
                        <!-- Champ de recherche -->
                        <input class="form-control rounded-pill me-2" type="search" name="barreRecherche"
                            placeholder="Rechercher..." aria-label="Search" required
                            value="<?php echo isset($_POST['barreRecherche']) ? htmlspecialchars($_POST['barreRecherche']) : ''; ?>">
                        <!-- Bouton de recherche -->
                        <button class="btn btn-outline-secondary rounded-pill" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </form>
                </div>


                <!-- Icônes utilisateur et panier alignés à gauche -->
                <div class="d-flex icons-redirec" style="gap: 1.5rem;">
                    <!-- Dropdown pour l'utilisateur -->
                    <div class="dropdown">
                        <a href="#" class="nav-icon me-3" id="userDropdown" data-bs-toggle="dropdown"
                            aria-expanded="false" style="color: #333; font-size: 1.7rem;">
                            <i class="bi bi-person"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-lg-end dropdown-menu-start"
                            aria-labelledby="userDropdown">
                            <?php if (isset($_SESSION['user'])): ?>
                            <li>
                                <span class="dropdown-item-text">Bonjour,
                                    <?php echo $_SESSION['user']['PRENOM']; ?></span>
                                <a class="dropdown-item" href="compte.php">Mon profil</a>
                                <form action="deconnexion.php" method="post">
                                    <input type="hidden" name="logout" value="true">
                                    <button type="submit" class="dropdown-item">Déconnexion</button>
                                </form>
                                <?php if ($_SESSION['user']['IDROLE'] == '1') {
                                        echo "<hr>";
                                        echo "<form action='zMenuDashboard.php' method='post'>";
                                        echo "<button type='submit' class='dropdown-item'>Dashboard</button>";
                                        echo "</form>";
                                    } ?>
                            </li>
                            <?php else: ?>
                            <li><a class="dropdown-item" href="login.php">Connexion</a></li>
                            <?php endif; ?>
                        </ul>
                    </div>

                    <!-- Icône du panier -->
                    <a href="<?php echo isset($_SESSION['user']) ? 'panier.php' : 'login.php'; ?>" class="nav-icon me-3"
                        style="color: #333; font-size: 1.7rem;">
                        <i class="bi bi-cart"></i>
                    </a>
                </div>
        </nav>
        <?php
        $currentPage = basename($_SERVER['PHP_SELF']);
        if ($currentPage !== 'zMenuDashboard.php') {
        ?>
        <!-- Nouvelle barre de navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-light">
            <div class="container">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#dashboardMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="dashboardMenu">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="zdashboard.php" style="color:black;">Produits disponibles</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="zproduitDeleted.php" style="color:black;">Produits non
                                disponibles</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="zAjouterProduitAdmin.php" style="color:black;">Ajouter produit</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <?php
        }
        ?>
    </header></br></br>