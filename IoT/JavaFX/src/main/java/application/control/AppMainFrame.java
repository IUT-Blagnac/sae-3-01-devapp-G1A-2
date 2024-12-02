package application.control;

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

    public void solarDisplay() {
        if (this.solarEdgeBorderPane == null) { // Créer la fenêtre si elle n'existe pas
            this.solarEdgeBorderPane = new SolarEdgeBorderPane(this.dbmfStage);
        }
        this.solarEdgeBorderPane.doSolarEdge(); // Affiche la fenêtre
    }

    public void am107Display() {
        if (this.am107BorderPane == null) { // Créer la fenêtre si elle n'existe pas
            this.am107BorderPane = new Am107BorderPane(this.dbmfStage);
        }
        this.am107BorderPane.doAm107(); // Affiche la fenêtre
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
    
    public Stage getAm107Stage() {
        return this.am107BorderPane != null ? this.am107BorderPane.getAm107Stage() : null;
    }
}
