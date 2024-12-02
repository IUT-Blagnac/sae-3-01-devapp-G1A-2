package application.control;

import application.tools.StageManagement;
import application.view.Am107ViewController;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.BorderPane;

public class Am107BorderPane {
    // Stage de la fenêtre principale construite par DailyBankMainFrame
    private Stage am107Stage;
    private Am107ViewController amViewController;
    // private Thread t;
    // private MyRun r;

    /**
     * Constructeur
     */
    public Am107BorderPane(Stage _parentStage) {

        try {

            // Chargement du source fxml
            FXMLLoader loader = new FXMLLoader(
                    Am107ViewController.class.getResource("am107.fxml"));
            BorderPane root = loader.load();

            // Paramétrage du Stage : feuille de style, titre
            Scene scene = new Scene(root, root.getPrefWidth() + 20, root.getPrefHeight() + 10);
            // scene.getStylesheets().add(DailyBankApp.class.getResource("application.css").toExternalForm());

            this.am107Stage = new Stage();
            // this.am107Stage.initModality(Modality.WINDOW_MODAL);
            this.am107Stage.initOwner(_parentStage);
            StageManagement.manageCenteringStage(_parentStage, this.am107Stage);
            this.am107Stage.setScene(scene);
            this.am107Stage.setTitle("Fenêtre AM107");

            // Récupération du contrôleur et initialisation (stage, contrôleur de dialogue,
            // état courant)
            amViewController = loader.getController();
            amViewController.initContext(this.am107Stage, this);

            // // Création du thread
            // this.r = new MyRun();
            // this.t = new Thread(r);
            // t.start();

        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
    }

    public void doAm107() {
        this.amViewController.displayDialog();
    }

    // public void doStopSolarEdge() {
    // this.r.stop();
    // }

    // // TEST THREAD DE LA CLASSE
    // public static class MyRun implements Runnable {
    // private boolean enCours;

    // public MyRun() {
    // this.enCours = true;
    // }

    // @Override
    // public void run() {
    // while (this.enCours) {
    // System.out.println("On est dans le thread du solar edge");
    // try {

    // Thread.sleep(2000); // pause de 2 secondes à remplacer par la fréquence
    // } catch (InterruptedException e) {
    // System.err.println("Thread interrompu : " + e.getMessage());
    // this.enCours = false;
    // }
    // }
    // // Nettoyage éventuel
    // System.out.println("Le thread est arrete.");
    // }

    // public void stop() {
    // this.enCours = false;
    // }
    // }
}
