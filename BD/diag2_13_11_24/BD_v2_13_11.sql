DROP DATABASE IF EXISTS MLR2;

CREATE DATABASE IF NOT EXISTS MLR2;
USE MLR2;
# -----------------------------------------------------------------------------
#       TABLE : PRODUITPANIER
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS PRODUITPANIER
 (
   IDPRODUITPANIER INTEGER NOT NULL  ,
   IDCOMMANDE INTEGER NOT NULL  ,
   IDPRODUIT INTEGER NOT NULL  ,
   IDPANIER INTEGER NOT NULL  ,
   QTEPP INTEGER NULL  ,
   PRIXACHAT DECIMAL(10,2) NULL  
   , PRIMARY KEY (IDPRODUITPANIER) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE PRODUITPANIER
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_PRODUITPANIER_COMMANDE
     ON PRODUITPANIER (IDCOMMANDE ASC);

CREATE  INDEX I_FK_PRODUITPANIER_PRODUIT
     ON PRODUITPANIER (IDPRODUIT ASC);

CREATE  INDEX I_FK_PRODUITPANIER_PANIER
     ON PRODUITPANIER (IDPANIER ASC);

# -----------------------------------------------------------------------------
#       TABLE : COMMENTAIRE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS COMMENTAIRE
 (
   IDCOMMENTAIRE INTEGER NOT NULL  ,
   IDPRODUIT INTEGER NOT NULL  ,
   IDUTILISATEUR INTEGER NOT NULL  ,
   NOTE INTEGER NULL  ,
   COMMENTAIRE VARCHAR(200) NULL  
   , PRIMARY KEY (IDCOMMENTAIRE) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE COMMENTAIRE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_COMMENTAIRE_PRODUIT
     ON COMMENTAIRE (IDPRODUIT ASC);

CREATE  INDEX I_FK_COMMENTAIRE_UTILISATEUR
     ON COMMENTAIRE (IDUTILISATEUR ASC);

# -----------------------------------------------------------------------------
#       TABLE : UTILISATEUR
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS UTILISATEUR
 (
   IDUTILISATEUR INTEGER NOT NULL  ,
   IDPANIER INTEGER NOT NULL  ,
   IDROLE INTEGER NOT NULL  ,
   NOM VARCHAR(128) NULL  ,
   PRENOM VARCHAR(128) NULL  ,
   EMAIL VARCHAR(128) NULL  ,
   PASSWORD VARCHAR(128) NULL  ,
   TELEPHONE CHAR(10) NULL  ,
   DATENAISSANCE DATE NULL  ,
   DATEINSCRIPTION DATE NULL  
   , PRIMARY KEY (IDUTILISATEUR) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE UTILISATEUR
# -----------------------------------------------------------------------------


CREATE UNIQUE INDEX I_FK_UTILISATEUR_PANIER
     ON UTILISATEUR (IDPANIER ASC);

CREATE  INDEX I_FK_UTILISATEUR_ROLE
     ON UTILISATEUR (IDROLE ASC);

# -----------------------------------------------------------------------------
#       TABLE : CATEGORIE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS CATEGORIE
 (
   IDCATEGORIE INTEGER NOT NULL  ,
   IDCATEGORIE_ASSO_4 INTEGER NOT NULL  ,
   NOMCATEGORIE VARCHAR(20) NULL  ,
   DESCCAT VARCHAR(200) NULL  
   , PRIMARY KEY (IDCATEGORIE) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE CATEGORIE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_CATEGORIE_CATEGORIE
     ON CATEGORIE (IDCATEGORIE_ASSO_4 ASC);

# -----------------------------------------------------------------------------
#       TABLE : MODEPAIEMENT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS MODEPAIEMENT
 (
   IDMODEPAIEMENT INTEGER NOT NULL  ,
   NOMPAIEMENT VARCHAR(20) NULL  ,
   DESCPAIEMENT VARCHAR(128) NULL  
   , PRIMARY KEY (IDMODEPAIEMENT) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : IMAGE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS IMAGE
 (
   IDIMAGE INTEGER NOT NULL  ,
   IDPRODUIT INTEGER NOT NULL  ,
   URL VARCHAR(200) NULL  
   , PRIMARY KEY (IDIMAGE) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE IMAGE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_IMAGE_PRODUIT
     ON IMAGE (IDPRODUIT ASC);

# -----------------------------------------------------------------------------
#       TABLE : COMMANDE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS COMMANDE
 (
   IDCOMMANDE INTEGER NOT NULL  ,
   IDUTILISATEUR INTEGER NOT NULL  ,
   IDSTATUT INTEGER NOT NULL  ,
   IDMODEPAIEMENT INTEGER NOT NULL  ,
   DATECOMMANDE DATE NULL  
   , PRIMARY KEY (IDCOMMANDE) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE COMMANDE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_COMMANDE_UTILISATEUR
     ON COMMANDE (IDUTILISATEUR ASC);

CREATE  INDEX I_FK_COMMANDE_STATUTCOMMANDE
     ON COMMANDE (IDSTATUT ASC);

CREATE  INDEX I_FK_COMMANDE_MODEPAIEMENT
     ON COMMANDE (IDMODEPAIEMENT ASC);

# -----------------------------------------------------------------------------
#       TABLE : STATUTCOMMANDE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS STATUTCOMMANDE
 (
   IDSTATUT INTEGER NOT NULL  ,
   NOMSTATUT VARCHAR(20) NULL  ,
   DESCSTATUT VARCHAR(128) NULL  
   , PRIMARY KEY (IDSTATUT) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : PANIER
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS PANIER
 (
   IDPANIER INTEGER NOT NULL  ,
   IDUTILISATEUR INTEGER NOT NULL  ,
   DATECREA DATE NULL  
   , PRIMARY KEY (IDPANIER) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE PANIER
# -----------------------------------------------------------------------------


CREATE UNIQUE INDEX I_FK_PANIER_UTILISATEUR
     ON PANIER (IDUTILISATEUR ASC);

# -----------------------------------------------------------------------------
#       TABLE : ADRESSE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ADRESSE
 (
   IDADR INTEGER NOT NULL  ,
   ADRESSE VARCHAR(128) NULL  ,
   CODEPOSTAL CHAR(5) NULL  ,
   VILLE VARCHAR(128) NULL  ,
   PAYS VARCHAR(128) NULL  
   , PRIMARY KEY (IDADR) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : ROLE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ROLE
 (
   IDROLE INTEGER NOT NULL  ,
   NOMROLE VARCHAR(20) NULL  ,
   DESCROLE VARCHAR(128) NULL  
   , PRIMARY KEY (IDROLE) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : MARQUE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS MARQUE
 (
   IDMARQUE INTEGER NOT NULL  ,
   NOMMARQUE VARCHAR(20) NULL  ,
   DESCMARQUE VARCHAR(200) NULL  
   , PRIMARY KEY (IDMARQUE) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : PRODUIT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS PRODUIT
 (
   IDPRODUIT INTEGER NOT NULL  ,
   IDCATEGORIE INTEGER NOT NULL  ,
   IDMARQUE INTEGER NOT NULL  ,
   NOMPRODUIT VARCHAR(128) NULL  ,
   DESCPRODUIT VARCHAR(200) NULL  ,
   PRIX DECIMAL(10,2) NULL  ,
   ASPECTTECHNIQUE VARCHAR(200) NULL  ,
   COMPOSITION VARCHAR(200) NULL  ,
   COULEUR VARCHAR(20) NULL  ,
   TAILLE CHAR(2) NULL  ,
   POIDS DECIMAL(10,2) NULL  ,
   GENRE CHAR(1) NULL  ,
   QTESTOCK INTEGER NULL  
   , PRIMARY KEY (IDPRODUIT) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE PRODUIT
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_PRODUIT_CATEGORIE
     ON PRODUIT (IDCATEGORIE ASC);

CREATE  INDEX I_FK_PRODUIT_MARQUE
     ON PRODUIT (IDMARQUE ASC);

# -----------------------------------------------------------------------------
#       TABLE : ASSO_15
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ASSO_15
 (
   IDPRODUIT INTEGER NOT NULL  ,
   IDUTILISATEUR INTEGER NOT NULL  
   , PRIMARY KEY (IDPRODUIT,IDUTILISATEUR) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE ASSO_15
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_ASSO_15_PRODUIT
     ON ASSO_15 (IDPRODUIT ASC);

CREATE  INDEX I_FK_ASSO_15_UTILISATEUR
     ON ASSO_15 (IDUTILISATEUR ASC);

# -----------------------------------------------------------------------------
#       TABLE : ASSO_11
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ASSO_11
 (
   IDPANIER INTEGER NOT NULL  ,
   IDPRODUIT INTEGER NOT NULL  
   , PRIMARY KEY (IDPANIER,IDPRODUIT) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE ASSO_11
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_ASSO_11_PANIER
     ON ASSO_11 (IDPANIER ASC);

CREATE  INDEX I_FK_ASSO_11_PRODUIT
     ON ASSO_11 (IDPRODUIT ASC);

# -----------------------------------------------------------------------------
#       TABLE : ASSO_3
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ASSO_3
 (
   IDCATEGORIE INTEGER NOT NULL  ,
   IDCATEGORIE_1 INTEGER NOT NULL  
   , PRIMARY KEY (IDCATEGORIE,IDCATEGORIE_1) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE ASSO_3
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_ASSO_3_CATEGORIE
     ON ASSO_3 (IDCATEGORIE ASC);

CREATE  INDEX I_FK_ASSO_3_CATEGORIE1
     ON ASSO_3 (IDCATEGORIE_1 ASC);

# -----------------------------------------------------------------------------
#       TABLE : ASSO_7
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ASSO_7
 (
   IDCOMMANDE INTEGER NOT NULL  ,
   IDADR INTEGER NOT NULL  
   , PRIMARY KEY (IDCOMMANDE,IDADR) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE ASSO_7
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_ASSO_7_COMMANDE
     ON ASSO_7 (IDCOMMANDE ASC);

CREATE  INDEX I_FK_ASSO_7_ADRESSE
     ON ASSO_7 (IDADR ASC);

# -----------------------------------------------------------------------------
#       TABLE : MOYENPAIEMENT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS MOYENPAIEMENT
 (
   IDMODEPAIEMENT INTEGER NOT NULL  ,
   IDUTILISATEUR INTEGER NOT NULL  ,
   IDMOYENPAIEMENT INTEGER NULL  ,
   NUMCARTE CHAR(16) NULL  ,
   DATEEXP DATE NULL  ,
   NOMCARTE VARCHAR(128) NULL  ,
   CRYPTOGRAMME CHAR(3) NULL  
   , PRIMARY KEY (IDMODEPAIEMENT,IDUTILISATEUR) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE MOYENPAIEMENT
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_MOYENPAIEMENT_MODEPAIEMENT
     ON MOYENPAIEMENT (IDMODEPAIEMENT ASC);

CREATE  INDEX I_FK_MOYENPAIEMENT_UTILISATEUR
     ON MOYENPAIEMENT (IDUTILISATEUR ASC);


# -----------------------------------------------------------------------------
#       CREATION DES REFERENCES DE TABLE
# -----------------------------------------------------------------------------


ALTER TABLE PRODUITPANIER 
  ADD FOREIGN KEY FK_PRODUITPANIER_COMMANDE (IDCOMMANDE)
      REFERENCES COMMANDE (IDCOMMANDE) ;


ALTER TABLE PRODUITPANIER 
  ADD FOREIGN KEY FK_PRODUITPANIER_PRODUIT (IDPRODUIT)
      REFERENCES PRODUIT (IDPRODUIT) ;


ALTER TABLE PRODUITPANIER 
  ADD FOREIGN KEY FK_PRODUITPANIER_PANIER (IDPANIER)
      REFERENCES PANIER (IDPANIER) ;


ALTER TABLE COMMENTAIRE 
  ADD FOREIGN KEY FK_COMMENTAIRE_PRODUIT (IDPRODUIT)
      REFERENCES PRODUIT (IDPRODUIT) ;


ALTER TABLE COMMENTAIRE 
  ADD FOREIGN KEY FK_COMMENTAIRE_UTILISATEUR (IDUTILISATEUR)
      REFERENCES UTILISATEUR (IDUTILISATEUR) ;


ALTER TABLE UTILISATEUR 
  ADD FOREIGN KEY FK_UTILISATEUR_PANIER (IDPANIER)
      REFERENCES PANIER (IDPANIER) ;


ALTER TABLE UTILISATEUR 
  ADD FOREIGN KEY FK_UTILISATEUR_ROLE (IDROLE)
      REFERENCES ROLE (IDROLE) ;


ALTER TABLE CATEGORIE 
  ADD FOREIGN KEY FK_CATEGORIE_CATEGORIE (IDCATEGORIE_ASSO_4)
      REFERENCES CATEGORIE (IDCATEGORIE) ;


ALTER TABLE IMAGE 
  ADD FOREIGN KEY FK_IMAGE_PRODUIT (IDPRODUIT)
      REFERENCES PRODUIT (IDPRODUIT) ;


ALTER TABLE COMMANDE 
  ADD FOREIGN KEY FK_COMMANDE_UTILISATEUR (IDUTILISATEUR)
      REFERENCES UTILISATEUR (IDUTILISATEUR) ;


ALTER TABLE COMMANDE 
  ADD FOREIGN KEY FK_COMMANDE_STATUTCOMMANDE (IDSTATUT)
      REFERENCES STATUTCOMMANDE (IDSTATUT) ;


ALTER TABLE COMMANDE 
  ADD FOREIGN KEY FK_COMMANDE_MODEPAIEMENT (IDMODEPAIEMENT)
      REFERENCES MODEPAIEMENT (IDMODEPAIEMENT) ;


ALTER TABLE PANIER 
  ADD FOREIGN KEY FK_PANIER_UTILISATEUR (IDUTILISATEUR)
      REFERENCES UTILISATEUR (IDUTILISATEUR) ;


ALTER TABLE PRODUIT 
  ADD FOREIGN KEY FK_PRODUIT_CATEGORIE (IDCATEGORIE)
      REFERENCES CATEGORIE (IDCATEGORIE) ;


ALTER TABLE PRODUIT 
  ADD FOREIGN KEY FK_PRODUIT_MARQUE (IDMARQUE)
      REFERENCES MARQUE (IDMARQUE) ;


ALTER TABLE ASSO_15 
  ADD FOREIGN KEY FK_ASSO_15_PRODUIT (IDPRODUIT)
      REFERENCES PRODUIT (IDPRODUIT) ;


ALTER TABLE ASSO_15 
  ADD FOREIGN KEY FK_ASSO_15_UTILISATEUR (IDUTILISATEUR)
      REFERENCES UTILISATEUR (IDUTILISATEUR) ;


ALTER TABLE ASSO_11 
  ADD FOREIGN KEY FK_ASSO_11_PANIER (IDPANIER)
      REFERENCES PANIER (IDPANIER) ;


ALTER TABLE ASSO_11 
  ADD FOREIGN KEY FK_ASSO_11_PRODUIT (IDPRODUIT)
      REFERENCES PRODUIT (IDPRODUIT) ;


ALTER TABLE ASSO_3 
  ADD FOREIGN KEY FK_ASSO_3_CATEGORIE (IDCATEGORIE)
      REFERENCES CATEGORIE (IDCATEGORIE) ;


ALTER TABLE ASSO_3 
  ADD FOREIGN KEY FK_ASSO_3_CATEGORIE1 (IDCATEGORIE_1)
      REFERENCES CATEGORIE (IDCATEGORIE) ;


ALTER TABLE ASSO_7 
  ADD FOREIGN KEY FK_ASSO_7_COMMANDE (IDCOMMANDE)
      REFERENCES COMMANDE (IDCOMMANDE) ;


ALTER TABLE ASSO_7 
  ADD FOREIGN KEY FK_ASSO_7_ADRESSE (IDADR)
      REFERENCES ADRESSE (IDADR) ;


ALTER TABLE MOYENPAIEMENT 
  ADD FOREIGN KEY FK_MOYENPAIEMENT_MODEPAIEMENT (IDMODEPAIEMENT)
      REFERENCES MODEPAIEMENT (IDMODEPAIEMENT) ;


ALTER TABLE MOYENPAIEMENT 
  ADD FOREIGN KEY FK_MOYENPAIEMENT_UTILISATEUR (IDUTILISATEUR)
      REFERENCES UTILISATEUR (IDUTILISATEUR) ;

