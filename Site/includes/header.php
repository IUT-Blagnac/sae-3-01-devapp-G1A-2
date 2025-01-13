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
                    <form action="listeProduits.php" method="GET" class="d-flex w-100">
                        <!-- Champ de recherche -->
                        <input class="form-control rounded-pill me-2" type="search" name="barreRecherche"
                            placeholder="Rechercher..." aria-label="Search" required
                            value="<?php echo isset($_GET['barreRecherche']) ? htmlspecialchars($_GET['barreRecherche']) : ''; ?>">
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
                                <p class="dropdown-item-text">Bonjour, <?php echo $_SESSION['user']['PRENOM']; ?></p>
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

        <nav class="navbar navbar-expand-lg navbar-dark bg-light category-nav">
            <div class="container">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#categoryMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <!-- catégories dynamisées -->
                <div class="collapse navbar-collapse" id="categoryMenu">
                    <ul class="navbar-nav">
                        <?php
                        $reqCategories = "SELECT * FROM CATEGORIE C WHERE IDPARENT IS NULL";
                        $result1 = $conn->prepare($reqCategories);
                        $result1->execute();

                        // Récupération des catégories principales
                        $categories = $result1->fetchAll(PDO::FETCH_ASSOC);

                        foreach ($categories as $categorie) {
                            echo '<li class="nav-item dropdown">';
                            echo '<a class="nav-link" style="color: white; font-weight: 500; font-size: large;" href="listeProduits.php?idCategorie=' . htmlspecialchars($categorie['IDCATEGORIE']) . '">' .
                                htmlspecialchars($categorie['NOMCATEGORIE']) .
                                '</a>';
                            echo '<div class="dropdown-menu">';

                            // Requête pour récupérer les sous-catégories
                            $reqSousCategories = "SELECT * FROM CATEGORIE C WHERE IDPARENT = :idParent";
                            $result2 = $conn->prepare($reqSousCategories);
                            $result2->execute(['idParent' => $categorie['IDCATEGORIE']]);

                            // Récupération des sous-catégories
                            $sousCategories = $result2->fetchAll(PDO::FETCH_ASSOC);

                            foreach ($sousCategories as $sousCategorie) {
                                echo '<a class="dropdown-item" href="listeProduits.php?idCategorie=' . htmlspecialchars($sousCategorie['IDCATEGORIE']) . '">' .
                                    htmlspecialchars($sousCategorie['NOMCATEGORIE']) .
                                    '</a>';
                            }

                            echo '</div>'; // Fin du dropdown-menu
                            echo '</li>';  // Fin du nav-item
                        }
                        ?>

                    </ul>
                </div>
            </div>
        </nav>
    </header>