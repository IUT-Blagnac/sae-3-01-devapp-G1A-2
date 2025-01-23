<?php
require_once 'includes/header.php';
require_once 'includes/connexionSecurisee.php';

// Vérifier si l'utilisateur est connecté
if (isset($_SESSION['user'])) {
  $idUser = $_SESSION['user']['IDUTILISATEUR'];

  // Vérifier si l'utilisateur a cliqué sur le bouton de modification de la quantité
  if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['modif_qtt'])) {
    $idProduit = $_POST['idProduit'];
    $couleur = $_POST['Couleur'];
    $taille = $_POST['Taille'];
    $quantite = $_POST['quantity'];

    try {
      // Récupère l'id du panier actif de l'utilisateur
      $stmt = $conn->prepare("CALL GetPanier(:idUtilisateur, @panierId)");
      $stmt->bindParam(':idUtilisateur', $idUser);
      $stmt->execute();
      $idPanier = $conn->query("SELECT @panierId AS PanierActif")->fetch()['PanierActif'];
    } catch (PDOException $e) {
      error_log("Erreur PDO : " . $e->getMessage());
      echo "<p class='text-danger'>Erreur lors de la récupération du panier.</p>";
    }

    try {
      // Récupère l'idCouleur
      $stmt = $conn->prepare("CALL GetIdCouleur(:couleur, @idCouleur)");
      $stmt->bindParam(':couleur', $couleur);
      $stmt->execute();
      $idCouleur = $conn->query("SELECT @idCouleur AS idCouleur")->fetch()['idCouleur'];

      // Récupère l'idTaille
      $stmt = $conn->prepare("CALL GetIdTaille(:taille, @idTaille)");
      $stmt->bindParam(':taille', $taille);
      $stmt->execute();
      $idTaille = $conn->query("SELECT @idTaille AS idTaille")->fetch()['idTaille'];

      // Récupère l'idProduit_ATTR du produit dont la quantité doit être modifiée
      $stmt = $conn->prepare("CALL GetIdProduitAttr(:idProduit, :idCouleur, :idTaille, @idProduitAttr)");
      $stmt->bindParam(':idProduit', $idProduit);
      $stmt->bindParam(':idCouleur', $idCouleur);
      $stmt->bindParam(':idTaille', $idTaille);
      $stmt->execute();
      $idProduitAttr = $conn->query("SELECT @idProduitAttr AS idProduitAttr")->fetch()['idProduitAttr'];
    } catch (PDOException $e) {
      error_log("Erreur PDO : " . $e->getMessage());
      echo "<p class='text-danger'>Erreur lors de la récupération de l'ID du produit.</p>";
    }

    try {
      // Vérifie que la quantité demandée est inférieure au stock disponible et supérieure à 0
      $stmt = $conn->prepare("CALL GetStock(:idProduitAttr, @stock)");
      $stmt->bindParam(':idProduitAttr', $idProduitAttr);
      $stmt->execute();
      $stock = $conn->query("SELECT @stock AS stock")->fetch()['stock'];

      if ($quantite > $stock) {
        $quantite = $stock;
        $message = "Quantité modifiée à la quantité maximale disponible";
      } if ($quantite <= 0) {
        // Supprime le produit du panier si la quantité est nulle
        $stmt = $conn->prepare("CALL SupprimerProduitPanier(:idPanier, :idProduitAttr)");
        $stmt->bindParam(':idPanier', $idPanier);
        $stmt->bindParam(':idProduitAttr', $idProduitAttr);
        $stmt->execute();
        $message = "Produit supprimé du panier car quantité nulle";
      }
    } catch (PDOException $e) {
      error_log("Erreur PDO : " . $e->getMessage());
      echo "<p class='text-danger'>Erreur lors de la vérification du stock.</p>";
    }

    try {
      $stmt = $conn->prepare("CALL UpdateQuantiteProduitPanier(:idPanier, :idProduit_ATTR, :QTEPP)");
      $stmt->bindParam(':idPanier', $idPanier);
      $stmt->bindParam(':idProduit_ATTR', $idProduitAttr);
      $stmt->bindParam(':QTEPP', $quantite);
      $stmt->execute();
    } catch (PDOException $e) {
      error_log("Erreur PDO : " . $e->getMessage());
      echo "<p class='text-danger'>Une erreur est survenue. Veuillez réessayer plus tard.</p>";
    }
  }
?>

  <head>
    <link rel="stylesheet" href="css/panier.css">
    <link rel="stylesheet" href="css/button.css">
  </head>

  <section class="h-100 h-custom">
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
                    </div>

                    <?php
                    // Vérifier si un message doit être affiché
                    if (isset($message)) {
                      echo '<div class="alert alert-warning alert-dismissible fade show" role="alert">
                              ' . $message . '
                              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>';
                    }
                    try {
                      // Requête pour récupérer le panier actif de l'utilisateur
                      $req = "CALL GetPanier(:idUtilisateur, @panierId)";
                      $result = $conn->prepare($req);
                      $result->bindParam(':idUtilisateur', $idUser);
                      $result->execute();
                      $idPanier = $conn->query("SELECT @panierId AS PanierActif")->fetch()['PanierActif'];

                      // Requête pour récupérer les produits à afficher
                      $req = "CALL GetProduitsPanier(:idPanier)";
                      $result = $conn->prepare($req);
                      $result->bindParam(':idPanier', $idPanier);
                      $result->execute();

                      $tabProd = $result->fetchAll(PDO::FETCH_ASSOC);

                      // Affichage des produits
                      if (count($tabProd) > 0) {
                        foreach ($tabProd as $prod) {
                          echo '<hr class="my-4">
                                    <div class="row mb-4 d-flex justify-content-between align-items-center">
                                        <div class="col-md-2 col-lg-2 col-xl-2">';
                          if (isset($prod['URL'])) {
                            echo '<a href="detailProduit.php?idProduit=' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                                                  <img src="' . htmlspecialchars($prod['URL'], ENT_QUOTES) . '" class="img-fluid rounded-3" alt="' . htmlspecialchars($prod['NOMPRODUIT'], ENT_QUOTES) . '">
                                                </a>';
                          } else {
                            echo '<a href="detailProduit.php?idProduit=' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                                                    <img src="images/no-image.jpg" class="img-fluid rounded-3" alt="' . htmlspecialchars($prod['NOMPRODUIT'], ENT_QUOTES) . '">
                                                  </a>';
                          }

                          echo '</div>
                                    <div class="col-md-3 col-lg-3 col-xl-3">
                                        <h6 class="text-muted">' . htmlspecialchars($prod['NOMCATEGORIE'], ENT_QUOTES) . '</h6>
                                        <h6 class="mb-0">' . htmlspecialchars($prod['NOMPRODUIT'], ENT_QUOTES) . '</h6><br>
                                        <h6 class="text-muted"> Taille : ' . htmlspecialchars($prod['TAILLE'], ENT_QUOTES) . '</h6>
                                        <h6 class="text-muted"> Couleur : ' . htmlspecialchars($prod['COULEUR'], ENT_QUOTES) . '</h6>
                                    </div>
                                    <div class="col-md-3 col-lg-3 col-xl-2 d-flex">
                                        <form method="POST" action="panier.php">
                                            <input type="hidden" name="idProduit" value="' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                                            <input type="hidden" name="Couleur" value="' . htmlspecialchars($prod['COULEUR'], ENT_QUOTES) . '">
                                            <input type="hidden" name="Taille" value="' . htmlspecialchars($prod['TAILLE'], ENT_QUOTES) . '">
                                            <button type="button" class="btn btn-link px-2" onclick="this.parentNode.querySelector(\'input[type=number]\').stepUp(); this.parentNode.submit();">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                            <input id="form1" min="0" name="quantity" value="' . htmlspecialchars($prod['QTEPP'], ENT_QUOTES) . '" type="number" class="form-control text-center" style="width: 60px;" onchange="this.form.submit()" readonly>
                                            <button type="button" class="btn btn-link px-2" onclick="this.parentNode.querySelector(\'input[type=number]\').stepDown(); this.parentNode.submit();">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <input type="hidden" name="modif_qtt" value="1">
                                        </form>
                                    </div>
                                    <div class="col-md-3 col-lg-2 col-xl-2 offset-lg-1">
                                        <h6 class="mb-0">' . number_format($prod['PRIXACHAT'], 2, ',', ' ') . '€</h6>
                                    </div>
                                    <div class="col-md-1 col-lg-1 col-xl-1 text-end">
                                      <a href="supprimerProduitPanier.php?idProduit=' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '&taille=' . htmlspecialchars($prod['TAILLE'], ENT_QUOTES) . '&couleur=' . htmlspecialchars($prod['COULEUR'], ENT_QUOTES) . '" class="text-danger">
                                        <i class="fas fa-times"></i>
                                      </a>
                                    </div>
                                </div>';
                        }
                      } else {
                        echo "<p class='text-danger'>Aucun produit dans le panier.</p>";
                      }
                    } catch (PDOException $e) {
                      error_log("Erreur PDO : " . $e->getMessage());
                      echo "<p class='text-danger'>Une erreur est survenue. Veuillez réessayer plus tard.</p>";
                    }
                    ?>
                    <hr class="my-4">

                    <div class="pt-5">
                      <h6 class="mb-0"><a href="index.php" class="text-body"><i
                            class="fas fa-long-arrow-alt-left me-2"></i>Retour à l'accueil</a>
                      </h6>
                    </div>
                  </div>
                </div>

                <!-- Partie résumé -->
                <div class="col-lg-4 bg-body-tertiary">
                  <div class="p-5">
                    <h3 class="fw-bold mb-5 mt-2 pt-1">Résumé du panier</h3>
                    <hr class="my-4">

                    <div class="d-flex justify-content-between mb-4">
                      <h5 class="text-uppercase">Prix avant réduction</h5>
                      <?php
                      $prixTotal = 0;
                      foreach ($tabProd as $prod) {
                        $prixTotal += $prod['PRIXACHAT'] * $prod['QTEPP'];
                      }
                      echo '<h5>' . number_format($prixTotal, 2, ',', ' ') . '€</h5>';
                      ?>
                    </div>

                    <h5 class="text-uppercase mb-3">Code de réduction</h5>

                    <div class="mb-5">
                      <div data-mdb-input-init class="form-outline">
                        <input type="text" id="form3Examplea2"
                          class="form-control form-control-lg" />
                        <label class="form-label" for="form3Examplea2">Entrez votre code de
                          réduction</label>
                      </div>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex justify-content-between mb-5">
                      <h5 class="text-uppercase">Prix final</h5>
                      <?php
                      // INCLURE LE CALCUL DE LA RÉDUCTION ICI QUAND IL SERA PRET EN BD
                      echo '<h5>' . number_format($prixTotal, 2, ',', ' ') . '€</h5>';
                      ?>
                    </div>

                    <form action="commande.php">
                      <input type="submit" class="btn btn-primary btn-lg" value="Valider la commande"
                        <?php if (count($tabProd) === 0) echo 'disabled'; ?>>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <footer>
    <?php
    require_once 'includes/footer.php';
    ?>

  <?php
} else {
  echo "<p class='text-danger'>Utilisateur non connecté.</p>";
}
  ?>