package application.control;

import application.tools.StageManagement;
import application.view.AppMainFrameViewController;
import application.view.SolarEdgeViewController;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Modality;
import javafx.stage.Stage;
import javafx.scene.layout.BorderPane;

public class SolarEdgeBorderPane {

    // Stage de la fenêtre principale construite par DailyBankMainFrame
    private Stage solarStage;
    private SolarEdgeViewController seViewController;
    private Thread t;
    private MyRun r;

    /**
     * Constructeur
     */
    public SolarEdgeBorderPane(Stage _parentStage) {

        try {

            // Chargement du source fxml
            FXMLLoader loader = new FXMLLoader(
                    SolarEdgeViewController.class.getResource("solaredge.fxml"));
            BorderPane root = loader.load();

            // Paramétrage du Stage : feuille de style, titre
            Scene scene = new Scene(root, root.getPrefWidth() + 20, root.getPrefHeight() + 10);
            // scene.getStylesheets().add(DailyBankApp.class.getResource("application.css").toExternalForm());

            this.solarStage = new Stage();
            // this.solarStage.initModality(Modality.WINDOW_MODAL);
            this.solarStage.initOwner(_parentStage);
            StageManagement.manageCenteringStage(_parentStage, this.solarStage);
            this.solarStage.setScene(scene);
            this.solarStage.setTitle("Fenêtre Solar Edge");

            // Récupération du contrôleur et initialisation (stage, contrôleur de dialogue,
            // état courant)
            seViewController = loader.getController();
            seViewController.initContext(this.solarStage, this);

            // Création du thread
            this.r = new MyRun(this.seViewController);
            this.t = new Thread(r);
            t.start();

        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void doSolarEdge() {
        this.seViewController.displayDialog();
    }

    public void doStopSolarEdge() {
        this.r.stop();
    }

    // TEST THREAD DE LA CLASSE
    public static class MyRun implements Runnable {
        private boolean enCours;
        private SolarEdgeViewController seRunViewController;

        public MyRun(SolarEdgeViewController pseRunViewController) {
            this.enCours = true;
            this.seRunViewController = pseRunViewController;
        }

        @Override
        public void run() {
            while (this.enCours) {

                System.out.println("On est dans le thread du solar edge");
                try {
                    this.seRunViewController.loadUpdateHistoric();
                    Thread.sleep(2000); // pause de 2 secondes à remplacer par la fréquence

                } catch (InterruptedException e) {
                    System.err.println("Thread interrompu : " + e.getMessage());
                    this.enCours = false;
                }
            }
            // Nettoyage éventuel
            System.out.println("Le thread est arrete.");
        }

        public void stop() {
            this.enCours = false;
        }
    }

}
