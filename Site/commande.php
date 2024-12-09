<?php
require_once 'includes/header.php';
require_once 'connect.inc.php';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ma commande</title>
</head>
<body>
    <p>Ma commande en cours</p>
    
    <?php
        var_dump($_SESSION);
    ?>
</body>
</html>