package application.control;

import application.tools.StageManagement;
import application.view.SolarEdgeViewController;
import javafx.application.Platform;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.BorderPane;

/**
 * Classe de controleur de Dialogue de SolarEdge.
 *
 */
/**
 * Classe de controleur de Dialogue de la fenêtre SolarEdge.
 *
 */
public class SolarEdgeBorderPane {

    // Stage de la fenêtre principale construite par DailyBankMainFrame
    private Stage solarStage;
    private SolarEdgeViewController seViewController;
    private Thread t;
    private MyRun r;

    /**
     * Constructeur de la classe `SolarEdgeBorderPane`.
     *
     * Ce constructeur initialise l'interface graphique pour le SolarEdge en
     * chargeant le
     * fichier FXML associé,
     * configure la scène et le stage, puis lance un thread pour rafraîchir les
     * données du SolarEdge.
     *
     * @param _parentStage Le stage parent utilisé pour centrer la nouvelle fenêtre.
     *                     (pas utilisé ici)
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
            // this.solarStage.initOwner(_parentStage);
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

    /**
     * Méthode permettant d'afficher la fenêtre du SolarEdge
     */
    public void doSolarEdge() {
        this.seViewController.displayDialog();
    }

    /**
     * Méthode permettant de stopper le thread du solarEdge
     */
    public void doStopSolarEdge() {
        this.r.stop();
    }

    // THREAD DE LA CLASSE
    public static class MyRun implements Runnable {
        private boolean enCours; // Indique si le thread est en cours d'exécution
        private SolarEdgeViewController seRunViewController; // contrôleur de la vue SolarEdge

        /**
         * Constructeur de la classe MyRun.
         *
         * @param pseRunViewController le contrôleur de la vue SolarEdge
         */
        public MyRun(SolarEdgeViewController pseRunViewController) {
            this.enCours = true;
            this.seRunViewController = pseRunViewController;
        }

        /**
         * Méthode run() du thread du SolarEdge.
         *
         * Cette méthode est appelée lors du démarrage du thread. Elle rafraîchit
         * le graphique du SolarEdge à intervalle régulier. (cf. refreshGraphiques)
         */
        @Override
        public void run() {
            while (this.enCours) {
                Platform.runLater(() -> {
                    this.seRunViewController.loadUpdateHistoric();
                });
                try {
                    Thread.sleep(10000); // Pause pour éviter une utilisation excessive des ressources
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            System.out.println("Le thread est arrêté.");
        }

        /**
         * Méthode permettant d'arrêter le thread du SolarEdge.
         */
        public void stop() {
            this.enCours = false;
        }
    }

    /**
     * Méthode permettant de récupérer le stage du SolarEdge.
     *
     * @return le stage du SolarEdge
     */
    public Stage getSolarStage() {
        return this.solarStage;
    }
}