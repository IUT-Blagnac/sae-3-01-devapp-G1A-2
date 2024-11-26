package application.control;

import application.view.AppMainFrameViewController;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

/**
 * Classe de controleur de Dialogue de la fenêtre principale.
 *
 */

public class AppMainFrame extends Application {

    // Stage de la fenêtre principale construite par DailyBankMainFrame
    private Stage dbmfStage;

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

            /*
             * // En mise au point : // Forcer une connexion existante pour rentrer dans
             * l'appli en mode connecté
             * 
             * try { Employe e; Access_BD_Employe ae = new Access_BD_Employe();
             * 
             * e = ae.getEmploye("Tuff", "Lejeune");
             * 
             * if (e == null) { System.out.println("\n\nPB DE CONNEXION\n\n"); } else {
             * this.dailyBankState.setEmployeActuel(e); } } catch
             * (DatabaseConnexionException e) { ExceptionDialog ed = new
             * ExceptionDialog(this.dbmfStage, this.dailyBankState, e);
             * ed.doExceptionDialog(); this.dailyBankState.setEmployeActuel(null); } catch
             * (ApplicationException ae) { ExceptionDialog ed = new
             * ExceptionDialog(this.dbmfStage, this.dailyBankState, ae);
             * ed.doExceptionDialog(); this.dailyBankState.setEmployeActuel(null); }
             * 
             * if (this.dailyBankState.getEmployeActuel() != null) {
             * this.dailyBankState.setEmployeActuel(this.dailyBankState.getEmployeActuel());
             * }
             * 
             */

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

}
