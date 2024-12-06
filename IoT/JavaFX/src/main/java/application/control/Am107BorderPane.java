package application.control;

import model.Config;

import application.tools.StageManagement;
import application.view.Am107ViewController;
import javafx.application.Platform;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;
import javafx.scene.layout.BorderPane;

/**
 * Classe de controleur de Dialogue de la fenêtre AM107.
 *
 */
public class Am107BorderPane {
    private Stage am107Stage;
    private Am107ViewController amViewController;
    private Thread t;
    private MyRun r;
    private static Config config;

    /**
     * Constructeur de la classe `Am107BorderPane`.
     *
     * Ce constructeur initialise l'interface graphique pour l'AM107 en chargeant le
     * fichier FXML associé,
     * configure la scène et le stage, puis lance un thread pour rafraîchir les
     * données de l'AM107.
     *
     * @param _parentStage Le stage parent utilisé pour centrer la nouvelle fenêtre.
     *                     (pas utilisé ici)
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
            // this.am107Stage.initOwner(_parentStage);
            StageManagement.manageCenteringStage(_parentStage, this.am107Stage);
            this.am107Stage.setScene(scene);
            this.am107Stage.setTitle("Fenêtre AM107");

            // Récupération du contrôleur et initialisation (stage, contrôleur de dialogue,
            // état courant)
            amViewController = loader.getController();
            amViewController.initContext(this.am107Stage, this);

            // Création du thread
            System.out.println("Lance le thread de refresh de l'AM107");
            this.r = new MyRun(this.amViewController);
            this.t = new Thread(r);
            t.start();

        } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
        }
    }

    /**
     * Exécute l'opération AM107 en affichant une boîte de dialogue avec la
     * configuration fournie.
     *
     * @param pconfig la configuration utilisateur notamment pour l'affichage des
     *                graphiques (cf.initializeGraphiquesParCapteur)
     */
    public void doAm107(Config pconfig) {
        config = pconfig;
        this.amViewController.displayDialog(pconfig);
    }

    /**
     * Retourne le Stage AM107.
     *
     * @return l'instance du Stage AM107
     */
    public Stage getAm107Stage() {
        return this.am107Stage;
    }

    /**
     * Méthode permettant de stopper le thread de l'AM107 appelée lors de la
     * fermeture
     * (cf. closeWindow de Am107ViewController).
     */
    public void doStopAm107() {
        this.r.stop();
    }

    // THREAD DE LA CLASSE AM107BORDERPANE
    public static class MyRun implements Runnable {
        private boolean enCours; // Indique si le thread est en cours d'exécution
        private Am107ViewController amRunViewController; // ViewContrôleur de l'AM107

        /**
         * Constructeur de l'instance MyRun avec le contrôleur de vue spécifié.
         *
         * @param pamRunViewController l'instance de Am107ViewController à associer à
         *                             cet MyRun
         */
        public MyRun(Am107ViewController pamRunViewController) {
            this.enCours = true;
            this.amRunViewController = pamRunViewController;
        }

        /**
         * Méthode run() du thread de l'AM107.
         *
         * Cette méthode est appelée lors du démarrage du thread. Elle rafraîchit les
         * graphiques de l'AM107 à intervalle régulier. (cf. refreshGraphiques)
         */
        @Override
        public void run() {
            while (this.enCours) {
                Platform.runLater(() -> {
                    this.amRunViewController.refreshGraphiques();
                    System.out.println("Refresh graphique");
                });
                try {
                    Thread.sleep(config.getFrequence() * 1000); // Pause pour éviter une utilisation excessive des
                                                                // ressources calquée sur la fréquence saisie par
                                                                // l'utilisateur
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            System.out.println("Le thread est arrêté.");
        }

        /**
         * Méthode permettant d'arrêter le thread de l'AM107.
         */
        public void stop() {
            this.enCours = false;
        }
    }
}
