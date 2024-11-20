-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : mysql
-- Généré le : mar. 19 nov. 2024 à 15:03
-- Version du serveur : 8.0.40
-- Version de PHP : 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `SAE301`
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
(97, 1, 1, 'Sneakers Retro Classiques', 'Sneakers de style rétro avec semelle renforcée', 79.99, 'Technologie d’amorti AirCell', 'Tige en cuir synthétique, semelle en caoutchouc', 'Blanc', '42', 0.90, 'M', 20),
(98, 1, 2, 'Chaussures de Running Pro', 'Chaussures de course ultra-légères pour performance optimale', 110.00, 'Semelle avec absorption des chocs', 'Textile respirant, caoutchouc', 'Noir', '44', 0.60, 'M', 30),
(99, 2, 3, 'Escarpins Vernis Élégance', 'Escarpins avec finition vernie pour une touche de glamour', 150.00, 'Semelle intérieure en cuir, talon de 7 cm', 'Cuir, vernis', 'Rouge', '38', 0.50, 'F', 15),
(100, 2, 4, 'Sandales en Cuir Premium', 'Sandales élégantes pour l\'été avec sangle ajustable', 60.00, 'Cuir pleine fleur, semelle souple', 'Cuir, caoutchouc', 'Marron', '39', 0.30, 'F', 50),
(101, 3, 1, 'Bottes en Daim Luxe', 'Bottes en daim avec doublure en fourrure synthétique', 220.00, 'Doublure chaude, semelle antidérapante', 'Daim, fourrure synthétique', 'Noir', '43', 1.20, 'M', 10),
(102, 3, 2, 'Sandales de Plage Confort', 'Sandales légères pour la plage avec semelle ergonomique', 25.00, 'Résistantes à l’eau, légères', 'Caoutchouc', 'Bleu', '41', 0.40, 'U', 60),
(103, 4, 1, 'Baskets Urban Chic', 'Baskets urbaines confortables pour la ville', 95.00, 'Semelle intermédiaire en mousse EVA', 'Tissu respirant, semelle en caoutchouc', 'Gris', '45', 0.80, 'M', 40),
(104, 4, 2, 'Chaussures de Ville Confort', 'Chaussures de ville classiques avec semelle en cuir', 120.00, 'Coussin d’air intégré pour plus de confort', 'Cuir pleine fleur, semelle en cuir', 'Noir', '40', 1.00, 'M', 25),
(105, 5, 1, 'Pack Été Femme', 'Pack de 3 paires de sandales en cuir pour l\'été', 200.00, 'Combinaison de sandales légères et élégantes', 'Cuir, caoutchouc', 'Multicolore', '37-39', 2.00, 'F', 10),
(106, 5, 2, 'Pack Sport Homme', 'Pack de 2 paires de baskets de running pour différentes surfaces', 180.00, 'Amorti renforcé pour trail et route', 'Textile, caoutchouc', 'Noir, Bleu', '42-44', 1.80, 'M', 8),
(107, 6, 3, 'Collection Casual Enfant', 'Ensemble de 5 paires de chaussures décontractées pour enfants', 150.00, 'Semelles souples, design coloré', 'Tissu, caoutchouc', 'Multicolore', '28-35', 3.00, 'E', 5),
(108, 6, 4, 'Pack Premium Homme', 'Ensemble de 2 paires de chaussures de ville élégantes', 250.00, 'Design raffiné, cuir de haute qualité', 'Cuir pleine fleur, semelle en cuir', 'Noir, Marron', '41-45', 2.50, 'M', 6),
(109, 7, 2, 'Chaussures de Randonnée', 'Chaussures robustes pour randonnée en montagne', 140.00, 'Imperméable, semelle Vibram', 'Cuir, synthétique', 'Vert', '44', 1.40, 'M', 18),
(110, 7, 3, 'Chaussures de Tennis Pro', 'Chaussures de tennis avec soutien latéral renforcé', 130.00, 'Technologie anti-dérapante', 'Synthétique, caoutchouc', 'Blanc', '40', 0.70, 'U', 20),
(111, 8, 1, 'Mocassins Cuir Élégant', 'Mocassins en cuir pour hommes, design classique', 90.00, 'Semelle en cuir flexible', 'Cuir', 'Marron', '42', 0.90, 'M', 22),
(112, 8, 2, 'Baskets Montantes Urban', 'Baskets montantes avec lacets pour un look streetwear', 100.00, 'Renforts au niveau de la cheville', 'Textile, caoutchouc', 'Rouge', '41', 1.00, 'U', 18),
(113, 9, 1, 'Ballerines Confort', 'Ballerines pour femmes, idéales pour un usage quotidien', 50.00, 'Semelle intérieure amortissante', 'Textile, cuir', 'Noir', '38', 0.40, 'F', 35),
(114, 9, 2, 'Chaussures de Sécurité', 'Chaussures de sécurité pour le travail en milieu industriel', 95.00, 'Coque renforcée en acier', 'Cuir, acier, caoutchouc', 'Noir', '44', 1.80, 'M', 20),
(115, 10, 1, 'Sneakers High-Tech', 'Sneakers innovantes avec écran LED intégré', 250.00, 'Écran LED programmable', 'Synthétique, caoutchouc', 'Noir', '42', 0.90, 'M', 5),
(116, 10, 2, 'Chaussures Enfant Lumineuses', 'Chaussures avec semelles LED lumineuses pour enfants', 60.00, 'Rechargeable par USB, léger', 'Synthétique, caoutchouc', 'Rose', '29', 0.50, 'E', 30),
(117, 10, 3, 'Pantoufles en Laine', 'Pantoufles en laine pour une chaleur maximale en hiver', 30.00, 'Doublure en laine naturelle', 'Laine, caoutchouc', 'Gris', '40', 0.30, 'U', 50),
(118, 10, 4, 'Derbies en Cuir Suédé', 'Chaussures élégantes pour hommes en cuir suédé', 110.00, 'Semelle extérieure en gomme', 'Cuir suédé', 'Bleu marine', '44', 0.80, 'M', 12),
(119, 11, 1, 'Baskets Vegan', 'Baskets écologiques fabriquées sans produits d’origine animale', 130.00, 'Matériaux recyclés, légères', 'Textile, caoutchouc', 'Vert', '43', 0.70, 'U', 18),
(120, 12, 1, 'Baskets Vegan et vegie', 'Baskets écologiques V2', 130.00, 'Matériaux recyclés, légères', 'Textile, caoutchouc', 'Vert', '43', 0.70, 'U', 18),
(148, 1, 1, 'Chaussures de Basketball Pro', 'Chaussures de basketball avec semelle ultra-réactive', 120.00, 'Amorti amélioré, adhérence optimisée', 'Cuir, caoutchouc', 'Noir, Bleu', '42', 0.90, 'M', 15),
(149, 1, 2, 'Baskets Running Fast', 'Baskets ultra-légères pour la course', 85.00, 'Système d\'amorti flexible', 'Textile, caoutchouc', 'Blanc, Rouge', '43', 0.70, 'M', 20),
(150, 2, 3, 'Escarpins Satin Élégance', 'Escarpins avec finition satinée, idéal pour les soirées chic', 160.00, 'Semelle en cuir, talon de 9 cm', 'Cuir satiné', 'Noir, Beige', '38', 0.60, 'F', 25),
(151, 2, 4, 'Mules en Cuir Chic', 'Mules élégantes pour l\'été, confortables et stylées', 70.00, 'Cuir souple, semelle en liège', 'Cuir, liège', 'Beige', '37', 0.40, 'F', 40),
(152, 3, 1, 'Bottes Hiver Confort', 'Bottes en cuir avec doublure en laine pour l\'hiver', 180.00, 'Doublure en laine, semelle antidérapante', 'Cuir, laine', 'Noir', '42', 1.30, 'M', 12),
(153, 3, 2, 'Sandales Hawaï Confort', 'Sandales pour la plage, légères et respirantes', 25.00, 'Système de ventilation, semelle en caoutchouc', 'Caoutchouc, tissu', 'Jaune', '40', 0.30, 'U', 60),
(154, 4, 1, 'Chaussures de Ville Mode', 'Chaussures classiques mais modernes pour les sorties urbaines', 130.00, 'Coussin d\'air intégré', 'Cuir, textile', 'Noir', '41', 1.00, 'M', 18),
(155, 4, 2, 'Mocassins Homme Élégants', 'Mocassins en cuir pour un look raffiné', 110.00, 'Semelle en cuir flexible', 'Cuir, cuir', 'Marron', '43', 0.90, 'M', 14),
(156, 5, 1, 'Pack Sandales Été Femme', 'Pack de 4 paires de sandales élégantes pour l\'été', 220.00, 'Sandales légères et confortables', 'Cuir, caoutchouc', 'Blanc, Beige, Noir, Rose', '37-40', 2.30, 'F', 12),
(157, 5, 2, 'Pack Tennis Homme', 'Pack de 3 paires de tennis pour sport et loisirs', 210.00, 'Tennis avec soutien optimal pour le sport', 'Textile, caoutchouc', 'Bleu, Gris, Noir', '41-44', 2.00, 'M', 10),
(158, 6, 3, 'Pack Chaussures Enfant', 'Pack de 4 paires de chaussures pour enfants, confort et style', 180.00, 'Design coloré, semelles souples', 'Tissu, caoutchouc', 'Multicolore', '28-32', 2.50, 'E', 6),
(159, 6, 4, 'Pack École Homme', 'Pack de 2 paires de chaussures de ville pour hommes', 180.00, 'Cuir haut de gamme, semelle en gomme', 'Cuir, caoutchouc', 'Noir, Marron', '42-44', 2.00, 'M', 15),
(160, 7, 2, 'Baskets High-Tech', 'Baskets futuristes avec émetteur de signal', 250.00, 'Semelle haute performance', 'Synthétique, caoutchouc', 'Noir', '44', 1.00, 'M', 5),
(161, 7, 3, 'Chaussures de Course Extrême', 'Chaussures de course avec technologie de rebond', 130.00, 'Amorti haute performance', 'Textile, caoutchouc', 'Rouge', '45', 0.80, 'M', 30),
(162, 9, 1, 'Escarpins à Talon Haut', 'Escarpins classiques avec talon haut pour une silhouette élégante', 140.00, 'Talon de 10 cm', 'Cuir, satin', 'Rouge', '37', 0.60, 'F', 30),
(163, 9, 2, 'Chaussures de Sécurité Standard', 'Chaussures de sécurité pour le milieu de travail', 90.00, 'Semelle renforcée, protection acier', 'Cuir, métal', 'Noir', '42', 1.70, 'M', 25),
(164, 10, 1, 'Bottes Montantes Hiver', 'Bottes robustes avec doublure chaude pour l\'hiver', 200.00, 'Semelle antidérapante', 'Cuir, laine', 'Marron', '43', 1.50, 'M', 12),
(165, 10, 2, 'Tennis Fashion', 'Tennis tendances pour hommes et femmes', 100.00, 'Légères, flexibles, avec renforts', 'Textile, caoutchouc', 'Blanc', '42', 0.80, 'U', 35),
(166, 10, 3, 'Baskets Sportives Hautes', 'Baskets hautes avec tige renforcée pour le sport', 110.00, 'Technologie d\'amorti renforcé', 'Cuir, textile', 'Gris', '44', 1.00, 'M', 40),
(167, 10, 4, 'Escarpins Satin Chic', 'Escarpins satinés pour les soirées chic', 180.00, 'Talon de 8 cm', 'Satin, cuir', 'Bleu', '39', 0.50, 'F', 22),
(168, 11, 1, 'Chaussures de Randonnée Femme', 'Chaussures de randonnée avec semelle antidérapante', 130.00, 'Semelle en caoutchouc durable', 'Cuir, caoutchouc', 'Gris', '38', 1.20, 'F', 10),
(169, 12, 1, 'Baskets de Trail Homme', 'Baskets pour trail avec semelle haute traction', 140.00, 'Amorti anti-chocs, semelle Vibram', 'Textile, caoutchouc', 'Noir', '45', 1.10, 'M', 20),
(170, 12, 3, 'Baskets Ultra Confort', 'Baskets ultra confortables pour un usage quotidien', 90.00, 'Semelle à mémoire de forme', 'Textile, caoutchouc', 'Bleu', '40', 0.70, 'U', 45),
(171, 13, 1, 'Baskets Légères Femme', 'Baskets confortables pour la course et les loisirs', 75.00, 'Semelle légère, respirante', 'Textile, caoutchouc', 'Rose', '37', 0.60, 'F', 30),
(172, 13, 2, 'Chaussures Ville Classiques', 'Chaussures de ville pour un look élégant', 120.00, 'Semelle cuir, design minimaliste', 'Cuir, textile', 'Marron', '42', 0.90, 'M', 25),
(173, 13, 3, 'Boots Fashion Femme', 'Boots tendances pour l\'hiver et l\'automne', 150.00, 'Semelle épaisse, doublure chaude', 'Cuir, laine', 'Noir', '39', 1.20, 'F', 22),
(174, 13, 4, 'Bottes Haute Gamme', 'Bottes hautes pour une silhouette élégante', 200.00, 'Cuir premium talon haut', 'Cuir', 'Beige', '41', 1.30, 'F', 10);

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
(3, 'Client', 'L\'utilisateur possedant se role peut visiter le site, mettre dans un panier les articles de son choix et payer le panier.');

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
  MODIFY `IDUTILISATEUR` int NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
