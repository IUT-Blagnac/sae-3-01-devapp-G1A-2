<?php
require_once 'includes/header.php';
require_once 'includes/connexionSecurisee.php';

// Vérifier si l'utilisateur est connecté
if (isset($_SESSION['user'])) {
    $idUser = $_SESSION['user']['IDUTILISATEUR'];

    try {
        // Requête pour compter le nombre de produits dans le panier
        $req = "SELECT COUNT(*) 
                FROM PANIER P1, PRODUITPANIER P2
                WHERE P1.IDUTILISATEUR = :idUtilisateur AND P1.IDPANIER = P2.IDPANIER";

        // Préparer et exécuter la requête
        $result = $conn->prepare($req);
        $result->execute(['idUtilisateur' => $idUser]);

        // Récupérer directement le résultat de la colonne COUNT(*)
        $nbProd = $result->fetchColumn();

    } catch (PDOException $e) {
        // Gestion des erreurs sans exposer de données sensibles
        error_log("Erreur PDO : " . $e->getMessage());
        echo "<p class='text-danger'>Une erreur est survenue. Veuillez réessayer plus tard.</p>";
    }
?>


<head>
    <link rel="stylesheet" href="css/panier.css">
</head>

<section class="h-100 h-custom" style="background-color: #d2c9ff;">
  <div class="container py-5 h-100">
    <div class="row d-flex justify-content-center align-items-center h-100">
      <div class="col-12">
        <div class="card card-registration card-registration-2" style="border-radius: 15px;">
          <div class="card-body p-0">
            <div class="row g-0">
              <div class="col-lg-8">
                <div class="p-5">
                  <div class="d-flex justify-content-between align-items-center mb-5">
                    <h1 class="fw-bold mb-0"> Panier </h1>
                    <h6 class="mb-0 text-muted"> <?php echo $nbProd . ' produit(s) différent(s)' ?> </h6>
                  </div>
        
                  <?php
                    // Paramètres de pagination
                    $productsPerPage = 4; // Nombre de produits à afficher par page
                    $currentPage = isset($_GET['page']) ? (int)$_GET['page'] : 1; // Page actuelle
                    $start = ($currentPage - 1) * $productsPerPage; // Calcul de l'offset

                    try {
                        // Requête pour compter le nombre total de produits dans le panier
                        $reqCount = "SELECT COUNT(*) 
                                    FROM PANIER P1
                                    INNER JOIN PRODUITPANIER P2 ON P1.IDPANIER = P2.IDPANIER
                                    WHERE P1.IDUTILISATEUR = :idUtilisateur";
                        $resultCount = $conn->prepare($reqCount);
                        $resultCount->execute(['idUtilisateur' => $idUser]);
                        $totalProducts = $resultCount->fetchColumn(); // Nombre total de produits

                        // Calcul du nombre de pages
                        $totalPages = ceil($totalProducts / $productsPerPage);

                        // Requête pour récupérer les produits à afficher (avec pagination)
                        $req = "SELECT P1.IDPANIER, P3.NOMPRODUIT, P3.Prix, P3.DESCPRODUIT, I.URL, C.NOMCATEGORIE
                                FROM PANIER P1
                                INNER JOIN PRODUITPANIER P2 ON P1.IDPANIER = P2.IDPANIER
                                INNER JOIN PRODUIT P3 ON P2.IDPRODUIT = P3.IDPRODUIT
                                LEFT JOIN IMAGE I ON P3.IDPRODUIT = I.IDPRODUIT
                                INNER JOIN CATEGORIE C ON C.IDCATEGORIE = P3.IDCATEGORIE
                                WHERE P1.IDUTILISATEUR = :idUtilisateur
                                LIMIT :start, :limit";
                        $result = $conn->prepare($req);
                        $result->bindParam(':idUtilisateur', $idUser);
                        $result->bindParam(':start', $start, PDO::PARAM_INT);
                        $result->bindParam(':limit', $productsPerPage, PDO::PARAM_INT);
                        $result->execute();

                        $tabProd = $result->fetchAll(PDO::FETCH_ASSOC);

                        // Affichage des produits
                        if (count($tabProd) > 0) {
                            foreach ($tabProd as $prod) {
                                echo '<hr class="my-4">
                                    <div class="row mb-4 d-flex justify-content-between align-items-center">
                                        <div class="col-md-2 col-lg-2 col-xl-2">';
                                if (isset($prod['URL'])) {
                                    echo '<img src="' . htmlspecialchars($prod['URL'], ENT_QUOTES) . '" class="img-fluid rounded-3" alt="' . htmlspecialchars($prod['NOMPRODUIT'], ENT_QUOTES) . '">';
                                } else {
                                    echo '<img src="https://i.ibb.co/L8Nrb7p/1.jpg" class="img-fluid rounded-3" alt="' . htmlspecialchars($prod['NOMPRODUIT'], ENT_QUOTES) . '">';
                                }
                                
                                echo '</div>
                                    <div class="col-md-3 col-lg-3 col-xl-3">
                                        <h6 class="text-muted">' . htmlspecialchars($prod['NOMCATEGORIE'], ENT_QUOTES) . '</h6>
                                        <h6 class="mb-0">' . htmlspecialchars($prod['NOMPRODUIT'], ENT_QUOTES) . '</h6>
                                    </div>
                                    <div class="col-md-3 col-lg-3 col-xl-2 d-flex">
                                        <button data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2"
                                            onclick="this.parentNode.querySelector(\'input[type=number]\').stepDown()">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                        <input id="form1" min="0" name="quantity" value="1" type="number" class="form-control form-control-sm" />
                                        <button data-mdb-button-init data-mdb-ripple-init class="btn btn-link px-2"
                                            onclick="this.parentNode.querySelector(\'input[type=number]\').stepUp()">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </div>
                                    <div class="col-md-3 col-lg-2 col-xl-2 offset-lg-1">
                                        <h6 class="mb-0">€ ' . number_format($prod['Prix'], 2, ',', ' ') . '</h6>
                                    </div>
                                    <div class="col-md-1 col-lg-1 col-xl-1 text-end">
                                        <a href="#!" class="text-muted"><i class="fas fa-times"></i></a>
                                    </div>
                                </div>';
                            }
                        } else {
                            echo "<p class='text-danger'>Aucun produit dans le panier.</p>";
                        }

                        // Pagination
                        echo '<nav aria-label="Page navigation">';
                        echo '<ul class="pagination justify-content-center">';
                        echo '<li class="page-item ' . ($currentPage == 1 ? 'disabled' : '') . '">
                                <a class="page-link" href="?page=' . ($currentPage - 1) . '" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>';

                        for ($i = 1; $i <= $totalPages; $i++) {
                            echo '<li class="page-item ' . ($i == $currentPage ? 'active' : '') . '">
                                    <a class="page-link" href="?page=' . $i . '">' . $i . '</a>
                                </li>';
                        }

                        echo '<li class="page-item ' . ($currentPage == $totalPages ? 'disabled' : '') . '">
                                <a class="page-link" href="?page=' . ($currentPage + 1) . '" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>';
                        echo '</ul>';
                        echo '</nav>';
                    } catch (PDOException $e) {
                        error_log("Erreur PDO : " . $e->getMessage());
                        echo "<p class='text-danger'>Une erreur est survenue. Veuillez réessayer plus tard.</p>";
                    }
                ?>




                  <hr class="my-4">

                  <div class="pt-5">
                    <h6 class="mb-0"><a href="index.php" class="text-body"><i
                          class="fas fa-long-arrow-alt-left me-2"></i>Retour à l'accueil</a></h6>
                  </div>
                </div>
              </div>

              <!-- Partie résumé -->
              <div class="col-lg-4 bg-body-tertiary">
                <div class="p-5">
                  <h3 class="fw-bold mb-5 mt-2 pt-1">Résumé du panier</h3>
                  <hr class="my-4">

                  <div class="d-flex justify-content-between mb-4">
                    <h5 class="text-uppercase">items 3</h5>
                    <h5>€ 132.00</h5>
                  </div>

                  <h5 class="text-uppercase mb-3">Give code</h5>

                  <div class="mb-5">
                    <div data-mdb-input-init class="form-outline">
                      <input type="text" id="form3Examplea2" class="form-control form-control-lg" />
                      <label class="form-label" for="form3Examplea2">Enter your code</label>
                    </div>
                  </div>

                  <hr class="my-4">

                  <div class="d-flex justify-content-between mb-5">
                    <h5 class="text-uppercase">Total price</h5>
                    <h5>€ 137.00</h5>
                  </div>

                  <button  type="button" data-mdb-button-init data-mdb-ripple-init class="btn btn-dark btn-block btn-lg"
                    data-mdb-ripple-color="dark">Register</button>

                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<?php 
    } else {
        echo "<p class='text-danger'>Utilisateur non connecté.</p>";
    } 
?>
<footer>
    <?php require_once 'includes/footer.php'; ?>
</footer>