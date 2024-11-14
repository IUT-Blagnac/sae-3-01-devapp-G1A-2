<?php
session_start();
    if (isset($_POST['login']) && ($_POST['password']) && ($_POST['Valider'])){
        if(htmlentities($_POST['login']) == "Achille" && htmlentities($_POST['password']) == "Talon" ){
            $_SESSION['sGourguesRobin'] = "OK";
            $_SESSION['PageSécurisé'] = "oui";
            if(isset($_POST["SeSouvenirDeMoi"])){
                setcookie('cGourguesRobin', $_POST['login'], time() + 60 * 5 );
            }
            header('location: index.php');
        }else{
            header('location: FormConnection.php?msgErreur=Erreur%20d%27Identification...%20Recommencez');
        } 
        }else{
            if($_SESSION['PageSécurisé'] != "oui"){
                header(header: 'location: FormConnection.php?msgErreur=Erreur%20d%27Identification...%20Recommencez');
            }
    }