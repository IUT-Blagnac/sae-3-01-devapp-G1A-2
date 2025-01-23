<?php
require_once 'connect.inc.php';
require_once 'includes/header.php';
require_once 'includes/fonctionDetailCouleur.php';
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Produit</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/detProd.css" rel="stylesheet">
</head>

<body>
    <div class="container mt-5">
        <?php
        $idProduit = $_GET['idProduit'] ?? null;
        $idCouleur = $_POST['idCouleur'] ?? null;
        $idTaille = $_POST['idTaille'] ?? null;

        // Récupération des détails du produit
        $detailsProd = $conn->prepare("
            SELECT * 
            FROM PRODUIT P 
            LEFT JOIN IMAGE I ON P.IDPRODUIT = I.IDPRODUIT 
            WHERE P.IDPRODUIT = :idProduit
        ");
        $detailsProd->execute(['idProduit' => $idProduit]);
        $detProd = $detailsProd->fetch();
        $detailsProd->closeCursor();

        // Récupération des couleurs disponibles pour ce produit
        $couleur = $conn->prepare("CALL getCouleurs(:idProduit)");
        $couleur->execute(['idProduit' => $idProduit]);
        $couleurs = $couleur->fetchAll();
        $couleur->closeCursor();

        // Sélection de la première couleur par défaut si aucune couleur n'est sélectionnée
        if (!$idCouleur && !empty($couleurs)) {
            $idCouleur = $couleurs[0]['IDCOULEUR'];
        }

        // Récupération des tailles disponibles pour la couleur sélectionnée
        $tailles = [];
        if ($idCouleur) {
            $taillesQuery = $conn->prepare("CALL getTailles(:idProduit, :idCouleur)");
            $taillesQuery->execute([
                'idProduit' => $idProduit,
                'idCouleur' => $idCouleur
            ]);
            $tailles = $taillesQuery->fetchAll();
            $taillesQuery->closeCursor();
        }

        // Sélection de la première taille par défaut si aucune taille n'est sélectionnée
        if (!$idTaille && !empty($tailles)) {
            $idTaille = $tailles[0]['IDTAILLE'];
        }

        $marqueQuery = $conn->prepare("
            SELECT NOMMARQUE
            FROM MARQUE M 
            JOIN PRODUIT P ON M.IDMARQUE = P.IDMARQUE 
            WHERE P.IDPRODUIT = :idProduit
        ");
        $marqueQuery->execute(['idProduit' => $idProduit]);
        $marque = $marqueQuery->fetchColumn();
        $marqueQuery->closeCursor();

        // Récupération du stock pour la taille sélectionnée
        $stock = 'Non disponible';
        if ($idTaille) {
            foreach ($tailles as $taille) {
                if ($taille['IDTAILLE'] == $idTaille) {
                    $stock = $taille['QTESTOCK'];
                    break;
                }
            }
        }

        // Récupération de la quantité, si elle est plus grande que le stock, on la met à jour
        $qtt = $_POST['quantite'] ?? 1;
        if ($qtt > $stock) {
            $qtt = $stock;
        }
        if ($qtt < 1) {
            $qtt = 0;
        }

        // Récupérer les informations supplémentaires sur le produit
        $descriptionQuery = $conn->prepare("SELECT DESCPRODUIT, ASPECTTECHNIQUE, COMPOSITION, POIDS FROM PRODUIT WHERE IDPRODUIT = :idProduit");
        $descriptionQuery->execute(['idProduit' => $idProduit]);
        $productDetails = $descriptionQuery->fetch();
        $descriptionQuery->closeCursor();

        // Vérifier si l'utilisateur est connecté et s'il a déjà acheté le produit
        $aAchete = false;
        if (isset($_SESSION['user'])) {
            $idUtilisateur = $_SESSION['user']['IDUTILISATEUR'];
            try {
                $checkAchat = $conn->prepare("CALL CheckSiUserAchat(:idUtilisateur, :idProduit, @resultat)");
                $checkAchat->bindParam(':idUtilisateur', $idUtilisateur, PDO::PARAM_INT);
                $checkAchat->bindParam(':idProduit', $idProduit, PDO::PARAM_INT);
                $checkAchat->execute();
                $aAchete = (bool) $conn->query("SELECT @resultat AS resultat")->fetch()['resultat'];
            } catch (PDOException $e) {
                error_log("Erreur PDO : " . $e->getMessage());
            }
        }
        ?>

        <?php if ($detProd): ?>
            <div class="row">
                <div class="col-md-6 text-center">
                    <img src="<?php echo htmlspecialchars($detProd['URL']); ?>"
                        alt="<?php echo htmlspecialchars($detProd['NOMPRODUIT']); ?>" class="img-fluid">
                </div>
                <div class="col-md-6">
                    <h2><?php echo htmlspecialchars($detProd['NOMPRODUIT']); ?></h2>
                    <p>Marque: <?php echo htmlspecialchars($marque); ?></p>
                    <p>Prix: <?php echo number_format($detProd['PRIX'], 2, ',', ' '); ?> €</p>

                    <!-- Formulaire de sélection des options du produit (taille, couleur, quantité) -->
                    <form id="productForm" method="post"
                        action="detailProduit.php?idProduit=<?php echo htmlspecialchars($idProduit); ?>">
                        <div class="form-group">
                            <label for="couleur">Sélectionnez une couleur :</label>
                            <div id="couleur">
                                <?php foreach ($couleurs as $couleur): ?>
                                    <?php $selected = ($couleur['IDCOULEUR'] == $idCouleur) ? 'selected' : ''; ?>
                                    <div class="color-circle <?php echo $selected; ?>"
                                        style="background-color: <?php echo obtenirCouleurCSS($couleur['COULEUR']); ?>;"
                                        onclick='selectColor("<?php echo $couleur["IDCOULEUR"]; ?>")'>
                                    </div>
                                <?php endforeach; ?>
                            </div>
                        </div>

                        <input type="hidden" id="idCouleur" name="idCouleur"
                            value="<?php echo htmlspecialchars($idCouleur); ?>">
                        <input type="hidden" id="idTaille" name="idTaille"
                            value="<?php echo htmlspecialchars($idTaille); ?>">

                        <?php if ($idCouleur): ?>
                            <div class="form-group">
                                <label for="taille">Tailles disponibles :</label>
                                <div id="taille">
                                    <?php foreach ($tailles as $taille): ?>
                                        <?php $selectedSize = ($taille['IDTAILLE'] == $idTaille) ? 'selected' : ''; ?>
                                        <?php if ($taille['QTESTOCK'] > 0): ?>
                                            <button type="button"
                                                class="btn btn-outline-secondary size-button <?php echo $selectedSize; ?>"
                                                onclick="selectSize('<?php echo $taille['IDTAILLE']; ?>')">
                                                <?php echo htmlspecialchars($taille['TAILLE']); ?>
                                            </button>
                                        <?php else: ?>
                                            <button type="button" class="btn btn-outline-secondary size-button disabled" disabled>
                                                <?php echo htmlspecialchars($taille['TAILLE']); ?>
                                            </button>
                                        <?php endif; ?>
                                    <?php endforeach; ?>
                                </div>
                            </div>
                        <?php endif; ?>

                        <div class="form-group">
                            <label for="quantite">Quantité:</label>
                            <input type="number" id="quantite" name="quantite" class="form-control"
                                value="<?php echo htmlspecialchars($qtt); ?>" min="1"
                                max="<?php echo $stock != 'Non disponible' ? $stock : 1; ?>" required>
                        </div>

                        <input type="hidden" id="hiddenQuantity" name="quantiteHidden"
                            value="<?php echo htmlspecialchars($qtt); ?>">
                    </form>

                    <!-- Formulaire d'ajout au panier -->
                    <?php if ($idCouleur && $idTaille): ?>
                        <?php if ($stock > 0): ?>
                            <div class="form-group">
                                <form action="ajoutProduit.php" method="post">
                                    <input type="hidden" name="idProduit" value="<?php echo htmlspecialchars($idProduit); ?>">
                                    <input type="hidden" name="idCouleur" value="<?php echo htmlspecialchars($idCouleur); ?>">
                                    <input type="hidden" name="idTaille" value="<?php echo htmlspecialchars($idTaille); ?>">
                                    <input type="hidden" name="quantite" id="finalQuantity"
                                        value="<?php echo htmlspecialchars($qtt); ?>">
                                    <?php $message = "Ajouté au panier"; ?>
                                    <button type="submit" class="btn btn-primary" onclick="envoie_qtt()">
                                        <?php echo $message; ?>
                                    </button>
                                </form>
                            </div>
                        <?php else: ?>
                            <button type="button" class="btn btn-secondary" disabled>
                                Hors stock
                            </button>
                        <?php endif; ?>
                    <?php endif; ?>
                </div>
            </div>

            <!-- Informations supplémentaires sur le produit -->
            <div class="product-info">
                <h5>Description du produit:</h5>
                <p><?php echo nl2br(htmlspecialchars($productDetails['DESCPRODUIT'])); ?></p>

                <h5>Aspect technique:</h5>
                <p><?php echo nl2br(htmlspecialchars($productDetails['ASPECTTECHNIQUE'])); ?></p>

                <h5>Composition:</h5>
                <p><?php echo nl2br(htmlspecialchars($productDetails['COMPOSITION'])); ?></p>

                <h5>Poids:</h5>
                <p><?php echo htmlspecialchars($productDetails['POIDS']); ?> kg</p>
            </div>

            <!-- Avis Clients -->
            <div id="avis-clients">
                <h3>Avis des clients</h3>
                <?php if ($aAchete): ?>
                        <div class="form-group mt-3">
                            <button id="ajouterAvisBtn" class="btn btn-info">
                                Ajouter un avis
                            </button>
                        </div>

                        <div id="formAvis" class="mt-3" style="display: none;">
                            <form action="soumettreAvis.php" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="idProduit" value="<?php echo htmlspecialchars($idProduit); ?>">
                                <div class="form-group">
                                    <label for="note">Note :</label>
                                    <select id="note" name="note" class="form-control" required>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="commentaire">Commentaire :</label>
                                    <textarea id="commentaire" name="commentaire" class="form-control" rows="4" required></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="images">Images :</label>
                                    <input type="file" id="images" name="images[]" class="form-control" multiple>
                                </div>
                                <button type="submit" class="btn btn-primary">Soumettre</button>
                            </form>
                        </div>
                    <?php endif; ?>
                <?php
                $commentsQuery = $conn->prepare("
                    SELECT C.IDCOMMENTAIRE, C.COMMENTAIRE, C.NOTE, CONCAT(U.NOM, ' ', U.PRENOM) AS NOMUTILISATEUR
                    FROM COMMENTAIRE C
                    JOIN UTILISATEUR U ON C.IDUTILISATEUR = U.IDUTILISATEUR
                    WHERE C.IDPRODUIT = :idProduit
                    ORDER BY C.IDCOMMENTAIRE DESC
                ");
                $commentsQuery->execute(['idProduit' => $idProduit]);
                $comments = $commentsQuery->fetchAll();

                if ($comments) {
                    foreach ($comments as $comment) {
                        echo '<div class="avis">';
                        echo '<strong>' . htmlspecialchars($comment['NOMUTILISATEUR']) . '</strong><br>';
                        echo '<span>Note: ' . htmlspecialchars($comment['NOTE']) . '/5</span><br>';
                        echo '<p>' . nl2br(htmlspecialchars($comment['COMMENTAIRE'])) . '</p>';

                        // Vérifier si l'image "commentaire_{IDCOMMENTAIRE}.jpg" ou autre extension existe
                        $commentImage = null;
                        foreach (['jpg','jpeg','png'] as $ext) {
                            $possiblePath = 'uploads/commentaire_' . $comment['IDCOMMENTAIRE'] . '.' . $ext;
                            if (file_exists($possiblePath)) {
                                $commentImage = $possiblePath;
                                break;
                            }
                        }

                        // Afficher l'image si elle existe
                        if ($commentImage) {
                            echo '<img src="' . htmlspecialchars($commentImage) . '" alt="Image du commentaire" class="img-fluid mt-2" style="width:100px; height:auto;">';
                        }

                        echo '</div>';
                    }
                } else {
                    echo '<p>Aucun avis pour ce produit.</p>';
                }
                ?>
            </div>

        <?php endif; ?>
    </div>
</body>

<script>
    function selectColor(idCouleur) {
        document.getElementById('idCouleur').value = idCouleur;
        document.getElementById('hiddenQuantity').value = document.getElementById('quantite').value;
        document.getElementById('productForm').submit();
    }

    function selectSize(idTaille) {
        document.getElementById('idTaille').value = idTaille;
        document.getElementById('hiddenQuantity').value = document.getElementById('quantite').value;
        document.getElementById('productForm').submit();
    }

    document.getElementById('quantite').addEventListener('change', function() {
        // Met à jour la quantité dans le champ caché
        document.getElementById('hiddenQuantity').value = this.value;
        // Soumet le formulaire
        document.getElementById('productForm').submit();
    });

    document.getElementById('ajouterAvisBtn').addEventListener('click', function() {
        var formAvis = document.getElementById('formAvis');
        if (formAvis.style.display === 'none') {
            formAvis.style.display = 'block';
        } else {
            formAvis.style.display = 'none';
        }
    });
</script>

</html>

<footer>
    <?php require_once 'includes/footer.php'; ?>
</footer>