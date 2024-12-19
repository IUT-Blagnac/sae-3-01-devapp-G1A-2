<?php
    require_once 'includes/header.php';
?>

<head>
    <link rel="stylesheet" href="css/listeProduits.css">
</head>

<section class="section-products">
		<div class="container">
				<div class="row justify-content-center text-center">
						<div class="col-md-8 col-lg-6">
								<div class="header">
                                <?php
                                    // Nombre de produits par page
                                    $productsPerPage = 8;

                                    // Page courante (ou 1 si aucune page n'est spécifiée)
                                    $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;

                                    // Calcul du point de départ pour la pagination
                                    $start = ($page - 1) * $productsPerPage;

                                    if (isset($_GET['idCategorie'])) {
                                        // Construire la requête SQL avec tri
                                        $idC = filter_input(INPUT_GET, 'idCategorie', FILTER_VALIDATE_INT);

                                        // Validation et récupération sécurisée de idCategorie depuis l'URL
                                        if (!$idC) {
                                            echo "<p class='text-danger'>idCategorie et critère de recherche manquant ou invalide dans l'URL.</p>";
                                            exit;
                                        }

                                        $req = "SELECT DESCCAT FROM CATEGORIE C WHERE C.IDCATEGORIE = :idCategorie";
                                        $result = $conn->prepare($req);
                                        $result->execute(['idCategorie' => $idC]);

                                        // Récupération de la ligne
                                        $row = $result->fetch(PDO::FETCH_ASSOC);

                                        $titre = htmlspecialchars($row['DESCCAT']);  // Sécuriser la valeur
                                    }
                                    elseif (isset($_GET['barreRecherche']) && !empty($_GET['barreRecherche'])) {
                                        // Si un terme de recherche est passé dans l'URL
                                        $searchValue = htmlspecialchars($_GET['barreRecherche']);  // Sécuriser la valeur
                                        $titre = 'Recherche pour "' . $searchValue . '"';
                                    }

                                    if ($titre) {
                                        echo '<h2>' . $titre . '</h2>';
                                    } else {
                                        echo '<h2>Aucune description trouvée </h2>';
                                    }
                                ?>

								</div>
						</div>
				</div>

                <?php
                    // Récupérer la valeur sélectionnée après soumission du formulaire
                    $selectedOption = isset($_POST['LD_TRI']) ? $_POST['LD_TRI'] : '';
                ?>

                <form method="POST" class="d-inline-block" id="triForm">
                    <fieldset class="d-flex align-items-center">
                        <select name="LD_TRI" class="form-control me-1" id="triSelect">
                            <option value="" <?php echo $selectedOption === '' ? 'selected' : ''; ?>>Tri par défaut</option>
                            <option value="croissant" <?php echo $selectedOption === 'croissant' ? 'selected' : ''; ?>>Trier par prix croissant</option>
                            <option value="decroissant" <?php echo $selectedOption === 'decroissant' ? 'selected' : ''; ?>>Trier par prix décroissant</option>
                        </select>
                        <!-- Le bouton est maintenant inutile, mais vous pouvez le garder pour des raisons d'accessibilité ou de style -->
                        <button type="submit" class="btn btn-secondary" style="display: none;">Appliquer</button>
                    </fieldset>
                </form>

                <!-- <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
                    <label class="form-check-label" for="flexCheckDefault">
                        Default checkbox
                    </label>
                    </div>
                    <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="flexCheckChecked" checked>
                    <label class="form-check-label" for="flexCheckChecked">
                        Checked checkbox
                    </label>
                </div> -->

                <script>
                    // Soumettre automatiquement le formulaire dès que l'option est changée
                    document.getElementById('triSelect').addEventListener('change', function() {
                        document.getElementById('triForm').submit();
                    });
                </script>

                <br> <br>

                
				<div class="row">

                <?php
                    try {
                        // Déterminer le critère de tri
                        $orderBy = "";
                        if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['LD_TRI'])) {
                            $tri = $_POST['LD_TRI'];
                            if ($tri === 'croissant') {
                                $orderBy = " ORDER BY PRIX ASC";
                            } elseif ($tri === 'decroissant') {
                                $orderBy = " ORDER BY PRIX DESC";
                            }
                            else {
                                $orderBy = "";
                            }
                        }

                        // Initialiser la requête
                        $req = "";

                        if (isset($idC)) {
                            if ($idC == 1 || $idC == 2 || $idC == 3) {
                                $req = "SELECT DISTINCT P.IDPRODUIT, P.NOMPRODUIT, P.PRIX, I.URL
                                        FROM PRODUIT P
                                        LEFT JOIN IMAGE I ON P.IDPRODUIT = I.IDPRODUIT
                                        WHERE P.IDCATEGORIE = :idCategorie 
                                        OR P.IDCATEGORIE IN (SELECT C.IDCATEGORIE FROM CATEGORIE C WHERE C.IDPARENT = :idCategorie)"
                                        . $orderBy . " LIMIT :start, :limit";  // Ajout du LIMIT
                            } else {
                                $req = "SELECT P.IDPRODUIT, P.NOMPRODUIT, P.PRIX, 
                                        (SELECT URL FROM IMAGE I WHERE I.IDPRODUIT = P.IDPRODUIT LIMIT 1) AS URL 
                                        FROM PRODUIT P
                                        WHERE P.IDCATEGORIE = :idCategorie 
                                        OR P.IDCATEGORIE IN (SELECT C.IDCATEGORIE FROM CATEGORIE C WHERE C.IDPARENT = :idCategorie)" 
                                        . $orderBy . " LIMIT :start, :limit";  // Ajout du LIMIT
                            }
                        } elseif (isset($searchValue)) {
                            $req = "SELECT P.IDPRODUIT, P.NOMPRODUIT, P.PRIX, I.URL 
                                    FROM PRODUIT P
                                    LEFT JOIN IMAGE I ON P.IDPRODUIT = I.IDPRODUIT
                                    WHERE P.NOMPRODUIT LIKE :searchValue"
                                    .  $orderBy . " LIMIT :start, :limit";  // Ajout du LIMIT
                        }

                        // Préparer et exécuter la requête
                        $result = $conn->prepare($req);

                        if (isset($searchValue)) {
                            // Lier le paramètre searchValue pour la recherche
                            $result->bindValue(':searchValue', '%' . $searchValue . '%', PDO::PARAM_STR);
                        } else {
                            // Lier le paramètre idCategorie pour les catégories
                            $result->bindValue(':idCategorie', $idC, PDO::PARAM_INT);
                        }

                        // Lier les paramètres de pagination
                        $result->bindValue(':start', $start, PDO::PARAM_INT);
                        $result->bindValue(':limit', $productsPerPage, PDO::PARAM_INT);

                        // Exécuter la requête
                        $result->execute();


                        // Récupérer les résultats
                        $tabProd = $result->fetchAll(PDO::FETCH_ASSOC);

                        // Calculer le nombre total de produits
                        $countReq = "SELECT COUNT(*) FROM PRODUIT P";
                        if (isset($idC)) {
                            $countReq .= " WHERE P.IDCATEGORIE = :idCategorie 
                                        OR P.IDCATEGORIE IN (SELECT C.IDCATEGORIE FROM CATEGORIE C WHERE C.IDPARENT = :idCategorie)";
                        } elseif (isset($searchValue)) {
                            $countReq .= " WHERE P.NOMPRODUIT LIKE :searchValue";
                        }

                        $countResult = $conn->prepare($countReq);
                        if (isset($searchValue)) {
                            $countResult->bindValue(':searchValue', '%' . $searchValue . '%', PDO::PARAM_STR);
                        } else {
                            $countResult->bindValue(':idCategorie', $idC, PDO::PARAM_INT);
                        }

                        $countResult->execute();

                        // Nombre total de produits
                        $totalProducts = $countResult->fetchColumn();

                        // Nombre total de pages
                        $totalPages = ceil($totalProducts / $productsPerPage);


                        // Vérifier si des produits existent
                        if (count($tabProd) > 0) {
                            foreach ($tabProd as $prod) {
                                echo '<div class="col-sm-6 col-md-4 col-lg-3 mb-4">
                                        <div class="card shadow-sm h-100 d-flex flex-column justify-content-between">';

                                // Vérification et affichage de l'image du produit
                                $imageUrl = !empty($prod['URL']) ? htmlspecialchars($prod['URL'], ENT_QUOTES) : 'https://i.ibb.co/L8Nrb7p/1.jpg'; // Image par défaut
                                echo '<a href="detailProduit.php?idProduit=' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                                        <div class="card-img-top" style="background: url(\'' . $imageUrl . '\') no-repeat center; background-size: cover; height: 200px; border: 2px solid #ddd; border-radius: 8px;">
                                        </div>
                                    </a>';

                                // Informations du produit
                                echo '<div class="card-body text-center d-flex flex-column justify-content-between">
                                <h5 class="card-title">' . htmlspecialchars($prod['NOMPRODUIT']) . '</h5>
                                <p class="card-text price text-success font-weight-bold mb-2">' . number_format($prod['PRIX'], 2, ',', ' ') . ' €</p> 
                                <button class="btn btn-primary btn-sm add-to-cart" data-product-id="' . htmlspecialchars($prod['IDPRODUIT'], ENT_QUOTES) . '">
                                    <i class="fas fa-shopping-cart"></i> Ajouter au panier
                                </button>
                                </div>
                                </div>
                                </div>';
                            }
                        } else {
                            echo "<p class='text-danger'>Aucun produit trouvé pour cette catégorie ou cette recherche.</p>";
                        }
                        
                        // Affichage de la pagination
                        echo '<nav aria-label="Page navigation">';
                        echo '<ul class="pagination justify-content-center">';

                        // Construire les paramètres communs pour les URLs
                        $queryParams = [];
                        if (isset($idC)) {
                            $queryParams['idCategorie'] = $idC;
                        }
                        if (isset($searchValue)) {
                            $queryParams['barreRecherche'] = $searchValue;
                        }

                        // Lien vers la page précédente
                        if ($page > 1) {
                            $queryParams['page'] = $page - 1;
                            echo '<li class="page-item"><a class="page-link" href="?' . http_build_query($queryParams) . '">Précédent</a></li>';
                        }

                        // Lien vers les pages
                        for ($i = 1; $i <= $totalPages; $i++) {
                            $queryParams['page'] = $i;
                            echo '<li class="page-item' . ($i == $page ? ' active' : '') . '"><a class="page-link" href="?' . http_build_query($queryParams) . '">' . $i . '</a></li>';
                        }

                        // Lien vers la page suivante
                        if ($page < $totalPages) {
                            $queryParams['page'] = $page + 1;
                            echo '<li class="page-item"><a class="page-link" href="?' . http_build_query($queryParams) . '">Suivant</a></li>';
                        }

                        echo '</ul>';
                        echo '</nav>';


                    } catch (PDOException $e) {
                        // Gestion des erreurs sans exposer de données sensibles
                        error_log("Erreur PDO : " . $e->getMessage());
                        echo "<p class='text-danger'>Une erreur est survenue. Veuillez réessayer plus tard.</p>";
                }
            ?>


						
						
				</div>
		</div>
</section>

<?php require_once 'includes/footer.php'; ?>