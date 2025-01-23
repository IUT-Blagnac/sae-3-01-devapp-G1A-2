<?php
require_once 'connect.inc.php';
require_once 'includes/headerVide.php';

// Fonction pour récupérer toutes les catégories
function getAllCategories($conn)
{
    $stmt = $conn->prepare("SELECT * FROM CATEGORIE");
    $stmt->execute();
    return $stmt->fetchAll();
}

// Fonction pour récupérer toutes les marques
function getAllMarques($conn)
{
    $stmt = $conn->prepare("SELECT * FROM MARQUE");
    $stmt->execute();
    return $stmt->fetchAll();
}

// Récupérer les données du formulaire
$idCategorie = $_POST['categorie'];
$idMarque = $_POST['idmarque'];
$nomProduit = $_POST['nomproduit'];
$descProduit = $_POST['descproduit'];
$prix = $_POST['prix'];
$aspectTechnique = $_POST['aspecttechnique'];
$composition = $_POST['composition'];
$poids = $_POST['poids'];

// Récupérer le genre en fonction de la catégorie sélectionnée
try {
    $stmt = $conn->prepare("SELECT IDPARENT FROM CATEGORIE WHERE IDCATEGORIE = :idCategorie");
    $stmt->bindParam(':idCategorie', $idCategorie, PDO::PARAM_INT);
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    $idParent = $result['IDPARENT'];

    if ($idParent === null) {
        $genre = $idCategorie;
    } else {
        $genre = $idParent;
    }
} catch (PDOException $e) {
    echo "Erreur lors de la récupération du genre : " . $e->getMessage();
    exit();
}

// Vérifier si un fichier a été uploadé
$imageUploaded = false;
if (isset($_FILES['monfichier']) && $_FILES['monfichier']['error'] == 0) {
    // Vérifier l'extension du fichier
    $infosfichier = pathinfo($_FILES['monfichier']['name']);
    $extension_upload = strtolower($infosfichier['extension']);
    $extensions_autorisees = ['jpg'];

    if (in_array($extension_upload, $extensions_autorisees)) {
        $imageUploaded = true;
        $url = '1'; // Indiquer qu'une image a été uploadée
    } else {
        echo "Le fichier n'est pas du bon type ! Seuls les fichiers .jpg sont autorisés.<br>";
        exit();
    }
} else {
    $url = null; // Pas d'image uploadée
}

try {
    // Préparer la requête pour appeler la procédure stockée
    $stmt = $conn->prepare("CALL ajouterProduit(:p_IDCATEGORIE, :p_IDMARQUE, :p_NOMPRODUIT, :p_DESCPRODUIT, :p_PRIX, :p_ASPECTTECHNIQUE, :p_COMPOSITION, :p_POIDS, :p_GENRE, :p_URL)");

    // Lier les paramètres
    $stmt->bindParam(':p_IDCATEGORIE', $idCategorie, PDO::PARAM_INT);
    $stmt->bindParam(':p_IDMARQUE', $idMarque, PDO::PARAM_INT);
    $stmt->bindParam(':p_NOMPRODUIT', $nomProduit, PDO::PARAM_STR);
    $stmt->bindParam(':p_DESCPRODUIT', $descProduit, PDO::PARAM_STR);
    $stmt->bindParam(':p_PRIX', $prix);
    $stmt->bindParam(':p_ASPECTTECHNIQUE', $aspectTechnique, PDO::PARAM_STR);
    $stmt->bindParam(':p_COMPOSITION', $composition, PDO::PARAM_STR);
    $stmt->bindParam(':p_POIDS', $poids);
    $stmt->bindParam(':p_GENRE', $genre, PDO::PARAM_INT);
    $stmt->bindParam(':p_URL', $url, PDO::PARAM_STR);

    // Exécuter la procédure stockée
    $stmt->execute();

    // Récupérer l'ID du produit inséré
    $stmt = $conn->query("SELECT MAX(IDPRODUIT) AS last_id FROM PRODUIT");
    $lastIDProduit = $stmt->fetch(PDO::FETCH_ASSOC)['last_id'];

    // Gérer le déplacement de l'image si elle a été uploadée
    if ($imageUploaded) {
        $nouveau_nom = "idProd" . $lastIDProduit . ".jpg";
        $path = "./images/" . $nouveau_nom;

        // Déplacer le fichier uploadé vers le répertoire cible
        move_uploaded_file($_FILES['monfichier']['tmp_name'], $path);
    }

    echo "<script>
            alert('Le produit a été ajouté avec succès.');
            window.location.href = 'zAjouterProduitAdmin.php';
          </script>";
} catch (PDOException $e) {
    echo "Erreur lors de l'ajout du produit : " . $e->getMessage();
}