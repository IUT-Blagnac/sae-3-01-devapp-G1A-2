<?php
session_start();
require 'connect.inc.php'; // Assurez-vous que ce fichier contient la connexion à la base de données

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $idProduit = $_POST['idProduit'];
    $note = $_POST['note'];
    $commentaire = $_POST['commentaire'];
    $idUtilisateur = $_SESSION['user']['IDUTILISATEUR'];
    
    try {
        // Insérer le commentaire dans la base de données
        $stmt = $conn->prepare("INSERT INTO COMMENTAIRE (IDPRODUIT, IDUTILISATEUR, NOTE, COMMENTAIRE) VALUES (:idProduit, :idUtilisateur, :note, :commentaire)");
        $stmt->bindParam(':idProduit', $idProduit, PDO::PARAM_INT);
        $stmt->bindParam(':idUtilisateur', $idUtilisateur, PDO::PARAM_INT);
        $stmt->bindParam(':note', $note, PDO::PARAM_INT);
        $stmt->bindParam(':commentaire', $commentaire, PDO::PARAM_STR);
        $stmt->execute();

        $idCommentaire = $conn->lastInsertId();

        // Traiter l'image téléchargée (limité à une seule image)
        if (!empty($_FILES['images']['name'][0])) {
            $uploadDir = 'uploads/';
            $tmpName = $_FILES['images']['tmp_name'][0];
            $fileExtension = pathinfo($_FILES['images']['name'][0], PATHINFO_EXTENSION);
            $fileName = 'commentaire_' . $idCommentaire . '.' . $fileExtension;
            $targetFilePath = $uploadDir . $fileName;

            // Déplacer le fichier téléchargé vers le répertoire de destination
            if (move_uploaded_file($tmpName, $targetFilePath)) {
                // Insérer le chemin de l'image dans la base de données
                $stmt = $conn->prepare("INSERT INTO IMAGE (IDPRODUIT, URL) VALUES (:idProduit, :url)");
                $stmt->bindParam(':idProduit', $idProduit, PDO::PARAM_INT);
                $stmt->bindParam(':url', $targetFilePath, PDO::PARAM_STR);
                $stmt->execute();
            }
        }

        // Rediriger vers la page de détails du produit avec un message de succès
        $_SESSION['message'] = "Votre avis a été soumis avec succès.";
        header("Location: detailProduit.php?idProduit=" . $idProduit);
        exit();
    } catch (PDOException $e) {
        error_log("Erreur PDO : " . $e->getMessage());
        $_SESSION['error'] = "Une erreur est survenue lors de la soumission de votre avis.";
        header("Location: detailProduit.php?idProduit=" . $idProduit);
        exit();
    }
} else {
    // Rediriger vers la page de détails du produit si la méthode de requête n'est pas POST
    header("Location: detailProduit.php?idProduit=" . $idProduit);
    exit();
}
?>