package application.control;

import java.io.IOException;

import application.view.AppMainFrameViewController;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

/**
 * Classe de controleur de Dialogue de la fenêtre principale.
 *
 */

public class AppMainFrame extends Application {

    // Stage de la fenêtre principale construite par DailyBankMainFrame
    private Stage dbmfStage;
    private Boolean isSolarEdgeRunning = false;
    private Boolean isAm107Running = false;
    private Am107BorderPane am107BorderPane;
    private SolarEdgeBorderPane solarEdgeBorderPane;
    // Ajoutez cette ligne en haut de votre classe
    private Process pythonProcess;

    /**
     * Méthode de démarrage (JavaFX).
     */
    @Override
    public void start(Stage primaryStage) {

        this.dbmfStage = primaryStage;

        try {

            // Chargement du source fxml
            FXMLLoader loader = new FXMLLoader(
                    AppMainFrameViewController.class.getResource("menu.fxml"));
            VBox root = loader.load();

            // Paramétrage du Stage : feuille de style, titre
            Scene scene = new Scene(root, root.getPrefWidth() + 20, root.getPrefHeight() + 10);
            // scene.getStylesheets().add(DailyBankApp.class.getResource("application.css").toExternalForm());

            this.dbmfStage.setScene(scene);
            this.dbmfStage.setTitle("Fenêtre Principale");

            // Récupération du contrôleur et initialisation (stage, contrôleur de dialogue,
            // état courant)
            AppMainFrameViewController dbmfViewController = loader.getController();
            dbmfViewController.initContext(this.dbmfStage, this);

            dbmfViewController.displayDialog();

        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
    }

    /**
     * Méthode principale de lancement de l'application.
     */
    public static void runApp() {
        Application.launch();
    }

    public Stage solarDisplay() {
        if (this.solarEdgeBorderPane == null) { // Créer la fenêtre si elle n'existe pas
            this.solarEdgeBorderPane = new SolarEdgeBorderPane(this.dbmfStage);
        }
        gestionLancementPython(); // Appel au lancement du programme python avant l'affichage de l'interface
        this.setSolarEdgeRunning(true); // Changement d'état de la fenêtre
        this.solarEdgeBorderPane.doSolarEdge(); // Affiche la fenêtre
        return this.solarEdgeBorderPane.getSolarStage(); // Retourne le Stage de la fenêtre
    }

    public Stage am107Display() {
        if (this.am107BorderPane == null) { // Créer la fenêtre si elle n'existe pas
            this.am107BorderPane = new Am107BorderPane(this.dbmfStage);
        }
        gestionLancementPython(); // Appel au lancement du programme python avant l'affichage de l'interface
        this.setAm107Running(true); // Changement d'état de la fenêtre
        this.am107BorderPane.doAm107(); // Affiche la fenêtre
        return this.am107BorderPane.getAm107Stage(); // Retourne le Stage de la fenêtre
    }

    public void setSolarEdgeRunning(Boolean _isRunning) {
        this.isSolarEdgeRunning = _isRunning;
    }

    public Boolean getSolarEdgeRunning() {
        return this.isSolarEdgeRunning;
    }

    public void setAm107Running(Boolean _isRunning) {
        this.isAm107Running = _isRunning;
    }

    public Boolean getAm107Running() {
        return this.isAm107Running;
    }

    public Stage getSolarStage() {
        return this.solarEdgeBorderPane.getSolarStage(); // Suppose que solarEdgeBorderPane est initialisé
    }

    // public Stage getAm107Stage() {
    // return this.am107BorderPane != null ? this.am107BorderPane.getAm107Stage() :
    // null;
    // }

    /**
     * Méthode permettant la gestion du lancement du programme Python
     * Le main.py est appelé une fois pour les deux fenêtres SolarEdge et AM107
     */
    public void gestionLancementPython() {
        System.out.println("Valeur de l'état fenêtre AM107 : " + this.getAm107Running());
        System.out.println("Valeur de l'état fenêtre SolarEdge : " + this.getSolarEdgeRunning());

        if (!this.getAm107Running() && !this.getSolarEdgeRunning()) {
            System.out.println("Aucune fenêtre ouverte. Pas de lancement du programme Python.");
        } else {
            if (pythonProcess == null || !pythonProcess.isAlive()) {
                System.out.println("Lancement du programme Python.");
                try {
                    // Chemin vers le script Python
                    String scriptPath = "../Python/main.py";

                    // Commande pour lancer le script Python
                    ProcessBuilder pb = new ProcessBuilder("python", scriptPath);

                    // Démarrer le processus Python
                    pythonProcess = pb.start();

                    System.out.println("Programme Python lancé avec succès.");
                } catch (IOException e) {
                    System.err.println("Erreur lors du lancement du programme Python : " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("Le programme Python est déjà en cours d'exécution.");
            }
        }
    }

    /**
     * Méthode permettant la gestion de la fin du programme Python
     * On arrête le programme ici si toutes les fenêtres sont fermées
     */
    public void testIfWindowsAreAllClosed() {
        if (!this.getAm107Running() && !this.getSolarEdgeRunning()) {
            System.out.println("Toutes les fenêtres sont fermées. Arrêt du programme Python.");
            if (pythonProcess != null && pythonProcess.isAlive()) {
                // Arrêter le processus Python
                pythonProcess.destroy();

                try {
                    // Attendre que le processus se termine
                    pythonProcess.waitFor();
                    System.out.println("Programme Python arrêté avec succès.");
                } catch (InterruptedException e) {
                    System.err.println("Erreur lors de l'arrêt du programme Python : " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("Le programme Python n'est pas en cours d'exécution.");
            }
        } else {
            System.out.println("Programme Python toujours nécessaire.");
        }
    }

}
