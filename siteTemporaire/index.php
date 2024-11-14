<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil</title>
    <a href="header.css"></a>
    <a href="index.css"></a>
   
   
</head>

<body class="d-flex flex-column min-vh-100">

    <!-- header -->
    <header class="bg-primary text-white text-center py-1">
        <div class="container">
            <h1 id="titre">Style & semelle.</h1>
            <a href="images/loupe.png" id="loupe"></a>
            <a href="images/user.png" id="user"></a>
        </div>
    </header>

    <!-- Conteneur principal -->
    <div class="container-fluid flex-grow-1">
        <div class="row">
 <!-- Menu vertical sur la gauche -->
 <nav id="sidebar" class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
            <div class="position-sticky">
                <ul class="nav nav-pills flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="index.php"> Accueil </a>
                    </li> 
                    <li class="nav-item">
                        <a class="nav-link" href="ConsultPrix.php"> Consulter les produits par prix </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href=" ConsultCat.php"> Consulter les produits par catalogue</a>
                    </li>
                  
                </ul>
            </div>
        </nav>

            <!-- Contenu principal -->
            <main role="main" class="col-md-9 ms-sm-auto col-lg-10 px-4">
               <h1><center>Bienvenue sur mon site</center></h1>
               <p>Je suis le site officiel </p>
               <p>Je suis le vrai </p>
               <?php
include("connect.inc.php");

try {
    $req = $conn->prepare("SELECT * FROM Role ");
    $req->execute();

    while ($row = $req->fetch(PDO::FETCH_ASSOC)) {
        echo "Nom de la catégorie : " . htmlspecialchars($row['nomRole']) . "<br>";
    }
} catch (PDOException $e) {
    echo "Erreur dans la requête : " . $e->getMessage();
}
?>

            </main>

        </div>
    </div>

    <!-- Pied de page -->
    <footer class="bg-dark text-white text-center py-1 mt-auto">
        <div class="container">
            <a href="mentionLegal.php">Mention Legal</a>
            <a href="quiSommesNous.php">Qui sommes nous ?</a>
        </div>
    </footer>

</body>

</html>