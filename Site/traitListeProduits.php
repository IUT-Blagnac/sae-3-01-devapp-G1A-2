<?php
require_once 'connect.inc.php';
require_once 'includes/headerVide.php';

// Fonction pour récupérer tous les produits avec ou sans filtres
function listeProduitsCategorie($conn, $categorie, $choixTri, $minValue, $maxValue, $marque = null)
{
    $pdostat = $conn->prepare("CALL getProduitsParCategorie(:categorie, :choixTri, :minValue, :maxValue, :marque)");
    $pdostat->bindParam(':choixTri', $choixTri, PDO::PARAM_STR);
    $pdostat->bindParam(':minValue', $minValue, PDO::PARAM_INT);
    $pdostat->bindParam(':maxValue', $maxValue, PDO::PARAM_INT);
    $pdostat->bindParam(':categorie', $categorie, PDO::PARAM_INT);
    $pdostat->bindParam(':marque', $marque, PDO::PARAM_INT);
    $pdostat->execute();
    return $pdostat->fetchAll(PDO::FETCH_ASSOC);
}

function listeProduitsRecherches($conn, $motCleRecherche, $choixTri, $marque, $minValue, $maxValue)
{
    $pdostat = $conn->prepare("CALL getProduitParNom(:motCleRecherche, :choixTri, :marque, :minValue, :maxValue)");
    $pdostat->bindParam(':motCleRecherche', $motCleRecherche, PDO::PARAM_STR);
    $pdostat->bindParam(':choixTri', $choixTri, PDO::PARAM_STR);
    $pdostat->bindParam(':marque', $marque, PDO::PARAM_INT);
    $pdostat->bindParam(':minValue', $minValue, PDO::PARAM_INT);
    $pdostat->bindParam(':maxValue', $maxValue, PDO::PARAM_INT);
    $pdostat->execute();
    return $pdostat->fetchAll(PDO::FETCH_ASSOC);
}

// Fonction pour récupérer la description de la catégorie
function descriptionCategorie($conn, $categorie)
{
    $pdostat = $conn->prepare("CALL getDescCategorie(?)");
    $pdostat->execute([$categorie]);
    return $pdostat->fetchColumn();
}

// Fonction pour récupérer toutes les marques
function getMarques($conn)
{
    $pdostat = $conn->prepare("CALL getToutesMarques()");
    $pdostat->execute();
    return $pdostat->fetchAll(PDO::FETCH_ASSOC);
}