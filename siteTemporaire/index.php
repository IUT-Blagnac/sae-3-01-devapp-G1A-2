<?php require_once 'includes/header.php'; ?>

<div class="container-fluid hero-section">
    <div class="row">
        <div class="col-md-12 text-center">
            <h1>Bienvenue chez Style et Semelle</h1>
            <p>Découvrez votre paire préférée.</p>
        </div>
    </div>
</div>

<div class="container featured-products">
    <h2 class="section-title">Meilleures ventes du mois</h2>

    <!-- Carousel Bootstrap -->
    <div id="productCarousel" class="carousel slide" data-bs-interval="false">
        <div class="carousel-inner">

            <?php
            // Sample featured products - will be replaced with database data
            $featured_products = [
                ['id' => 1, 'name' => 'Classic Runner', 'price' => 89.99, 'image' => 'images/shoe1.jpg'],
                ['id' => 2, 'name' => 'Urban Comfort', 'price' => 129.99, 'image' => 'images/shoe2.jpg'],
                ['id' => 3, 'name' => 'Sport Elite', 'price' => 159.99, 'image' => 'images/shoe3.jpg'],
                ['id' => 4, 'name' => 'Casual Flex', 'price' => 79.99, 'image' => 'images/shoe4.jpg'],
                ['id' => 5, 'name' => 'Elegant Step', 'price' => 99.99, 'image' => 'images/shoe5.jpg'],
                ['id' => 6, 'name' => 'Light Jogger', 'price' => 139.99, 'image' => 'images/shoe6.jpg']
            ];

            $chunks = array_chunk($featured_products, 3); // Group products by 3
            $isActive = true;

            foreach ($chunks as $index => $productGroup): ?>
                <div class="carousel-item <?php if ($isActive) {
                                                echo 'active';
                                                $isActive = false;
                                            } ?>">
                    <div class="row">
                        <?php foreach ($productGroup as $product): ?>
                            <div class="col-md-4">
                                <div class="product-card text-center">
                                    <img src="<?php echo $product['image']; ?>" alt="<?php echo $product['name']; ?>" class="img-fluid">
                                    <div class="product-info">
                                        <h3><?php echo $product['name']; ?></h3>
                                        <p class="price">$<?php echo number_format($product['price'], 2); ?></p>
                                        <button class="btn btn-primary add-to-cart" data-product-id="<?php echo $product['id']; ?>">
                                            Add to Cart
                                        </button>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            <?php endforeach; ?>

        </div>

        <!-- Carousel controls -->
        <button class="carousel-control-prev" type="button" data-bs-target="#productCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#productCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>

    </div>
</div>

<?php require_once 'includes/footer.php'; ?>