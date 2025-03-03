<?php
require_once 'includes/header.php';
?>

<head>
    <title>Accueil</title>
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" href="css/button.css">
</head>

<body>
    <div class="main-content">
        <div class="container-fluid bandeau">
            <a href="detailProduit.php?idProduit=214">
                <img src="images/hero-bg1.jpg" alt="Bandeau" class="img-fluid">
            </a>
        </div>

        <div class="container featured-products">
            <br> <br>
            <h2 class="section-title">Meilleures ventes du mois</h2>

            <!-- Carousel Bootstrap -->
            <div id="productCarousel" class="carousel slide" data-bs-interval="false">
                <div class="carousel-inner">

                    <?php
                    // requête SQL pour les produits vedettes (ici un produit est considéré comme étant en vedette si celui-ci a été commandé plus de 100 fois)
                    try {
                        $pdostat = $conn->prepare("CALL getProduitsVedettes()");
                        $pdostat->execute();
                        $tabProdVedette = $pdostat->fetchAll(PDO::FETCH_ASSOC);
                    } catch (PDOException $e) {
                        echo "Erreur: " . $e->getMessage() . "<br>";
                        die();
                    }

                    $isMobile = preg_match('/(android|iphone|ipod|windows phone)/i', $_SERVER['HTTP_USER_AGENT']);
                    $groupSize = $isMobile ? 1 : 3;
                    $chunks = array_chunk($tabProdVedette, $groupSize);
                    $isActive = true;
                    foreach ($chunks as $productGroup):
                    ?>
                    <div class="carousel-item <?php echo $isActive ? 'active' : ''; ?>">
                        <div class="row">
                            <?php foreach ($productGroup as $product): 
                                
                                ?>
                            <div class="col-md-4">
                                <a
                                    href="detailProduit.php?idProduit=<?php echo htmlspecialchars($product['IDPRODUIT'], ENT_QUOTES); ?>">
                                    <div class="product-card text-center">

                                        <!-- Affichage de l'image, du nom et du prix du produit -->
                                        <?php
                                                if (isset($product['URL'])) {
                                                    echo '<img src="' . htmlspecialchars($product['URL']) . '"
                                                alt="' . htmlspecialchars($product['NOMPRODUIT']) . '" class="img-fluid">';
                                                } else {
                                                    echo '<img src="https://i.ibb.co/L8Nrb7p/1.jpg"
                                                alt="' . htmlspecialchars($product['NOMPRODUIT']) . '" class="img-fluid">';
                                                }
                                                ?>

                                        <div class="product-info">
                                            <div class="card-title">
                                                <h3><?php echo htmlspecialchars($product['NOMPRODUIT']); ?></h3>
                                            </div>
                                            <p class="price"><?php echo number_format($product['PRIX'], 2, ',', ' '); ?>
                                                €
                                            </p>
                                            <!-- Bouton Ajouter au panier -->
                                            <button class="btn btn-primary add-to-cart"
                                                data-product-id="<?php echo htmlspecialchars($product['IDPRODUIT']); ?>">
                                                <i class="fas fa-eye"></i>
                                                Voir le produit
                                            </button>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
                    <?php
                        // Désactivation de l'élément actif pour les itérations suivantes
                        $isActive = false;
                    endforeach;
                    ?>

                </div>

                <!-- Carousel controls -->
                <button class="carousel-control-prev" type="button" data-bs-target="#productCarousel"
                    data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#productCarousel"
                    data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>

            </div>
        </div>
    </div>
</body>
<footer>
    <?php require_once 'includes/footer.php'; ?>
</footer>