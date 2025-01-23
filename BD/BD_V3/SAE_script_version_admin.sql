-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : ven. 20 déc. 2024 à 14:41
-- Version du serveur : 8.0.40-0ubuntu0.22.04.1
-- Version de PHP : 8.1.2-1ubuntu2.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `R2024MYSAE3009`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `AjouterAdresse` (IN `p_nom` VARCHAR(255), IN `p_prenom` VARCHAR(255), IN `p_adresse` VARCHAR(255), IN `p_ville` VARCHAR(255), IN `p_codePostal` VARCHAR(20), IN `p_pays` VARCHAR(255), IN `p_idRegion` INT, IN `p_telephone` VARCHAR(20), IN `p_idUtilisateur` INT)  BEGIN
    INSERT INTO ADRESSE (NOM, PRENOM, ADRESSE, VILLE, CODEPOSTAL, PAYS, IDREGION, TELEPHONE, IDUTILISATEUR)
    VALUES (p_nom, p_prenom, p_adresse, p_ville, p_codePostal, p_pays, p_idRegion, p_telephone, p_idUtilisateur);
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `ajouterProduit` (IN `p_IDCATEGORIE` INT, IN `p_IDMARQUE` INT, IN `p_NOMPRODUIT` VARCHAR(128), IN `p_DESCPRODUIT` VARCHAR(200), IN `p_PRIX` DECIMAL(10,2), IN `p_ASPECTTECHNIQUE` VARCHAR(200), IN `p_COMPOSITION` VARCHAR(200), IN `p_POIDS` DECIMAL(10,2), IN `p_GENRE` CHAR(1), IN `p_URL` VARCHAR(200))  BEGIN
    -- Supprimer l'usage de DECLARE pour respecter les contraintes
    -- Insérer dans la table produit
    INSERT INTO PRODUIT (
        IDCATEGORIE, 
        IDMARQUE, 
        NOMPRODUIT, 
        DESCPRODUIT, 
        PRIX, 
        ASPECTTECHNIQUE, 
        COMPOSITION, 
        POIDS, 
        GENRE, 
        supprime
    )
    VALUES (
        p_IDCATEGORIE, 
        p_IDMARQUE, 
        p_NOMPRODUIT, 
        p_DESCPRODUIT, 
        p_PRIX, 
        p_ASPECTTECHNIQUE, 
        p_COMPOSITION, 
        p_POIDS, 
        p_GENRE, 
        0
    );

    -- Récupérer directement l'ID du dernier produit inséré
    SET @lastIDProduit = (SELECT MAX(IDPRODUIT) FROM PRODUIT);

    -- Déterminer l'URL de l'image
    IF p_URL IS NOT NULL THEN
        SET @finalURL = CONCAT('images/idProd', @lastIDProduit, '.jpg');
    ELSE
        SET @finalURL = 'images/no-image.jpg';
    END IF;

    -- Insérer dans la table image
    INSERT INTO IMAGE (
        IDPRODUIT, 
        URL
    )
    VALUES (
        @lastIDProduit, 
        @finalURL
    );
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `ajouterProduitAttr` (IN `p_IDPRODUIT` INT, IN `p_IDTAILLE` INT, IN `p_IDCOULEUR` INT, IN `p_QTESTOCK` INT)  BEGIN
    INSERT INTO PRODUIT_ATTR
        (IDPRODUIT, IDTAILLE, IDCOULEUR, QTESTOCK)
    VALUES
        (p_IDPRODUIT, p_IDTAILLE, p_IDCOULEUR, p_QTESTOCK);
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `CheckEmailExists` (IN `p_email` VARCHAR(255))  BEGIN
    SELECT COUNT(*) AS email_count FROM UTILISATEUR WHERE EMAIL = p_email;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `creeCompte` (IN `p_idRole` INT, IN `p_nom` VARCHAR(255), IN `p_prenom` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_telephone` VARCHAR(20), IN `p_dateNaissance` DATE)  BEGIN
    INSERT INTO UTILISATEUR (IDROLE, NOM, PRENOM, PASSWORD, EMAIL, TELEPHONE, DATENAISSANCE, DATEINSCRIPTION)
    VALUES (p_idRole, p_nom, p_prenom, p_password, p_email, p_telephone, p_dateNaissance, NOW());
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `CreePanier` (IN `p_IDUTILISATEUR` INT)  BEGIN
    INSERT INTO PANIER (IDPANIER, IDUTILISATEUR, DATECREA, IDCOMMANDE)
    VALUES (NULL, p_IDUTILISATEUR, NOW(), NULL);
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `DeleteCompte` (IN `p_userId` INT)  BEGIN
    DELETE FROM UTILISATEUR WHERE IDUTILISATEUR = p_userId;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetAdressesUtilisateur` (IN `p_idUtilisateur` INT)  BEGIN
    SELECT 
        IDADRESSE, 
        NOM, 
        PRENOM, 
        ADRESSE, 
        VILLE, 
        CODEPOSTAL, 
        PAYS, 
        IDREGION, 
        TELEPHONE
    FROM 
        ADRESSE
    WHERE 
        IDUTILISATEUR = p_idUtilisateur;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetAdressesUtilisateurInComptes` (IN `p_idUtilisateur` INT)  BEGIN
    SELECT 
        IDADRESSE, 
        NOM, 
        PRENOM, 
        ADRESSE, 
        VILLE, 
        CODEPOSTAL, 
        PAYS, 
        NOMREGION, 
        TELEPHONE
    FROM 
        ADRESSE a, REGION r
    WHERE 
    	a.IDREGION = r.IDREGION 
        AND
        IDUTILISATEUR = p_idUtilisateur;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getAllMarques` ()  BEGIN
    SELECT * FROM MARQUE;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getAllProductsDeleted` ()  BEGIN
    SELECT DISTINCT P.*, I.URL
    FROM PRODUIT P
    JOIN IMAGE I ON P.IDPRODUIT = I.IDPRODUIT
    WHERE P.supprime = 1;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getAllProductsImages` ()  BEGIN
    SELECT P.*, I.URL
    FROM PRODUIT P, IMAGE I 
    WHERE P.IDPRODUIT = I.IDPRODUIT AND P.supprime = 0;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetCommandesUtilisateurs` (IN `p_idUtilisateur` INT)  BEGIN
    SELECT 
        C.IDCOMMANDE,
        C.IDADRLIVRAISON,
        C.IDADRFACTURATION,
        C.IDSTATUT,
        C.IDMODEPAIEMENT,
        C.DATECOMMANDE,
        P.IDPANIER
    FROM 
        COMMANDE C
    JOIN 
        PANIER P ON C.IDCOMMANDE = P.IDCOMMANDE
    WHERE 
        P.IDUTILISATEUR = p_idUtilisateur
    ORDER BY C.DATECOMMANDE DESC;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetCouleurs` (IN `p_idProduit` INT)  BEGIN
    SELECT DISTINCT C.IDCOULEUR, C.COULEUR
    FROM PRODUIT_ATTR PA
    JOIN COULEUR C ON PA.IDCOULEUR = C.IDCOULEUR
    WHERE PA.IDPRODUIT = p_idProduit;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getDeletedProductByName` (IN `motCleRecherche` VARCHAR(255))  BEGIN
    SELECT DISTINCT P.*, I.URL
    FROM PRODUIT P
    JOIN IMAGE I ON P.IDPRODUIT = I.IDPRODUIT
    WHERE (P.NOMPRODUIT LIKE CONCAT('%', motCleRecherche, '%') 
           OR P.DESCPRODUIT LIKE CONCAT('%', motCleRecherche, '%'))
      AND P.supprime = 0;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getDescCategorie` (IN `categorie` INT)  BEGIN
    SELECT DESCCAT FROM CATEGORIE WHERE IDCATEGORIE = categorie;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetIdCouleur` (IN `p_couleur` VARCHAR(50), OUT `p_idCouleur` INT)  BEGIN
    SELECT IDCOULEUR INTO p_idCouleur
    FROM COULEUR
    WHERE COULEUR = p_couleur;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetIdProduitAttr` (IN `idProduit` INT, IN `idCouleur` INT, IN `idTaille` INT, OUT `idProduitAttr` INT)  BEGIN
    -- Récupération de l'IDPRODUIT_ATTR correspondant
    SELECT PA.IDPRODUIT_ATTR
    INTO idProduitAttr
    FROM PRODUIT_ATTR PA
    WHERE PA.IDPRODUIT = idProduit
      AND PA.IDCOULEUR = idCouleur
      AND PA.IDTAILLE = idTaille
    LIMIT 1; -- Limite à un résultat unique

    -- Si aucun résultat trouvé, retourne NULL
    IF idProduitAttr IS NULL THEN
        SET idProduitAttr = NULL;
    END IF;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetIdProduitAttrFromProduit` (IN `p_idProduit` INT, IN `p_couleur` VARCHAR(50), IN `p_taille` VARCHAR(50), OUT `p_idProduitAttr` INT)  BEGIN
    DECLARE v_idCouleur INT;
    DECLARE v_idTaille INT;

    -- Récupérer l'ID de la couleur
    SELECT IDCOULEUR INTO v_idCouleur
    FROM COULEUR
    WHERE COULEUR = p_couleur
    LIMIT 1;

    -- Récupérer l'ID de la taille
    SELECT IDTAILLE INTO v_idTaille
    FROM TAILLE
    WHERE TAILLE = p_taille
    LIMIT 1;

    -- Récupérer l'ID de l'attribut produit (ProduitAttr)
    SELECT IDPRODUIT_ATTR INTO p_idProduitAttr
    FROM PRODUIT_ATTR
    WHERE IDPRODUIT = p_idProduit
    AND IDCOULEUR = v_idCouleur
    AND IDTAILLE = v_idTaille
    LIMIT 1;

    -- Si aucun produit n'est trouvé, retourner NULL
    IF p_idProduitAttr IS NULL THEN
        SET p_idProduitAttr = NULL;
    END IF;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetIdTaille` (IN `p_taille` VARCHAR(50), OUT `p_idTaille` INT)  BEGIN
    SELECT IDTAILLE INTO p_idTaille
    FROM TAILLE
    WHERE TAILLE = p_taille;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetPanier` (IN `idUtilisateur` INT, OUT `idPanier` INT)  BEGIN
    DECLARE activeidPanier INT;

    -- Vérification de l'existence d'un PANIER actif avec le plus grand IDPANIER
    SELECT MAX(P.IDPANIER)
    INTO activeidPanier
    FROM PANIER P
    WHERE P.IDUTILISATEUR = idUtilisateur
      AND P.IDCOMMANDE IS NULL; -- Vérifie que le panier est actif (non validé)

    -- Si un PANIER actif existe, le retourner
    IF activeidPanier IS NOT NULL THEN
        SET idPanier = activeidPanier;
    ELSE
        -- Sinon, créer un nouveau PANIER
        INSERT INTO PANIER (IDUTILISATEUR, DATECREA, IDCOMMANDE)
        VALUES (idUtilisateur, NOW(), NULL); -- IDCOMMANDE est NULL pour indiquer que le panier est actif

        -- Récupérer l'ID du PANIER nouvellement créé
        SET idPanier = LAST_INSERT_ID();
    END IF;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getProductsByName` (IN `motCleRecherche` VARCHAR(128))  BEGIN
    SELECT DISTINCT P.*, I.URL
    FROM PRODUIT P, IMAGE I
    WHERE P.IDPRODUIT = I.IDPRODUIT 
        AND (P.NOMPRODUIT LIKE CONCAT('%', motCleRecherche, '%') OR P.DESCPRODUIT LIKE CONCAT('%', motCleRecherche, '%'))
        AND P.supprime = 0;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetProduitDetailsByPanier` (IN `idPanier` INT)  BEGIN
    SELECT 
        pp.IDPRODUITPANIER, 
        pp.IDPANIER, 
        pp.QTEPP, 
        pp.PRIXACHAT, 
        pa.IDPRODUIT_ATTR, 
        p.IDPRODUIT, 
        p.NOMPRODUIT, 
        p.DESCPRODUIT, 
        p.PRIX, 
        t.TAILLE, 
        c.COULEUR 
    FROM 
        PRODUITPANIER pp 
    JOIN 
        PRODUIT_ATTR pa ON pp.IDPRODUIT_ATTR = pa.IDPRODUIT_ATTR 
    JOIN 
        PRODUIT p ON p.IDPRODUIT = pa.IDPRODUIT 
    JOIN 
        TAILLE t ON pa.IDTAILLE = t.IDTAILLE 
    JOIN 
        COULEUR c ON pa.IDCOULEUR = c.IDCOULEUR 
    WHERE 
        pp.IDPANIER = idPanier 
    ORDER BY 
        pp.IDPANIER DESC;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getProduitParNom` (IN `motCleRecherche` VARCHAR(255), IN `choixTri` VARCHAR(50), IN `marque` INT, IN `valeurMin` INT, IN `valeurMax` INT)  BEGIN
    SELECT DISTINCT
        P.IDPRODUIT, 
        P.NOMPRODUIT, 
        P.PRIX, 
        I.URL, 
        P.IDMARQUE
    FROM 
        PRODUIT P
    LEFT JOIN 
        IMAGE I ON P.IDPRODUIT = I.IDPRODUIT
    WHERE 
        (P.NOMPRODUIT LIKE CONCAT('%', motCleRecherche, '%') OR P.DESCPRODUIT LIKE CONCAT('%', motCleRecherche, '%'))
        AND P.PRIX BETWEEN valeurMin AND valeurMax
        AND (P.IDMARQUE = marque OR marque IS NULL)
        AND P.supprime = 0;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetProduitsPanier` (IN `panierId` INT)  BEGIN
    SELECT 
        p.IDPRODUIT, 
        p.NOMPRODUIT, 
        p.PRIX, 
        t.TAILLE, 
        c.COULEUR, 
        i.URL, 
        m.NOMMARQUE, 
        cat.NOMCATEGORIE, 
        pp.QTEPP, 
        pp.PRIXACHAT, 
        pan.IDPANIER
    FROM PRODUIT p
    JOIN PRODUIT_ATTR pa ON p.IDPRODUIT = pa.IDPRODUIT
    LEFT JOIN TAILLE t ON pa.IDTAILLE = t.IDTAILLE
    LEFT JOIN COULEUR c ON pa.IDCOULEUR = c.IDCOULEUR
    LEFT JOIN IMAGE i ON p.IDPRODUIT = i.IDPRODUIT
    JOIN MARQUE m ON p.IDMARQUE = m.IDMARQUE
    JOIN CATEGORIE cat ON p.IDCATEGORIE = cat.IDCATEGORIE
    JOIN PRODUITPANIER pp ON pa.IDPRODUIT_ATTR = pp.IDPRODUIT_ATTR
    JOIN PANIER pan ON pp.IDPANIER = pan.IDPANIER
    WHERE pan.IDPANIER = panierId;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getProduitsParCategorie` (IN `categorie` INT, IN `choixTri` VARCHAR(50), IN `valeurMin` INT, IN `valeurMax` INT, IN `marque` INT)  BEGIN
    -- Produits de la catégorie et des sous-catégories
    IF categorie IN (1, 2, 3) THEN
        SELECT DISTINCT
            P.IDPRODUIT, 
            P.NOMPRODUIT, 
            P.PRIX, 
            I.URL, 
            P.IDMARQUE
        FROM 
            PRODUIT P
        LEFT JOIN 
            IMAGE I ON P.IDPRODUIT = I.IDPRODUIT
        WHERE 
            (P.IDCATEGORIE = categorie OR P.IDCATEGORIE IN (SELECT IDCATEGORIE FROM CATEGORIE WHERE IDPARENT = categorie))
            AND P.PRIX BETWEEN valeurMin AND valeurMax
            AND (P.IDMARQUE = marque OR marque IS NULL)
            AND P.supprime = 0;
    ELSE
        -- Produits uniquement de la sous-catégorie
        SELECT 
            P.IDPRODUIT, 
            P.NOMPRODUIT, 
            P.PRIX, 
            I.URL, 
            P.IDMARQUE
        FROM 
            PRODUIT P
        LEFT JOIN 
            IMAGE I ON P.IDPRODUIT = I.IDPRODUIT
        WHERE 
            P.IDCATEGORIE = categorie
            AND P.PRIX BETWEEN valeurMin AND valeurMax
            AND (P.IDMARQUE = marque OR marque IS NULL)
            AND P.supprime = 0;
    END IF;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getProduitsVedettes` ()  BEGIN
    SELECT P.IDPRODUIT, PA.IDPRODUIT_ATTR, P.NOMPRODUIT, P.PRIX, I.URL
    FROM PRODUIT P
    LEFT JOIN IMAGE I ON P.IDPRODUIT = I.IDPRODUIT
    INNER JOIN PRODUIT_ATTR PA ON P.IDPRODUIT = PA.IDPRODUIT
    INNER JOIN PRODUITPANIER PP ON PA.IDPRODUIT_ATTR = PP.IDPRODUIT_ATTR
    WHERE PP.QTEPP > 100 AND P.supprime = 0;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetStock` (IN `p_idProduitAttr` INT, OUT `p_stock` INT)  BEGIN
    SELECT QTESTOCK INTO p_stock
    FROM PRODUIT_ATTR
    WHERE IDPRODUIT_ATTR = p_idProduitAttr;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetTailles` (IN `idProduit` INT, IN `idCouleur` INT)  BEGIN
    SELECT T.IDTAILLE, T.TAILLE, PA.QTESTOCK
    FROM PRODUIT_ATTR PA
    JOIN TAILLE T ON PA.IDTAILLE = T.IDTAILLE
    WHERE PA.IDPRODUIT = idProduit AND PA.IDCOULEUR = idCouleur;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `getToutesMarques` ()  BEGIN
    SELECT IDMARQUE, NOMMARQUE FROM MARQUE;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetUtilisateurByEmail` (IN `p_email` VARCHAR(255))  BEGIN
    SELECT * FROM UTILISATEUR WHERE email = p_email;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `GetUtilisateurById` (IN `p_IDUTILISATEUR` INT)  BEGIN
    SELECT * FROM UTILISATEUR WHERE IDUTILISATEUR = p_IDUTILISATEUR;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `InsertProduitDansPanier` (IN `p_idProduitAttr` INT, IN `p_QTEPP` INT, IN `p_idPanier` INT)  BEGIN
    DECLARE v_prix DECIMAL(10,2);
    DECLARE v_existingQty INT;

    -- Récupération du prix d'achat du produit depuis la table PRODUIT
    SELECT PRIX INTO v_prix
    FROM PRODUIT
    WHERE IDPRODUIT = (SELECT IDPRODUIT FROM PRODUIT_ATTR WHERE IDPRODUIT_ATTR = p_idProduitAttr LIMIT 1);

    -- Vérifier si le produit est déjà dans le panier
    SELECT QTEPP INTO v_existingQty
    FROM PRODUITPANIER
    WHERE IDPANIER = p_idPanier
    AND IDPRODUIT_ATTR = p_idProduitAttr;

    -- Si le produit existe déjà, on met à jour la quantité
    IF v_existingQty IS NOT NULL THEN
        UPDATE PRODUITPANIER
        SET QTEPP = QTEPP + p_QTEPP
        WHERE IDPANIER = p_idPanier
        AND IDPRODUIT_ATTR = p_idProduitAttr;
    ELSE
        -- Sinon, on insère un nouveau produit dans le panier
        INSERT INTO PRODUITPANIER (IDPANIER, QTEPP, PRIXACHAT, IDPRODUIT_ATTR)
        VALUES (p_idPanier, p_QTEPP, v_prix, p_idProduitAttr);
    END IF;

END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `modifierProduit` (IN `p_IDPRODUIT` INT, IN `p_IDCATEGORIE` INT, IN `p_IDMARQUE` INT, IN `p_NOMPRODUIT` VARCHAR(128), IN `p_DESCPRODUIT` VARCHAR(200), IN `p_PRIX` DECIMAL(10,2), IN `p_ASPECTTECHNIQUE` VARCHAR(200), IN `p_COMPOSITION` VARCHAR(200), IN `p_POIDS` DECIMAL(10,2), IN `p_GENRE` CHAR(1))  BEGIN
    UPDATE PRODUIT
    SET
        IDCATEGORIE = p_IDCATEGORIE,
        IDMARQUE = p_IDMARQUE,
        NOMPRODUIT = p_NOMPRODUIT,
        DESCPRODUIT = p_DESCPRODUIT,
        PRIX = p_PRIX,
        ASPECTTECHNIQUE = p_ASPECTTECHNIQUE,
        COMPOSITION = p_COMPOSITION,
        POIDS = p_POIDS,
        GENRE = p_GENRE
    WHERE IDPRODUIT = p_IDPRODUIT;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `RestaurerProduitAdmin` (IN `idProduit` INT)  BEGIN
    -- Restaurer le produit (marquer comme non supprimé)
    UPDATE PRODUIT P
    SET P.supprime = 0
    WHERE P.IDPRODUIT = idProduit;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `SupprimerProduitEtPanierAdmin` (IN `idProduit` INT)  BEGIN
    -- Marquer le produit comme supprimé
    UPDATE PRODUIT P
    SET P.supprime = 1 
    WHERE P.IDPRODUIT = idProduit;

    -- Supprimer les entrées associées dans PRODUITPANIER
    DELETE PRODUITPANIER
    FROM PRODUITPANIER
    JOIN PRODUIT_ATTR ON PRODUITPANIER.IDPRODUIT_ATTR = PRODUIT_ATTR.IDPRODUIT_ATTR
    JOIN PANIER ON PANIER.IDPANIER = PRODUITPANIER.IDPANIER
    WHERE PRODUIT_ATTR.IDPRODUIT = idProduit
      AND PANIER.IDCOMMANDE IS NULL;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `SupprimerProduitPanier` (IN `p_idPanier` INT, IN `p_idProduitAttr` INT)  BEGIN
    DELETE FROM PRODUITPANIER
    WHERE IDPANIER = p_idPanier AND IDPRODUIT_ATTR = p_idProduitAttr;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `UpdatePassword` (IN `p_IDUTILISATEUR` INT, IN `p_newPassword` VARCHAR(255))  BEGIN
    UPDATE UTILISATEUR SET PASSWORD = p_newPassword WHERE IDUTILISATEUR = p_IDUTILISATEUR;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `UpdateQuantiteProduitPanier` (IN `p_idPanier` INT, IN `p_idProduit_ATTR` INT, IN `p_QTEPP` INT)  BEGIN
    UPDATE PRODUITPANIER
    SET QTEPP = p_QTEPP
    WHERE IDPanier = p_idPanier
      AND IDProduit_ATTR = p_idProduit_ATTR;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `UpdateUtilisateurInfo` (IN `p_IDUTILISATEUR` INT, IN `p_NOM` VARCHAR(255), IN `p_PRENOM` VARCHAR(255), IN `p_TELEPHONE` VARCHAR(20), IN `p_DATENAISSANCE` DATE)  BEGIN
    UPDATE UTILISATEUR
    SET
        NOM = p_NOM,
        PRENOM = p_PRENOM,
        TELEPHONE = p_TELEPHONE,
        DATENAISSANCE = p_DATENAISSANCE
    WHERE IDUTILISATEUR = p_IDUTILISATEUR;
END$$

CREATE DEFINER=`R2024MYSAE3009`@`%` PROCEDURE `ValiderCommande` (IN `p_idPanier` INT, IN `p_idAdrLivraison` INT, IN `p_idAdrFacturation` INT, IN `p_idUtilisateur` INT, IN `p_modePaiement` INT)  BEGIN
    -- Déclarer les variables nécessaires
    DECLARE v_idCommande INT;
    DECLARE v_qteCommande INT;
    DECLARE v_idProduitAttr INT;
    DECLARE done INT DEFAULT FALSE;

    -- Déclarer le curseur avant les gestionnaires
    DECLARE cursor_produits CURSOR FOR
        SELECT IDPRODUIT_ATTR, QTEPP
        FROM PRODUITS_PANIER
        WHERE IDPANIER = p_idPanier;

    -- Déclarer les gestionnaires d'exceptions
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Insérer la commande dans la table COMMANDE
    INSERT INTO COMMANDE (IDADRLIVRAISON, IDADRFACTURATION, IDUTILISATEUR, IDSTATUT, IDMODEPAIEMENT, DATECOMMANDE)
    VALUES (p_idAdrLivraison, p_idAdrFacturation, p_idUtilisateur, 1, p_modePaiement, NOW());

    -- Récupérer l'ID de la commande insérée
    SET v_idCommande = LAST_INSERT_ID();

    -- Associer le panier à la commande
    UPDATE PANIER
    SET IDCOMMANDE = v_idCommande
    WHERE IDPANIER = p_idPanier;

    -- Ouvrir le curseur
    OPEN cursor_produits;

    -- Parcourir les produits et mettre à jour le stock
    read_loop: LOOP
        FETCH cursor_produits INTO v_idProduitAttr, v_qteCommande;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Réduire le stock
        UPDATE PRODUIT_ATTR
        SET QTE_STOCK = QTE_STOCK - v_qteCommande
        WHERE IDPRODUIT_ATTR = v_idProduitAttr;

        -- Vérifier le stock
        IF (SELECT QTE_STOCK FROM PRODUIT_ATTR WHERE IDPRODUIT_ATTR = v_idProduitAttr) < 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insuffisant pour un ou plusieurs produits';
        END IF;
    END LOOP;

    -- Fermer le curseur
    CLOSE cursor_produits;

    -- Mettre à jour le statut de la commande
    UPDATE COMMANDE
    SET IDSTATUT = 1
    WHERE IDCOMMANDE = v_idCommande;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `ADRESSE`
--

CREATE TABLE `ADRESSE` (
  `IDADRESSE` int NOT NULL,
  `NOM` varchar(255) NOT NULL,
  `PRENOM` varchar(255) NOT NULL,
  `ADRESSE` varchar(255) NOT NULL,
  `VILLE` varchar(255) NOT NULL,
  `CODEPOSTAL` varchar(20) NOT NULL,
  `PAYS` varchar(255) NOT NULL,
  `IDREGION` int NOT NULL,
  `TELEPHONE` varchar(20) NOT NULL,
  `IDUTILISATEUR` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `ADRESSE`
--

INSERT INTO `ADRESSE` (`IDADRESSE`, `NOM`, `PRENOM`, `ADRESSE`, `VILLE`, `CODEPOSTAL`, `PAYS`, `IDREGION`, `TELEPHONE`, `IDUTILISATEUR`) VALUES
(1, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(2, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(3, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(4, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(5, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(6, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(7, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(8, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(9, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(10, 'Bouyssou', 'Melvin', '1 BLABLAZ', 'Blagnac', '31111', 'France', 1, '065665653', 67),
(11, 'DeLaCroix', 'Templier', '123 rue des arbresFleuri', 'Toulouse', '31140', 'France', 15, '0609596306', 73),
(15, 'Bou', 'ze', 'azeaze', 'poazn', '31O459', 'France', 1, '1212121212', 67),
(17, 'Lefevre', 'louna', '123 rue Victor Hugo', 'Toulouse', '31000', 'France', 15, '0609258299', 88);

-- --------------------------------------------------------

--
-- Structure de la table `CATEGORIE`
--

CREATE TABLE `CATEGORIE` (
  `IDCATEGORIE` int NOT NULL,
  `IDPARENT` int DEFAULT NULL,
  `NOMCATEGORIE` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `DESCCAT` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `CATEGORIE`
--

INSERT INTO `CATEGORIE` (`IDCATEGORIE`, `IDPARENT`, `NOMCATEGORIE`, `DESCCAT`) VALUES
(1, NULL, 'Homme', 'Catégorie principale pour les produits pour hommes'),
(2, NULL, 'Femme', 'Catégorie principale pour les produits pour femmes'),
(3, NULL, 'Enfant', 'Catégorie principale pour les produits pour enfants'),
(4, 1, 'Chaussures de sport', 'Chaussures pour activités sportives pour hommes'),
(5, 1, 'Chaussures de ville', 'Chaussures formelles et élégantes pour hommes'),
(6, 1, 'Chaussures décontractées', 'Chaussures quotidiennes et relax pour hommes'),
(7, 2, 'Chaussures de sport', 'Chaussures pour activités sportives pour femmes'),
(8, 2, 'Chaussures de ville', 'Chaussures formelles et élégantes pour femmes'),
(9, 2, 'Sandales et tongs', 'Chaussures ouvertes pour femmes'),
(10, 3, 'Chaussures de sport', 'Chaussures pour activités sportives pour enfants'),
(11, 3, 'Chaussures scolaires', 'Chaussures adaptées à un usage scolaire pour enfants'),
(12, 3, 'Sandales et chaussures d’été', 'Chaussures légères pour la saison estivale pour enfants');

-- --------------------------------------------------------

--
-- Structure de la table `COMMANDE`
--

CREATE TABLE `COMMANDE` (
  `IDCOMMANDE` int NOT NULL,
  `IDADRLIVRAISON` int NOT NULL,
  `IDADRFACTURATION` int NOT NULL,
  `IDUTILISATEUR` int NOT NULL,
  `IDSTATUT` int NOT NULL,
  `IDMODEPAIEMENT` int NOT NULL,
  `DATECOMMANDE` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `COMMANDE`
--

INSERT INTO `COMMANDE` (`IDCOMMANDE`, `IDADRLIVRAISON`, `IDADRFACTURATION`, `IDUTILISATEUR`, `IDSTATUT`, `IDMODEPAIEMENT`, `DATECOMMANDE`) VALUES
(1, 1, 1, 1, 4, 2, '2024-11-01 00:00:00'),
(2, 2, 2, 2, 4, 1, '2024-11-03 00:00:00'),
(3, 3, 3, 1, 4, 2, '2024-11-05 00:00:00'),
(4, 4, 4, 3, 4, 2, '2024-11-10 00:00:00'),
(5, 5, 5, 2, 4, 1, '2024-11-12 00:00:00'),
(6, 6, 6, 4, 4, 2, '2024-11-15 00:00:00'),
(7, 7, 7, 5, 4, 1, '2024-11-20 00:00:00'),
(8, 8, 8, 6, 4, 2, '2024-11-21 00:00:00'),
(9, 9, 9, 7, 4, 2, '2024-11-23 00:00:00'),
(10, 10, 10, 8, 4, 1, '2024-11-25 00:00:00'),
(11, 2, 2, 67, 4, 1, '2024-12-11 00:00:00'),
(12, 1, 1, 67, 1, 1, '2024-12-18 21:18:58'),
(13, 2, 2, 67, 1, 1, '2024-12-18 23:00:23'),
(14, 1, 1, 66, 1, 1, '2024-12-18 23:02:11'),
(15, 3, 3, 67, 1, 1, '2024-12-18 23:09:48'),
(16, 3, 3, 67, 1, 1, '2024-12-18 23:11:48'),
(17, 3, 3, 67, 1, 1, '2024-12-18 23:11:53'),
(18, 3, 3, 67, 1, 1, '2024-12-18 23:11:58'),
(19, 3, 3, 67, 1, 1, '2024-12-18 23:14:11'),
(20, 3, 3, 67, 1, 1, '2024-12-18 23:14:15'),
(21, 9, 1, 67, 1, 1, '2024-12-19 16:42:03'),
(22, 2, 7, 67, 1, 2, '2024-12-19 17:24:48'),
(23, 15, 15, 67, 1, 1, '2024-12-19 17:55:09');

-- --------------------------------------------------------

--
-- Structure de la table `COMMENTAIRE`
--

CREATE TABLE `COMMENTAIRE` (
  `IDCOMMENTAIRE` int NOT NULL,
  `IDPRODUIT` int NOT NULL,
  `IDUTILISATEUR` int NOT NULL,
  `NOTE` int DEFAULT NULL,
  `COMMENTAIRE` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `COMMENTAIRE`
--

INSERT INTO `COMMENTAIRE` (`IDCOMMENTAIRE`, `IDPRODUIT`, `IDUTILISATEUR`, `NOTE`, `COMMENTAIRE`) VALUES
(1, 214, 1, 5, 'Produit parfait, exactement ce que je cherchais. Très satisfait !'),
(2, 214, 2, 4, 'Bon produit, la qualité est au rendez-vous. Juste un petit bémol sur la livraison.'),
(3, 214, 3, 3, 'Le produit est correct, mais la taille ne correspond pas tout à fait à ce que j’attendais.'),
(4, 214, 4, 5, 'Super qualité, je recommande sans hésiter. Livraison rapide en plus !'),
(5, 5, 5, 2, 'Le produit ne correspond pas à la description, je suis déçu.'),
(6, 6, 6, 4, 'Très bien, mais j’aurais aimé plus de choix de couleurs.'),
(7, 7, 7, 5, 'Très bon rapport qualité/prix, je l’utilise tous les jours. Très content !'),
(8, 8, 8, 3, 'Produit acceptable, mais quelques défauts visibles sur le matériau.'),
(9, 9, 9, 4, 'Très satisfait, mais le produit pourrait être un peu plus durable.'),
(10, 10, 10, 1, 'Très décevant. Produit défectueux dès la première utilisation.'),
(11, 11, 11, 4, 'Très bon produit, bonne qualité mais un peu cher à mon goût.'),
(12, 12, 12, 5, 'Produit excellent, je suis très satisfait ! Aucune mauvaise surprise.'),
(13, 13, 13, 2, 'Produit abîmé à la réception, je n’ai pas pu l’utiliser.'),
(14, 14, 14, 4, 'Belle finition, confortable, mais la taille n’est pas vraiment adaptée.'),
(15, 15, 15, 3, 'Moyenne qualité, mais le prix est abordable. Peut mieux faire.'),
(16, 16, 16, 5, 'Je recommande vivement ce produit, il a surpassé mes attentes.'),
(17, 17, 17, 4, 'Bon produit, mais il aurait été mieux avec des instructions plus claires.'),
(18, 18, 18, 5, 'Vraiment content de mon achat, la qualité est top et la livraison rapide.'),
(19, 19, 19, 1, 'Très déçu par ce produit, il ne correspond absolument pas à la description.'),
(20, 20, 20, 3, 'Produit assez bien, mais il manque quelques fonctionnalités que j’attendais.');

-- --------------------------------------------------------

--
-- Structure de la table `COULEUR`
--

CREATE TABLE `COULEUR` (
  `IDCOULEUR` int NOT NULL,
  `COULEUR` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `COULEUR`
--

INSERT INTO `COULEUR` (`IDCOULEUR`, `COULEUR`) VALUES
(1, 'Noir'),
(2, 'Blanc'),
(3, 'Rouge'),
(4, 'Orange'),
(5, 'Rose'),
(6, 'Jaune'),
(7, 'Sable'),
(8, 'Bleu'),
(9, 'Bleu-ciel'),
(10, 'Cyan'),
(11, 'Turquoise'),
(12, 'Bleu-marine'),
(13, 'Vert'),
(14, 'Vert-clair'),
(15, 'Kaki'),
(16, 'Olive'),
(17, 'Violet'),
(18, 'Magenta'),
(19, 'Bordeaux'),
(20, 'Gris'),
(21, 'Gris-clair'),
(22, 'Gris-Anthracite'),
(23, 'Marron'),
(24, 'Beige'),
(25, 'Argent'),
(26, 'Doré');

-- --------------------------------------------------------

--
-- Structure de la table `IMAGE`
--

CREATE TABLE `IMAGE` (
  `IDIMAGE` int NOT NULL,
  `IDPRODUIT` int NOT NULL,
  `URL` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `IMAGE`
--

INSERT INTO `IMAGE` (`IDIMAGE`, `IDPRODUIT`, `URL`) VALUES
(1, 175, 'images/idProd175.jpg'),
(2, 176, 'images/idProd176.jpg'),
(3, 177, 'images/idProd177.jpg'),
(4, 178, 'images/idProd178.jpg'),
(5, 179, 'images/idProd179.jpg'),
(6, 180, 'images/idProd180.jpg'),
(7, 97, 'images/idProd97.jpg'),
(8, 98, 'images/idProd98.jpg'),
(9, 99, 'images/idProd99.jpg'),
(10, 100, 'images/idProd100.jpg'),
(11, 101, 'images/idProd101.jpg'),
(12, 102, 'images/idProd102.jpg'),
(13, 103, 'images/idProd103.jpg'),
(14, 104, 'images/idProd104.jpg'),
(15, 105, 'images/idProd105.jpg'),
(16, 106, 'images/idProd106.jpg'),
(17, 107, 'images/idProd107.jpg'),
(18, 108, 'images/idProd108.jpg'),
(19, 109, 'images/idProd109.jpg'),
(20, 110, 'images/idProd110.jpg'),
(21, 111, 'images/idProd111.jpg'),
(22, 112, 'images/idProd112.jpg'),
(23, 113, 'images/idProd113.jpg'),
(28, 118, 'images/idProd118.jpg'),
(30, 120, 'images/idProd120.jpg'),
(31, 148, 'images/idProd148.jpg'),
(32, 149, 'images/idProd149.jpg'),
(33, 150, 'images/idProd150.jpg'),
(34, 151, 'images/idProd151.jpg'),
(35, 152, 'images/idProd152.jpg'),
(36, 153, 'images/idProd153.jpg'),
(37, 154, 'images/idProd154.jpg'),
(38, 155, 'images/idProd155.jpg'),
(39, 156, 'images/idProd156.jpg'),
(40, 157, 'images/idProd157.jpg'),
(41, 158, 'images/idProd158.jpg'),
(42, 159, 'images/idProd159.jpg'),
(43, 160, 'images/idProd160.jpg'),
(44, 161, 'images/idProd161.jpg'),
(45, 162, 'images/idProd162.jpg'),
(46, 164, 'images/idProd164.jpg'),
(47, 165, 'images/idProd165.jpg'),
(48, 166, 'images/idProd166.jpg'),
(49, 167, 'images/idProd167.jpg'),
(50, 168, 'images/idProd168.jpg'),
(51, 169, 'images/idProd169.jpg'),
(52, 170, 'images/idProd170.jpg'),
(53, 171, 'images/idProd171.jpg'),
(54, 172, 'images/idProd172.jpg'),
(55, 173, 'images/idProd173.jpg'),
(56, 174, 'images/idProd174.jpg'),
(58, 214, 'images/idProd214.jpg'),
(59, 1000, NULL),
(60, 213, 'images/idProd213.jpg'),
(61, 114, 'images/idProd114.jpg'),
(62, 212, 'images/idProd212.jpg'),
(63, 211, 'images/idProd211.jpg'),
(64, 115, 'images/idProd115.jpg'),
(65, 210, 'images/idProd210.jpg'),
(66, 116, 'images/idProd116.jpg'),
(67, 209, 'images/idProd209.jpg'),
(68, 117, 'images/idProd117.jpg'),
(71, 163, 'images/idProd163.jpg'),
(72, 208, 'images/idProd208.jpg'),
(73, 207, 'images/idProd207.jpg'),
(74, 202, 'images/idProd202.jpg'),
(75, 206, 'images/idProd206.jpg'),
(76, 205, 'images/idProd205.jpg'),
(77, 203, 'images/idProd203.jpg'),
(78, 204, 'images/idProd204.jpg'),
(79, 119, 'images/idProd119.jpg'),
(93, 1015, 'images/idProd1015.jpg'),
(94, 1016, 'images/idProd1016.jpg'),
(95, 1017, 'images/no-image.jpg'),
(96, 1018, 'images/idProd1018.jpg'),
(97, 1019, 'images/no-image.jpg'),
(98, 1020, 'images/idProd1020.jpg'),
(99, 1021, 'images/idProd1021.jpg'),
(100, 1022, 'images/no-image.jpg');

-- --------------------------------------------------------

--
-- Structure de la table `MARQUE`
--

CREATE TABLE `MARQUE` (
  `IDMARQUE` int NOT NULL,
  `NOMMARQUE` varchar(20) DEFAULT NULL,
  `DESCMARQUE` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `MARQUE`
--

INSERT INTO `MARQUE` (`IDMARQUE`, `NOMMARQUE`, `DESCMARQUE`) VALUES
(1, 'Nyke', 'Nyke est une marque de chaussures innovante, alliant performance, confort et style. Avec des designs audacieux et des matériaux durables, elle inspire à repousser les limites, pas après pas.'),
(2, 'Poum\'Ah', 'Pour des chaussures qui frappent fort à chaque pas.'),
(3, 'Adi\'Asse', 'La fusion parfaite entre confort et style intemporel.'),
(4, 'Style & Semelle', 'Marque made in France, qualitative et peu couteux.'),
(5, 'Convairse', 'Pour des discussions stylées avec vos pieds.'),
(6, 'Vannes', 'Chaussures qui ne manquent jamais de punch.'),
(7, 'Ah\'Sticks', 'Des semelles qui collent à votre rythme.'),
(8, 'Nue Balansse', 'L\'équilibre parfait entre innovation et élégance.'),
(9, 'Saleau\'Monde', 'Taillées pour les aventures les plus extrêmes.'),
(10, 'Timberlentes', 'Robustes et indémodables, même à pas mesurés.');

-- --------------------------------------------------------

--
-- Structure de la table `MODEPAIEMENT`
--

CREATE TABLE `MODEPAIEMENT` (
  `IDMODEPAIEMENT` int NOT NULL,
  `NOMPAIEMENT` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `DESCPAIEMENT` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `MODEPAIEMENT`
--

INSERT INTO `MODEPAIEMENT` (`IDMODEPAIEMENT`, `NOMPAIEMENT`, `DESCPAIEMENT`) VALUES
(1, 'Carte de crédit', 'Paiement par carte bancaire (Visa, MasterCard, American Express).'),
(2, 'PayPal', 'Paiement sécurisé via le service PayPal.');

-- --------------------------------------------------------

--
-- Structure de la table `PANIER`
--

CREATE TABLE `PANIER` (
  `IDPANIER` int NOT NULL,
  `IDUTILISATEUR` int NOT NULL,
  `DATECREA` date DEFAULT NULL,
  `IDCOMMANDE` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `PANIER`
--

INSERT INTO `PANIER` (`IDPANIER`, `IDUTILISATEUR`, `DATECREA`, `IDCOMMANDE`) VALUES
(1, 1, '2024-11-25', NULL),
(2, 2, '2024-11-27', NULL),
(3, 3, '2024-11-30', NULL),
(4, 4, '2024-11-22', NULL),
(5, 5, '2024-11-20', NULL),
(6, 6, '2024-11-23', NULL),
(7, 7, '2024-11-28', NULL),
(8, 8, '2024-11-21', NULL),
(9, 9, '2024-11-19', NULL),
(10, 10, '2024-11-18', NULL),
(11, 11, '2024-11-18', NULL),
(12, 12, '2024-11-19', NULL),
(13, 13, '2024-11-20', NULL),
(14, 14, '2024-11-21', NULL),
(15, 15, '2024-11-22', NULL),
(16, 16, '2024-11-23', NULL),
(17, 17, '2024-11-24', NULL),
(18, 18, '2024-11-25', NULL),
(19, 19, '2024-11-26', NULL),
(20, 20, '2024-11-27', NULL),
(21, 21, '2024-11-28', NULL),
(22, 22, '2024-11-29', NULL),
(23, 23, '2024-11-30', NULL),
(24, 24, '2024-12-01', NULL),
(25, 25, '2024-12-02', NULL),
(26, 26, '2024-12-03', NULL),
(27, 27, '2024-12-04', NULL),
(28, 28, '2024-12-05', NULL),
(29, 29, '2024-12-06', NULL),
(30, 30, '2024-12-07', NULL),
(31, 31, '2024-11-28', NULL),
(32, 32, '2024-11-29', NULL),
(33, 33, '2024-11-30', NULL),
(34, 34, '2024-12-01', NULL),
(35, 35, '2024-12-02', NULL),
(36, 36, '2024-12-03', NULL),
(37, 37, '2024-12-04', NULL),
(38, 38, '2024-12-05', NULL),
(39, 39, '2024-12-06', NULL),
(40, 40, '2024-12-07', NULL),
(41, 41, '2024-12-08', NULL),
(42, 42, '2024-12-09', NULL),
(43, 43, '2024-12-10', NULL),
(44, 44, '2024-12-11', NULL),
(45, 45, '2024-12-12', NULL),
(46, 46, '2024-12-13', NULL),
(47, 47, '2024-12-14', NULL),
(48, 48, '2024-12-15', NULL),
(49, 49, '2024-12-16', NULL),
(50, 50, '2024-12-17', NULL),
(51, 74, '2024-12-04', NULL),
(52, 75, '2024-12-05', NULL),
(53, 76, '2024-12-06', NULL),
(54, 67, '2024-11-25', 12),
(69, 73, '2024-12-12', NULL),
(70, 0, '2024-12-12', NULL),
(71, 77, '2024-12-12', NULL),
(72, 0, '2024-12-12', NULL),
(73, 0, '2024-12-12', NULL),
(74, 0, '2024-12-12', NULL),
(75, 66, '2024-12-12', 14),
(76, 72, '2024-12-12', NULL),
(77, 0, '2024-12-13', NULL),
(78, 81, '2024-12-13', NULL),
(79, 0, '2024-12-13', NULL),
(80, 0, '2024-12-13', NULL),
(81, 0, '2024-12-13', NULL),
(83, 0, '2024-12-13', NULL),
(84, 0, '2024-12-13', NULL),
(86, 83, '2024-12-14', NULL),
(87, 0, '2024-12-16', NULL),
(88, 87, '2024-12-16', NULL),
(89, 67, '2024-12-18', 13),
(90, 67, '2024-12-18', 15),
(91, 66, '2024-12-18', NULL),
(92, 67, '2024-12-18', 16),
(93, 67, '2024-12-18', 17),
(94, 67, '2024-12-18', 18),
(95, 67, '2024-12-18', 19),
(96, 67, '2024-12-18', 20),
(97, 67, '2024-12-18', 21),
(98, 67, '2024-12-19', 22),
(99, 67, '2024-12-19', 23),
(100, 67, '2024-12-19', NULL),
(101, 0, '2024-12-20', NULL),
(102, 88, '2024-12-20', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `PRODUIT`
--

CREATE TABLE `PRODUIT` (
  `IDPRODUIT` int NOT NULL,
  `IDCATEGORIE` int NOT NULL,
  `IDMARQUE` int NOT NULL,
  `NOMPRODUIT` varchar(128) DEFAULT NULL,
  `DESCPRODUIT` varchar(200) DEFAULT NULL,
  `PRIX` decimal(10,2) DEFAULT NULL,
  `ASPECTTECHNIQUE` varchar(200) DEFAULT NULL,
  `COMPOSITION` varchar(200) DEFAULT NULL,
  `POIDS` decimal(10,2) DEFAULT NULL,
  `GENRE` char(1) DEFAULT NULL,
  `supprime` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `PRODUIT`
--

INSERT INTO `PRODUIT` (`IDPRODUIT`, `IDCATEGORIE`, `IDMARQUE`, `NOMPRODUIT`, `DESCPRODUIT`, `PRIX`, `ASPECTTECHNIQUE`, `COMPOSITION`, `POIDS`, `GENRE`, `supprime`) VALUES
(97, 1, 1, 'Sneakers Retro Classiques', 'Sneakers de style rétro avec semelle renforcée', '79.99', 'Technologie d’amorti AirCell', 'Tige en cuir synthétique, semelle en caoutchouc', '0.90', 'M', 0),
(98, 1, 2, 'Chaussures de Running Pro', 'Chaussures de course ultra-légères pour performance optimale', '110.00', 'Semelle avec absorption des chocs', 'Textile respirant, caoutchouc', '0.60', 'M', 0),
(99, 2, 3, 'Escarpins Vernis Élégance', 'Escarpins avec finition vernie pour une touche de glamour', '150.00', 'Semelle intérieure en cuir, talon de 7 cm', 'Cuir, vernis', '0.50', 'F', 0),
(100, 2, 4, 'Sandales en Cuir Premium', 'Sandales élégantes pour l\'été avec sangle ajustable', '60.00', 'Cuir pleine fleur, semelle souple', 'Cuir, caoutchouc', '0.30', 'F', 0),
(101, 8, 1, 'Bottes en Daim Luxe', 'Bottes en daim avec doublure en fourrure synthétique', '220.00', 'Doublure chaude, semelle antidérapante', 'Daim, fourrure synthétique', '1.20', 'M', 0),
(102, 3, 2, 'Chaussures de Randonnée', 'Chaussures robustes pour randonnée en montagne', '140.00', 'Imperméable, semelle Vibram', 'Cuir, synthétique', '1.40', 'M', 0),
(103, 5, 1, 'Baskets Urban Chic', 'Baskets urbaines confortables pour la ville', '95.00', 'Semelle intermédiaire en mousse EVA', 'Tissu respirant, semelle en caoutchouc', '0.80', 'M', 0),
(104, 5, 2, 'Chaussures de Ville Confort', 'Chaussures de ville classiques avec semelle en cuir', '120.00', 'Coussin d’air intégré pour plus de confort', 'Cuir pleine fleur, semelle en cuir', '1.00', 'M', 0),
(105, 9, 1, 'Pack Été Femme', 'Pack de 3 paires de sandales en cuir pour l\'été', '200.00', 'Combinaison de sandales légères et élégantes', 'Cuir, caoutchouc', '2.00', 'F', 0),
(106, 4, 2, 'Pack Sport Homme', 'Pack de 2 paires de baskets de running pour différentes surfaces', '180.00', 'Amorti renforcé pour trail et route', 'Textile, caoutchouc', '1.80', 'M', 0),
(107, 11, 3, 'Chaussures Lumineuses Enfants', 'Chaussures LED rechargeables pour enfants', '60.00', 'LED rechargeable USB', 'Synthétique, caoutchouc', '0.50', 'E', 0),
(108, 11, 4, 'Collection Casual Enfant', 'Ensemble de 5 paires de chaussures décontractées pour enfants', '150.00', 'Semelles souples, design coloré', 'Tissu, caoutchouc', '3.00', 'E', 0),
(109, 5, 2, 'Chaussures de Sécurité', 'Chaussures de sécurité pour le travail en milieu industriel', '95.00', 'Coque renforcée en acier', 'Cuir, acier, caoutchouc', '1.80', 'M', 0),
(110, 9, 3, 'Pantoufles en Laine', 'Pantoufles en laine pour une chaleur maximale en hiver', '30.00', 'Doublure en laine naturelle', 'Laine, caoutchouc', '0.30', 'F', 0),
(111, 6, 4, 'Sneakers High-Tech', 'Sneakers innovantes avec écran LED intégré', '250.00', 'Écran LED programmable', 'Synthétique, caoutchouc', '0.90', 'M', 0),
(112, 2, 3, 'Mocassins Élégants', 'Mocassins en cuir pour hommes, design classique', '90.00', 'Semelle flexible', 'Cuir', '0.90', 'M', 0),
(113, 2, 1, 'Ballerines Confort', 'Ballerines pour femmes, idéales pour un usage quotidien', '50.00', 'Semelle intérieure amortissante', 'Textile, cuir', '0.40', 'F', 0),
(114, 8, 2, 'Chaussures de Sécurité', 'Chaussures de sécurité pour le travail en milieu industriel', '95.00', 'Coque renforcée en acier', 'Cuir, acier, caoutchouc', '1.80', 'M', 0),
(115, 7, 3, 'Sneakers High-Tech', 'Sneakers innovantes avec écran LED intégré', '250.00', 'Écran LED programmable', 'Synthétique, caoutchouc', '0.90', 'M', 0),
(116, 11, 4, 'Chaussures Enfant Lumineuses', 'Chaussures avec semelles LED lumineuses pour enfants', '60.00', 'Rechargeable par USB, léger', 'Synthétique, caoutchouc', '0.50', 'E', 0),
(117, 9, 3, 'Pantoufles en Laine', 'Pantoufles en laine pour une chaleur maximale en hiver', '30.00', 'Doublure en laine naturelle', 'Laine, caoutchouc', '0.30', 'M', 0),
(118, 2, 4, 'Derbies en Cuir Suédé', 'Chaussures élégantes pour hommes en cuir suédé', '110.00', 'Semelle extérieure en gomme', 'Cuir suédé', '0.80', 'M', 0),
(119, 6, 1, 'Baskets Vegan', 'Baskets écologiques fabriquées sans produits d’origine animale', '130.00', 'Matériaux recyclés, légères', 'Textile, caoutchouc', '0.70', 'M', 0),
(120, 1, 2, 'Baskets Vegan et Vegie', 'Baskets écologiques V2', '130.00', 'Matériaux recyclés, légères', 'Textile, caoutchouc', '0.70', 'M', 0),
(148, 7, 1, 'Chaussures de Basketball Pro', 'Chaussures de basketball avec semelle ultra-réactive', '120.00', 'Amorti amélioré, adhérence optimisée', 'Cuir, caoutchouc', '0.90', 'M', 0),
(149, 1, 2, 'Baskets Running Fast', 'Baskets ultra-légères pour la course', '85.00', 'Système d\'amorti flexible', 'Textile, caoutchouc', '0.70', 'M', 0),
(150, 2, 3, 'Escarpins Satin Élégance', 'Escarpins avec finition satinée, idéal pour les soirées chic', '160.00', 'Semelle en cuir, talon de 9 cm', 'Cuir satiné', '0.60', 'F', 0),
(151, 2, 4, 'Mules en Cuir Chic', 'Mules élégantes pour l\'été, confortables et stylées', '70.00', 'Cuir souple, semelle en liège', 'Cuir, liège', '0.40', 'F', 0),
(152, 8, 1, 'Bottes Hiver Confort', 'Bottes en cuir avec doublure en laine pour l\'hiver', '180.00', 'Doublure en laine, semelle antidérapante', 'Cuir, laine', '1.30', 'M', 0),
(153, 9, 2, 'Sandales Hawaï Confort', 'Sandales pour la plage, légères et respirantes', '25.00', 'Système de ventilation, semelle en caoutchouc', 'Caoutchouc, tissu', '0.30', 'F', 0),
(154, 5, 1, 'Chaussures de Ville Mode', 'Chaussures classiques mais modernes pour les sorties urbaines', '130.00', 'Coussin d\'air intégré', 'Cuir, textile', '1.00', 'M', 0),
(155, 6, 2, 'Mocassins Homme Élégants', 'Mocassins en cuir pour un look raffiné', '110.00', 'Semelle en cuir flexible', 'Cuir, cuir', '0.90', 'M', 0),
(156, 9, 1, 'Pack Sandales Été Femme', 'Pack de 4 paires de sandales élégantes pour l\'été', '220.00', 'Sandales légères et confortables', 'Cuir, caoutchouc', '2.30', 'F', 0),
(157, 4, 2, 'Pack Tennis Homme', 'Pack de 3 paires de tennis pour sport et loisirs', '210.00', 'Tennis avec soutien optimal pour le sport', 'Textile, caoutchouc', '2.00', 'M', 0),
(158, 11, 3, 'Pack Chaussures Enfant', 'Pack de 4 paires de chaussures pour enfants, confort et style', '180.00', 'Design coloré, semelles souples', 'Tissu, caoutchouc', '2.50', 'E', 0),
(159, 5, 4, 'Pack École Homme', 'Pack de 2 paires de chaussures de ville pour hommes', '180.00', 'Cuir haut de gamme, semelle en gomme', 'Cuir, caoutchouc', '2.00', 'M', 0),
(160, 7, 2, 'Baskets High-Tech', 'Baskets futuristes avec émetteur de signal', '250.00', 'Semelle haute performance', 'Synthétique, caoutchouc', '1.00', 'M', 0),
(161, 7, 3, 'Chaussures de Course Extrême', 'Chaussures de course avec technologie de rebond', '130.00', 'Amorti haute performance', 'Textile, caoutchouc', '0.80', 'M', 0),
(162, 2, 1, 'Escarpins à Talon Haut', 'Escarpins classiques avec talon haut pour une silhouette élégante', '140.00', 'Talon de 10 cm', 'Cuir, satin', '0.60', 'F', 0),
(163, 5, 2, 'Chaussures de Sécurité Standard', 'Chaussures de sécurité pour le milieu de travail', '90.00', 'Semelle renforcée, protection acier', 'Cuir, métal', '1.70', 'M', 0),
(164, 8, 1, 'Bottes Montantes Hiver', 'Bottes robustes avec doublure chaude pour l\'hiver', '200.00', 'Semelle antidérapante', 'Cuir, laine', '1.50', 'F', 0),
(165, 1, 2, 'Tennis Fashion', 'Tennis tendances pour hommes et femmes', '100.00', 'Légères, flexibles, avec renforts', 'Textile, caoutchouc', '0.80', 'F', 0),
(166, 7, 3, 'Baskets Sportives Hautes', 'Baskets hautes avec tige renforcée pour le sport', '110.00', 'Technologie d\'amorti renforcé', 'Cuir, textile', '1.00', 'M', 0),
(167, 2, 4, 'Escarpins Satin Chic', 'Escarpins satinés pour les soirées chic', '180.00', 'Talon de 8 cm', 'Satin, cuir', '0.50', 'F', 0),
(168, 7, 1, 'Chaussures de Randonnée Femme', 'Chaussures de randonnée avec semelle antidérapante', '130.00', 'Semelle en caoutchouc durable', 'Cuir, caoutchouc', '1.20', 'F', 0),
(169, 4, 1, 'Baskets de Trail Homme', 'Baskets pour trail avec semelle haute traction', '140.00', 'Amorti anti-chocs, semelle Vibram', 'Textile, caoutchouc', '1.10', 'M', 0),
(170, 7, 3, 'Baskets Ultra Confort', 'Baskets ultra confortables pour un usage quotidien', '90.00', 'Semelle à mémoire de forme', 'Textile, caoutchouc', '0.70', 'M', 0),
(171, 8, 1, 'Baskets Légères Femme', 'Baskets confortables pour la course et les loisirs', '75.00', 'Semelle légère, respirante', 'Textile, caoutchouc', '0.60', 'F', 0),
(172, 5, 2, 'Chaussures Ville Classiques', 'Chaussures de ville pour un look élégant', '120.00', 'Semelle cuir, design minimaliste', 'Cuir, textile', '0.90', 'M', 0),
(173, 8, 3, 'Boots Fashion Femme', 'Boots tendances pour l\'hiver et l\'automne', '150.00', 'Semelle épaisse, doublure chaude', 'Cuir, laine', '1.20', 'F', 0),
(174, 8, 4, 'Bottes Haute Gamme', 'Bottes hautes pour une silhouette élégante', '200.00', 'Cuir premium talon haut', 'Cuir', '1.30', 'F', 0),
(175, 6, 1, 'Casual Flex', 'Chaussures sportives légères pour hommes avec tige en Flyknit et semelle EVA pour un amorti optimal.', '79.99', 'EVA sole, EVA insole for shock absorption, breathable mesh upper', 'Flyknit, EVA, mesh', '0.80', 'M', 0),
(176, 5, 2, 'Elegant Step', 'Chaussures Oxford pour hommes, élégantes et idéales pour les occasions formelles.', '99.99', 'Cuir lisse, semelle en caoutchouc antidérapante', 'Cuir, caoutchouc', '1.00', 'M', 0),
(177, 4, 1, 'Light Jogger', 'Chaussures de jogging légères pour hommes, avec semelle souple et bon amorti.', '139.99', 'Semelle souple avec amorti', 'Textile, caoutchouc', '0.90', 'M', 0),
(178, 4, 2, 'Classic Runner', 'Chaussures de sport Adidas légères avec semelle amortissante et tige en maille.', '89.99', 'Semelle amortissante, tige en maille respirante', 'Textile, caoutchouc', '0.80', 'M', 0),
(179, 6, 1, 'Urban Comfort', 'Chaussures urbaines pour hommes, légères et avec semelle antidérapante pour la ville.', '129.99', 'Semelle antidérapante pour une traction optimale', 'Cuir, caoutchouc', '1.50', 'M', 0),
(180, 4, 2, 'Sport Elite', 'Chaussures de sport polyvalentes pour femmes, avec semelle flexible et bon amorti.', '79.99', 'Semelle flexible avec amorti', 'Cuir, caoutchouc', '1.20', 'F', 0),
(202, 9, 1, 'Sandales Été Confort', 'Sandales ouvertes avec semelle confort', '45.00', 'Semelle souple, design élégant', 'Cuir, caoutchouc', '0.40', 'F', 0),
(203, 9, 2, 'Tongs Été', 'Tongs pratiques et confortables pour l\'été', '20.00', 'Semelle antidérapante', 'Caoutchouc', '0.30', 'F', 0),
(204, 9, 3, 'Sandales Style Boho', 'Sandales ouvertes au style bohème', '55.00', 'Design tressé, semelle épaisse', 'Textile, caoutchouc', '0.60', 'F', 0),
(205, 10, 1, 'Baskets Sport Enfant', 'Baskets légères pour les activités sportives des enfants', '50.00', 'Amorti léger, semelle antidérapante', 'Textile, caoutchouc', '0.40', 'E', 0),
(206, 10, 3, 'Chaussures de Foot Junior', 'Chaussures de football pour enfants avec bonne traction', '45.00', 'Semelle souple, design sport', 'Cuir, caoutchouc', '0.55', 'E', 0),
(207, 10, 2, 'Baskets Multisports', 'Baskets adaptées à tous types de sports pour enfants', '55.00', 'Semelle flexible, respirante', 'Textile, caoutchouc', '0.60', 'E', 0),
(208, 11, 1, 'Chaussures Scolaires Fille', 'Chaussures élégantes et confortables pour l\'école', '40.00', 'Semelle antidérapante, cuir doux', 'Cuir, textile', '0.40', 'F', 0),
(209, 11, 2, 'Chaussures Scolaires Garçon', 'Chaussures classiques pour les journées scolaires', '45.00', 'Confort optimisé, semelle résistante', 'Cuir', '0.45', 'M', 0),
(210, 11, 3, 'Chaussures d\'École Unisexes', 'Chaussures scolaires pour enfants', '35.00', 'Design simple, semelle souple', 'Textile', '0.35', 'E', 0),
(211, 12, 1, 'Sandales Été Enfant', 'Sandales légères et confortables pour les journées d\'été', '30.00', 'Semelle respirante, réglable', 'Cuir, caoutchouc', '0.40', 'E', 0),
(212, 12, 2, 'Tongs Été Enfant', 'Tongs légères et colorées pour les enfants', '15.00', 'Semelle flexible, pratique', 'Caoutchouc', '0.30', 'E', 0),
(213, 12, 3, 'Chaussures d’été Enfant', 'Chaussures ouvertes et légères pour la saison estivale', '25.00', 'Design simple, semelle anti-dérapante', 'Textile', '0.35', 'E', 0),
(214, 4, 1, 'Jordan', 'Les Nyke Jordan incarnent l\'essence même du style et de la performance. Conçues pour les amateurs de basket et les passionnés de streetwear, elles allient technologie avancée et design iconique.', '119.90', 'Semelle intermédiaire ultra-réactive :\r\nFabriquée en mousse haute densité avec technologie Air Boost, elle offre un amorti exceptionnel et un retour d\'énergie optimal pour des sauts explosifs.', 'Les **Nyke Jordan** sont composées de matériaux haut de gamme : une tige en mesh respirant et cuir synthétique renforcé, une semelle intermédiaire en mousse réactive avec technologie *Air Boost*.', '320.34', 'M', 0),
(1019, 4, 1, 'TEST', 'Description par defaut', '100.00', 'Aspect tech defaut', 'composition défaut', '100.00', '1', 0),
(1020, 4, 1, 'TEST IMAGE', 'desc', '100.00', 'aspect tech', 'compo', '100.00', '1', 0),
(1021, 4, 1, 'TEST MODIFY', 'des', '100.00', 'as', 'co', '100.00', '1', 0),
(1022, 4, 1, 'TEST recover', 'deds', '10.00', 'da', 'ada', '10.00', '1', 0);

-- --------------------------------------------------------

--
-- Structure de la table `PRODUITPANIER`
--

CREATE TABLE `PRODUITPANIER` (
  `IDPRODUITPANIER` int NOT NULL,
  `IDPANIER` int NOT NULL,
  `QTEPP` int DEFAULT NULL,
  `PRIXACHAT` decimal(10,2) DEFAULT NULL,
  `IDPRODUIT_ATTR` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `PRODUITPANIER`
--

INSERT INTO `PRODUITPANIER` (`IDPRODUITPANIER`, `IDPANIER`, `QTEPP`, `PRIXACHAT`, `IDPRODUIT_ATTR`) VALUES
(1, 1, 150, '79.99', 3291),
(2, 1, 145, '99.99', 3341),
(3, 2, 160, '139.99', 3361),
(4, 3, 170, '89.99', 3411),
(5, 4, 180, '129.99', 3461),
(6, 5, 195, '159.99', 3481),
(7, 51, 10, '100.00', 2437),
(12, 51, 10, '100.00', 3481),
(13, 51, 10, '100.00', 2921),
(14, 51, 10, '100.00', 2053),
(15, 51, 10, '100.00', 2093),
(16, 51, 10, '100.00', 2123),
(17, 51, 10, '100.00', 2163),
(18, 51, 10, '100.00', 2179),
(19, 51, 10, '100.00', 2189),
(31, 71, 1, '79.99', 2090),
(32, 51, 1, '99.99', 3343),
(33, 51, 1, '139.99', 3362),
(46, 76, 1, '79.99', 2054),
(47, 76, 1, '119.90', 4100),
(49, 76, 1, '140.00', 2208),
(50, 76, 1, '180.00', 2278),
(79, 54, 12, '79.99', 3297),
(84, 75, 4, '200.00', 2261),
(89, 54, 16, '130.00', 2517),
(91, 89, 1, '79.99', 2057),
(92, 75, 1, '79.99', 3291),
(93, 91, 3, '119.90', 4100),
(94, 90, 1, '150.00', 2123),
(95, 97, 2, '79.99', 2090),
(96, 97, 3, '119.90', 4100),
(97, 91, 1, '79.99', 3331),
(98, 98, 1, '60.00', 2163),
(99, 99, 1, '110.00', 2093),
(100, 100, 11, '79.99', 2057),
(101, 100, 13, '79.99', 2053),
(102, 91, 2, '139.99', 3361),
(103, 102, 1, '119.90', 4100);

-- --------------------------------------------------------

--
-- Structure de la table `PRODUIT_ATTR`
--

CREATE TABLE `PRODUIT_ATTR` (
  `IDPRODUIT_ATTR` int NOT NULL,
  `IDPRODUIT` int NOT NULL,
  `IDTAILLE` int NOT NULL,
  `IDCOULEUR` int NOT NULL,
  `QTESTOCK` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `PRODUIT_ATTR`
--

INSERT INTO `PRODUIT_ATTR` (`IDPRODUIT_ATTR`, `IDPRODUIT`, `IDTAILLE`, `IDCOULEUR`, `QTESTOCK`) VALUES
(2053, 97, 15, 1, 14),
(2054, 97, 15, 13, 19),
(2055, 97, 15, 22, 20),
(2056, 97, 15, 23, 28),
(2057, 97, 16, 1, 28),
(2058, 97, 16, 13, 10),
(2059, 97, 16, 22, 14),
(2060, 97, 16, 23, 29),
(2061, 97, 17, 1, 12),
(2062, 97, 17, 13, 21),
(2063, 97, 17, 22, 14),
(2064, 97, 17, 23, 22),
(2065, 97, 18, 1, 21),
(2066, 97, 18, 13, 15),
(2067, 97, 18, 22, 29),
(2068, 97, 18, 23, 24),
(2069, 97, 19, 1, 20),
(2070, 97, 19, 13, 15),
(2071, 97, 19, 22, 12),
(2072, 97, 19, 23, 30),
(2073, 97, 20, 1, 17),
(2074, 97, 20, 13, 10),
(2075, 97, 20, 22, 22),
(2076, 97, 20, 23, 24),
(2077, 97, 21, 1, 25),
(2078, 97, 21, 13, 15),
(2079, 97, 21, 22, 29),
(2080, 97, 21, 23, 20),
(2081, 97, 22, 1, 12),
(2082, 97, 22, 13, 19),
(2083, 97, 22, 22, 17),
(2084, 97, 22, 23, 29),
(2085, 97, 23, 1, 30),
(2086, 97, 23, 13, 10),
(2087, 97, 23, 22, 30),
(2088, 97, 23, 23, 25),
(2089, 97, 24, 1, 28),
(2090, 97, 24, 13, 20),
(2091, 97, 24, 22, 27),
(2092, 97, 24, 23, 15),
(2093, 98, 15, 3, 20),
(2094, 98, 15, 12, 18),
(2095, 98, 15, 19, 20),
(2096, 98, 16, 3, 25),
(2097, 98, 16, 12, 12),
(2098, 98, 16, 19, 18),
(2099, 98, 17, 3, 11),
(2100, 98, 17, 12, 10),
(2101, 98, 17, 19, 21),
(2102, 98, 18, 3, 14),
(2103, 98, 18, 12, 24),
(2104, 98, 18, 19, 18),
(2105, 98, 19, 3, 30),
(2106, 98, 19, 12, 20),
(2107, 98, 19, 19, 27),
(2108, 98, 20, 3, 28),
(2109, 98, 20, 12, 29),
(2110, 98, 20, 19, 22),
(2111, 98, 21, 3, 20),
(2112, 98, 21, 12, 17),
(2113, 98, 21, 19, 10),
(2114, 98, 22, 3, 27),
(2115, 98, 22, 12, 16),
(2116, 98, 22, 19, 21),
(2117, 98, 23, 3, 14),
(2118, 98, 23, 12, 11),
(2119, 98, 23, 19, 28),
(2120, 98, 24, 3, 12),
(2121, 98, 24, 12, 16),
(2122, 98, 24, 19, 15),
(2123, 99, 11, 3, 29),
(2124, 99, 11, 5, 28),
(2125, 99, 11, 10, 13),
(2126, 99, 11, 13, 11),
(2127, 99, 11, 19, 21),
(2128, 99, 12, 3, 20),
(2129, 99, 12, 5, 22),
(2130, 99, 12, 10, 22),
(2131, 99, 12, 13, 10),
(2132, 99, 12, 19, 16),
(2133, 99, 13, 3, 14),
(2134, 99, 13, 5, 25),
(2135, 99, 13, 10, 15),
(2136, 99, 13, 13, 24),
(2137, 99, 13, 19, 23),
(2138, 99, 14, 3, 13),
(2139, 99, 14, 5, 10),
(2140, 99, 14, 10, 15),
(2141, 99, 14, 13, 19),
(2142, 99, 14, 19, 23),
(2143, 99, 15, 3, 28),
(2144, 99, 15, 5, 19),
(2145, 99, 15, 10, 23),
(2146, 99, 15, 13, 21),
(2147, 99, 15, 19, 13),
(2148, 99, 16, 3, 18),
(2149, 99, 16, 5, 18),
(2150, 99, 16, 10, 17),
(2151, 99, 16, 13, 19),
(2152, 99, 16, 19, 25),
(2153, 99, 17, 3, 24),
(2154, 99, 17, 5, 20),
(2155, 99, 17, 10, 10),
(2156, 99, 17, 13, 21),
(2157, 99, 17, 19, 27),
(2158, 99, 18, 3, 10),
(2159, 99, 18, 5, 10),
(2160, 99, 18, 10, 15),
(2161, 99, 18, 13, 25),
(2162, 99, 18, 19, 20),
(2163, 100, 11, 6, 10),
(2164, 100, 11, 21, 25),
(2165, 100, 12, 6, 17),
(2166, 100, 12, 21, 28),
(2167, 100, 13, 6, 21),
(2168, 100, 13, 21, 28),
(2169, 100, 14, 6, 20),
(2170, 100, 14, 21, 20),
(2171, 100, 15, 6, 30),
(2172, 100, 15, 21, 28),
(2173, 100, 16, 6, 12),
(2174, 100, 16, 21, 23),
(2175, 100, 17, 6, 20),
(2176, 100, 17, 21, 12),
(2177, 100, 18, 6, 13),
(2178, 100, 18, 21, 30),
(2179, 101, 15, 14, 24),
(2180, 101, 16, 14, 20),
(2181, 101, 17, 14, 23),
(2182, 101, 18, 14, 28),
(2183, 101, 19, 14, 22),
(2184, 101, 20, 14, 18),
(2185, 101, 21, 14, 26),
(2186, 101, 22, 14, 13),
(2187, 101, 23, 14, 10),
(2188, 101, 24, 14, 10),
(2189, 102, 15, 10, 29),
(2190, 102, 15, 18, 16),
(2191, 102, 16, 10, 12),
(2192, 102, 16, 18, 10),
(2193, 102, 17, 10, 28),
(2194, 102, 17, 18, 14),
(2195, 102, 18, 10, 19),
(2196, 102, 18, 18, 25),
(2197, 102, 19, 10, 25),
(2198, 102, 19, 18, 26),
(2199, 102, 20, 10, 26),
(2200, 102, 20, 18, 25),
(2201, 102, 21, 10, 18),
(2202, 102, 21, 18, 24),
(2203, 102, 22, 10, 25),
(2204, 102, 22, 18, 21),
(2205, 102, 23, 10, 18),
(2206, 102, 23, 18, 30),
(2207, 102, 24, 10, 19),
(2208, 102, 24, 18, 26),
(2209, 103, 15, 21, 21),
(2210, 103, 16, 21, 26),
(2211, 103, 17, 21, 19),
(2212, 103, 18, 21, 13),
(2213, 103, 19, 21, 19),
(2214, 103, 20, 21, 17),
(2215, 103, 21, 21, 26),
(2216, 103, 22, 21, 13),
(2217, 103, 23, 21, 17),
(2218, 103, 24, 21, 14),
(2219, 104, 15, 3, 30),
(2220, 104, 15, 9, 10),
(2221, 104, 15, 12, 14),
(2222, 104, 15, 24, 27),
(2223, 104, 16, 3, 16),
(2224, 104, 16, 9, 20),
(2225, 104, 16, 12, 23),
(2226, 104, 16, 24, 20),
(2227, 104, 17, 3, 13),
(2228, 104, 17, 9, 26),
(2229, 104, 17, 12, 24),
(2230, 104, 17, 24, 22),
(2231, 104, 18, 3, 27),
(2232, 104, 18, 9, 20),
(2233, 104, 18, 12, 21),
(2234, 104, 18, 24, 12),
(2235, 104, 19, 3, 24),
(2236, 104, 19, 9, 14),
(2237, 104, 19, 12, 25),
(2238, 104, 19, 24, 10),
(2239, 104, 20, 3, 20),
(2240, 104, 20, 9, 28),
(2241, 104, 20, 12, 17),
(2242, 104, 20, 24, 23),
(2243, 104, 21, 3, 16),
(2244, 104, 21, 9, 17),
(2245, 104, 21, 12, 24),
(2246, 104, 21, 24, 11),
(2247, 104, 22, 3, 30),
(2248, 104, 22, 9, 10),
(2249, 104, 22, 12, 24),
(2250, 104, 22, 24, 15),
(2251, 104, 23, 3, 14),
(2252, 104, 23, 9, 14),
(2253, 104, 23, 12, 22),
(2254, 104, 23, 24, 17),
(2255, 104, 24, 3, 17),
(2256, 104, 24, 9, 10),
(2257, 104, 24, 12, 25),
(2258, 104, 24, 24, 14),
(2259, 105, 11, 4, 26),
(2260, 105, 11, 26, 22),
(2261, 105, 12, 4, 25),
(2262, 105, 12, 26, 24),
(2263, 105, 13, 4, 29),
(2264, 105, 13, 26, 15),
(2265, 105, 14, 4, 30),
(2266, 105, 14, 26, 29),
(2267, 105, 15, 4, 24),
(2268, 105, 15, 26, 11),
(2269, 105, 16, 4, 26),
(2270, 105, 16, 26, 13),
(2271, 105, 17, 4, 25),
(2272, 105, 17, 26, 15),
(2273, 105, 18, 4, 23),
(2274, 105, 18, 26, 25),
(2275, 106, 15, 1, 14),
(2276, 106, 15, 7, 26),
(2277, 106, 16, 1, 13),
(2278, 106, 16, 7, 20),
(2279, 106, 17, 1, 14),
(2280, 106, 17, 7, 21),
(2281, 106, 18, 1, 16),
(2282, 106, 18, 7, 11),
(2283, 106, 19, 1, 25),
(2284, 106, 19, 7, 29),
(2285, 106, 20, 1, 13),
(2286, 106, 20, 7, 21),
(2287, 106, 21, 1, 10),
(2288, 106, 21, 7, 29),
(2289, 106, 22, 1, 16),
(2290, 106, 22, 7, 17),
(2291, 106, 23, 1, 27),
(2292, 106, 23, 7, 30),
(2293, 106, 24, 1, 29),
(2294, 106, 24, 7, 20),
(2295, 107, 1, 23, 26),
(2296, 107, 1, 25, 12),
(2297, 107, 2, 23, 29),
(2298, 107, 2, 25, 23),
(2299, 107, 3, 23, 29),
(2300, 107, 3, 25, 18),
(2301, 107, 4, 23, 15),
(2302, 107, 4, 25, 12),
(2303, 107, 5, 23, 26),
(2304, 107, 5, 25, 18),
(2305, 107, 6, 23, 22),
(2306, 107, 6, 25, 23),
(2307, 107, 7, 23, 17),
(2308, 107, 7, 25, 29),
(2309, 107, 8, 23, 11),
(2310, 107, 8, 25, 23),
(2311, 107, 9, 23, 16),
(2312, 107, 9, 25, 26),
(2313, 107, 10, 23, 21),
(2314, 107, 10, 25, 18),
(2315, 108, 1, 10, 22),
(2316, 108, 2, 10, 25),
(2317, 108, 3, 10, 10),
(2318, 108, 4, 10, 27),
(2319, 108, 5, 10, 17),
(2320, 108, 6, 10, 30),
(2321, 108, 7, 10, 28),
(2322, 108, 8, 10, 26),
(2323, 108, 9, 10, 24),
(2324, 108, 10, 10, 14),
(2325, 109, 15, 20, 19),
(2326, 109, 15, 21, 27),
(2327, 109, 15, 22, 25),
(2328, 109, 15, 24, 26),
(2329, 109, 15, 26, 30),
(2330, 109, 16, 20, 21),
(2331, 109, 16, 21, 16),
(2332, 109, 16, 22, 11),
(2333, 109, 16, 24, 21),
(2334, 109, 16, 26, 10),
(2335, 109, 17, 20, 11),
(2336, 109, 17, 21, 29),
(2337, 109, 17, 22, 14),
(2338, 109, 17, 24, 16),
(2339, 109, 17, 26, 18),
(2340, 109, 18, 20, 15),
(2341, 109, 18, 21, 12),
(2342, 109, 18, 22, 30),
(2343, 109, 18, 24, 17),
(2344, 109, 18, 26, 30),
(2345, 109, 19, 20, 26),
(2346, 109, 19, 21, 21),
(2347, 109, 19, 22, 29),
(2348, 109, 19, 24, 19),
(2349, 109, 19, 26, 13),
(2350, 109, 20, 20, 20),
(2351, 109, 20, 21, 14),
(2352, 109, 20, 22, 28),
(2353, 109, 20, 24, 16),
(2354, 109, 20, 26, 30),
(2355, 109, 21, 20, 29),
(2356, 109, 21, 21, 27),
(2357, 109, 21, 22, 12),
(2358, 109, 21, 24, 25),
(2359, 109, 21, 26, 29),
(2360, 109, 22, 20, 18),
(2361, 109, 22, 21, 30),
(2362, 109, 22, 22, 29),
(2363, 109, 22, 24, 26),
(2364, 109, 22, 26, 13),
(2365, 109, 23, 20, 24),
(2366, 109, 23, 21, 30),
(2367, 109, 23, 22, 13),
(2368, 109, 23, 24, 10),
(2369, 109, 23, 26, 17),
(2370, 109, 24, 20, 24),
(2371, 109, 24, 21, 24),
(2372, 109, 24, 22, 16),
(2373, 109, 24, 24, 26),
(2374, 109, 24, 26, 13),
(2375, 110, 11, 5, 29),
(2376, 110, 11, 17, 21),
(2377, 110, 11, 21, 20),
(2378, 110, 12, 5, 27),
(2379, 110, 12, 17, 10),
(2380, 110, 12, 21, 30),
(2381, 110, 13, 5, 11),
(2382, 110, 13, 17, 28),
(2383, 110, 13, 21, 19),
(2384, 110, 14, 5, 13),
(2385, 110, 14, 17, 20),
(2386, 110, 14, 21, 12),
(2387, 110, 15, 5, 15),
(2388, 110, 15, 17, 27),
(2389, 110, 15, 21, 17),
(2390, 110, 16, 5, 25),
(2391, 110, 16, 17, 28),
(2392, 110, 16, 21, 14),
(2393, 110, 17, 5, 20),
(2394, 110, 17, 17, 21),
(2395, 110, 17, 21, 29),
(2396, 110, 18, 5, 21),
(2397, 110, 18, 17, 22),
(2398, 110, 18, 21, 13),
(2399, 111, 15, 5, 23),
(2400, 111, 16, 5, 16),
(2401, 111, 17, 5, 30),
(2402, 111, 18, 5, 14),
(2403, 111, 19, 5, 17),
(2404, 111, 20, 5, 14),
(2405, 111, 21, 5, 28),
(2406, 111, 22, 5, 11),
(2407, 111, 23, 5, 13),
(2408, 111, 24, 5, 21),
(2409, 112, 15, 8, 11),
(2410, 112, 15, 15, 13),
(2411, 112, 16, 8, 30),
(2412, 112, 16, 15, 20),
(2413, 112, 17, 8, 30),
(2414, 112, 17, 15, 25),
(2415, 112, 18, 8, 29),
(2416, 112, 18, 15, 18),
(2417, 112, 19, 8, 29),
(2418, 112, 19, 15, 12),
(2419, 112, 20, 8, 21),
(2420, 112, 20, 15, 18),
(2421, 112, 21, 8, 29),
(2422, 112, 21, 15, 22),
(2423, 112, 22, 8, 11),
(2424, 112, 22, 15, 14),
(2425, 112, 23, 8, 19),
(2426, 112, 23, 15, 13),
(2427, 112, 24, 8, 18),
(2428, 112, 24, 15, 14),
(2429, 113, 11, 2, 25),
(2430, 113, 12, 2, 18),
(2431, 113, 13, 2, 26),
(2432, 113, 14, 2, 20),
(2433, 113, 15, 2, 22),
(2434, 113, 16, 2, 20),
(2435, 113, 17, 2, 15),
(2436, 113, 18, 2, 15),
(2437, 114, 15, 2, 22),
(2438, 114, 16, 2, 16),
(2439, 114, 17, 2, 16),
(2440, 114, 18, 2, 11),
(2441, 114, 19, 2, 10),
(2442, 114, 20, 2, 24),
(2443, 114, 21, 2, 27),
(2444, 114, 22, 2, 13),
(2445, 114, 23, 2, 23),
(2446, 114, 24, 2, 17),
(2447, 115, 15, 3, 17),
(2448, 115, 15, 24, 13),
(2449, 115, 15, 25, 27),
(2450, 115, 16, 3, 27),
(2451, 115, 16, 24, 24),
(2452, 115, 16, 25, 25),
(2453, 115, 17, 3, 22),
(2454, 115, 17, 24, 12),
(2455, 115, 17, 25, 23),
(2456, 115, 18, 3, 24),
(2457, 115, 18, 24, 23),
(2458, 115, 18, 25, 27),
(2459, 115, 19, 3, 30),
(2460, 115, 19, 24, 24),
(2461, 115, 19, 25, 13),
(2462, 115, 20, 3, 10),
(2463, 115, 20, 24, 29),
(2464, 115, 20, 25, 10),
(2465, 115, 21, 3, 25),
(2466, 115, 21, 24, 24),
(2467, 115, 21, 25, 16),
(2468, 115, 22, 3, 28),
(2469, 115, 22, 24, 20),
(2470, 115, 22, 25, 20),
(2471, 115, 23, 3, 29),
(2472, 115, 23, 24, 15),
(2473, 115, 23, 25, 11),
(2474, 115, 24, 3, 28),
(2475, 115, 24, 24, 15),
(2476, 115, 24, 25, 30),
(2477, 116, 1, 26, 12),
(2478, 116, 2, 26, 13),
(2479, 116, 3, 26, 21),
(2480, 116, 4, 26, 28),
(2481, 116, 5, 26, 29),
(2482, 116, 6, 26, 22),
(2483, 116, 7, 26, 30),
(2484, 116, 8, 26, 26),
(2485, 116, 9, 26, 30),
(2486, 116, 10, 26, 24),
(2487, 117, 15, 10, 16),
(2488, 117, 15, 13, 16),
(2489, 117, 16, 10, 18),
(2490, 117, 16, 13, 24),
(2491, 117, 17, 10, 14),
(2492, 117, 17, 13, 11),
(2493, 117, 18, 10, 15),
(2494, 117, 18, 13, 28),
(2495, 117, 19, 10, 30),
(2496, 117, 19, 13, 19),
(2497, 117, 20, 10, 29),
(2498, 117, 20, 13, 18),
(2499, 117, 21, 10, 20),
(2500, 117, 21, 13, 14),
(2501, 117, 22, 10, 14),
(2502, 117, 22, 13, 15),
(2503, 117, 23, 10, 21),
(2504, 117, 23, 13, 16),
(2505, 117, 24, 10, 20),
(2506, 117, 24, 13, 12),
(2507, 118, 15, 12, 24),
(2508, 118, 16, 12, 13),
(2509, 118, 17, 12, 11),
(2510, 118, 18, 12, 10),
(2511, 118, 19, 12, 18),
(2512, 118, 20, 12, 16),
(2513, 118, 21, 12, 24),
(2514, 118, 22, 12, 25),
(2515, 118, 23, 12, 30),
(2516, 118, 24, 12, 18),
(2517, 119, 15, 3, 16),
(2518, 119, 15, 17, 11),
(2519, 119, 15, 18, 22),
(2520, 119, 15, 19, 26),
(2521, 119, 15, 26, 28),
(2522, 119, 16, 3, 15),
(2523, 119, 16, 17, 28),
(2524, 119, 16, 18, 30),
(2525, 119, 16, 19, 24),
(2526, 119, 16, 26, 16),
(2527, 119, 17, 3, 23),
(2528, 119, 17, 17, 26),
(2529, 119, 17, 18, 19),
(2530, 119, 17, 19, 15),
(2531, 119, 17, 26, 28),
(2532, 119, 18, 3, 30),
(2533, 119, 18, 17, 17),
(2534, 119, 18, 18, 18),
(2535, 119, 18, 19, 20),
(2536, 119, 18, 26, 17),
(2537, 119, 19, 3, 19),
(2538, 119, 19, 17, 16),
(2539, 119, 19, 18, 13),
(2540, 119, 19, 19, 19),
(2541, 119, 19, 26, 16),
(2542, 119, 20, 3, 18),
(2543, 119, 20, 17, 11),
(2544, 119, 20, 18, 20),
(2545, 119, 20, 19, 15),
(2546, 119, 20, 26, 25),
(2547, 119, 21, 3, 13),
(2548, 119, 21, 17, 30),
(2549, 119, 21, 18, 19),
(2550, 119, 21, 19, 22),
(2551, 119, 21, 26, 26),
(2552, 119, 22, 3, 20),
(2553, 119, 22, 17, 16),
(2554, 119, 22, 18, 22),
(2555, 119, 22, 19, 21),
(2556, 119, 22, 26, 18),
(2557, 119, 23, 3, 19),
(2558, 119, 23, 17, 20),
(2559, 119, 23, 18, 27),
(2560, 119, 23, 19, 25),
(2561, 119, 23, 26, 11),
(2562, 119, 24, 3, 28),
(2563, 119, 24, 17, 11),
(2564, 119, 24, 18, 27),
(2565, 119, 24, 19, 25),
(2566, 119, 24, 26, 23),
(2567, 120, 15, 8, 14),
(2568, 120, 15, 10, 14),
(2569, 120, 16, 8, 25),
(2570, 120, 16, 10, 23),
(2571, 120, 17, 8, 19),
(2572, 120, 17, 10, 24),
(2573, 120, 18, 8, 27),
(2574, 120, 18, 10, 22),
(2575, 120, 19, 8, 29),
(2576, 120, 19, 10, 26),
(2577, 120, 20, 8, 29),
(2578, 120, 20, 10, 11),
(2579, 120, 21, 8, 15),
(2580, 120, 21, 10, 21),
(2581, 120, 22, 8, 12),
(2582, 120, 22, 10, 14),
(2583, 120, 23, 8, 12),
(2584, 120, 23, 10, 14),
(2585, 120, 24, 8, 13),
(2586, 120, 24, 10, 22),
(2587, 148, 15, 18, 24),
(2588, 148, 16, 18, 29),
(2589, 148, 17, 18, 23),
(2590, 148, 18, 18, 19),
(2591, 148, 19, 18, 28),
(2592, 148, 20, 18, 29),
(2593, 148, 21, 18, 30),
(2594, 148, 22, 18, 30),
(2595, 148, 23, 18, 29),
(2596, 148, 24, 18, 29),
(2597, 149, 15, 2, 14),
(2598, 149, 15, 12, 18),
(2599, 149, 16, 2, 25),
(2600, 149, 16, 12, 17),
(2601, 149, 17, 2, 20),
(2602, 149, 17, 12, 27),
(2603, 149, 18, 2, 28),
(2604, 149, 18, 12, 15),
(2605, 149, 19, 2, 24),
(2606, 149, 19, 12, 26),
(2607, 149, 20, 2, 20),
(2608, 149, 20, 12, 15),
(2609, 149, 21, 2, 29),
(2610, 149, 21, 12, 20),
(2611, 149, 22, 2, 17),
(2612, 149, 22, 12, 18),
(2613, 149, 23, 2, 30),
(2614, 149, 23, 12, 20),
(2615, 149, 24, 2, 27),
(2616, 149, 24, 12, 25),
(2617, 150, 11, 2, 15),
(2618, 150, 11, 9, 28),
(2619, 150, 11, 25, 22),
(2620, 150, 11, 26, 21),
(2621, 150, 12, 2, 30),
(2622, 150, 12, 9, 17),
(2623, 150, 12, 25, 16),
(2624, 150, 12, 26, 11),
(2625, 150, 13, 2, 28),
(2626, 150, 13, 9, 30),
(2627, 150, 13, 25, 16),
(2628, 150, 13, 26, 29),
(2629, 150, 14, 2, 20),
(2630, 150, 14, 9, 14),
(2631, 150, 14, 25, 26),
(2632, 150, 14, 26, 27),
(2633, 150, 15, 2, 21),
(2634, 150, 15, 9, 30),
(2635, 150, 15, 25, 27),
(2636, 150, 15, 26, 18),
(2637, 150, 16, 2, 18),
(2638, 150, 16, 9, 15),
(2639, 150, 16, 25, 12),
(2640, 150, 16, 26, 11),
(2641, 150, 17, 2, 27),
(2642, 150, 17, 9, 18),
(2643, 150, 17, 25, 15),
(2644, 150, 17, 26, 24),
(2645, 150, 18, 2, 28),
(2646, 150, 18, 9, 23),
(2647, 150, 18, 25, 18),
(2648, 150, 18, 26, 12),
(2649, 151, 11, 3, 19),
(2650, 151, 11, 9, 20),
(2651, 151, 11, 17, 11),
(2652, 151, 11, 23, 10),
(2653, 151, 11, 25, 16),
(2654, 151, 12, 3, 13),
(2655, 151, 12, 9, 14),
(2656, 151, 12, 17, 20),
(2657, 151, 12, 23, 11),
(2658, 151, 12, 25, 26),
(2659, 151, 13, 3, 13),
(2660, 151, 13, 9, 21),
(2661, 151, 13, 17, 12),
(2662, 151, 13, 23, 26),
(2663, 151, 13, 25, 14),
(2664, 151, 14, 3, 14),
(2665, 151, 14, 9, 20),
(2666, 151, 14, 17, 10),
(2667, 151, 14, 23, 15),
(2668, 151, 14, 25, 25),
(2669, 151, 15, 3, 23),
(2670, 151, 15, 9, 30),
(2671, 151, 15, 17, 10),
(2672, 151, 15, 23, 27),
(2673, 151, 15, 25, 13),
(2674, 151, 16, 3, 23),
(2675, 151, 16, 9, 13),
(2676, 151, 16, 17, 24),
(2677, 151, 16, 23, 23),
(2678, 151, 16, 25, 11),
(2679, 151, 17, 3, 27),
(2680, 151, 17, 9, 22),
(2681, 151, 17, 17, 13),
(2682, 151, 17, 23, 13),
(2683, 151, 17, 25, 17),
(2684, 151, 18, 3, 28),
(2685, 151, 18, 9, 29),
(2686, 151, 18, 17, 24),
(2687, 151, 18, 23, 17),
(2688, 151, 18, 25, 29),
(2689, 152, 15, 12, 25),
(2690, 152, 16, 12, 10),
(2691, 152, 17, 12, 27),
(2692, 152, 18, 12, 17),
(2693, 152, 19, 12, 16),
(2694, 152, 20, 12, 11),
(2695, 152, 21, 12, 10),
(2696, 152, 22, 12, 16),
(2697, 152, 23, 12, 14),
(2698, 152, 24, 12, 14),
(2699, 153, 11, 3, 26),
(2700, 153, 11, 23, 22),
(2701, 153, 12, 3, 12),
(2702, 153, 12, 23, 21),
(2703, 153, 13, 3, 22),
(2704, 153, 13, 23, 10),
(2705, 153, 14, 3, 22),
(2706, 153, 14, 23, 14),
(2707, 153, 15, 3, 26),
(2708, 153, 15, 23, 24),
(2709, 153, 16, 3, 12),
(2710, 153, 16, 23, 11),
(2711, 153, 17, 3, 15),
(2712, 153, 17, 23, 21),
(2713, 153, 18, 3, 18),
(2714, 153, 18, 23, 21),
(2715, 154, 15, 10, 23),
(2716, 154, 15, 19, 15),
(2717, 154, 15, 20, 30),
(2718, 154, 15, 22, 24),
(2719, 154, 15, 25, 22),
(2720, 154, 16, 10, 18),
(2721, 154, 16, 19, 30),
(2722, 154, 16, 20, 29),
(2723, 154, 16, 22, 25),
(2724, 154, 16, 25, 23),
(2725, 154, 17, 10, 11),
(2726, 154, 17, 19, 20),
(2727, 154, 17, 20, 20),
(2728, 154, 17, 22, 16),
(2729, 154, 17, 25, 14),
(2730, 154, 18, 10, 17),
(2731, 154, 18, 19, 28),
(2732, 154, 18, 20, 21),
(2733, 154, 18, 22, 16),
(2734, 154, 18, 25, 27),
(2735, 154, 19, 10, 28),
(2736, 154, 19, 19, 22),
(2737, 154, 19, 20, 18),
(2738, 154, 19, 22, 24),
(2739, 154, 19, 25, 23),
(2740, 154, 20, 10, 17),
(2741, 154, 20, 19, 18),
(2742, 154, 20, 20, 20),
(2743, 154, 20, 22, 11),
(2744, 154, 20, 25, 26),
(2745, 154, 21, 10, 10),
(2746, 154, 21, 19, 19),
(2747, 154, 21, 20, 18),
(2748, 154, 21, 22, 22),
(2749, 154, 21, 25, 19),
(2750, 154, 22, 10, 21),
(2751, 154, 22, 19, 30),
(2752, 154, 22, 20, 19),
(2753, 154, 22, 22, 22),
(2754, 154, 22, 25, 27),
(2755, 154, 23, 10, 28),
(2756, 154, 23, 19, 12),
(2757, 154, 23, 20, 16),
(2758, 154, 23, 22, 13),
(2759, 154, 23, 25, 28),
(2760, 154, 24, 10, 23),
(2761, 154, 24, 19, 14),
(2762, 154, 24, 20, 11),
(2763, 154, 24, 22, 17),
(2764, 154, 24, 25, 13),
(2765, 155, 15, 4, 20),
(2766, 155, 15, 6, 14),
(2767, 155, 15, 11, 16),
(2768, 155, 15, 17, 28),
(2769, 155, 15, 26, 21),
(2770, 155, 16, 4, 15),
(2771, 155, 16, 6, 14),
(2772, 155, 16, 11, 18),
(2773, 155, 16, 17, 19),
(2774, 155, 16, 26, 12),
(2775, 155, 17, 4, 21),
(2776, 155, 17, 6, 23),
(2777, 155, 17, 11, 29),
(2778, 155, 17, 17, 13),
(2779, 155, 17, 26, 24),
(2780, 155, 18, 4, 21),
(2781, 155, 18, 6, 17),
(2782, 155, 18, 11, 11),
(2783, 155, 18, 17, 26),
(2784, 155, 18, 26, 26),
(2785, 155, 19, 4, 10),
(2786, 155, 19, 6, 24),
(2787, 155, 19, 11, 13),
(2788, 155, 19, 17, 21),
(2789, 155, 19, 26, 25),
(2790, 155, 20, 4, 21),
(2791, 155, 20, 6, 18),
(2792, 155, 20, 11, 21),
(2793, 155, 20, 17, 17),
(2794, 155, 20, 26, 22),
(2795, 155, 21, 4, 21),
(2796, 155, 21, 6, 25),
(2797, 155, 21, 11, 28),
(2798, 155, 21, 17, 11),
(2799, 155, 21, 26, 12),
(2800, 155, 22, 4, 18),
(2801, 155, 22, 6, 19),
(2802, 155, 22, 11, 30),
(2803, 155, 22, 17, 16),
(2804, 155, 22, 26, 16),
(2805, 155, 23, 4, 20),
(2806, 155, 23, 6, 27),
(2807, 155, 23, 11, 23),
(2808, 155, 23, 17, 14),
(2809, 155, 23, 26, 27),
(2810, 155, 24, 4, 10),
(2811, 155, 24, 6, 28),
(2812, 155, 24, 11, 12),
(2813, 155, 24, 17, 14),
(2814, 155, 24, 26, 16),
(2815, 156, 11, 20, 25),
(2816, 156, 11, 25, 23),
(2817, 156, 12, 20, 21),
(2818, 156, 12, 25, 30),
(2819, 156, 13, 20, 17),
(2820, 156, 13, 25, 17),
(2821, 156, 14, 20, 25),
(2822, 156, 14, 25, 30),
(2823, 156, 15, 20, 19),
(2824, 156, 15, 25, 27),
(2825, 156, 16, 20, 14),
(2826, 156, 16, 25, 11),
(2827, 156, 17, 20, 20),
(2828, 156, 17, 25, 27),
(2829, 156, 18, 20, 19),
(2830, 156, 18, 25, 10),
(2831, 157, 15, 6, 30),
(2832, 157, 15, 17, 13),
(2833, 157, 16, 6, 30),
(2834, 157, 16, 17, 24),
(2835, 157, 17, 6, 16),
(2836, 157, 17, 17, 19),
(2837, 157, 18, 6, 27),
(2838, 157, 18, 17, 21),
(2839, 157, 19, 6, 23),
(2840, 157, 19, 17, 11),
(2841, 157, 20, 6, 26),
(2842, 157, 20, 17, 15),
(2843, 157, 21, 6, 19),
(2844, 157, 21, 17, 18),
(2845, 157, 22, 6, 12),
(2846, 157, 22, 17, 29),
(2847, 157, 23, 6, 11),
(2848, 157, 23, 17, 25),
(2849, 157, 24, 6, 18),
(2850, 157, 24, 17, 29),
(2851, 158, 1, 14, 28),
(2852, 158, 1, 16, 30),
(2853, 158, 1, 22, 27),
(2854, 158, 1, 26, 27),
(2855, 158, 2, 14, 28),
(2856, 158, 2, 16, 27),
(2857, 158, 2, 22, 14),
(2858, 158, 2, 26, 30),
(2859, 158, 3, 14, 27),
(2860, 158, 3, 16, 25),
(2861, 158, 3, 22, 12),
(2862, 158, 3, 26, 17),
(2863, 158, 4, 14, 11),
(2864, 158, 4, 16, 30),
(2865, 158, 4, 22, 18),
(2866, 158, 4, 26, 30),
(2867, 158, 5, 14, 20),
(2868, 158, 5, 16, 10),
(2869, 158, 5, 22, 24),
(2870, 158, 5, 26, 12),
(2871, 158, 6, 14, 20),
(2872, 158, 6, 16, 11),
(2873, 158, 6, 22, 30),
(2874, 158, 6, 26, 22),
(2875, 158, 7, 14, 24),
(2876, 158, 7, 16, 18),
(2877, 158, 7, 22, 18),
(2878, 158, 7, 26, 15),
(2879, 158, 8, 14, 16),
(2880, 158, 8, 16, 24),
(2881, 158, 8, 22, 17),
(2882, 158, 8, 26, 14),
(2883, 158, 9, 14, 22),
(2884, 158, 9, 16, 23),
(2885, 158, 9, 22, 12),
(2886, 158, 9, 26, 22),
(2887, 158, 10, 14, 14),
(2888, 158, 10, 16, 28),
(2889, 158, 10, 22, 18),
(2890, 158, 10, 26, 22),
(2891, 159, 15, 17, 15),
(2892, 159, 15, 25, 28),
(2893, 159, 15, 26, 24),
(2894, 159, 16, 17, 13),
(2895, 159, 16, 25, 12),
(2896, 159, 16, 26, 13),
(2897, 159, 17, 17, 13),
(2898, 159, 17, 25, 14),
(2899, 159, 17, 26, 18),
(2900, 159, 18, 17, 22),
(2901, 159, 18, 25, 23),
(2902, 159, 18, 26, 15),
(2903, 159, 19, 17, 22),
(2904, 159, 19, 25, 17),
(2905, 159, 19, 26, 24),
(2906, 159, 20, 17, 26),
(2907, 159, 20, 25, 10),
(2908, 159, 20, 26, 17),
(2909, 159, 21, 17, 26),
(2910, 159, 21, 25, 29),
(2911, 159, 21, 26, 10),
(2912, 159, 22, 17, 10),
(2913, 159, 22, 25, 14),
(2914, 159, 22, 26, 22),
(2915, 159, 23, 17, 26),
(2916, 159, 23, 25, 24),
(2917, 159, 23, 26, 10),
(2918, 159, 24, 17, 30),
(2919, 159, 24, 25, 19),
(2920, 159, 24, 26, 12),
(2921, 160, 15, 5, 10),
(2922, 160, 16, 5, 18),
(2923, 160, 17, 5, 17),
(2924, 160, 18, 5, 26),
(2925, 160, 19, 5, 13),
(2926, 160, 20, 5, 10),
(2927, 160, 21, 5, 23),
(2928, 160, 22, 5, 18),
(2929, 160, 23, 5, 13),
(2930, 160, 24, 5, 26),
(2931, 161, 15, 22, 20),
(2932, 161, 16, 22, 30),
(2933, 161, 17, 22, 12),
(2934, 161, 18, 22, 14),
(2935, 161, 19, 22, 16),
(2936, 161, 20, 22, 12),
(2937, 161, 21, 22, 26),
(2938, 161, 22, 22, 15),
(2939, 161, 23, 22, 13),
(2940, 161, 24, 22, 27),
(2941, 162, 11, 4, 25),
(2942, 162, 11, 9, 14),
(2943, 162, 11, 13, 14),
(2944, 162, 11, 18, 21),
(2945, 162, 12, 4, 19),
(2946, 162, 12, 9, 28),
(2947, 162, 12, 13, 13),
(2948, 162, 12, 18, 29),
(2949, 162, 13, 4, 14),
(2950, 162, 13, 9, 17),
(2951, 162, 13, 13, 21),
(2952, 162, 13, 18, 17),
(2953, 162, 14, 4, 27),
(2954, 162, 14, 9, 17),
(2955, 162, 14, 13, 20),
(2956, 162, 14, 18, 29),
(2957, 162, 15, 4, 30),
(2958, 162, 15, 9, 19),
(2959, 162, 15, 13, 16),
(2960, 162, 15, 18, 26),
(2961, 162, 16, 4, 17),
(2962, 162, 16, 9, 16),
(2963, 162, 16, 13, 17),
(2964, 162, 16, 18, 30),
(2965, 162, 17, 4, 30),
(2966, 162, 17, 9, 10),
(2967, 162, 17, 13, 19),
(2968, 162, 17, 18, 17),
(2969, 162, 18, 4, 20),
(2970, 162, 18, 9, 29),
(2971, 162, 18, 13, 17),
(2972, 162, 18, 18, 22),
(2973, 163, 15, 2, 30),
(2974, 163, 15, 10, 13),
(2975, 163, 15, 13, 12),
(2976, 163, 15, 16, 12),
(2977, 163, 16, 2, 29),
(2978, 163, 16, 10, 30),
(2979, 163, 16, 13, 23),
(2980, 163, 16, 16, 28),
(2981, 163, 17, 2, 15),
(2982, 163, 17, 10, 15),
(2983, 163, 17, 13, 24),
(2984, 163, 17, 16, 11),
(2985, 163, 18, 2, 12),
(2986, 163, 18, 10, 26),
(2987, 163, 18, 13, 29),
(2988, 163, 18, 16, 13),
(2989, 163, 19, 2, 12),
(2990, 163, 19, 10, 14),
(2991, 163, 19, 13, 30),
(2992, 163, 19, 16, 29),
(2993, 163, 20, 2, 12),
(2994, 163, 20, 10, 19),
(2995, 163, 20, 13, 23),
(2996, 163, 20, 16, 12),
(2997, 163, 21, 2, 14),
(2998, 163, 21, 10, 17),
(2999, 163, 21, 13, 11),
(3000, 163, 21, 16, 15),
(3001, 163, 22, 2, 22),
(3002, 163, 22, 10, 11),
(3003, 163, 22, 13, 21),
(3004, 163, 22, 16, 11),
(3005, 163, 23, 2, 22),
(3006, 163, 23, 10, 24),
(3007, 163, 23, 13, 15),
(3008, 163, 23, 16, 30),
(3009, 163, 24, 2, 27),
(3010, 163, 24, 10, 19),
(3011, 163, 24, 13, 29),
(3012, 163, 24, 16, 30),
(3013, 164, 15, 14, 27),
(3014, 164, 16, 14, 29),
(3015, 164, 17, 14, 22),
(3016, 164, 18, 14, 30),
(3017, 164, 19, 14, 19),
(3018, 164, 20, 14, 26),
(3019, 164, 21, 14, 26),
(3020, 164, 22, 14, 25),
(3021, 164, 23, 14, 23),
(3022, 164, 24, 14, 27),
(3023, 165, 11, 17, 18),
(3024, 165, 11, 19, 10),
(3025, 165, 11, 25, 23),
(3026, 165, 11, 26, 13),
(3027, 165, 12, 17, 19),
(3028, 165, 12, 19, 30),
(3029, 165, 12, 25, 12),
(3030, 165, 12, 26, 21),
(3031, 165, 13, 17, 22),
(3032, 165, 13, 19, 22),
(3033, 165, 13, 25, 16),
(3034, 165, 13, 26, 13),
(3035, 165, 14, 17, 13),
(3036, 165, 14, 19, 16),
(3037, 165, 14, 25, 26),
(3038, 165, 14, 26, 19),
(3039, 165, 15, 17, 11),
(3040, 165, 15, 19, 17),
(3041, 165, 15, 25, 14),
(3042, 165, 15, 26, 24),
(3043, 165, 16, 17, 18),
(3044, 165, 16, 19, 19),
(3045, 165, 16, 25, 18),
(3046, 165, 16, 26, 10),
(3047, 165, 17, 17, 30),
(3048, 165, 17, 19, 16),
(3049, 165, 17, 25, 23),
(3050, 165, 17, 26, 13),
(3051, 165, 18, 17, 20),
(3052, 165, 18, 19, 24),
(3053, 165, 18, 25, 14),
(3054, 165, 18, 26, 15),
(3055, 166, 15, 14, 19),
(3056, 166, 16, 14, 23),
(3057, 166, 17, 14, 22),
(3058, 166, 18, 14, 26),
(3059, 166, 19, 14, 19),
(3060, 166, 20, 14, 27),
(3061, 166, 21, 14, 21),
(3062, 166, 22, 14, 30),
(3063, 166, 23, 14, 25),
(3064, 166, 24, 14, 29),
(3065, 167, 11, 18, 26),
(3066, 167, 11, 19, 18),
(3067, 167, 11, 21, 25),
(3068, 167, 11, 25, 17),
(3069, 167, 12, 18, 23),
(3070, 167, 12, 19, 16),
(3071, 167, 12, 21, 24),
(3072, 167, 12, 25, 27),
(3073, 167, 13, 18, 20),
(3074, 167, 13, 19, 25),
(3075, 167, 13, 21, 15),
(3076, 167, 13, 25, 23),
(3077, 167, 14, 18, 23),
(3078, 167, 14, 19, 12),
(3079, 167, 14, 21, 27),
(3080, 167, 14, 25, 26),
(3081, 167, 15, 18, 28),
(3082, 167, 15, 19, 16),
(3083, 167, 15, 21, 23),
(3084, 167, 15, 25, 18),
(3085, 167, 16, 18, 15),
(3086, 167, 16, 19, 26),
(3087, 167, 16, 21, 27),
(3088, 167, 16, 25, 18),
(3089, 167, 17, 18, 27),
(3090, 167, 17, 19, 28),
(3091, 167, 17, 21, 13),
(3092, 167, 17, 25, 14),
(3093, 167, 18, 18, 22),
(3094, 167, 18, 19, 13),
(3095, 167, 18, 21, 16),
(3096, 167, 18, 25, 29),
(3097, 168, 11, 1, 10),
(3098, 168, 11, 13, 25),
(3099, 168, 11, 14, 14),
(3100, 168, 11, 21, 14),
(3101, 168, 11, 26, 10),
(3102, 168, 12, 1, 26),
(3103, 168, 12, 13, 16),
(3104, 168, 12, 14, 22),
(3105, 168, 12, 21, 23),
(3106, 168, 12, 26, 25),
(3107, 168, 13, 1, 17),
(3108, 168, 13, 13, 15),
(3109, 168, 13, 14, 29),
(3110, 168, 13, 21, 30),
(3111, 168, 13, 26, 14),
(3112, 168, 14, 1, 23),
(3113, 168, 14, 13, 10),
(3114, 168, 14, 14, 30),
(3115, 168, 14, 21, 26),
(3116, 168, 14, 26, 19),
(3117, 168, 15, 1, 29),
(3118, 168, 15, 13, 23),
(3119, 168, 15, 14, 24),
(3120, 168, 15, 21, 16),
(3121, 168, 15, 26, 24),
(3122, 168, 16, 1, 24),
(3123, 168, 16, 13, 24),
(3124, 168, 16, 14, 19),
(3125, 168, 16, 21, 29),
(3126, 168, 16, 26, 24),
(3127, 168, 17, 1, 13),
(3128, 168, 17, 13, 30),
(3129, 168, 17, 14, 14),
(3130, 168, 17, 21, 18),
(3131, 168, 17, 26, 15),
(3132, 168, 18, 1, 17),
(3133, 168, 18, 13, 10),
(3134, 168, 18, 14, 27),
(3135, 168, 18, 21, 25),
(3136, 168, 18, 26, 13),
(3137, 169, 15, 12, 12),
(3138, 169, 15, 25, 15),
(3139, 169, 15, 26, 17),
(3140, 169, 16, 12, 19),
(3141, 169, 16, 25, 29),
(3142, 169, 16, 26, 10),
(3143, 169, 17, 12, 11),
(3144, 169, 17, 25, 26),
(3145, 169, 17, 26, 15),
(3146, 169, 18, 12, 23),
(3147, 169, 18, 25, 23),
(3148, 169, 18, 26, 12),
(3149, 169, 19, 12, 17),
(3150, 169, 19, 25, 13),
(3151, 169, 19, 26, 18),
(3152, 169, 20, 12, 25),
(3153, 169, 20, 25, 18),
(3154, 169, 20, 26, 30),
(3155, 169, 21, 12, 11),
(3156, 169, 21, 25, 15),
(3157, 169, 21, 26, 20),
(3158, 169, 22, 12, 22),
(3159, 169, 22, 25, 23),
(3160, 169, 22, 26, 27),
(3161, 169, 23, 12, 22),
(3162, 169, 23, 25, 17),
(3163, 169, 23, 26, 14),
(3164, 169, 24, 12, 19),
(3165, 169, 24, 25, 24),
(3166, 169, 24, 26, 12),
(3167, 170, 15, 2, 29),
(3168, 170, 15, 4, 10),
(3169, 170, 15, 11, 19),
(3170, 170, 15, 24, 20),
(3171, 170, 16, 2, 15),
(3172, 170, 16, 4, 28),
(3173, 170, 16, 11, 17),
(3174, 170, 16, 24, 12),
(3175, 170, 17, 2, 12),
(3176, 170, 17, 4, 19),
(3177, 170, 17, 11, 13),
(3178, 170, 17, 24, 17),
(3179, 170, 18, 2, 19),
(3180, 170, 18, 4, 26),
(3181, 170, 18, 11, 12),
(3182, 170, 18, 24, 14),
(3183, 170, 19, 2, 11),
(3184, 170, 19, 4, 27),
(3185, 170, 19, 11, 27),
(3186, 170, 19, 24, 14),
(3187, 170, 20, 2, 23),
(3188, 170, 20, 4, 19),
(3189, 170, 20, 11, 16),
(3190, 170, 20, 24, 30),
(3191, 170, 21, 2, 10),
(3192, 170, 21, 4, 20),
(3193, 170, 21, 11, 15),
(3194, 170, 21, 24, 28),
(3195, 170, 22, 2, 27),
(3196, 170, 22, 4, 10),
(3197, 170, 22, 11, 16),
(3198, 170, 22, 24, 13),
(3199, 170, 23, 2, 17),
(3200, 170, 23, 4, 21),
(3201, 170, 23, 11, 12),
(3202, 170, 23, 24, 16),
(3203, 170, 24, 2, 24),
(3204, 170, 24, 4, 14),
(3205, 170, 24, 11, 19),
(3206, 170, 24, 24, 27),
(3207, 171, 11, 19, 18),
(3208, 171, 12, 19, 26),
(3209, 171, 13, 19, 20),
(3210, 171, 14, 19, 28),
(3211, 171, 15, 19, 16),
(3212, 171, 16, 19, 21),
(3213, 171, 17, 19, 13),
(3214, 171, 18, 19, 12),
(3215, 172, 15, 8, 10),
(3216, 172, 15, 24, 17),
(3217, 172, 16, 8, 18),
(3218, 172, 16, 24, 19),
(3219, 172, 17, 8, 23),
(3220, 172, 17, 24, 23),
(3221, 172, 18, 8, 22),
(3222, 172, 18, 24, 29),
(3223, 172, 19, 8, 12),
(3224, 172, 19, 24, 17),
(3225, 172, 20, 8, 24),
(3226, 172, 20, 24, 22),
(3227, 172, 21, 8, 12),
(3228, 172, 21, 24, 14),
(3229, 172, 22, 8, 29),
(3230, 172, 22, 24, 26),
(3231, 172, 23, 8, 14),
(3232, 172, 23, 24, 15),
(3233, 172, 24, 8, 24),
(3234, 172, 24, 24, 27),
(3235, 173, 11, 3, 11),
(3236, 173, 11, 17, 10),
(3237, 173, 11, 26, 29),
(3238, 173, 12, 3, 10),
(3239, 173, 12, 17, 28),
(3240, 173, 12, 26, 13),
(3241, 173, 13, 3, 10),
(3242, 173, 13, 17, 18),
(3243, 173, 13, 26, 30),
(3244, 173, 14, 3, 10),
(3245, 173, 14, 17, 18),
(3246, 173, 14, 26, 22),
(3247, 173, 15, 3, 24),
(3248, 173, 15, 17, 14),
(3249, 173, 15, 26, 17),
(3250, 173, 16, 3, 19),
(3251, 173, 16, 17, 21),
(3252, 173, 16, 26, 17),
(3253, 173, 17, 3, 21),
(3254, 173, 17, 17, 13),
(3255, 173, 17, 26, 27),
(3256, 173, 18, 3, 11),
(3257, 173, 18, 17, 19),
(3258, 173, 18, 26, 22),
(3259, 174, 11, 7, 20),
(3260, 174, 11, 8, 22),
(3261, 174, 11, 9, 18),
(3262, 174, 11, 19, 17),
(3263, 174, 12, 7, 18),
(3264, 174, 12, 8, 16),
(3265, 174, 12, 9, 30),
(3266, 174, 12, 19, 18),
(3267, 174, 13, 7, 14),
(3268, 174, 13, 8, 23),
(3269, 174, 13, 9, 13),
(3270, 174, 13, 19, 21),
(3271, 174, 14, 7, 20),
(3272, 174, 14, 8, 23),
(3273, 174, 14, 9, 22),
(3274, 174, 14, 19, 11),
(3275, 174, 15, 7, 12),
(3276, 174, 15, 8, 27),
(3277, 174, 15, 9, 23),
(3278, 174, 15, 19, 23),
(3279, 174, 16, 7, 25),
(3280, 174, 16, 8, 27),
(3281, 174, 16, 9, 14),
(3282, 174, 16, 19, 17),
(3283, 174, 17, 7, 27),
(3284, 174, 17, 8, 19),
(3285, 174, 17, 9, 19),
(3286, 174, 17, 19, 17),
(3287, 174, 18, 7, 12),
(3288, 174, 18, 8, 12),
(3289, 174, 18, 9, 17),
(3290, 174, 18, 19, 13),
(3291, 175, 15, 4, 19),
(3292, 175, 15, 11, 30),
(3293, 175, 15, 15, 16),
(3294, 175, 15, 22, 15),
(3295, 175, 15, 23, 28),
(3296, 175, 16, 4, 27),
(3297, 175, 16, 11, 12),
(3298, 175, 16, 15, 11),
(3299, 175, 16, 22, 22),
(3300, 175, 16, 23, 12),
(3301, 175, 17, 4, 21),
(3302, 175, 17, 11, 13),
(3303, 175, 17, 15, 24),
(3304, 175, 17, 22, 22),
(3305, 175, 17, 23, 29),
(3306, 175, 18, 4, 30),
(3307, 175, 18, 11, 15),
(3308, 175, 18, 15, 13),
(3309, 175, 18, 22, 11),
(3310, 175, 18, 23, 20),
(3311, 175, 19, 4, 19),
(3312, 175, 19, 11, 24),
(3313, 175, 19, 15, 24),
(3314, 175, 19, 22, 30),
(3315, 175, 19, 23, 27),
(3316, 175, 20, 4, 18),
(3317, 175, 20, 11, 11),
(3318, 175, 20, 15, 25),
(3319, 175, 20, 22, 29),
(3320, 175, 20, 23, 29),
(3321, 175, 21, 4, 21),
(3322, 175, 21, 11, 14),
(3323, 175, 21, 15, 17),
(3324, 175, 21, 22, 21),
(3325, 175, 21, 23, 15),
(3326, 175, 22, 4, 26),
(3327, 175, 22, 11, 17),
(3328, 175, 22, 15, 24),
(3329, 175, 22, 22, 15),
(3330, 175, 22, 23, 19),
(3331, 175, 23, 4, 25),
(3332, 175, 23, 11, 20),
(3333, 175, 23, 15, 16),
(3334, 175, 23, 22, 14),
(3335, 175, 23, 23, 16),
(3336, 175, 24, 4, 17),
(3337, 175, 24, 11, 25),
(3338, 175, 24, 15, 23),
(3339, 175, 24, 22, 30),
(3340, 175, 24, 23, 25),
(3341, 176, 15, 15, 20),
(3342, 176, 15, 18, 19),
(3343, 176, 16, 15, 15),
(3344, 176, 16, 18, 30),
(3345, 176, 17, 15, 23),
(3346, 176, 17, 18, 19),
(3347, 176, 18, 15, 29),
(3348, 176, 18, 18, 12),
(3349, 176, 19, 15, 24),
(3350, 176, 19, 18, 24),
(3351, 176, 20, 15, 28),
(3352, 176, 20, 18, 26),
(3353, 176, 21, 15, 28),
(3354, 176, 21, 18, 11),
(3355, 176, 22, 15, 27),
(3356, 176, 22, 18, 20),
(3357, 176, 23, 15, 18),
(3358, 176, 23, 18, 12),
(3359, 176, 24, 15, 19),
(3360, 176, 24, 18, 25),
(3361, 177, 15, 1, 13),
(3362, 177, 15, 4, 12),
(3363, 177, 15, 7, 29),
(3364, 177, 15, 8, 19),
(3365, 177, 15, 21, 18),
(3366, 177, 16, 1, 21),
(3367, 177, 16, 4, 14),
(3368, 177, 16, 7, 26),
(3369, 177, 16, 8, 23),
(3370, 177, 16, 21, 27),
(3371, 177, 17, 1, 14),
(3372, 177, 17, 4, 16),
(3373, 177, 17, 7, 23),
(3374, 177, 17, 8, 14),
(3375, 177, 17, 21, 15),
(3376, 177, 18, 1, 14),
(3377, 177, 18, 4, 12),
(3378, 177, 18, 7, 27),
(3379, 177, 18, 8, 13),
(3380, 177, 18, 21, 26),
(3381, 177, 19, 1, 15),
(3382, 177, 19, 4, 18),
(3383, 177, 19, 7, 27),
(3384, 177, 19, 8, 21),
(3385, 177, 19, 21, 29),
(3386, 177, 20, 1, 24),
(3387, 177, 20, 4, 30),
(3388, 177, 20, 7, 18),
(3389, 177, 20, 8, 14),
(3390, 177, 20, 21, 22),
(3391, 177, 21, 1, 18),
(3392, 177, 21, 4, 12),
(3393, 177, 21, 7, 19),
(3394, 177, 21, 8, 27),
(3395, 177, 21, 21, 17),
(3396, 177, 22, 1, 19),
(3397, 177, 22, 4, 15),
(3398, 177, 22, 7, 29),
(3399, 177, 22, 8, 23),
(3400, 177, 22, 21, 25),
(3401, 177, 23, 1, 29),
(3402, 177, 23, 4, 24),
(3403, 177, 23, 7, 18),
(3404, 177, 23, 8, 19),
(3405, 177, 23, 21, 26),
(3406, 177, 24, 1, 11),
(3407, 177, 24, 4, 18),
(3408, 177, 24, 7, 17),
(3409, 177, 24, 8, 21),
(3410, 177, 24, 21, 10),
(3411, 178, 15, 7, 16),
(3412, 178, 15, 10, 24),
(3413, 178, 15, 12, 30),
(3414, 178, 15, 15, 18),
(3415, 178, 15, 18, 23),
(3416, 178, 16, 7, 23),
(3417, 178, 16, 10, 25),
(3418, 178, 16, 12, 30),
(3419, 178, 16, 15, 10),
(3420, 178, 16, 18, 21),
(3421, 178, 17, 7, 23),
(3422, 178, 17, 10, 17),
(3423, 178, 17, 12, 30),
(3424, 178, 17, 15, 22),
(3425, 178, 17, 18, 30),
(3426, 178, 18, 7, 20),
(3427, 178, 18, 10, 17),
(3428, 178, 18, 12, 15),
(3429, 178, 18, 15, 23),
(3430, 178, 18, 18, 20),
(3431, 178, 19, 7, 30),
(3432, 178, 19, 10, 12),
(3433, 178, 19, 12, 20),
(3434, 178, 19, 15, 28),
(3435, 178, 19, 18, 26),
(3436, 178, 20, 7, 19),
(3437, 178, 20, 10, 11),
(3438, 178, 20, 12, 17),
(3439, 178, 20, 15, 15),
(3440, 178, 20, 18, 27),
(3441, 178, 21, 7, 26),
(3442, 178, 21, 10, 19),
(3443, 178, 21, 12, 12),
(3444, 178, 21, 15, 27),
(3445, 178, 21, 18, 13),
(3446, 178, 22, 7, 27),
(3447, 178, 22, 10, 24),
(3448, 178, 22, 12, 18),
(3449, 178, 22, 15, 29),
(3450, 178, 22, 18, 16),
(3451, 178, 23, 7, 12),
(3452, 178, 23, 10, 24),
(3453, 178, 23, 12, 23),
(3454, 178, 23, 15, 23),
(3455, 178, 23, 18, 26),
(3456, 178, 24, 7, 15),
(3457, 178, 24, 10, 29),
(3458, 178, 24, 12, 15),
(3459, 178, 24, 15, 25),
(3460, 178, 24, 18, 21),
(3461, 179, 15, 1, 12),
(3462, 179, 15, 18, 23),
(3463, 179, 16, 1, 19),
(3464, 179, 16, 18, 14),
(3465, 179, 17, 1, 25),
(3466, 179, 17, 18, 13),
(3467, 179, 18, 1, 18),
(3468, 179, 18, 18, 20),
(3469, 179, 19, 1, 18),
(3470, 179, 19, 18, 12),
(3471, 179, 20, 1, 21),
(3472, 179, 20, 18, 24),
(3473, 179, 21, 1, 12),
(3474, 179, 21, 18, 26),
(3475, 179, 22, 1, 24),
(3476, 179, 22, 18, 12),
(3477, 179, 23, 1, 12),
(3478, 179, 23, 18, 29),
(3479, 179, 24, 1, 22),
(3480, 179, 24, 18, 27),
(3481, 180, 11, 4, 16),
(3482, 180, 11, 25, 11),
(3483, 180, 12, 4, 17),
(3484, 180, 12, 25, 19),
(3485, 180, 13, 4, 12),
(3486, 180, 13, 25, 25),
(3487, 180, 14, 4, 18),
(3488, 180, 14, 25, 18),
(3489, 180, 15, 4, 23),
(3490, 180, 15, 25, 18),
(3491, 180, 16, 4, 29),
(3492, 180, 16, 25, 14),
(3493, 180, 17, 4, 10),
(3494, 180, 17, 25, 21),
(3495, 180, 18, 4, 11),
(3496, 180, 18, 25, 13),
(3497, 202, 11, 2, 24),
(3498, 202, 11, 10, 26),
(3499, 202, 11, 24, 24),
(3500, 202, 12, 2, 18),
(3501, 202, 12, 10, 13),
(3502, 202, 12, 24, 20),
(3503, 202, 13, 2, 12),
(3504, 202, 13, 10, 10),
(3505, 202, 13, 24, 15),
(3506, 202, 14, 2, 11),
(3507, 202, 14, 10, 10),
(3508, 202, 14, 24, 23),
(3509, 202, 15, 2, 11),
(3510, 202, 15, 10, 16),
(3511, 202, 15, 24, 23),
(3512, 202, 16, 2, 26),
(3513, 202, 16, 10, 28),
(3514, 202, 16, 24, 20),
(3515, 202, 17, 2, 15),
(3516, 202, 17, 10, 17),
(3517, 202, 17, 24, 16),
(3518, 202, 18, 2, 28),
(3519, 202, 18, 10, 16),
(3520, 202, 18, 24, 23),
(3521, 203, 11, 1, 14),
(3522, 203, 11, 15, 27),
(3523, 203, 11, 22, 24),
(3524, 203, 12, 1, 26),
(3525, 203, 12, 15, 17),
(3526, 203, 12, 22, 10),
(3527, 203, 13, 1, 28),
(3528, 203, 13, 15, 10),
(3529, 203, 13, 22, 26),
(3530, 203, 14, 1, 14),
(3531, 203, 14, 15, 28),
(3532, 203, 14, 22, 16),
(3533, 203, 15, 1, 25),
(3534, 203, 15, 15, 13),
(3535, 203, 15, 22, 15),
(3536, 203, 16, 1, 20),
(3537, 203, 16, 15, 30),
(3538, 203, 16, 22, 17),
(3539, 203, 17, 1, 29),
(3540, 203, 17, 15, 22),
(3541, 203, 17, 22, 20),
(3542, 203, 18, 1, 18),
(3543, 203, 18, 15, 23),
(3544, 203, 18, 22, 17),
(3545, 204, 11, 4, 15),
(3546, 204, 11, 10, 16),
(3547, 204, 11, 13, 18),
(3548, 204, 11, 14, 13),
(3549, 204, 11, 26, 12),
(3550, 204, 12, 4, 16),
(3551, 204, 12, 10, 22),
(3552, 204, 12, 13, 18),
(3553, 204, 12, 14, 14),
(3554, 204, 12, 26, 27),
(3555, 204, 13, 4, 26),
(3556, 204, 13, 10, 28),
(3557, 204, 13, 13, 20),
(3558, 204, 13, 14, 30),
(3559, 204, 13, 26, 24),
(3560, 204, 14, 4, 13),
(3561, 204, 14, 10, 29),
(3562, 204, 14, 13, 25),
(3563, 204, 14, 14, 27),
(3564, 204, 14, 26, 14),
(3565, 204, 15, 4, 24),
(3566, 204, 15, 10, 15),
(3567, 204, 15, 13, 11),
(3568, 204, 15, 14, 19),
(3569, 204, 15, 26, 27),
(3570, 204, 16, 4, 19),
(3571, 204, 16, 10, 13),
(3572, 204, 16, 13, 20),
(3573, 204, 16, 14, 12),
(3574, 204, 16, 26, 23),
(3575, 204, 17, 4, 14),
(3576, 204, 17, 10, 13),
(3577, 204, 17, 13, 20),
(3578, 204, 17, 14, 10),
(3579, 204, 17, 26, 19),
(3580, 204, 18, 4, 27),
(3581, 204, 18, 10, 28),
(3582, 204, 18, 13, 30),
(3583, 204, 18, 14, 17),
(3584, 204, 18, 26, 13),
(3585, 205, 1, 4, 29),
(3586, 205, 1, 9, 28),
(3587, 205, 1, 11, 14),
(3588, 205, 1, 20, 15),
(3589, 205, 1, 23, 26),
(3590, 205, 2, 4, 24),
(3591, 205, 2, 9, 25),
(3592, 205, 2, 11, 13),
(3593, 205, 2, 20, 17),
(3594, 205, 2, 23, 25),
(3595, 205, 3, 4, 20),
(3596, 205, 3, 9, 15),
(3597, 205, 3, 11, 14),
(3598, 205, 3, 20, 27),
(3599, 205, 3, 23, 16),
(3600, 205, 4, 4, 15),
(3601, 205, 4, 9, 20),
(3602, 205, 4, 11, 23),
(3603, 205, 4, 20, 29),
(3604, 205, 4, 23, 16),
(3605, 205, 5, 4, 15),
(3606, 205, 5, 9, 11),
(3607, 205, 5, 11, 10),
(3608, 205, 5, 20, 29),
(3609, 205, 5, 23, 25),
(3610, 205, 6, 4, 16),
(3611, 205, 6, 9, 23),
(3612, 205, 6, 11, 19),
(3613, 205, 6, 20, 21),
(3614, 205, 6, 23, 19),
(3615, 205, 7, 4, 12),
(3616, 205, 7, 9, 17),
(3617, 205, 7, 11, 26),
(3618, 205, 7, 20, 29),
(3619, 205, 7, 23, 20),
(3620, 205, 8, 4, 26),
(3621, 205, 8, 9, 11),
(3622, 205, 8, 11, 12),
(3623, 205, 8, 20, 18),
(3624, 205, 8, 23, 23),
(3625, 205, 9, 4, 14),
(3626, 205, 9, 9, 17),
(3627, 205, 9, 11, 29),
(3628, 205, 9, 20, 30),
(3629, 205, 9, 23, 29),
(3630, 205, 10, 4, 12),
(3631, 205, 10, 9, 14),
(3632, 205, 10, 11, 21),
(3633, 205, 10, 20, 21),
(3634, 205, 10, 23, 16),
(3635, 206, 1, 17, 13),
(3636, 206, 2, 17, 26),
(3637, 206, 3, 17, 22),
(3638, 206, 4, 17, 25),
(3639, 206, 5, 17, 25),
(3640, 206, 6, 17, 30),
(3641, 206, 7, 17, 10),
(3642, 206, 8, 17, 17),
(3643, 206, 9, 17, 23),
(3644, 206, 10, 17, 22),
(3645, 207, 1, 1, 24),
(3646, 207, 1, 2, 13),
(3647, 207, 2, 1, 11),
(3648, 207, 2, 2, 30),
(3649, 207, 3, 1, 14),
(3650, 207, 3, 2, 28),
(3651, 207, 4, 1, 17),
(3652, 207, 4, 2, 27),
(3653, 207, 5, 1, 27),
(3654, 207, 5, 2, 18),
(3655, 207, 6, 1, 30),
(3656, 207, 6, 2, 18),
(3657, 207, 7, 1, 23),
(3658, 207, 7, 2, 21),
(3659, 207, 8, 1, 25),
(3660, 207, 8, 2, 19),
(3661, 207, 9, 1, 17),
(3662, 207, 9, 2, 15),
(3663, 207, 10, 1, 17),
(3664, 207, 10, 2, 15),
(3665, 208, 11, 4, 12),
(3666, 208, 11, 7, 27),
(3667, 208, 11, 23, 27),
(3668, 208, 11, 26, 29),
(3669, 208, 12, 4, 28),
(3670, 208, 12, 7, 26),
(3671, 208, 12, 23, 11),
(3672, 208, 12, 26, 26),
(3673, 208, 13, 4, 19),
(3674, 208, 13, 7, 17),
(3675, 208, 13, 23, 14),
(3676, 208, 13, 26, 23),
(3677, 208, 14, 4, 26),
(3678, 208, 14, 7, 10),
(3679, 208, 14, 23, 23),
(3680, 208, 14, 26, 13),
(3681, 208, 15, 4, 20),
(3682, 208, 15, 7, 15),
(3683, 208, 15, 23, 24),
(3684, 208, 15, 26, 25),
(3685, 208, 16, 4, 14),
(3686, 208, 16, 7, 25),
(3687, 208, 16, 23, 15),
(3688, 208, 16, 26, 20),
(3689, 208, 17, 4, 14),
(3690, 208, 17, 7, 20),
(3691, 208, 17, 23, 21),
(3692, 208, 17, 26, 15),
(3693, 208, 18, 4, 29),
(3694, 208, 18, 7, 15),
(3695, 208, 18, 23, 27),
(3696, 208, 18, 26, 29),
(3697, 209, 15, 9, 21),
(3698, 209, 15, 24, 25),
(3699, 209, 16, 9, 12),
(3700, 209, 16, 24, 17),
(3701, 209, 17, 9, 11),
(3702, 209, 17, 24, 18),
(3703, 209, 18, 9, 24),
(3704, 209, 18, 24, 20),
(3705, 209, 19, 9, 20),
(3706, 209, 19, 24, 25),
(3707, 209, 20, 9, 22),
(3708, 209, 20, 24, 17),
(3709, 209, 21, 9, 20),
(3710, 209, 21, 24, 17),
(3711, 209, 22, 9, 23),
(3712, 209, 22, 24, 20),
(3713, 209, 23, 9, 14),
(3714, 209, 23, 24, 11),
(3715, 209, 24, 9, 19),
(3716, 209, 24, 24, 29),
(3717, 210, 1, 2, 20),
(3718, 210, 1, 4, 28),
(3719, 210, 1, 6, 16),
(3720, 210, 1, 16, 25),
(3721, 210, 1, 23, 16),
(3722, 210, 2, 2, 28),
(3723, 210, 2, 4, 20),
(3724, 210, 2, 6, 19),
(3725, 210, 2, 16, 14),
(3726, 210, 2, 23, 25),
(3727, 210, 3, 2, 22),
(3728, 210, 3, 4, 27),
(3729, 210, 3, 6, 10),
(3730, 210, 3, 16, 19),
(3731, 210, 3, 23, 27),
(3732, 210, 4, 2, 24),
(3733, 210, 4, 4, 22),
(3734, 210, 4, 6, 27),
(3735, 210, 4, 16, 17),
(3736, 210, 4, 23, 12),
(3737, 210, 5, 2, 16),
(3738, 210, 5, 4, 24),
(3739, 210, 5, 6, 11),
(3740, 210, 5, 16, 12),
(3741, 210, 5, 23, 22),
(3742, 210, 6, 2, 29),
(3743, 210, 6, 4, 16),
(3744, 210, 6, 6, 13),
(3745, 210, 6, 16, 11),
(3746, 210, 6, 23, 16),
(3747, 210, 7, 2, 12),
(3748, 210, 7, 4, 30),
(3749, 210, 7, 6, 23),
(3750, 210, 7, 16, 25),
(3751, 210, 7, 23, 29),
(3752, 210, 8, 2, 21),
(3753, 210, 8, 4, 20),
(3754, 210, 8, 6, 16),
(3755, 210, 8, 16, 27),
(3756, 210, 8, 23, 20),
(3757, 210, 9, 2, 21),
(3758, 210, 9, 4, 20),
(3759, 210, 9, 6, 23),
(3760, 210, 9, 16, 20),
(3761, 210, 9, 23, 27),
(3762, 210, 10, 2, 11),
(3763, 210, 10, 4, 10),
(3764, 210, 10, 6, 30),
(3765, 210, 10, 16, 14),
(3766, 210, 10, 23, 28),
(3767, 211, 1, 10, 21),
(3768, 211, 2, 10, 13),
(3769, 211, 3, 10, 25),
(3770, 211, 4, 10, 13),
(3771, 211, 5, 10, 24),
(3772, 211, 6, 10, 26),
(3773, 211, 7, 10, 25),
(3774, 211, 8, 10, 23),
(3775, 211, 9, 10, 20),
(3776, 211, 10, 10, 16),
(3777, 212, 1, 18, 16),
(3778, 212, 1, 19, 16),
(3779, 212, 1, 23, 11),
(3780, 212, 1, 26, 23),
(3781, 212, 2, 18, 25),
(3782, 212, 2, 19, 18),
(3783, 212, 2, 23, 19),
(3784, 212, 2, 26, 24),
(3785, 212, 3, 18, 20),
(3786, 212, 3, 19, 29),
(3787, 212, 3, 23, 25),
(3788, 212, 3, 26, 22),
(3789, 212, 4, 18, 21),
(3790, 212, 4, 19, 11),
(3791, 212, 4, 23, 17),
(3792, 212, 4, 26, 19),
(3793, 212, 5, 18, 12),
(3794, 212, 5, 19, 20),
(3795, 212, 5, 23, 18),
(3796, 212, 5, 26, 28),
(3797, 212, 6, 18, 23),
(3798, 212, 6, 19, 19),
(3799, 212, 6, 23, 21),
(3800, 212, 6, 26, 10),
(3801, 212, 7, 18, 25),
(3802, 212, 7, 19, 23),
(3803, 212, 7, 23, 18),
(3804, 212, 7, 26, 17),
(3805, 212, 8, 18, 23),
(3806, 212, 8, 19, 14),
(3807, 212, 8, 23, 13),
(3808, 212, 8, 26, 30),
(3809, 212, 9, 18, 13),
(3810, 212, 9, 19, 27),
(3811, 212, 9, 23, 13),
(3812, 212, 9, 26, 26),
(3813, 212, 10, 18, 11),
(3814, 212, 10, 19, 16),
(3815, 212, 10, 23, 14),
(3816, 212, 10, 26, 17),
(3817, 213, 1, 13, 15),
(3818, 213, 1, 17, 10),
(3819, 213, 1, 24, 24),
(3820, 213, 2, 13, 18),
(3821, 213, 2, 17, 15),
(3822, 213, 2, 24, 29),
(3823, 213, 3, 13, 28),
(3824, 213, 3, 17, 18),
(3825, 213, 3, 24, 16),
(3826, 213, 4, 13, 10),
(3827, 213, 4, 17, 23),
(3828, 213, 4, 24, 28),
(3829, 213, 5, 13, 25),
(3830, 213, 5, 17, 14),
(3831, 213, 5, 24, 24),
(3832, 213, 6, 13, 15),
(3833, 213, 6, 17, 20),
(3834, 213, 6, 24, 13),
(3835, 213, 7, 13, 13),
(3836, 213, 7, 17, 12),
(3837, 213, 7, 24, 11),
(3838, 213, 8, 13, 21),
(3839, 213, 8, 17, 16),
(3840, 213, 8, 24, 18),
(3841, 213, 9, 13, 20),
(3842, 213, 9, 17, 20),
(3843, 213, 9, 24, 30),
(3844, 213, 10, 13, 16),
(3845, 213, 10, 17, 11),
(3846, 213, 10, 24, 13),
(4100, 214, 12, 13, 2);

-- --------------------------------------------------------

--
-- Structure de la table `REGION`
--

CREATE TABLE `REGION` (
  `IDREGION` int NOT NULL,
  `NOMREGION` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `REGION`
--

INSERT INTO `REGION` (`IDREGION`, `NOMREGION`) VALUES
(1, 'Auvergne-Rhône-Alpes'),
(2, 'Bourgogne-Franche-Comté'),
(7, 'Bretagne'),
(8, 'Centre-Val de Loire'),
(9, 'Corse'),
(10, 'Grand Est'),
(11, 'Hauts-de-France'),
(12, 'Île-de-France'),
(13, 'Normandie'),
(14, 'Nouvelle-Aquitaine'),
(15, 'Occitanie'),
(16, 'Pays de la Loire'),
(17, 'Provence-Alpes-Côte d\'Azur'),
(18, 'Guadeloupe'),
(19, 'Martinique'),
(20, 'Guyane'),
(21, 'La Réunion'),
(22, 'Mayotte');

-- --------------------------------------------------------

--
-- Structure de la table `ROLE`
--

CREATE TABLE `ROLE` (
  `IDROLE` int NOT NULL,
  `NOMROLE` varchar(20) DEFAULT NULL,
  `DESCROLE` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `ROLE`
--

INSERT INTO `ROLE` (`IDROLE`, `NOMROLE`, `DESCROLE`) VALUES
(1, 'Admin', 'L\'utilisateur possedant se role a acces au dashboard admin il peut donc gerer le CRUD des produits.'),
(2, 'Client', 'L\'utilisateur possedant se role peut visiter le site, mettre dans un panier les articles de son choix et payer le panier.');

-- --------------------------------------------------------

--
-- Structure de la table `STATUTCOMMANDE`
--

CREATE TABLE `STATUTCOMMANDE` (
  `IDSTATUT` int NOT NULL,
  `NOMSTATUT` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `DESCSTATUT` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `STATUTCOMMANDE`
--

INSERT INTO `STATUTCOMMANDE` (`IDSTATUT`, `NOMSTATUT`, `DESCSTATUT`) VALUES
(1, 'En attente', 'La commande a été enregistrée mais n’a pas encore été traitée.'),
(2, 'En cours de traitement', 'La commande est actuellement en cours de préparation.'),
(3, 'Expédiée', 'La commande a été expédiée et est en route vers le client.'),
(4, 'Livrée', 'La commande a été livrée au client.'),
(5, 'Annulée', 'La commande a été annulée par le client ou le vendeur.'),
(6, 'Remboursée', 'La commande a été annulée et le remboursement a été effectué.'),
(7, 'Retournée', 'Le client a retourné la commande, en attente de traitement.'),
(8, 'En attente de paiement', 'La commande est en attente de réception du paiement.'),
(9, 'Échec de paiement', 'Le paiement de la commande a échoué, elle est suspendue.'),
(10, 'Préparée', 'La commande a été préparée et est prête à être expédiée.');

-- --------------------------------------------------------

--
-- Structure de la table `TAILLE`
--

CREATE TABLE `TAILLE` (
  `IDTAILLE` int NOT NULL,
  `TAILLE` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `TAILLE`
--

INSERT INTO `TAILLE` (`IDTAILLE`, `TAILLE`) VALUES
(1, '25'),
(2, '26'),
(3, '27'),
(4, '28'),
(5, '29'),
(6, '30'),
(7, '31'),
(8, '32'),
(9, '33'),
(10, '34'),
(11, '35'),
(12, '36'),
(13, '37'),
(14, '38'),
(15, '39'),
(16, '40'),
(17, '41'),
(18, '42'),
(19, '43'),
(20, '44'),
(21, '45'),
(22, '46'),
(23, '47'),
(24, '48');

-- --------------------------------------------------------

--
-- Structure de la table `UTILISATEUR`
--

CREATE TABLE `UTILISATEUR` (
  `IDUTILISATEUR` int NOT NULL,
  `IDROLE` int NOT NULL,
  `NOM` varchar(128) DEFAULT NULL,
  `PRENOM` varchar(128) DEFAULT NULL,
  `EMAIL` varchar(128) DEFAULT NULL,
  `PASSWORD` varchar(128) DEFAULT NULL,
  `TELEPHONE` char(10) DEFAULT NULL,
  `DATENAISSANCE` date DEFAULT NULL,
  `DATEINSCRIPTION` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `UTILISATEUR`
--

INSERT INTO `UTILISATEUR` (`IDUTILISATEUR`, `IDROLE`, `NOM`, `PRENOM`, `EMAIL`, `PASSWORD`, `TELEPHONE`, `DATENAISSANCE`, `DATEINSCRIPTION`) VALUES
(1, 2, 'Dupont', 'Jean', 'jean.dupont@gmail.com', 'hashed_password_1', '0612345678', '1990-02-14', '2024-11-25'),
(2, 2, 'Martin', 'Sophie', 'sophie.martin@hotmail.com', 'hashed_password_2', '0654321098', '1985-07-22', '2024-11-27'),
(3, 2, 'Lemoine', 'Pierre', 'pierre.lemoine@yahoo.com', 'hashed_password_3', '0645123654', '1992-10-05', '2024-11-30'),
(4, 2, 'Durand', 'Marc', 'marc.durand@gmail.com', 'hashed_password_4', '0678123456', '1998-11-18', '2024-11-22'),
(5, 2, 'Petit', 'Julie', 'julie.petit@hotmail.com', 'hashed_password_5', '0698765432', '1988-03-12', '2024-11-20'),
(6, 2, 'Nguyen', 'Thi', 'thi.nguyen@gmail.com', 'hashed_password_6', '0634567890', '1995-06-30', '2024-11-23'),
(7, 2, 'Bernard', 'Lucie', 'lucie.bernard@hotmail.com', 'hashed_password_7', '0611223344', '1993-01-11', '2024-11-28'),
(8, 2, 'Lemoine', 'Claire', 'claire.lemoine@gmail.com', 'hashed_password_8', '0687654321', '1994-05-17', '2024-11-21'),
(9, 2, 'Sanchez', 'Ana', 'ana.sanchez@gmail.com', 'hashed_password_9', '0687654321', '1991-09-18', '2024-11-19'),
(10, 2, 'Roche', 'Valérie', 'valerie.roche@hotmail.com', 'hashed_password_10', '0656789123', '1982-12-15', '2024-11-18'),
(11, 2, 'Tanguy', 'Louis', 'louis.tanguy@gmail.com', 'hashed_password_11', '0611223345', '1997-02-05', '2024-11-18'),
(12, 2, 'Chevalier', 'Isabelle', 'isabelle.chevalier@hotmail.com', 'hashed_password_12', '0634567891', '1989-12-18', '2024-11-19'),
(13, 2, 'Fournier', 'Antoine', 'antoine.fournier@yahoo.com', 'hashed_password_13', '0687654322', '1994-01-02', '2024-11-20'),
(14, 2, 'Rousseau', 'Benoît', 'benoit.rousseau@gmail.com', 'hashed_password_14', '0654321090', '1996-03-10', '2024-11-21'),
(15, 2, 'Gauthier', 'Chloé', 'chloe.gauthier@hotmail.com', 'hashed_password_15', '0678234567', '1991-09-27', '2024-11-22'),
(16, 2, 'Dupuis', 'Thierry', 'thierry.dupuis@gmail.com', 'hashed_password_16', '0622345678', '1984-04-14', '2024-11-23'),
(17, 2, 'Boucher', 'Emilie', 'emilie.boucher@gmail.com', 'hashed_password_17', '0636547890', '1999-06-19', '2024-11-24'),
(18, 2, 'Pires', 'Luis', 'luis.pires@hotmail.com', 'hashed_password_18', '0667881234', '1993-07-11', '2024-11-25'),
(19, 2, 'Lemoine', 'Julien', 'julien.lemoine@gmail.com', 'hashed_password_19', '0645236789', '1987-02-23', '2024-11-26'),
(20, 2, 'Girard', 'Sophie', 'sophie.girard@hotmail.com', 'hashed_password_20', '0612345679', '1995-11-30', '2024-11-27'),
(21, 2, 'Beaufort', 'Elise', 'elise.beaufort@gmail.com', 'hashed_password_21', '0678543210', '1989-01-06', '2024-11-28'),
(22, 2, 'Lemoine', 'Maxime', 'maxime.lemoine@yahoo.com', 'hashed_password_22', '0687654323', '1997-10-14', '2024-11-29'),
(23, 2, 'Leclerc', 'Cécile', 'cecile.leclerc@hotmail.com', 'hashed_password_23', '0654781234', '1993-05-17', '2024-11-30'),
(24, 2, 'Roux', 'Mathieu', 'mathieu.roux@gmail.com', 'hashed_password_24', '0623456789', '1998-11-22', '2024-12-01'),
(25, 2, 'Lemoine', 'Sébastien', 'sebastien.lemoine@hotmail.com', 'hashed_password_25', '0634567892', '1986-08-03', '2024-12-02'),
(26, 2, 'Joly', 'Camille', 'camille.joly@gmail.com', 'hashed_password_26', '0611234567', '1994-02-12', '2024-12-03'),
(27, 2, 'Leblanc', 'Clément', 'clement.leblanc@hotmail.com', 'hashed_password_27', '0656789123', '1992-09-06', '2024-12-04'),
(28, 2, 'Lemoine', 'Nicolas', 'nicolas.lemoine@gmail.com', 'hashed_password_28', '0687654324', '1988-01-15', '2024-12-05'),
(29, 2, 'Ziegler', 'Ingrid', 'ingrid.ziegler@yahoo.com', 'hashed_password_29', '0623456780', '1996-07-29', '2024-12-06'),
(30, 2, 'Henri', 'Raphaël', 'raphael.henri@hotmail.com', 'hashed_password_30', '0612345671', '1990-05-19', '2024-12-07'),
(31, 2, 'Marchand', 'Pauline', 'pauline.marchand@gmail.com', 'hashed_password_31', '0611122334', '1992-03-15', '2024-11-28'),
(32, 2, 'Delacroix', 'Léon', 'leon.delacroix@hotmail.com', 'hashed_password_32', '0654321098', '1985-06-22', '2024-11-29'),
(33, 2, 'Blanc', 'Emma', 'emma.blanc@gmail.com', 'hashed_password_33', '0687654325', '1997-11-12', '2024-11-30'),
(34, 2, 'Dufresne', 'Michel', 'michel.dufresne@yahoo.com', 'hashed_password_34', '0623456789', '1994-05-23', '2024-12-01'),
(35, 2, 'Langlois', 'Amandine', 'amandine.langlois@hotmail.com', 'hashed_password_35', '0645123456', '1989-08-17', '2024-12-02'),
(36, 2, 'Dupont', 'Laurent', 'laurent.dupont@gmail.com', 'hashed_password_36', '0678234567', '1993-10-09', '2024-12-03'),
(37, 2, 'Rivet', 'Alice', 'alice.rivet@hotmail.com', 'hashed_password_37', '0687654326', '1988-07-04', '2024-12-04'),
(38, 2, 'Vidal', 'Xavier', 'xavier.vidal@gmail.com', 'hashed_password_38', '0623456790', '1996-02-28', '2024-12-05'),
(39, 2, 'Richard', 'Sophie', 'sophie.richard@yahoo.com', 'hashed_password_39', '0654320987', '1991-12-17', '2024-12-06'),
(40, 2, 'Giraud', 'Benjamin', 'benjamin.giraud@hotmail.com', 'hashed_password_40', '0687654327', '1990-01-20', '2024-12-07'),
(41, 2, 'Thomas', 'Florence', 'florence.thomas@gmail.com', 'hashed_password_41', '0612345670', '1997-09-11', '2024-12-08'),
(42, 2, 'Lemoine', 'Benoît', 'benoit.lemoine@hotmail.com', 'hashed_password_42', '0656789012', '1983-04-13', '2024-12-09'),
(43, 2, 'Vallet', 'Clara', 'clara.vallet@gmail.com', 'hashed_password_43', '0678234568', '1995-07-24', '2024-12-10'),
(44, 2, 'Garnier', 'Nathalie', 'nathalie.garnier@yahoo.com', 'hashed_password_44', '0687654328', '1992-10-30', '2024-12-11'),
(45, 2, 'Fuchs', 'Marc', 'marc.fuchs@hotmail.com', 'hashed_password_45', '0612345673', '1987-12-06', '2024-12-12'),
(46, 2, 'Simon', 'Charlotte', 'charlotte.simon@gmail.com', 'hashed_password_46', '0654321099', '1999-04-02', '2024-12-13'),
(47, 2, 'Tanguy', 'Pierre', 'pierre.tanguy@yahoo.com', 'hashed_password_47', '0623456781', '1990-06-25', '2024-12-14'),
(48, 2, 'Lemoine', 'Hélène', 'helene.lemoine@hotmail.com', 'hashed_password_48', '0678234569', '1988-08-15', '2024-12-15'),
(49, 2, 'Faure', 'Julien', 'julien.faure@gmail.com', 'hashed_password_49', '0656789013', '1995-01-07', '2024-12-16'),
(50, 2, 'Pires', 'Audrey', 'audrey.pires@hotmail.com', 'hashed_password_50', '0612345672', '1993-03-17', '2024-12-17'),
(66, 1, 'Gaches', 'Luca', 'luca@admin.com', '$argon2id$v=19$m=65536,t=4,p=1$Tkk2NldCZzlOeDVKclJ1SQ$hAWMfNxb5WVc5fYclQnjLaXPic9HKOii0RII11Yuu/U', '0101010101', '2000-01-01', '2024-12-02'),
(67, 1, 'Bouyssou', 'Melvin', 'melvin@admin.ouee', '$argon2id$v=19$m=65536,t=4,p=1$Ukh0YmhSSnRueng3T21idA$OwrI6Cz5uMGUoedj/NANClKFZmogX0lt8caGet4wFO4', '0666000000', '2000-01-01', '2024-12-02'),
(71, 2, 'dark', 'sasuke', 'sasuke@gmail.com', '$argon2id$v=19$m=65536,t=4,p=1$dHBsdm5KYm9jb2YydUY5Tg$QAimsakXvQhHph/QMgn8HIJwovPvRF14cg/Fq/wtzLM', '0698988098', '2000-01-01', '2024-12-02'),
(72, 2, 'Melvin', 'CompteClient', 'melvin@client.fr', '$argon2id$v=19$m=65536,t=4,p=1$d2d1MmpPYlhBcjZMUjdvVg$JxOxe84F5erecR7lIyQ7qpSm9fapvSEnFsCaI6a/95I', '0999999999', '1850-01-01', '2024-12-02'),
(73, 1, 'Gourgues', 'Robin', 'admin4@gmail.com', '$argon2id$v=19$m=65536,t=4,p=1$SExXQUpXSE14LzNTR0NhTA$+LJ5UE6d/dD/h8fenbujCYqNYdk0lfa1vjmaZxc1lwA', '0692057257', '2000-01-01', '2024-12-03'),
(74, 1, 'Ho', 'Nicolas', 'nicolas.ho@gmail.com', '$argon2id$v=19$m=65536,t=4,p=1$bEp2c3Y0VnA3MWRXU2NEeQ$Rq/PVJcLNAV7cClv+exC5H5ukOrmGfqiCn+u/578Rgs', '0688888888', '2000-01-01', '2024-12-04'),
(76, 2, 'DuBois', 'Oliver', 'dubois@gmail.com', '$argon2id$v=19$m=65536,t=4,p=1$R3dqY3JpcUwwOEFaMW1qLw$RuX/p6hfD3GdXoiRAycW0Vz+WylDgA+YR634hyH2puI', '0698390985', '2000-01-01', '2024-12-06'),
(81, 2, 'gourges', 'robine', 'gourges.robine@gmail.com', '$argon2id$v=19$m=65536,t=4,p=1$RnFqNkdJN2ZjeXlBVEdZZA$bV7aemabDtCsqFVOnIG8UMolHu2vsi2AlfIqp4MT3KQ', '0601020304', '2000-01-07', '2024-12-13'),
(83, 2, 'Procedure', 'creeCompte', 'procedure@gmail.com', '$argon2id$v=19$m=65536,t=4,p=1$bGVTb2ZMOXJYWU5JN1p6Tg$ESuGjxH24jMke17oJ5VSzauUQgrNoaVThvPeHwzu3dY', '0693859082', '2000-01-01', '2024-12-13'),
(88, 2, 'Lef&egrave;vre', 'Guillaume', 'lefevre.antoine@gmail.com', '$argon2id$v=19$m=65536,t=4,p=1$M3RVajFDRUxFMWNTYlN2ZA$CskGVyS3zvCEW3/Ga7YB3VDH0o2pX0u7k+f0v7oz84I', '0690939525', '1998-04-02', '2024-12-20');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `ADRESSE`
--
ALTER TABLE `ADRESSE`
  ADD PRIMARY KEY (`IDADRESSE`),
  ADD KEY `IDUTILISATEUR` (`IDUTILISATEUR`),
  ADD KEY `IDREGION` (`IDREGION`);

--
-- Index pour la table `CATEGORIE`
--
ALTER TABLE `CATEGORIE`
  ADD PRIMARY KEY (`IDCATEGORIE`);

--
-- Index pour la table `COMMANDE`
--
ALTER TABLE `COMMANDE`
  ADD PRIMARY KEY (`IDCOMMANDE`),
  ADD KEY `IDADRLIVRAISON` (`IDADRLIVRAISON`),
  ADD KEY `IDADRFACTURATION` (`IDADRFACTURATION`),
  ADD KEY `IDUTILISATEUR` (`IDUTILISATEUR`),
  ADD KEY `IDSTATUT` (`IDSTATUT`),
  ADD KEY `IDMODEPAIEMENT` (`IDMODEPAIEMENT`);

--
-- Index pour la table `COMMENTAIRE`
--
ALTER TABLE `COMMENTAIRE`
  ADD PRIMARY KEY (`IDCOMMENTAIRE`);

--
-- Index pour la table `COULEUR`
--
ALTER TABLE `COULEUR`
  ADD PRIMARY KEY (`IDCOULEUR`);

--
-- Index pour la table `IMAGE`
--
ALTER TABLE `IMAGE`
  ADD PRIMARY KEY (`IDIMAGE`);

--
-- Index pour la table `MARQUE`
--
ALTER TABLE `MARQUE`
  ADD PRIMARY KEY (`IDMARQUE`);

--
-- Index pour la table `MODEPAIEMENT`
--
ALTER TABLE `MODEPAIEMENT`
  ADD PRIMARY KEY (`IDMODEPAIEMENT`);

--
-- Index pour la table `PANIER`
--
ALTER TABLE `PANIER`
  ADD PRIMARY KEY (`IDPANIER`),
  ADD KEY `fk_commande` (`IDCOMMANDE`);

--
-- Index pour la table `PRODUIT`
--
ALTER TABLE `PRODUIT`
  ADD PRIMARY KEY (`IDPRODUIT`);

--
-- Index pour la table `PRODUITPANIER`
--
ALTER TABLE `PRODUITPANIER`
  ADD PRIMARY KEY (`IDPRODUITPANIER`),
  ADD KEY `FK_PRODUITPANIER_PRODUITATTR` (`IDPRODUIT_ATTR`);

--
-- Index pour la table `PRODUIT_ATTR`
--
ALTER TABLE `PRODUIT_ATTR`
  ADD PRIMARY KEY (`IDPRODUIT_ATTR`),
  ADD KEY `IDPRODUIT` (`IDPRODUIT`),
  ADD KEY `IDTAILLE` (`IDTAILLE`),
  ADD KEY `IDCOULEUR` (`IDCOULEUR`);

--
-- Index pour la table `REGION`
--
ALTER TABLE `REGION`
  ADD PRIMARY KEY (`IDREGION`);

--
-- Index pour la table `ROLE`
--
ALTER TABLE `ROLE`
  ADD PRIMARY KEY (`IDROLE`);

--
-- Index pour la table `STATUTCOMMANDE`
--
ALTER TABLE `STATUTCOMMANDE`
  ADD PRIMARY KEY (`IDSTATUT`);

--
-- Index pour la table `TAILLE`
--
ALTER TABLE `TAILLE`
  ADD PRIMARY KEY (`IDTAILLE`);

--
-- Index pour la table `UTILISATEUR`
--
ALTER TABLE `UTILISATEUR`
  ADD PRIMARY KEY (`IDUTILISATEUR`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `ADRESSE`
--
ALTER TABLE `ADRESSE`
  MODIFY `IDADRESSE` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT pour la table `CATEGORIE`
--
ALTER TABLE `CATEGORIE`
  MODIFY `IDCATEGORIE` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `COMMANDE`
--
ALTER TABLE `COMMANDE`
  MODIFY `IDCOMMANDE` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT pour la table `COMMENTAIRE`
--
ALTER TABLE `COMMENTAIRE`
  MODIFY `IDCOMMENTAIRE` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=215;

--
-- AUTO_INCREMENT pour la table `COULEUR`
--
ALTER TABLE `COULEUR`
  MODIFY `IDCOULEUR` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT pour la table `IMAGE`
--
ALTER TABLE `IMAGE`
  MODIFY `IDIMAGE` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT pour la table `MARQUE`
--
ALTER TABLE `MARQUE`
  MODIFY `IDMARQUE` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `MODEPAIEMENT`
--
ALTER TABLE `MODEPAIEMENT`
  MODIFY `IDMODEPAIEMENT` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `PANIER`
--
ALTER TABLE `PANIER`
  MODIFY `IDPANIER` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT pour la table `PRODUIT`
--
ALTER TABLE `PRODUIT`
  MODIFY `IDPRODUIT` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1023;

--
-- AUTO_INCREMENT pour la table `PRODUITPANIER`
--
ALTER TABLE `PRODUITPANIER`
  MODIFY `IDPRODUITPANIER` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT pour la table `PRODUIT_ATTR`
--
ALTER TABLE `PRODUIT_ATTR`
  MODIFY `IDPRODUIT_ATTR` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4101;

--
-- AUTO_INCREMENT pour la table `REGION`
--
ALTER TABLE `REGION`
  MODIFY `IDREGION` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT pour la table `ROLE`
--
ALTER TABLE `ROLE`
  MODIFY `IDROLE` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `STATUTCOMMANDE`
--
ALTER TABLE `STATUTCOMMANDE`
  MODIFY `IDSTATUT` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `TAILLE`
--
ALTER TABLE `TAILLE`
  MODIFY `IDTAILLE` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT pour la table `UTILISATEUR`
--
ALTER TABLE `UTILISATEUR`
  MODIFY `IDUTILISATEUR` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `ADRESSE`
--
ALTER TABLE `ADRESSE`
  ADD CONSTRAINT `ADRESSE_ibfk_1` FOREIGN KEY (`IDUTILISATEUR`) REFERENCES `UTILISATEUR` (`IDUTILISATEUR`),
  ADD CONSTRAINT `ADRESSE_ibfk_2` FOREIGN KEY (`IDREGION`) REFERENCES `REGION` (`IDREGION`);

--
-- Contraintes pour la table `COMMANDE`
--
ALTER TABLE `COMMANDE`
  ADD CONSTRAINT `COMMANDE_ibfk_1` FOREIGN KEY (`IDADRLIVRAISON`) REFERENCES `ADRESSE` (`IDADRESSE`),
  ADD CONSTRAINT `COMMANDE_ibfk_2` FOREIGN KEY (`IDADRFACTURATION`) REFERENCES `ADRESSE` (`IDADRESSE`),
  ADD CONSTRAINT `COMMANDE_ibfk_3` FOREIGN KEY (`IDUTILISATEUR`) REFERENCES `UTILISATEUR` (`IDUTILISATEUR`),
  ADD CONSTRAINT `COMMANDE_ibfk_4` FOREIGN KEY (`IDSTATUT`) REFERENCES `STATUTCOMMANDE` (`IDSTATUT`),
  ADD CONSTRAINT `COMMANDE_ibfk_5` FOREIGN KEY (`IDMODEPAIEMENT`) REFERENCES `MODEPAIEMENT` (`IDMODEPAIEMENT`);

--
-- Contraintes pour la table `PANIER`
--
ALTER TABLE `PANIER`
  ADD CONSTRAINT `fk_commande` FOREIGN KEY (`IDCOMMANDE`) REFERENCES `COMMANDE` (`IDCOMMANDE`);

--
-- Contraintes pour la table `PRODUITPANIER`
--
ALTER TABLE `PRODUITPANIER`
  ADD CONSTRAINT `FK_PRODUITPANIER_PRODUITATTR` FOREIGN KEY (`IDPRODUIT_ATTR`) REFERENCES `PRODUIT_ATTR` (`IDPRODUIT_ATTR`);

--
-- Contraintes pour la table `PRODUIT_ATTR`
--
ALTER TABLE `PRODUIT_ATTR`
  ADD CONSTRAINT `PRODUIT_ATTR_ibfk_1` FOREIGN KEY (`IDPRODUIT`) REFERENCES `PRODUIT` (`IDPRODUIT`),
  ADD CONSTRAINT `PRODUIT_ATTR_ibfk_2` FOREIGN KEY (`IDTAILLE`) REFERENCES `TAILLE` (`IDTAILLE`),
  ADD CONSTRAINT `PRODUIT_ATTR_ibfk_3` FOREIGN KEY (`IDCOULEUR`) REFERENCES `COULEUR` (`IDCOULEUR`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
