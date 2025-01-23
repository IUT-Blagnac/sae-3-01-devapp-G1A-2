<?php
// includes
require_once 'connect.inc.php';
require_once 'includes/connexionSecurisee.php';
require_once 'includes/header.php';
require_once 'traitListeProduits.php';

// Initialisation des variables avec des valeurs par défaut
$searchValue = '';
$idC = null;
$tri = '';
$idMarque = null;
$minimum = 0;
$maximum = 1000;
$tabMarques = getMarques($conn);


// Récupération des critères
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['LD_TRI']) && !empty($_POST['LD_TRI'])) {
        $tri = $_POST['LD_TRI'];
    }
    if (isset($_POST['LD_MARQUE']) && !empty($_POST['LD_MARQUE'])) {
        $idMarque = $_POST['LD_MARQUE'];
    }
    if (isset($_POST['minValue']) && !empty($_POST['minValue'])) {
        $minimum = $_POST['minValue'];
    }
    if (isset($_POST['maxValue']) && !empty($_POST['maxValue'])) {
        $maximum = $_POST['maxValue'];
    }
}

if (!empty($_GET['barreRecherche'])) {
    $searchValue = htmlspecialchars($_GET['barreRecherche']);
}

if (isset($_GET['idCategorie'])) {
    $idC = $_GET['idCategorie'];
}

$titre = descriptionCategorie($conn, $idC);
?>

<head>
    <link rel="stylesheet" href="css/listeProduits.css">
    <link rel="stylesheet" href="css/button.css">
    <link rel="stylesheet" href="css/filtrePrix.css">
</head>

<section class="section-products">
    <div class="container principal">
        <div class="row justify-content-center text-center">
            <div class="col-md-8 col-lg-6">
                <div class="header">
                    <!-- Affichage de la description de la catégorie -->
                    <?php
                    if (!empty($titre)) {
                        echo '<h2>' . $titre . '</h2>';
                    } else if (!empty($searchValue)) {
                        echo '<h2>Résultats de recherche pour : ' . $searchValue . '</h2>';
                    } else {
                        echo ' <h2>Aucune description trouvée </h2>';
                    }
                    ?>
                </div>
            </div>
        </div>

        <div class="container mt-5">
            <form method="POST" action="<?php echo htmlspecialchars($_SERVER['REQUEST_URI'], ENT_QUOTES); ?>"
                class="d-inline-block" id="triForm">
                <fieldset class="fieldsetcontainer">
                    <select name="LD_TRI" class="form-control me-3">
                        <!-- Tri par défaut -->
                        <option value="" <?php echo isset($tri) && $tri === '' ? 'selected' : ''; ?>>
                            Tri par défaut
                        </option>

                        <!-- Tri par prix croissant -->
                        <option value="croissant" <?php echo isset($tri) && $tri === 'croissant' ? 'selected' : ''; ?>>
                            Trier par prix croissant
                        </option>

                        <!-- Tri par prix décroissant -->
                        <option value="decroissant"
                            <?php echo isset($tri) && $tri === 'decroissant' ? 'selected' : ''; ?>>
                            Trier par prix décroissant
                        </option>

                        <!-- Tri par nom croissant -->
                        <option value="nom_asc" <?php echo isset($tri) && $tri === 'nom_asc' ? 'selected' : ''; ?>>
                            Trier par nom croissant
                        </option>

                        <!-- Tri par nom décroissant -->
                        <option value="nom_desc" <?php echo isset($tri) && $tri === 'nom_desc' ? 'selected' : ''; ?>>
                            Trier par nom décroissant
                        </option>
                    </select>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="minValue" class="form-label">Prix minimum</label>
                            <input type="number" name="minValue" id="minValue" class="form-control"
                                value="<?= htmlspecialchars($minimum) ?>" min="0">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="maxValue" class="form-label">Prix maximum</label>
                            <input type="number" name="maxValue" id="maxValue" class="form-control"
                                value="<?= htmlspecialchars($maximum) ?>" min="0">
                        </div>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="marque">Marque : </label>
                        <select id="marqueSelect" name="LD_MARQUE">
                            <option value="">Sélectionnez une marque</option>
                            <?php
                            foreach ($tabMarques as $marque) {
                                $selected = isset($idMarque) && $idMarque == $marque['IDMARQUE'] ? 'selected' : '';
                                echo '<option value="' . $marque['IDMARQUE'] . '" ' . $selected . '>' . $marque['NOMMARQUE'] . '</option>';
                            }
                            ?>
                        </select>
                    </div>

                    <input type='submit' name='Appliquer' value='Appliquer' class='btn btn-primary' />
                    <br><br>
                </fieldset>
            </form>

        </div>

        <div class="row">
            <?php
            try {
                // Recherche des produits
                $tabProd = [];
                if (isset($searchValue) && !empty($searchValue)) { // Recherche par mot-clé
                    try {
                        $tabProd = listeProduitsRecherches($conn, $searchValue, $tri, $idMarque, $minimum, $maximum);
                    } catch (PDOException $e) {
                        echo "<p class='text-danger'>Erreur SQL : " . $e->getMessage() . "</p>";
                    }
                } elseif (isset($idC)) { // Recherche par catégorie
                    try {
                        $tabProd = listeProduitsCategorie($conn, $idC, $tri, $minimum, $maximum, $idMarque);
                    } catch (PDOException $e) {
                        echo "<p class='text-danger'>Erreur SQL : " . $e->getMessage() . "</p>";
                    }
                } else {
                    echo "<p class='text-danger'>Erreur de chargement.</p>";
                }

                if (!empty($tabProd) && count($tabProd) > 0) {
                    // Tri des résultats si nécessaire
                    if (!empty($tri)) {
                        usort($tabProd, function ($a, $b) use ($tri) {
                            if ($tri == 'croissant') {
                                return $a['PRIX'] <=> $b['PRIX'];
                            } elseif ($tri == 'decroissant') {
                                return $b['PRIX'] <=> $a['PRIX'];
                            } elseif ($tri == 'nom_asc') {
                                return strcmp($a['NOMPRODUIT'], $b['NOMPRODUIT']);
                            } elseif ($tri == 'nom_desc') {
                                return strcmp($b['NOMPRODUIT'], $a['NOMPRODUIT']);
                            }
                            return 0;
                        });
                    }

                    foreach ($tabProd as $prod) {
                        $imageUrl = !empty($prod['URL']) ? htmlspecialchars($prod['URL'], ENT_QUOTES) : './images/no-image.jpg';
                        echo '<div class="col-sm-6 col-md-4 col-lg-3 mb-4">
                  <a href="detailProduit.php?idProduit=' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                      <div class="card shadow-sm h-100 d-flex flex-column justify-content-between">
                          <div class="card-img-top" style="background: url(\'' . $imageUrl . '\') no-repeat center; background-size: cover; height: 200px; border: 2px solid #ddd; border-radius: 8px;"></div>
                          <div class="card-body text-center d-flex flex-column justify-content-between">
                              <h5 class="card-title">' . htmlspecialchars($prod['NOMPRODUIT']) . '</h5>
                              <p class="card-text price text-success font-weight-bold mb-2">' . number_format($prod['PRIX'], 2, ',', ' ') . ' €</p>
                              <a href="detailProduit.php?idProduit=' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                                  <button class="btn btn-primary btn-sm add-to-cart" data-product-id="' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                                      Voir le produit
                                  </button>
                              </a>
                          </div>
                      </div>
                  </a>
              </div>';
                    }
                } else {
                    echo "<p class='text-danger'>Aucun produit trouvé.</p>";
                }
            } catch (Exception $e) {
                echo "<p class='text-danger'>Erreur : " . $e->getMessage() . "</p>";
            }
            ?>
        </div>
    </div>
</section>
</body>

<?php require_once 'includes/footer.php'; ?>