<?php
$securePage = true;
require_once 'includes/connexionSecurisee.php';
require_once 'connect.inc.php';
require("includes/headerVide.php");

// Récupérer les régions disponibles
try {
    $requete = $conn->prepare("SELECT IDREGION, NOMREGION FROM REGION");
    $requete->execute();
    $regions = $requete->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    error_log("Erreur PDO : " . $e->getMessage());
    echo "<p class='text-danger'>Erreur lors de la récupération des régions.</p>";
    exit();
}
    if(isset($_GET['from'])){
        $from = $_GET['from'];
    }
    else{
        $from = "";
    }
?>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="css/button.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"> <!-- Icônes de Bootstrap -->
    <title>Nouvel adresse</title>
</head>

<body>
    <div class="login-form">
        <h1>Cree une nouvelle adrese</h1>
        <form action="traitCreeAdresse.php" method="post">

        <input type="hidden" name="from" value="<?php echo $from; ?>">
            <div id="nouvelleAdresse">
                <div class="mb-3">
                    <label for="nom" class="form-label">Nom</label>
                    <input type="text" id="nom" name="nom" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="prenom" class="form-label">Prénom</label>
                    <input type="text" id="prenom" name="prenom" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="adress" class="form-label">Adresse</label>
                    <input type="text" id="adresse" name="adresse" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="ville" class="form-label">Ville</label>
                    <input type="text" id="ville" name="ville" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="codePostal" class="form-label">Code Postal</label>
                    <input type="text" id="codePostal" name="codePostal" class="form-control" maxlength="5" minlength="5" required>
                </div>
                <div class="mb-3">
                    <label for="pays" class="form-label">Pays</label>
                    <input type="text" id="pays" name="pays" class="form-control" value="France" readonly required>
                </div>
                <div class="mb-3">
                    <label for="region" class="form-label">Région</label>
                    <select id="region" name="region" class="form-control" required>
                        <option value="">Sélectionner une région</option>
                        <?php
                        foreach ($regions as $region) {
                            echo '<option value="' . htmlspecialchars($region['IDREGION']) . '">' . htmlspecialchars($region['NOMREGION']) . '</option>';
                        }
                        ?>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="telephone" class="form-label">Téléphone</label>
                    <input type="text" id="telephone" name="telephone" class="form-control" minlength="10" maxlength="10" required>
                </div>
                <button type="submit" name="ajouterAdresse" class="btn btn-primary">Ajouter l'adresse de facturation</button>
            </div>
    </div>
    </form>
    <?php
    if (isset($_GET["erreur"])): ?>
    <div class="alert alert-danger mt-3" role="alert">
        <?php
        if ($_GET["erreur"] == "codepostal") {
            echo "<p style='color:red;'>Format code postal invalide</p>";        
        } elseif ($_GET["erreur"] == "tel") {
            echo"<p style='color:red;'>Format numéro de téléphone invalide</p>";   
        }
        ?>
    </div>
<?php endif; ?>
    </div>
</body>

</html>