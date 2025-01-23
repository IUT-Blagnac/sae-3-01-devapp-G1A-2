<?php
require_once 'connect.inc.php';
require_once 'includes/headerVide.php';
$idUtilisateur = htmlentities($_SESSION['user']['IDUTILISATEUR']);
$modifCompte = $conn->prepare("CALL GetUtilisateurById(:IDUTILISATEUR)");
$modifCompte->execute(['IDUTILISATEUR' => $idUtilisateur]);
$modCompte = $modifCompte->fetch(PDO::FETCH_ASSOC);
$modifCompte->closeCursor();
if (isset($_POST['passwordActuel']) && isset($_POST['nouveauPassword']) && isset($_POST['confirmePassword'])) {
    $mdpActuel = htmlentities($_POST['passwordActuel']);
    $NewMdp = htmlentities($_POST['nouveauPassword']);
    $confMdp = htmlentities($_POST['confirmePassword']);

    if (password_verify($_POST['passwordActuel'], $modCompte['PASSWORD'])) {
        if ($mdpActuel == $NewMdp) {
            header('location: modifPassWord.php?erreur=mdpIdentique');
            exit();
        }
        if ($NewMdp == $confMdp) {
            $newMdpHash = password_hash($NewMdp, PASSWORD_ARGON2ID);
            $updateMdp = $conn->prepare("CALL UpdatePassword(:idUtilisateur, :newMdpHash)");
            $updateMdp->bindParam(':newMdpHash', $newMdpHash);
            $updateMdp->bindParam(':idUtilisateur', $idUtilisateur);
            if ($updateMdp->execute()) {
                $_SESSION['user']['PASSWORD'] = $newMdpHash;
                header("Location: compte.php");
                exit();
            } else {
                header('location: modifPassWord.php?erreur=erreur');
                exit();
            }
            $updateMdp->closeCursor(); 
        } else {
            header('location: modifPassWord.php?erreur=mdpdifférent');
            exit();
        }
    } else {
        header('location: modifPassWord.php?erreur=mauvaismdp');
        exit();
    }
}
?>