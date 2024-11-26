package application.control;

import application.view.AppMainFrameViewController;
import application.view.SolarEdgeViewController;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.BorderPane;

public class SolarEdgeBorderPane {

    // Stage de la fenêtre principale construite par DailyBankMainFrame
    private Stage dbmfStage;
    private SolarEdgeViewController seViewController;

    /**
     * Constructeur
     */
    public SolarEdgeBorderPane(Stage parentStage) {

        this.dbmfStage = parentStage;

        try {

            // Chargement du source fxml
            FXMLLoader loader = new FXMLLoader(
                    AppMainFrameViewController.class.getResource("solaredge.fxml"));
            BorderPane root = loader.load();

            // Paramétrage du Stage : feuille de style, titre
            Scene scene = new Scene(root, root.getPrefWidth() + 20, root.getPrefHeight() + 10);
            // scene.getStylesheets().add(DailyBankApp.class.getResource("application.css").toExternalForm());

            this.dbmfStage.setScene(scene);
            this.dbmfStage.setTitle("Fenêtre solar edge ");

            // Récupération du contrôleur et initialisation (stage, contrôleur de dialogue,
            // état courant)
            seViewController = loader.getController();
            seViewController.initContext(this.dbmfStage, this);

            // dbmfViewController.displayDialog();

        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void doSolarEdge() {
        this.seViewController.displayDialog();
    }

}
