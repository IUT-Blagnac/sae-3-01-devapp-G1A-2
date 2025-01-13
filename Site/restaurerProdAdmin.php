<?php
require_once 'connect.inc.php';
require_once 'includes/headerVide.php';

if (!empty($_GET['idProduit'])) {
    $idProduit = htmlspecialchars($_GET['idProduit']);
    if (isset($_GET['confirm']) && $_GET['confirm'] == 1) {
        // appel à la procédure pour restaurer le produit (traitement du deuxieme appel)
        $pdostat = $conn->prepare("CALL RestaurerProduitAdmin(:idProduit)");
        $pdostat->execute([':idProduit' => $idProduit]);
        echo "
        <script type='text/javascript'>
            alert('Restauration effectuée avec succès');
            window.location.replace('zproduitDeleted.php');
        </script>
        ";
    } else {
        // demande la confirmation de la restauration du produit (premier appel à la page)
        // puis deuxieme rappel des la confirmation
        echo "
        <script type='text/javascript'>
            if (confirm('Êtes-vous sûr de vouloir restaurer ce produit ? ID = $idProduit')) {
                window.location.href = 'restaurerProdAdmin.php?idProduit=$idProduit&confirm=1';
            } else {
                alert('Restauration du produit annulée');
                window.location.replace('zproduitDeleted.php');
            }
        </script>
        ";
    }
} else {
    // redirection si aucun produit n'est fourni
    header('Location: zproduitDeleted.php');
    exit();
}