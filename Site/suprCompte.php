<script>
        // Cette fonction permettra de demander confirmation avant la suppression d'un produit
        function confirmSuppr(idCLient) {
            if (confirm("Etes vous sur de  vouloir supprimer votre compte ?")) {
                document.location.href = "suprCompte.php?pIdCLient=" + idCLient;
            } else {
                alert("Suppression annulée");
                return false;
            }
        }
    </script>
<?php
$securePage = true;
require_once 'includes/header.php';
include("connect.inc.php");

if (isset($_GET['pIdCLient'])) {
    $idProduit = $_GET['pIdCLient'];
    $surpProd = $conn->prepare("DELETE FROM UTILISATEUR WHERE IDUTILISATEUR = :IDUTILISATEUR");
    $surpProd->bindParam(':IDUTILISATEUR', $idProduit);

    if ($surpProd->execute()) {

        echo '<script language="JavaScript" type="text/javascript">alert("Suppression effectuée !"); </script>';
        echo '<script language="JavaScript" type="text/javascript"> window.location.replace("index.php"); </script>';
        header("Location: index.php");
        exit();
    }
}