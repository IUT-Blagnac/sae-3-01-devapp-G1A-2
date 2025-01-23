<?php

/* TEST DU DELETE 

insert dans produit : 

INSERT INTO `PRODUIT` (`IDPRODUIT`, `IDCATEGORIE`, `IDMARQUE`, `NOMPRODUIT`, `DESCPRODUIT`, `PRIX`, `ASPECTTECHNIQUE`, `COMPOSITION`, `POIDS`, `GENRE`, `SUPPRIME`) VALUES
(1000, 1, 1, 'TEST', 'Sneakers de style rétro avec semelle renforcée', '79.99', 'Technologie d’amorti AirCell', 'Tige en cuir synthétique, semelle en caoutchouc', '0.90', 'M', 0);
insert dans image : 

INSERT INTO `IMAGE` (`IDIMAGE`, `IDPRODUIT`, `URL`) VALUES
(null, 1000, null);


COMMENTAIRE
IMAGE
PRODUIT_ATTR


*/
require_once 'connect.inc.php';
require_once 'includes/headerVide.php';

if (!empty($_GET['idProduit'])) {
    $idProduit = htmlspecialchars($_GET['idProduit']);
    if (isset($_GET['confirm']) && $_GET['confirm'] == 1) {
        // appel à la procédure pour supprimer le produit (traitement du deuxieme appel)
        $pdostat = $conn->prepare("CALL SupprimerProduitEtPanierAdmin(:idProduit)");
        $pdostat->execute([':idProduit' => $idProduit]);
        echo "
        <script type='text/javascript'>
            alert('Suppression effectuée avec succès');
            window.location.replace('zdashboard.php');
        </script>
        ";
    } else {
        // demande la confirmation de la suppression du produit (premier appel à la page)
        // puis deuxieme rappel des la confirmation
        echo "
        <script type='text/javascript'>
            if (confirm('Êtes-vous sûr de vouloir supprimer ce produit ? ID = $idProduit')) {
                window.location.href = 'supprProdAdmin.php?idProduit=$idProduit&confirm=1';
            } else {
                alert('Suppression annulée');
                window.location.replace('zdashboard.php');
            }
        </script>
        ";
    }
} else {
    // redirection si aucun produit n'est fourni
    header('Location: zdashboard.php');
    exit();
}