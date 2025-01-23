# **Récap réunion interne à l'équipe du 12 déc. 2024**

## 12 déc. 2024 15:00

**─**

# **Intervenants et rôles :** 

**G1A-2 \- Agence**

Nicolas Ho \- Animateur  
Luca Gaches  
Robin Gourgues  
Bouyssou Melvin \- Secrétaire

**Temps : 35 minutes**

# **Contexte**

L'objectif de cette réunion était de faire un point d'avancement sur les différents travaux en cours et d'organiser les prochaines étapes liées à l'oral de communication, aux développements techniques, et aux rendus de fin de sprint.

# **Déroulement de la réunion**

#### **1\. Présentation des progrès** 

1. **Sprint 1 :**   
   * Connexion et déconnexion (Site Web) : Fait  
   * Création compte client : Fait  
   * Visualiser la liste des produits (ceux à la une) : Fait

2. **Sprint 2 :** 

   * Tri de la liste de produits par prix croissant / décroissant : Fait

   * Rechercher de produits par catégorie/sous-catégorie : Fait

   * Visualiser la liste de produits correspondants à la recherche : Fait / à retravailler pour rendre plus flexible

   * Visualiser le détail d’un type produit : en cours **(légèrement en retard)**

3. **Sprint 3 :** 

   * Dashboard administrateur : en cours

   * Gestion du panier : Fait (léger problème dans la gestions des quantités dans la page d'affichage du panier à fix.)

   * Gestion des commandes : à faire

     

**2\. Définition des tâches restantes et événements \+ répartition des issues *\- 25 minutes :*** 

* Dashboard administrateur \- ***bien commencé*** :   
  * Créer une interface d'ajout de produit, avec validation des champs requis. \- **Robin**  
  * Mettre en place une confirmation de suppression pour chaque produit. \- **Luca**  
  * Créer une interface de modification de produit avec mise à jour en temps réel dans le catalogue. \- **Luca**  
  * Afficher le nombre de commandes pour chaque produit et ajouter un filtre pour trier par popularité. \- **Robin**  
  * Les détails produits peuvent être modifiés \- **Luca**

* Gérer le panier (afficher le panier, modifier qté, supprimer un produit) \- ***manque uniquement un bug à fix*** :  
  * Il faut pouvoir modifier la quantité d'un produit \- **Melvin**  
  * CRUD \- **Melvin** & **Nicolas** : *Déjà fait*

* Faire un achat / passer commande ***à commencer*** :  
  * Création compte : L'utilisateur connecté peut accéder à son panier et valider une commande en procédant au paiement. \- **Melvin**  
  * Demander la connexion de l’utilisateur avant la validation de la commande et permettre l’ajout d'une nouvelle adresse de livraison. \- **Robin**  
  * Implémenter les options de paiement (carte bancaire, PayPal, virement) et gérer le statut de devis avant paiement. \- **Nicolas**  
  * Créer une page de suivi de commande avec historique et détails des commandes passées et en cours. \- **Nicolas**

* Visualiser ses commandes passées (et saisir un avis sur un type produit acheté et livré, avec photos éventuelles) ***à commencer***  
  * Il faut pouvoir afficher une page contenant la liste des commandes passées \- **Melvin**  
  * Il faut pouvoir pour chaque commande pouvoir voir les détail produits des commandes \- **Robin**  
  * Il faut pouvoir sélectionner un produit acheter pour pouvoir laisser un avis \- **Nicolas**  
  * Il faut pouvoir dans un avis mettre un avis texte, note le produit et la possibilité de mettre une photo \- **Luca**

* **Modification de la base de données :**  
  * Suppression de l'idCommande dans ProduitPanier

    Ajout de idCommande pouvant être null dans Panier

    Une idCommande à null dans Panier signifie que le panier est actif et non validé Une idCommande remplie dans Panier signifie que le panier a été commandé \- **Melvin**

  * Suppression de la table ADRESSELIVRAISON  
  	TYPEADRESSE est une contrainte check qui ne peut avoir que facturation ou livraison comme valeur  
    Les champs nom et prénom ne sont pas les même que celui du compte car si il a prêté son compte et que la personne commande et se fait livrer chez elle le nom ne sera pas le bon  
  	Création de la table ADDRESSE  
  	Création de la table REGION  
  	Insertion de toutes les régions de france métropolitaine \+ DOM TOM dans la table REGION \- **Robin**

1. **Rendu exceptionnels de la semaine et répartition des tâches *\- 5 minutes :***

   * Diaporama pour la soutenance de communication du 17 déc. 2024 \- toute l'équipe (partie individuelle notamment)

   * Documentation base de données de la semaine (procédure) \- Robin & Nicolas & Luca

   * Documentation PHP de la semaine (US prioritaires) \- Robin & Nicolas & Luca

# **Conclusion**

La réunion a permis de clarifier les priorités et de structurer les efforts restants. Les participants se sont engagés à respecter les échéances en vue de livrer un travail complet et professionnel.

