<?php
require_once 'connect.inc.php';
require_once 'includes/header.php';
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/detProd.css">
    <title>Detail Produit</title>
</head>

<body>
    <?php
    $detailsProd = $conn->prepare("SELECT * FROM PRODUIT P LEFT JOIN IMAGE I ON P.IDPRODUIT = I.IDPRODUIT WHERE P.IDPRODUIT = :idProduit");
    $detailsProd->execute(['idProduit' => $_GET['idProduit']]);
    $detProd = $detailsProd->fetch(); // Utilisez fetch() pour récupérer une seule ligne
    
    if ($detProd) {    ?>
    <center><h2><?php echo $detProd['NOMPRODUIT'];?></h2></center>
     <form class="form-inline" action="/action_page.php">
  <label for="nom">Nom Produit:</label>
  <input type="text" id="nom" name="nom" value="<?php echo $detProd["NOMPRODUIT"] ;?>" readonly>
  <label for="prix">prix:</label>
  <input type="text" id="prix" name="prix" value="<?php echo $detProd["PRIX"] ;?>" readonly>   
  <label for="desc">Description:</label>
  <textarea type="text" id="desc" name="desc" value="<?php echo $detProd["DESCPRODUIT"] ;?>" readonly><?php echo $detProd["DESCPRODUIT"] ;?></textarea>
  <label for="asp">Aspect technique:</label>
  <textarea type="asp" id="asp" name="aps" value="<?php echo $detProd["ASPECTTECHNIQUE"] ;?>" readonly><?php echo $detProd["ASPECTTECHNIQUE"] ;?> </textarea>
  <br>
  <label for="comp">Composition :</label>
  <textarea for="comp" id="comp"><?php echo $detProd["COMPOSITION"] ;?> </textarea>
  <label for="couleur">Couleur :</label>
  <input for="couleur" id="couleur" value="<?php echo $detProd["COULEUR"] ;?>" readonly>
  <label for="taille">Taille :</label>
  <textarea for="taille" id="taille"><?php echo $detProd["TAILLE"] ;?> </textarea>
  <label for="poids">Poids :</label>
  <textarea for="poids" id="poids"><?php echo $detProd["POIDS"] ;?> </textarea>
  <br>
  <label for="genre">Genre :</label>
  <input for="genre" id="genre" value="<?php echo $detProd["GENRE"] ;?>" readonly> 
  <label for="stock">Stock :</label>
  <input for="stock" id="stock" value="<?php echo $detProd["QTESTOCK"] ;?>">
  </form>
  <br>
  <img src="<?php echo htmlspecialchars($detProd['URL']); ?>" alt="<?php echo htmlspecialchars($detProd['NOMPRODUIT']); ?>" class="img-fluid">



  <p>ajouter au panier</p>
  <?php
    }
    ?>
</body>

</html>
<footer>
    <?php
    require_once 'includes/footer.php';
    ?>
</footer>