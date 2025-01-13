<?php
$securePage = true;

require_once 'connect.inc.php';
require_once 'includes/connexionSecuriseeAdmin.php';
require_once 'includes/headerDashboard.php';
require_once 'ztraitProduitDashboard.php';

// Récupérer l'ID du produit depuis le paramètre GET
$idProduit = $_GET['idProduit'] ?? null;

if (!$idProduit) {
    echo "Aucun produit sélectionné.";
    exit();
}

// Récupérer les détails du produit à l'aide de la fonctiob dans ztraitProduitDashboard.php
$product = getProduitDetails($conn, $idProduit);

// Récupérer les catégories et marques pour les listes déroulantes
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
$marques = getAllMarques($conn);

// Handle form submission to update product
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['updateProduct'])) {
    // Retrieve form data
    $idCategorie = $_POST['categorie'];
    $idMarque = $_POST['idmarque'];
    $nomProduit = $_POST['nomproduit'];
    $descProduit = $_POST['descproduit'];
    $prix = $_POST['prix'];
    $aspectTechnique = $_POST['aspecttechnique'];
    $composition = $_POST['composition'];
    $poids = $_POST['poids'];
    $genre = $_POST['genre'];
    // ...existing code to handle image upload if needed...

    // Call the stored procedure to update the product
    $stmt = $conn->prepare("CALL modifierProduit(:p_IDPRODUIT, :p_IDCATEGORIE, :p_IDMARQUE, :p_NOMPRODUIT, :p_DESCPRODUIT, :p_PRIX, :p_ASPECTTECHNIQUE, :p_COMPOSITION, :p_POIDS, :p_GENRE)");
    $stmt->execute([
        'p_IDPRODUIT' => $idProduit,
        'p_IDCATEGORIE' => $idCategorie,
        'p_IDMARQUE' => $idMarque,
        'p_NOMPRODUIT' => $nomProduit,
        'p_DESCPRODUIT' => $descProduit,
        'p_PRIX' => $prix,
        'p_ASPECTTECHNIQUE' => $aspectTechnique,
        'p_COMPOSITION' => $composition,
        'p_POIDS' => $poids,
        'p_GENRE' => $genre
    ]);

    echo "<script>
            alert('Produit mis à jour avec succès.');
            window.location.href = 'zmodifierProduit.php?idProduit=$idProduit';
          </script>";
}

// Fetch categories and marques for dropdowns
// ...existing code to fetch categories and marques...

// Fetch current product variants
$variantsStmt = $conn->prepare("
    SELECT PA.*, T.TAILLE, C.COULEUR
    FROM PRODUIT_ATTR PA
    JOIN TAILLE T ON PA.IDTAILLE = T.IDTAILLE
    JOIN COULEUR C ON PA.IDCOULEUR = C.IDCOULEUR
    WHERE PA.IDPRODUIT = :idProduit
");
$variantsStmt->execute(['idProduit' => $idProduit]);
$variants = $variantsStmt->fetchAll();

// Handle form submission to add a new variant
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['addVariant'])) {
    $idTaille = $_POST['idTaille'];
    $idCouleur = $_POST['idCouleur'];
    $qteStock = $_POST['qteStock'];

    // Call the stored procedure to add a new product variant
    $stmt = $conn->prepare("CALL ajouterProduitAttr(:p_IDPRODUIT, :p_IDTAILLE, :p_IDCOULEUR, :p_QTESTOCK)");
    $stmt->execute([
        'p_IDPRODUIT' => $idProduit,
        'p_IDTAILLE' => $idTaille,
        'p_IDCOULEUR' => $idCouleur,
        'p_QTESTOCK' => $qteStock
    ]);

    echo "<script>
            alert('Variante ajoutée avec succès.');
            window.location.href = 'zmodifierProduit.php?idProduit=$idProduit';
          </script>";
}
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier un produit</title>
    <!-- Inclure les fichiers CSS de Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclure les fichiers CSS personnalisés -->
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/button.css">
    <link rel="stylesheet" href="css/dashboard.css">
</head>

<body>
    <div class="container modifyProduct">
        <h1 class="mb-4 text-center">Modifier le Produit</h1>
        <div class="row product-content">
            <div class="col-md-6 text-center">
                <img src="<?php echo htmlspecialchars($product['URL']); ?>"
                    alt="<?php echo htmlspecialchars($product['NOMPRODUIT']); ?>" class="img-fluid">
            </div>
            <div class="col-md-4">
                <!-- Formulaire de modification du produit -->
                <form method="POST" action="zmodifierProduit.php?idProduit=<?php echo htmlspecialchars($idProduit); ?>"
                    enctype="multipart/form-data">
                    <input type="hidden" name="idProduit"
                        value="<?php echo htmlspecialchars($product['IDPRODUIT']); ?>">
                    <!-- Remove the col-md-4 class to allow full width -->
                    <div>
                        <!-- Champ pour le nom du produit -->
                        <div class="form-group">
                            <label for="nomproduit">Nom du produit:</label>
                            <input type="text" class="form-control" name="nomproduit"
                                value="<?php echo htmlspecialchars($product['NOMPRODUIT']); ?>" required>
                        </div>
                        <!-- Champ pour la description -->
                        <div class="form-group">
                            <label for="descproduit">Description:</label>
                            <textarea class="form-control" name="descproduit"
                                required><?php echo htmlspecialchars($product['DESCPRODUIT']); ?></textarea>
                        </div>
                        <!-- Champ pour le prix -->
                        <div class="form-group">
                            <label for="prix">Prix:</label>
                            <input type="number" step="0.01" class="form-control" name="prix"
                                value="<?php echo htmlspecialchars($product['PRIX']); ?>" required>
                        </div>
                        <!-- Champ pour l'aspect technique -->
                        <div class="form-group">
                            <label for="aspecttechnique">Aspect Technique:</label>
                            <textarea class="form-control"
                                name="aspecttechnique"><?php echo htmlspecialchars($product['ASPECTTECHNIQUE']); ?></textarea>
                        </div>
                        <!-- Champ pour la composition -->
                        <div class="form-group">
                            <label for="composition">Composition:</label>
                            <textarea class="form-control"
                                name="composition"><?php echo htmlspecialchars($product['COMPOSITION']); ?></textarea>
                        </div>
                        <!-- Champ pour le poids -->
                        <div class="form-group">
                            <label for="poids">Poids:</label>
                            <input type="number" step="0.01" class="form-control" name="poids"
                                value="<?php echo htmlspecialchars($product['POIDS']); ?>">
                        </div>
                        <!-- Liste déroulante pour la catégorie -->
                        <div class="form-group">
                            <label for="categorie">Catégorie:</label>
                            <select class="form-control" name="categorie" required>
                                <option value="">Sélectionnez une catégorie</option>
                                <?php foreach ($categories as $catId => $cat): ?>
                                <?php if (!empty($cat['subcategories'])): ?>
                                <optgroup label="<?= htmlspecialchars($cat['name']) ?>">
                                    <?php foreach ($cat['subcategories'] as $subcat): ?>
                                    <option value="<?= htmlspecialchars($subcat['id']) ?>"
                                        <?= ($subcat['id'] == $product['IDCATEGORIE']) ? 'selected' : '' ?>>
                                        <?= htmlspecialchars($subcat['name']) ?>
                                    </option>
                                    <?php endforeach; ?>
                                </optgroup>
                                <?php else: ?>
                                <option value="<?= htmlspecialchars($catId) ?>"
                                    <?= ($catId == $product['IDCATEGORIE']) ? 'selected' : '' ?>>
                                    <?= htmlspecialchars($cat['name']) ?>
                                </option>
                                <?php endif; ?>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <!-- Liste déroulante pour le genre du produit -->
                        <div class="form-group">
                            <label for="genre">Genre:</label>
                            <select class="form-control" name="genre" required>
                                <option value="M" <?= ($product['GENRE'] === 'M') ? 'selected' : ''; ?>>Homme
                                </option>
                                <option value="F" <?= ($product['GENRE'] === 'F') ? 'selected' : ''; ?>>Femme
                                </option>
                                <option value="E" <?= ($product['GENRE'] === 'E') ? 'selected' : ''; ?>>Enfant
                                </option>
                            </select>
                        </div>
                        <!-- Liste déroulante pour la marque -->
                        <div class="form-group">
                            <label for="idmarque">Marque:</label>
                            <select class="form-control" name="idmarque" required>
                                <!-- Remplir les options de marque -->
                                <?php foreach ($marques as $marque): ?>
                                <option value="<?php echo $marque['IDMARQUE']; ?>"
                                    <?php if ($product['IDMARQUE'] == $marque['IDMARQUE']) echo 'selected'; ?>>
                                    <?php echo htmlspecialchars($marque['NOMMARQUE']); ?>
                                </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <!-- Champ pour télécharger une nouvelle image -->
                        <div class="form-group">
                            <label for="monfichier">Image du produit (JPG uniquement):</label>
                            <input type="file" class="form-control-file" name="monfichier" accept=".jpg">
                        </div>
                        <!-- Bouton pour soumettre le formulaire -->
                        <button type="submit" name="updateProduct" class="btn btn-primary mt-3">Mettre à jour le
                            produit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

                                </br></br>
<!-- Affichage des variantes du produit -->
<div class="container py-5">
    <h2 class="mb-4 text-center">Variantes du Produit</h2>
    <div class="row">
        <!-- Colonne pour le tableau -->
        <div class="col-md-6  tab-variante">
            <div class="table-responsive">
                <table class="table table-bordered table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>Taille</th>
                            <th>Couleur</th>
                            <th>Quantité en stock</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($variants as $variant): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($variant['TAILLE']); ?></td>
                            <td><?php echo htmlspecialchars($variant['COULEUR']); ?></td>
                            <td><?php echo htmlspecialchars($variant['QTESTOCK']); ?></td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Colonne pour le formulaire -->
        <div class="col-md-6">
            <form method="POST" action="zmodifierProduit.php?idProduit=<?php echo htmlspecialchars($idProduit); ?>">
                <div class="mb-3">
                    <label for="idTaille" class="form-label">Taille:</label>
                    <select name="idTaille" class="form-select" required>
                        <?php
                        $taillesStmt = $conn->query("SELECT * FROM TAILLE");
                        $tailles = $taillesStmt->fetchAll();
                        foreach ($tailles as $taille):
                        ?>
                        <option value="<?php echo $taille['IDTAILLE']; ?>">
                            <?php echo htmlspecialchars($taille['TAILLE']); ?>
                        </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="idCouleur" class="form-label">Couleur:</label>
                    <select name="idCouleur" class="form-select" required>
                        <?php
                        $couleursStmt = $conn->query("SELECT * FROM COULEUR");
                        $couleurs = $couleursStmt->fetchAll();
                        foreach ($couleurs as $couleur):
                        ?>
                        <option value="<?php echo $couleur['IDCOULEUR']; ?>">
                            <?php echo htmlspecialchars($couleur['COULEUR']); ?>
                        </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="qteStock" class="form-label">Quantité en stock:</label>
                    <input type="number" class="form-control" name="qteStock" min="0" required>
                </div>
                <button type="submit" name="addVariant" class="btn btn-success w-100">Ajouter la variante</button>
            </form>
        </div>
    </div>
</div>
    <!-- Inclure les fichiers JavaScript de Bootstrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>