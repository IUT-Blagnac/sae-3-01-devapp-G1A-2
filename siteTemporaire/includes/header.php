<?php
session_start();
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
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="css/footer.css">
</head>

<body>
    <header>
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container-fluid d-flex justify-content-between">
                <!-- Logo et nom de l'entreprise alignés à droite -->
                <div class="d-flex align-items-center">
                    <img src="images/iconEntreprise.jpg" class="img-fluid d-inline-block align-top me-2" alt="Logo" style="height: 50px; width: auto;">
                    <a class="navbar-brand mb-0" style="font-weight: 500;" href="index.php">Style et Semelle</a>
                </div>

                <!-- Barre de recherche centrée -->
                <div class="search-container d-flex align-items-center flex-grow-1 justify-content-center" style="flex-basis: 300px; max-width: 600px;">
                    <input class="form-control me-2" type="search" placeholder="Rechercher..." aria-label="Search">
                    <button class="btn btn-outline-secondary" type="button">
                        <i class="bi bi-search"></i>
                    </button>
                </div>

                <!-- Icônes utilisateur et panier alignés à gauche -->
                <div class="d-flex align-items-center" style="gap: 1.5rem;">
                    <!-- Dropdown pour l'utilisateur -->
                    <div class="dropdown">
                        <a href="#" class="nav-icon me-3" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false" style="color: #333; font-size: 1.7rem;">
                            <i class="bi bi-person"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <?php if (isset($_SESSION['user'])): ?>
                                <li>
                                    <p class="dropdown-item disabled">Bonjour, <?php echo $_SESSION['user']['PRENOM']; ?></p>
                                    <a class="dropdown-item" href="#">Mon profil</a>
                                    <form action="login.php" method="post">
                                        <input type="hidden" name="logout" value="true">
                                        <button type="submit" class="dropdown-item">Déconnexion</button>
                                    </form>
                                </li>
                            <?php else: ?>
                                <li><a class="dropdown-item" href="login.php">Connexion</a></li>
                            <?php endif; ?>
                        </ul>
                    </div>

                    <!-- Icône du panier -->
                    <a href="#" class="nav-icon me-3" style="color: #333; font-size: 1.7rem;">
                        <i class="bi bi-cart"></i>
                    </a>

                </div>
        </nav>

        <nav class="navbar navbar-expand-lg navbar-dark bg-dark category-nav">
            <div class="container">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#categoryMenu">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <!-- Navbar des catégories à dynamiser -->
                <div class="collapse navbar-collapse" id="categoryMenu">
                    <ul class="navbar-nav">
                        <li class="nav-item dropdown">
                            <a class="nav-link" style="color: white; font-weight: 500;" href="#">Nouveauté</a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#">New Arrivals</a>
                                <a class="dropdown-item" href="#">Trending</a>
                                <a class="dropdown-item" href="#">Collections</a>
                            </div>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link" style="color: white; font-weight: 500;" href="#">Homme</a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#">Sneakers</a>
                                <a class="dropdown-item" href="#">Formal</a>
                                <a class="dropdown-item" href="#">Sports</a>
                            </div>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link" style="color: white; font-weight: 500;" href="#">Femme</a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#">Heels</a>
                                <a class="dropdown-item" href="#">Flats</a>
                                <a class="dropdown-item" href="#">Boots</a>
                            </div>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link" style="color: white; font-weight: 500;" href="#">Enfant</a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#">Boys</a>
                                <a class="dropdown-item" href="#">Girls</a>
                                <a class="dropdown-item" href="#">Toddlers</a>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>