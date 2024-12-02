-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : mar. 26 nov. 2024 à 11:40
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

-- --------------------------------------------------------

--
-- Structure de la table `ADRESSELIVRAISON`
--

CREATE TABLE `ADRESSELIVRAISON` (
  `IDADR` int NOT NULL,
  `ADRESSE` varchar(128) DEFAULT NULL,
  `CODEPOSTAL` char(5) DEFAULT NULL,
  `VILLE` varchar(128) DEFAULT NULL,
  `PAYS` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `CATEGORIE`
--

CREATE TABLE `CATEGORIE` (
  `IDCATEGORIE` int NOT NULL,
  `IDCATEGORIE_ASSO_4` int DEFAULT NULL,
  `NOMCATEGORIE` varchar(20) DEFAULT NULL,
  `DESCCAT` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `COMMANDE`
--

CREATE TABLE `COMMANDE` (
  `IDCOMMANDE` int NOT NULL,
  `IDADR` int NOT NULL,
  `IDUTILISATEUR` int NOT NULL,
  `IDSTATUT` int NOT NULL,
  `IDMODEPAIEMENT` int NOT NULL,
  `DATECOMMANDE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

-- --------------------------------------------------------

--
-- Structure de la table `IMAGE`
--

CREATE TABLE `IMAGE` (
  `IDIMAGE` int NOT NULL,
  `IDPRODUIT` int NOT NULL,
  `URL` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `MARQUE`
--

CREATE TABLE `MARQUE` (
  `IDMARQUE` int NOT NULL,
  `NOMMARQUE` varchar(20) DEFAULT NULL,
  `DESCMARQUE` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `MODEPAIEMENT`
--

CREATE TABLE `MODEPAIEMENT` (
  `IDMODEPAIEMENT` int NOT NULL,
  `NOMPAIEMENT` varchar(20) DEFAULT NULL,
  `DESCPAIEMENT` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `MOYENPAIEMENT`
--

CREATE TABLE `MOYENPAIEMENT` (
  `IDMODEPAIEMENT` int NOT NULL,
  `IDUTILISATEUR` int NOT NULL,
  `IDMOYENPAIEMENT` int DEFAULT NULL,
  `NUMCARTE` char(16) DEFAULT NULL,
  `DATEEXP` date DEFAULT NULL,
  `NOMCARTE` varchar(128) DEFAULT NULL,
  `CRYPTOGRAMME` char(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `PANIER`
--

CREATE TABLE `PANIER` (
  `IDPANIER` int NOT NULL,
  `IDUTILISATEUR` int NOT NULL,
  `DATECREA` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `COULEUR` varchar(40) DEFAULT NULL,
  `TAILLE` varchar(10) DEFAULT NULL,
  `POIDS` decimal(10,2) DEFAULT NULL,
  `GENRE` char(1) DEFAULT NULL,
  `QTESTOCK` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `PRODUIT`
--

INSERT INTO `PRODUIT` (`IDPRODUIT`, `IDCATEGORIE`, `IDMARQUE`, `NOMPRODUIT`, `DESCPRODUIT`, `PRIX`, `ASPECTTECHNIQUE`, `COMPOSITION`, `COULEUR`, `TAILLE`, `POIDS`, `GENRE`, `QTESTOCK`) VALUES
(97, 1, 1, 'Sneakers Retro Classiques', 'Sneakers de style rétro avec semelle renforcée', '79.99', 'Technologie d’amorti AirCell', 'Tige en cuir synthétique, semelle en caoutchouc', 'Blanc', '42', '0.90', 'M', 20),
(98, 1, 2, 'Chaussures de Running Pro', 'Chaussures de course ultra-légères pour performance optimale', '110.00', 'Semelle avec absorption des chocs', 'Textile respirant, caoutchouc', 'Noir', '44', '0.60', 'M', 30),
(99, 2, 3, 'Escarpins Vernis Élégance', 'Escarpins avec finition vernie pour une touche de glamour', '150.00', 'Semelle intérieure en cuir, talon de 7 cm', 'Cuir, vernis', 'Rouge', '38', '0.50', 'F', 15),
(100, 2, 4, 'Sandales en Cuir Premium', 'Sandales élégantes pour l\'été avec sangle ajustable', '60.00', 'Cuir pleine fleur, semelle souple', 'Cuir, caoutchouc', 'Marron', '39', '0.30', 'F', 50),
(101, 3, 1, 'Bottes en Daim Luxe', 'Bottes en daim avec doublure en fourrure synthétique', '220.00', 'Doublure chaude, semelle antidérapante', 'Daim, fourrure synthétique', 'Noir', '43', '1.20', 'M', 10),
(102, 3, 2, 'Chaussures de Randonnée', 'Chaussures robustes pour randonnée en montagne', '140.00', 'Imperméable, semelle Vibram', 'Cuir, synthétique', 'Vert', '44', '1.40', 'M', 18),
(103, 4, 1, 'Baskets Urban Chic', 'Baskets urbaines confortables pour la ville', '95.00', 'Semelle intermédiaire en mousse EVA', 'Tissu respirant, semelle en caoutchouc', 'Gris', '45', '0.80', 'M', 40),
(104, 4, 2, 'Chaussures de Ville Confort', 'Chaussures de ville classiques avec semelle en cuir', '120.00', 'Coussin d’air intégré pour plus de confort', 'Cuir pleine fleur, semelle en cuir', 'Noir', '40', '1.00', 'M', 25),
(105, 5, 1, 'Pack Été Femme', 'Pack de 3 paires de sandales en cuir pour l\'été', '200.00', 'Combinaison de sandales légères et élégantes', 'Cuir, caoutchouc', 'Multicolore', '37-39', '2.00', 'F', 10),
(106, 5, 2, 'Pack Sport Homme', 'Pack de 2 paires de baskets de running pour différentes surfaces', '180.00', 'Amorti renforcé pour trail et route', 'Textile, caoutchouc', 'Noir, Bleu', '42-44', '1.80', 'M', 8),
(107, 6, 3, 'Chaussures Lumineuses Enfants', 'Chaussures LED rechargeables pour enfants', '60.00', 'LED rechargeable USB', 'Synthétique, caoutchouc', 'Rose', '29', '0.50', 'E', 30),
(108, 6, 4, 'Collection Casual Enfant', 'Ensemble de 5 paires de chaussures décontractées pour enfants', '150.00', 'Semelles souples, design coloré', 'Tissu, caoutchouc', 'Multicolore', '28-35', '3.00', 'E', 5),
(109, 7, 2, 'Chaussures de Sécurité', 'Chaussures de sécurité pour le travail en milieu industriel', '95.00', 'Coque renforcée en acier', 'Cuir, acier, caoutchouc', 'Noir', '44', '1.80', 'M', 20),
(110, 7, 3, 'Pantoufles en Laine', 'Pantoufles en laine pour une chaleur maximale en hiver', '30.00', 'Doublure en laine naturelle', 'Laine, caoutchouc', 'Gris', '40', '0.30', 'U', 50),
(111, 7, 4, 'Sneakers High-Tech', 'Sneakers innovantes avec écran LED intégré', '250.00', 'Écran LED programmable', 'Synthétique, caoutchouc', 'Noir', '42', '0.90', 'M', 5),
(112, 2, 3, 'Mocassins Élégants', 'Mocassins en cuir pour hommes, design classique', '90.00', 'Semelle flexible', 'Cuir', 'Marron', '42', '0.90', 'M', 22),
(113, 2, 1, 'Ballerines Confort', 'Ballerines pour femmes, idéales pour un usage quotidien', '50.00', 'Semelle intérieure amortissante', 'Textile, cuir', 'Noir', '38', '0.40', 'F', 35),
(114, 7, 2, 'Chaussures de Sécurité', 'Chaussures de sécurité pour le travail en milieu industriel', '95.00', 'Coque renforcée en acier', 'Cuir, acier, caoutchouc', 'Noir', '44', '1.80', 'M', 20),
(115, 7, 3, 'Sneakers High-Tech', 'Sneakers innovantes avec écran LED intégré', '250.00', 'Écran LED programmable', 'Synthétique, caoutchouc', 'Noir', '42', '0.90', 'M', 5),
(116, 6, 4, 'Chaussures Enfant Lumineuses', 'Chaussures avec semelles LED lumineuses pour enfants', '60.00', 'Rechargeable par USB, léger', 'Synthétique, caoutchouc', 'Rose', '29', '0.50', 'E', 30),
(117, 7, 3, 'Pantoufles en Laine', 'Pantoufles en laine pour une chaleur maximale en hiver', '30.00', 'Doublure en laine naturelle', 'Laine, caoutchouc', 'Gris', '40', '0.30', 'U', 50),
(118, 2, 4, 'Derbies en Cuir Suédé', 'Chaussures élégantes pour hommes en cuir suédé', '110.00', 'Semelle extérieure en gomme', 'Cuir suédé', 'Bleu marine', '44', '0.80', 'M', 12),
(119, 1, 1, 'Baskets Vegan', 'Baskets écologiques fabriquées sans produits d’origine animale', '130.00', 'Matériaux recyclés, légères', 'Textile, caoutchouc', 'Vert', '43', '0.70', 'U', 18),
(120, 1, 2, 'Baskets Vegan et Vegie', 'Baskets écologiques V2', '130.00', 'Matériaux recyclés, légères', 'Textile, caoutchouc', 'Vert', '43', '0.70', 'U', 18),
(148, 7, 1, 'Chaussures de Basketball Pro', 'Chaussures de basketball avec semelle ultra-réactive', '120.00', 'Amorti amélioré, adhérence optimisée', 'Cuir, caoutchouc', 'Noir, Bleu', '42', '0.90', 'M', 15),
(149, 1, 2, 'Baskets Running Fast', 'Baskets ultra-légères pour la course', '85.00', 'Système d\'amorti flexible', 'Textile, caoutchouc', 'Blanc, Rouge', '43', '0.70', 'M', 20),
(150, 2, 3, 'Escarpins Satin Élégance', 'Escarpins avec finition satinée, idéal pour les soirées chic', '160.00', 'Semelle en cuir, talon de 9 cm', 'Cuir satiné', 'Noir, Beige', '38', '0.60', 'F', 25),
(151, 2, 4, 'Mules en Cuir Chic', 'Mules élégantes pour l\'été, confortables et stylées', '70.00', 'Cuir souple, semelle en liège', 'Cuir, liège', 'Beige', '37', '0.40', 'F', 40),
(152, 3, 1, 'Bottes Hiver Confort', 'Bottes en cuir avec doublure en laine pour l\'hiver', '180.00', 'Doublure en laine, semelle antidérapante', 'Cuir, laine', 'Noir', '42', '1.30', 'M', 12),
(153, 3, 2, 'Sandales Hawaï Confort', 'Sandales pour la plage, légères et respirantes', '25.00', 'Système de ventilation, semelle en caoutchouc', 'Caoutchouc, tissu', 'Jaune', '40', '0.30', 'U', 60),
(154, 4, 1, 'Chaussures de Ville Mode', 'Chaussures classiques mais modernes pour les sorties urbaines', '130.00', 'Coussin d\'air intégré', 'Cuir, textile', 'Noir', '41', '1.00', 'M', 18),
(155, 4, 2, 'Mocassins Homme Élégants', 'Mocassins en cuir pour un look raffiné', '110.00', 'Semelle en cuir flexible', 'Cuir, cuir', 'Marron', '43', '0.90', 'M', 14),
(156, 5, 1, 'Pack Sandales Été Femme', 'Pack de 4 paires de sandales élégantes pour l\'été', '220.00', 'Sandales légères et confortables', 'Cuir, caoutchouc', 'Blanc, Beige, Noir, Rose', '37-40', '2.30', 'F', 12),
(157, 5, 2, 'Pack Tennis Homme', 'Pack de 3 paires de tennis pour sport et loisirs', '210.00', 'Tennis avec soutien optimal pour le sport', 'Textile, caoutchouc', 'Bleu, Gris, Noir', '41-44', '2.00', 'M', 10),
(158, 6, 3, 'Pack Chaussures Enfant', 'Pack de 4 paires de chaussures pour enfants, confort et style', '180.00', 'Design coloré, semelles souples', 'Tissu, caoutchouc', 'Multicolore', '28-32', '2.50', 'E', 6),
(159, 4, 4, 'Pack École Homme', 'Pack de 2 paires de chaussures de ville pour hommes', '180.00', 'Cuir haut de gamme, semelle en gomme', 'Cuir, caoutchouc', 'Noir, Marron', '42-44', '2.00', 'M', 15),
(160, 7, 2, 'Baskets High-Tech', 'Baskets futuristes avec émetteur de signal', '250.00', 'Semelle haute performance', 'Synthétique, caoutchouc', 'Noir', '44', '1.00', 'M', 5),
(161, 7, 3, 'Chaussures de Course Extrême', 'Chaussures de course avec technologie de rebond', '130.00', 'Amorti haute performance', 'Textile, caoutchouc', 'Rouge', '45', '0.80', 'M', 30),
(162, 2, 1, 'Escarpins à Talon Haut', 'Escarpins classiques avec talon haut pour une silhouette élégante', '140.00', 'Talon de 10 cm', 'Cuir, satin', 'Rouge', '37', '0.60', 'F', 30),
(163, 7, 2, 'Chaussures de Sécurité Standard', 'Chaussures de sécurité pour le milieu de travail', '90.00', 'Semelle renforcée, protection acier', 'Cuir, métal', 'Noir', '42', '1.70', 'M', 25),
(164, 3, 1, 'Bottes Montantes Hiver', 'Bottes robustes avec doublure chaude pour l\'hiver', '200.00', 'Semelle antidérapante', 'Cuir, laine', 'Marron', '43', '1.50', 'M', 12),
(165, 1, 2, 'Tennis Fashion', 'Tennis tendances pour hommes et femmes', '100.00', 'Légères, flexibles, avec renforts', 'Textile, caoutchouc', 'Blanc', '42', '0.80', 'U', 35),
(166, 7, 3, 'Baskets Sportives Hautes', 'Baskets hautes avec tige renforcée pour le sport', '110.00', 'Technologie d\'amorti renforcé', 'Cuir, textile', 'Gris', '44', '1.00', 'M', 40),
(167, 2, 4, 'Escarpins Satin Chic', 'Escarpins satinés pour les soirées chic', '180.00', 'Talon de 8 cm', 'Satin, cuir', 'Bleu', '39', '0.50', 'F', 22),
(168, 8, 1, 'Chaussures de Randonnée Femme', 'Chaussures de randonnée avec semelle antidérapante', '130.00', 'Semelle en caoutchouc durable', 'Cuir, caoutchouc', 'Gris', '38', '1.20', 'F', 10),
(169, 8, 1, 'Baskets de Trail Homme', 'Baskets pour trail avec semelle haute traction', '140.00', 'Amorti anti-chocs, semelle Vibram', 'Textile, caoutchouc', 'Noir', '45', '1.10', 'M', 20),
(170, 7, 3, 'Baskets Ultra Confort', 'Baskets ultra confortables pour un usage quotidien', '90.00', 'Semelle à mémoire de forme', 'Textile, caoutchouc', 'Bleu', '40', '0.70', 'U', 45),
(171, 1, 1, 'Baskets Légères Femme', 'Baskets confortables pour la course et les loisirs', '75.00', 'Semelle légère, respirante', 'Textile, caoutchouc', 'Rose', '37', '0.60', 'F', 30),
(172, 4, 2, 'Chaussures Ville Classiques', 'Chaussures de ville pour un look élégant', '120.00', 'Semelle cuir, design minimaliste', 'Cuir, textile', 'Marron', '42', '0.90', 'M', 25),
(173, 3, 3, 'Boots Fashion Femme', 'Boots tendances pour l\'hiver et l\'automne', '150.00', 'Semelle épaisse, doublure chaude', 'Cuir, laine', 'Noir', '39', '1.20', 'F', 22),
(174, 3, 4, 'Bottes Haute Gamme', 'Bottes hautes pour une silhouette élégante', '200.00', 'Cuir premium talon haut', 'Cuir', 'Beige', '41', '1.30', 'F', 10),
(175, 4, 1, 'Casual Flex', 'Chaussures sportives légères pour hommes avec tige en Flyknit et semelle EVA pour un amorti optimal.', '79.99', 'EVA sole, EVA insole for shock absorption, breathable mesh upper', 'Flyknit, EVA, mesh', 'Noir, Rouge', '42', '0.80', 'M', 25),
(176, 4, 2, 'Elegant Step', 'Chaussures Oxford pour hommes, élégantes et idéales pour les occasions formelles.', '99.99', 'Cuir lisse, semelle en caoutchouc antidérapante', 'Cuir, caoutchouc', 'Noir', '43', '1.00', 'M', 20),
(177, 5, 1, 'Light Jogger', 'Chaussures de jogging légères pour hommes, avec semelle souple et bon amorti.', '139.99', 'Semelle souple avec amorti', 'Textile, caoutchouc', 'Gris, Bleu', '42', '0.90', 'M', 30),
(178, 5, 2, 'Classic Runner', 'Chaussures de sport Adidas légères avec semelle amortissante et tige en maille.', '89.99', 'Semelle amortissante, tige en maille respirante', 'Textile, caoutchouc', 'Noir, Blanc', '41', '0.80', 'M', 20),
(179, 9, 1, 'Urban Comfort', 'Chaussures urbaines pour hommes, légères et avec semelle antidérapante pour la ville.', '129.99', 'Semelle antidérapante pour une traction optimale', 'Cuir, caoutchouc', 'Noir', '43', '1.50', 'M', 20),
(180, 9, 2, 'Sport Elite', 'Chaussures de sport polyvalentes pour femmes, avec semelle flexible et bon amorti.', '79.99', 'Semelle flexible avec amorti', 'Cuir, caoutchouc', 'Gris', '38', '1.20', 'F', 15);
(202, 9, 1, 'Sandales Été Confort', 'Sandales ouvertes avec semelle confort', '45.00', 'Semelle souple, design élégant', 'Cuir, caoutchouc', 'Rose', '38', '0.40', 'F', 50),
(203, 9, 2, 'Tongs Été', 'Tongs pratiques et confortables pour l\'été', '20.00', 'Semelle antidérapante', 'Caoutchouc', 'Blanc', '39', '0.30', 'F', 70),
(204, 9, 3, 'Sandales Style Boho', 'Sandales ouvertes au style bohème', '55.00', 'Design tressé, semelle épaisse', 'Textile, caoutchouc', 'Beige', '40', '0.60', 'F', 25),
(205, 10, 1, 'Baskets Sport Enfant', 'Baskets légères pour les activités sportives des enfants', '50.00', 'Amorti léger, semelle antidérapante', 'Textile, caoutchouc', 'Multicolore', '30', '0.40', 'U', 50),
(206, 10, 3, 'Chaussures de Foot Junior', 'Chaussures de football pour enfants avec bonne traction', '45.00', 'Semelle souple, design sport', 'Cuir, caoutchouc', 'Bleu, Blanc', '32', '0.55', 'U', 30),
(207, 10, 2, 'Baskets Multisports', 'Baskets adaptées à tous types de sports pour enfants', '55.00', 'Semelle flexible, respirante', 'Textile, caoutchouc', 'Rouge', '33', '0.60', 'U', 40),
(208, 11, 1, 'Chaussures Scolaires Fille', 'Chaussures élégantes et confortables pour l\'école', '40.00', 'Semelle antidérapante, cuir doux', 'Cuir, textile', 'Noir', '30', '0.40', 'F', 50),
(209, 11, 2, 'Chaussures Scolaires Garçon', 'Chaussures classiques pour les journées scolaires', '45.00', 'Confort optimisé, semelle résistante', 'Cuir', 'Marron', '31', '0.45', 'M', 40),
(210, 11, 3, 'Chaussures d\'École Unisexes', 'Chaussures scolaires pour enfants', '35.00', 'Design simple, semelle souple', 'Textile', 'Gris', '32', '0.35', 'U', 60),
(211, 12, 1, 'Sandales Été Enfant', 'Sandales légères et confortables pour les journées d\'été', '30.00', 'Semelle respirante, réglable', 'Cuir, caoutchouc', 'Bleu', '30', '0.40', 'U', 40),
(212, 12, 2, 'Tongs Été Enfant', 'Tongs légères et colorées pour les enfants', '15.00', 'Semelle flexible, pratique', 'Caoutchouc', 'Jaune', '28', '0.30', 'U', 50),
(213, 12, 3, 'Chaussures d’été Enfant', 'Chaussures ouvertes et légères pour la saison estivale', '25.00', 'Design simple, semelle anti-dérapante', 'Textile', 'Rose', '29', '0.35', 'U', 60);
-- --------------------------------------------------------

--
-- Structure de la table `PRODUITPANIER`
--

CREATE TABLE `PRODUITPANIER` (
  `IDPRODUITPANIER` int NOT NULL,
  `IDCOMMANDE` int NOT NULL,
  `IDPRODUIT` int NOT NULL,
  `IDPANIER` int NOT NULL,
  `QTEPP` int DEFAULT NULL,
  `PRIXACHAT` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
-- Structure de la table `SOUS_CATEGORIE`
--

CREATE TABLE `SOUS_CATEGORIE` (
  `IDCATEGORIE` int NOT NULL,
  `IDCATEGORIE_1` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `STATUTCOMMANDE`
--

CREATE TABLE `STATUTCOMMANDE` (
  `IDSTATUT` int NOT NULL,
  `NOMSTATUT` varchar(20) DEFAULT NULL,
  `DESCSTATUT` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
(1, 1, 'admin', 'admin', 'lol@gmail.com', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', '0606060606', '1999-01-01', '2024-11-19');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `ADRESSELIVRAISON`
--
ALTER TABLE `ADRESSELIVRAISON`
  ADD PRIMARY KEY (`IDADR`);

--
-- Index pour la table `CATEGORIE`
--
ALTER TABLE `CATEGORIE`
  ADD PRIMARY KEY (`IDCATEGORIE`);

--
-- Index pour la table `COMMANDE`
--
ALTER TABLE `COMMANDE`
  ADD PRIMARY KEY (`IDCOMMANDE`);

--
-- Index pour la table `COMMENTAIRE`
--
ALTER TABLE `COMMENTAIRE`
  ADD PRIMARY KEY (`IDCOMMENTAIRE`);

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
-- Index pour la table `MOYENPAIEMENT`
--
ALTER TABLE `MOYENPAIEMENT`
  ADD PRIMARY KEY (`IDMODEPAIEMENT`,`IDUTILISATEUR`);

--
-- Index pour la table `PANIER`
--
ALTER TABLE `PANIER`
  ADD PRIMARY KEY (`IDPANIER`);

--
-- Index pour la table `PRODUIT`
--
ALTER TABLE `PRODUIT`
  ADD PRIMARY KEY (`IDPRODUIT`);

--
-- Index pour la table `PRODUITPANIER`
--
ALTER TABLE `PRODUITPANIER`
  ADD PRIMARY KEY (`IDPRODUITPANIER`);

--
-- Index pour la table `ROLE`
--
ALTER TABLE `ROLE`
  ADD PRIMARY KEY (`IDROLE`);

--
-- Index pour la table `SOUS_CATEGORIE`
--
ALTER TABLE `SOUS_CATEGORIE`
  ADD PRIMARY KEY (`IDCATEGORIE`,`IDCATEGORIE_1`);

--
-- Index pour la table `STATUTCOMMANDE`
--
ALTER TABLE `STATUTCOMMANDE`
  ADD PRIMARY KEY (`IDSTATUT`);

--
-- Index pour la table `UTILISATEUR`
--
ALTER TABLE `UTILISATEUR`
  ADD PRIMARY KEY (`IDUTILISATEUR`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `ADRESSELIVRAISON`
--
ALTER TABLE `ADRESSELIVRAISON`
  MODIFY `IDADR` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `CATEGORIE`
--
ALTER TABLE `CATEGORIE`
  MODIFY `IDCATEGORIE` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `COMMANDE`
--
ALTER TABLE `COMMANDE`
  MODIFY `IDCOMMANDE` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `COMMENTAIRE`
--
ALTER TABLE `COMMENTAIRE`
  MODIFY `IDCOMMENTAIRE` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `IMAGE`
--
ALTER TABLE `IMAGE`
  MODIFY `IDIMAGE` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `MARQUE`
--
ALTER TABLE `MARQUE`
  MODIFY `IDMARQUE` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `MODEPAIEMENT`
--
ALTER TABLE `MODEPAIEMENT`
  MODIFY `IDMODEPAIEMENT` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `PANIER`
--
ALTER TABLE `PANIER`
  MODIFY `IDPANIER` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `PRODUIT`
--
ALTER TABLE `PRODUIT`
  MODIFY `IDPRODUIT` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=175;

--
-- AUTO_INCREMENT pour la table `PRODUITPANIER`
--
ALTER TABLE `PRODUITPANIER`
  MODIFY `IDPRODUITPANIER` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `ROLE`
--
ALTER TABLE `ROLE`
  MODIFY `IDROLE` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `STATUTCOMMANDE`
--
ALTER TABLE `STATUTCOMMANDE`
  MODIFY `IDSTATUT` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `UTILISATEUR`
--
ALTER TABLE `UTILISATEUR`
  MODIFY `IDUTILISATEUR` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- Insérer les catégories principales
INSERT INTO CATEGORIE (idCategorie, nomCategorie, descCat, idParent) VALUES
(1, 'Homme', 'Catégorie principale pour les produits pour hommes', NULL),
(2, 'Femme', 'Catégorie principale pour les produits pour femmes', NULL),
(3, 'Enfant', 'Catégorie principale pour les produits pour enfants', NULL);

-- Insérer les sous-catégories pour Homme
INSERT INTO CATEGORIE (idCategorie, nomCategorie, descCat, idParent) VALUES
(4, 'Chaussures de sport', 'Chaussures pour activités sportives pour hommes', 1),
(5, 'Chaussures de ville', 'Chaussures formelles et élégantes pour hommes', 1),
(6, 'Chaussures décontractées', 'Chaussures quotidiennes et relax pour hommes', 1);

-- Insérer les sous-catégories pour Femme
INSERT INTO CATEGORIE (idCategorie, nomCategorie, descCat, idParent) VALUES
(7, 'Chaussures de sport', 'Chaussures pour activités sportives pour femmes', 2),
(8, 'Chaussures de ville', 'Chaussures formelles et élégantes pour femmes', 2),
(9, 'Sandales et tongs', 'Chaussures ouvertes pour femmes', 2);

-- Insérer les sous-catégories pour Enfant
INSERT INTO CATEGORIE (idCategorie, nomCategorie, descCat, idParent) VALUES
(10, 'Chaussures de sport', 'Chaussures pour activités sportives pour enfants', 3),
(11, 'Chaussures scolaires', 'Chaussures adaptées à un usage scolaire pour enfants', 3),
(12, 'Sandales et chaussures d’été', 'Chaussures légères pour la saison estivale pour enfants', 3);

-- Insérer des utilisateurs (Clients) dans la table Utilisateur
INSERT INTO UTILISATEUR (idUtilisateur, nom, prenom, email, password, telephone, dateNaissance, dateInscription, idRole)
VALUES
(1, 'Dupont', 'Jean', 'jean.dupont@gmail.com', 'hashed_password_1', '0612345678', '1990-02-14', '2024-12-01', 2),
(2, 'Martin', 'Sophie', 'sophie.martin@hotmail.com', 'hashed_password_2', '0654321098', '1985-07-22', '2024-12-01', 2),
(3, 'Lemoine', 'Pierre', 'pierre.lemoine@yahoo.com', 'hashed_password_3', '0645123654', '1992-10-05', '2024-12-01', 2),
(4, 'Durand', 'Marc', 'marc.durand@gmail.com', 'hashed_password_4', '0678123456', '1998-11-18', '2024-12-01', 2),
(5, 'Petit', 'Julie', 'julie.petit@hotmail.com', 'hashed_password_5', '0698765432', '1988-03-12', '2024-12-01', 2),
(6, 'Nguyen', 'Thi', 'thi.nguyen@gmail.com', 'hashed_password_6', '0634567890', '1995-06-30', '2024-12-01', 2),
(7, 'Bernard', 'Lucie', 'lucie.bernard@hotmail.com', 'hashed_password_7', '0611223344', '1993-01-11', '2024-12-01', 2),
(8, 'Lemoine', 'Claire', 'claire.lemoine@gmail.com', 'hashed_password_8', '0687654321', '1994-05-17', '2024-12-01', 2),
(9, 'Sanchez', 'Ana', 'ana.sanchez@gmail.com', 'hashed_password_9', '0687654321', '1991-09-18', '2024-12-01', 2),
(10, 'Roche', 'Valérie', 'valerie.roche@hotmail.com', 'hashed_password_10', '0656789123', '1982-12-15', '2024-12-01', 2),
(11, 'Tanguy', 'Louis', 'louis.tanguy@gmail.com', 'hashed_password_11', '0611223345', '1997-02-05', '2024-12-01', 2),
(12, 'Chevalier', 'Isabelle', 'isabelle.chevalier@hotmail.com', 'hashed_password_12', '0634567891', '1989-12-18', '2024-12-01', 2),
(13, 'Fournier', 'Antoine', 'antoine.fournier@yahoo.com', 'hashed_password_13', '0687654322', '1994-01-02', '2024-12-01', 2),
(14, 'Rousseau', 'Benoît', 'benoit.rousseau@gmail.com', 'hashed_password_14', '0654321090', '1996-03-10', '2024-12-01', 2),
(15, 'Gauthier', 'Chloé', 'chloe.gauthier@hotmail.com', 'hashed_password_15', '0678234567', '1991-09-27', '2024-12-01', 2),
(16, 'Dupuis', 'Thierry', 'thierry.dupuis@gmail.com', 'hashed_password_16', '0622345678', '1984-04-14', '2024-12-01', 2),
(17, 'Boucher', 'Emilie', 'emilie.boucher@gmail.com', 'hashed_password_17', '0636547890', '1999-06-19', '2024-12-01', 2),
(18, 'Pires', 'Luis', 'luis.pires@hotmail.com', 'hashed_password_18', '0667881234', '1993-07-11', '2024-12-01', 2),
(19, 'Lemoine', 'Julien', 'julien.lemoine@gmail.com', 'hashed_password_19', '0645236789', '1987-02-23', '2024-12-01', 2),
(20, 'Girard', 'Sophie', 'sophie.girard@hotmail.com', 'hashed_password_20', '0612345679', '1995-11-30', '2024-12-01', 2),
(21, 'Beaufort', 'Elise', 'elise.beaufort@gmail.com', 'hashed_password_21', '0678543210', '1989-01-06', '2024-12-01', 2),
(22, 'Lemoine', 'Maxime', 'maxime.lemoine@yahoo.com', 'hashed_password_22', '0687654323', '1997-10-14', '2024-12-01', 2),
(23, 'Leclerc', 'Cécile', 'cecile.leclerc@hotmail.com', 'hashed_password_23', '0654781234', '1993-05-17', '2024-12-01', 2),
(24, 'Roux', 'Mathieu', 'mathieu.roux@gmail.com', 'hashed_password_24', '0623456789', '1998-11-22', '2024-12-01', 2),
(25, 'Lemoine', 'Sébastien', 'sebastien.lemoine@hotmail.com', 'hashed_password_25', '0634567892', '1986-08-03', '2024-12-01', 2),
(26, 'Joly', 'Camille', 'camille.joly@gmail.com', 'hashed_password_26', '0611234567', '1994-02-12', '2024-12-01', 2),
(27, 'Leblanc', 'Clément', 'clement.leblanc@hotmail.com', 'hashed_password_27', '0656789123', '1992-09-06', '2024-12-01', 2),
(28, 'Lemoine', 'Nicolas', 'nicolas.lemoine@gmail.com', 'hashed_password_28', '0687654324', '1988-01-15', '2024-12-01', 2),
(29, 'Ziegler', 'Ingrid', 'ingrid.ziegler@yahoo.com', 'hashed_password_29', '0623456780', '1996-07-29', '2024-12-01', 2),
(30, 'Henri', 'Raphaël', 'raphael.henri@hotmail.com', 'hashed_password_30', '0612345671', '1990-05-19', '2024-12-01', 2),
(31, 'Marchand', 'Pauline', 'pauline.marchand@gmail.com', 'hashed_password_31', '0611122334', '1992-03-15', '2024-12-01', 2),
(32, 'Delacroix', 'Léon', 'leon.delacroix@hotmail.com', 'hashed_password_32', '0654321098', '1985-06-22', '2024-12-01', 2),
(33, 'Blanc', 'Emma', 'emma.blanc@gmail.com', 'hashed_password_33', '0687654325', '1997-11-12', '2024-12-01', 2),
(34, 'Dufresne', 'Michel', 'michel.dufresne@yahoo.com', 'hashed_password_34', '0623456789', '1994-05-23', '2024-12-01', 2),
(35, 'Langlois', 'Amandine', 'amandine.langlois@hotmail.com', 'hashed_password_35', '0645123456', '1989-08-17', '2024-12-01', 2),
(36, 'Dupont', 'Laurent', 'laurent.dupont@gmail.com', 'hashed_password_36', '0678234567', '1993-10-09', '2024-12-01', 2),
(37, 'Rivet', 'Alice', 'alice.rivet@hotmail.com', 'hashed_password_37', '0687654326', '1988-07-04', '2024-12-01', 2),
(38, 'Vidal', 'Xavier', 'xavier.vidal@gmail.com', 'hashed_password_38', '0623456790', '1996-02-28', '2024-12-01', 2),
(39, 'Richard', 'Sophie', 'sophie.richard@yahoo.com', 'hashed_password_39', '0654320987', '1991-12-17', '2024-12-01', 2),
(40, 'Giraud', 'Benjamin', 'benjamin.giraud@hotmail.com', 'hashed_password_40', '0687654327', '1990-01-20', '2024-12-01', 2),
(41, 'Thomas', 'Florence', 'florence.thomas@gmail.com', 'hashed_password_41', '0612345670', '1997-09-11', '2024-12-01', 2),
(42, 'Lemoine', 'Benoît', 'benoit.lemoine@hotmail.com', 'hashed_password_42', '0656789012', '1983-04-13', '2024-12-01', 2),
(43, 'Vallet', 'Clara', 'clara.vallet@gmail.com', 'hashed_password_43', '0678234568', '1995-07-24', '2024-12-01', 2),
(44, 'Garnier', 'Nathalie', 'nathalie.garnier@yahoo.com', 'hashed_password_44', '0687654328', '1992-10-30', '2024-12-01', 2),
(45, 'Fuchs', 'Marc', 'marc.fuchs@hotmail.com', 'hashed_password_45', '0612345673', '1987-12-06', '2024-12-01', 2),
(46, 'Simon', 'Charlotte', 'charlotte.simon@gmail.com', 'hashed_password_46', '0654321099', '1999-04-02', '2024-12-01', 2),
(47, 'Tanguy', 'Pierre', 'pierre.tanguy@yahoo.com', 'hashed_password_47', '0623456781', '1990-06-25', '2024-12-01', 2),
(48, 'Lemoine', 'Hélène', 'helene.lemoine@hotmail.com', 'hashed_password_48', '0678234569', '1988-08-15', '2024-12-01', 2),
(49, 'Faure', 'Julien', 'julien.faure@gmail.com', 'hashed_password_49', '0656789013', '1995-01-07', '2024-12-01', 2),
(50, 'Pires', 'Audrey', 'audrey.pires@hotmail.com', 'hashed_password_50', '0612345672', '1993-03-17', '2024-12-01', 2);


-- Insérer des paniers associés aux utilisateurs dans la table Panier
INSERT INTO PANIER (idPanier, dateCrea, idUtilisateur)
VALUES
(1, '2024-11-25', 1),
(2, '2024-11-27', 2),
(3, '2024-11-30', 3),
(4, '2024-11-22', 4),
(5, '2024-11-20', 5),
(6, '2024-11-23', 6),
(7, '2024-11-28', 7),
(8, '2024-11-21', 8),
(9, '2024-11-19', 9),
(10, '2024-11-18', 10),
(11, '2024-11-18', 11),
(12, '2024-11-19', 12),
(13, '2024-11-20', 13),
(14, '2024-11-21', 14),
(15, '2024-11-22', 15),
(16, '2024-11-23', 16),
(17, '2024-11-24', 17),
(18, '2024-11-25', 18),
(19, '2024-11-26', 19),
(20, '2024-11-27', 20),
(21, '2024-11-28', 21),
(22, '2024-11-29', 22),
(23, '2024-11-30', 23),
(24, '2024-12-01', 24),
(25, '2024-12-02', 25),
(26, '2024-12-03', 26),
(27, '2024-12-04', 27),
(28, '2024-12-05', 28),
(29, '2024-12-06', 29),
(30, '2024-12-07', 30),
(31, '2024-11-28', 31),
(32, '2024-11-29', 32),
(33, '2024-11-30', 33),
(34, '2024-12-01', 34),
(35, '2024-12-02', 35),
(36, '2024-12-03', 36),
(37, '2024-12-04', 37),
(38, '2024-12-05', 38),
(39, '2024-12-06', 39),
(40, '2024-12-07', 40),
(41, '2024-12-08', 41),
(42, '2024-12-09', 42),
(43, '2024-12-10', 43),
(44, '2024-12-11', 44),
(45, '2024-12-12', 45),
(46, '2024-12-13', 46),
(47, '2024-12-14', 47),
(48, '2024-12-15', 48),
(49, '2024-12-16', 49),
(50, '2024-12-17', 50);

// Mise à jour dates inscription 
UPDATE UTILISATEUR U
SET U.dateInscription = (
    SELECT P.dateCrea
    FROM PANIER P
    WHERE P.idUtilisateur = U.idUtilisateur
)
WHERE U.idUtilisateur IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                         21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
                         39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50);
						 
-- Insérer 4 administrateurs dans la table Utilisateur
INSERT INTO UTILISATEUR (idUtilisateur, nom, prenom, email, password, telephone, dateNaissance, dateInscription, idRole)
VALUES
(51, 'Ho', 'Nicolas', 'admin1@gmail.com', 'nicoScrum', '0601234567', '1980-11-05', '2024-12-01', 1),
(52, 'Gaches', 'Luca', 'admin2@gmail.com', 'nicoScrum', '0612345678', '1975-09-13', '2024-12-01', 1),
(53, 'Bouyssou', 'Melvin', 'admin3@gmail.com', 'nicoScrum', '0623456789', '1983-02-22', '2024-12-01', 1),
(54, 'Gourgues', 'Robin', 'admin4@gmail.com', 'nicoScrum', '0634567890', '1987-04-09', '2024-12-01', 1);

-- Insertion des commentaires
INSERT INTO COMMENTAIRE (idCommentaire, note, commentaire, idProduit, idUtilisateur) VALUES
(1, 5, 'Produit parfait, exactement ce que je cherchais. Très satisfait !', 1, 1),
(2, 4, 'Bon produit, la qualité est au rendez-vous. Juste un petit bémol sur la livraison.', 2, 2),
(3, 3, 'Le produit est correct, mais la taille ne correspond pas tout à fait à ce que j’attendais.', 3, 3),
(4, 5, 'Super qualité, je recommande sans hésiter. Livraison rapide en plus !', 4, 4),
(5, 2, 'Le produit ne correspond pas à la description, je suis déçu.', 5, 5),
(6, 4, 'Très bien, mais j’aurais aimé plus de choix de couleurs.', 6, 6),
(7, 5, 'Très bon rapport qualité/prix, je l’utilise tous les jours. Très content !', 7, 7),
(8, 3, 'Produit acceptable, mais quelques défauts visibles sur le matériau.', 8, 8),
(9, 4, 'Très satisfait, mais le produit pourrait être un peu plus durable.', 9, 9),
(10, 1, 'Très décevant. Produit défectueux dès la première utilisation.', 10, 10),
(11, 4, 'Très bon produit, bonne qualité mais un peu cher à mon goût.', 11, 11),
(12, 5, 'Produit excellent, je suis très satisfait ! Aucune mauvaise surprise.', 12, 12),
(13, 2, 'Produit abîmé à la réception, je n’ai pas pu l’utiliser.', 13, 13),
(14, 4, 'Belle finition, confortable, mais la taille n’est pas vraiment adaptée.', 14, 14),
(15, 3, 'Moyenne qualité, mais le prix est abordable. Peut mieux faire.', 15, 15),
(16, 5, 'Je recommande vivement ce produit, il a surpassé mes attentes.', 16, 16),
(17, 4, 'Bon produit, mais il aurait été mieux avec des instructions plus claires.', 17, 17),
(18, 5, 'Vraiment content de mon achat, la qualité est top et la livraison rapide.', 18, 18),
(19, 1, 'Très déçu par ce produit, il ne correspond absolument pas à la description.', 19, 19),
(20, 3, 'Produit assez bien, mais il manque quelques fonctionnalités que j’attendais.', 20, 20);
