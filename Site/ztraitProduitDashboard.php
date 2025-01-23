<?php
require_once 'connect.inc.php';
require_once 'includes/headerVide.php';



function list_products($conn)
{
    $pdostat = $conn->prepare("CALL getAllProductsImages()");

    $pdostat->execute();

    // on retourne toutes les lignes du résultat de la requête
    return $pdostat->fetchAll(PDO::FETCH_ASSOC);
}

function list_products_deleted($conn)
{
    $pdostat = $conn->prepare("CALL getAllProductsDeleted()");

    $pdostat->execute();

    // on retourne toutes les lignes du résultat de la requête
    return $pdostat->fetchAll(PDO::FETCH_ASSOC);
}


function list_products_filtered($conn, $motCleRecherche)
{
    $pdostat = $conn->prepare("CALL getProductsByName(:motCle)");
    $pdostat->execute([':motCle' => $motCleRecherche]);
    return $pdostat->fetchAll(PDO::FETCH_ASSOC);
}


function list_products_deleted_filtered($conn, $motCleRecherche)
{
    $pdostat = $conn->prepare("CALL getDeletedProductByName(:motCle)");
    $pdostat->execute([':motCle' => $motCleRecherche]);
    return $pdostat->fetchAll(PDO::FETCH_ASSOC);
}

/**
 * Récupérer les marques pour le menu déroulant IDMARQUE
 */
function getAllMarques($conn)
{
    $stmt = $conn->prepare("CALL getAllMarques()");
    $stmt->execute();
    $marques = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $stmt->closeCursor();
    return $marques;
}

/**
 * Récupérer les catégories et sous-catégories
 */
function getAllCategories($conn)
{
    $reqCategories = "SELECT * FROM CATEGORIE";
    $result = $conn->prepare($reqCategories);
    $result->execute();
    $allCategories = $result->fetchAll(PDO::FETCH_ASSOC);
    $result->closeCursor();
    return $allCategories;
}


/**
 * Récupération des détails du produit
 */
function getProduitDetails($conn, $idProduit)
{
    // Récupérer les détails du produit
    $stmt = $conn->prepare("SELECT * 
            FROM PRODUIT P 
            LEFT JOIN IMAGE I ON P.IDPRODUIT = I.IDPRODUIT 
            WHERE P.IDPRODUIT = :idProduit");
    $stmt->execute(['idProduit' => $idProduit]);
    $product = $stmt->fetch();
    return $product;
}