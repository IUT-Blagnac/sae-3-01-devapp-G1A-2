<?php
$securePage = true;

require_once 'connect.inc.php';
require_once 'includes/connexionSecuriseeAdmin.php';
require_once 'includes/headerDashboard.php';
require_once 'ztraitProduitDashboard.php';

// Récupérer les marques pour le menu déroulant IDMARQUE
$marques = getAllMarques($conn);

// Récupérer les catégories et sous-catégories
$allCategories = getAllCategories($conn);

$categories = [];
foreach ($allCategories as $categorie) {
    if (is_null($categorie['IDPARENT'])) {
        // Catégorie principale
        $categories[$categorie['IDCATEGORIE']] = [
            'name' => $categorie['NOMCATEGORIE'],
            'subcategories' => []
        ];
    } else {
        // Sous-catégorie
        $categories[$categorie['IDPARENT']]['subcategories'][] = [
            'id' => $categorie['IDCATEGORIE'],
            'name' => $categorie['NOMCATEGORIE']
        ];
    }
}
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un produit</title>
    <!-- Inclure les fichiers CSS de Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclure les fichiers CSS personnalisés -->
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/button.css">
    <link rel="stylesheet" href="css/dashboard.css">
</head>

<body>
    <div class="container">
        <h1 class="mb-4 text-center">Ajouter un produit en base de données</h1>
        <div class="form-wrapper">
            <form class="ajouterProdForm" action="zTraitAjouterProdAdmin.php" method="post"
                enctype="multipart/form-data">
                <div class="mb-3">
                    <label for="idmarque" class="form-label">Marque</label>
                    <select class="form-select" id="idmarque" name="idmarque" required>
                        <?php foreach ($marques as $marque): ?>
                        <option value="<?= htmlspecialchars($marque['IDMARQUE']) ?>">
                            <?= htmlspecialchars($marque['NOMMARQUE']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="nomproduit" class="form-label">Nom du produit</label>
                    <input type="text" class="form-control" id="nomproduit" name="nomproduit" required>
                </div>
                <div class="mb-3">
                    <label for="descproduit" class="form-label">Description du produit</label>
                    <textarea class="form-control" id="descproduit" name="descproduit" rows="3" required></textarea>
                </div>
                <div class="mb-3">
                    <label for="prix" class="form-label">Prix</label>
                    <input type="number" step="0.01" class="form-control" id="prix" name="prix" required>
                </div>
                <div class="mb-3">
                    <label for="aspecttechnique" class="form-label">Aspect technique</label>
                    <textarea class="form-control" id="aspecttechnique" name="aspecttechnique" rows="3"></textarea>
                </div>
                <div class="mb-3">
                    <label for="composition" class="form-label">Composition</label>
                    <textarea class="form-control" id="composition" name="composition" rows="3"></textarea>
                </div>
                <div class="mb-3">
                    <label for="poids" class="form-label">Poids</label>
                    <input type="number" step="0.01" class="form-control" id="poids" name="poids">
                </div>
                <div class="mb-3">
                    <label for="categorie" class="form-label">Catégorie</label>
                    <select class="form-select" id="categorie" name="categorie" required>
                        <option value="">Sélectionnez une catégorie</option>
                        <?php foreach ($categories as $catId => $cat): ?>
                        <?php if (!empty($cat['subcategories'])): ?>
                        <optgroup label="<?= htmlspecialchars($cat['name']) ?>">
                            <?php foreach ($cat['subcategories'] as $subcat): ?>
                            <option value="<?= htmlspecialchars($subcat['id']) ?>">
                                <?= htmlspecialchars($subcat['name']) ?></option>
                            <?php endforeach; ?>
                        </optgroup>
                        <?php else: ?>
                        <option value="<?= htmlspecialchars($catId) ?>"><?= htmlspecialchars($cat['name']) ?></option>
                        <?php endif; ?>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="monfichier" class="form-label">Image</label>
                    <input type="file" class="form-control" id="monfichier" name="monfichier" accept=".jpg">
                </div></br>
                <button type="submit" class="btn btn-primary">Ajouter le produit</button>
                </br></br>
            </form>
        </div>
    </div>
    <!-- Inclure les fichiers JavaScript de Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>