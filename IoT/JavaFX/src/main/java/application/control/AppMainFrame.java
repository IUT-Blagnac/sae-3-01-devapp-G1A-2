package application.control;

import java.io.IOException;
import model.Config;
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

    /**
     * Méthode de lancement de la fenêtre SolarEdge.
     */
    public Stage solarDisplay() {
        if (this.solarEdgeBorderPane == null) { // Créer la fenêtre si elle n'existe pas
            this.solarEdgeBorderPane = new SolarEdgeBorderPane(this.dbmfStage);
        }
        gestionLancementPython(); // Appel au lancement du programme python avant l'affichage de l'interface
        this.setSolarEdgeRunning(true); // Changement d'état de la fenêtre
        this.solarEdgeBorderPane.doSolarEdge(); // Affiche la fenêtre
        return this.solarEdgeBorderPane.getSolarStage(); // Retourne le Stage de la fenêtre
    }

    /**
     * Méthode de lancement de la fenêtre AM107.
     * @param pconfig : configuration de la fenêtre AM107 (permet d'être transmise au contrôleur de la fenêtre)
     */
    public Stage am107Display(Config pconfig) {
        this.am107BorderPane = new Am107BorderPane(this.dbmfStage);
        gestionLancementPython(); // Appel au lancement du programme python avant l'affichage de l'interface
        this.setAm107Running(true); // Changement d'état de la fenêtre
        this.am107BorderPane.doAm107(pconfig); // Affiche la fenêtre
        return this.am107BorderPane.getAm107Stage(); // Retourne le Stage de la fenêtre
    }

    /**
     * Méthode permettant de changer l'état de la fenêtre SolarEdge afin de gérer le lancement du programme Python en 1 seule "exemplaire".
     * @param _isRunning : état de la fenêtre SolarEdge (true : ouverte, false : fermée)
     */
    public void setSolarEdgeRunning(Boolean _isRunning) {
        this.isSolarEdgeRunning = _isRunning;
    }

    /**
     * Méthode permettant de récupérer l'état de la fenêtre SolarEdge.
     */
    public Boolean getSolarEdgeRunning() {
        return this.isSolarEdgeRunning;
    }

    /**
     * Méthode permettant de changer l'état de la fenêtre AM107 afin de gérer le lancement du programme Python en 1 seule "exemplaire".
     * @param _isRunning : état de la fenêtre AM107 (true : ouverte, false : fermée)
     */
    public void setAm107Running(Boolean _isRunning) {
        this.isAm107Running = _isRunning;
    }

    /**
     * Méthode permettant de récupérer l'état de la fenêtre AM107.
     */
    public Boolean getAm107Running() {
        return this.isAm107Running;
    }

    /**
     * Méthode permettant de récupérer le Stage de la fenêtre SolarEdge.
     */
    public Stage getSolarStage() {
        return this.solarEdgeBorderPane.getSolarStage(); // Suppose que solarEdgeBorderPane est initialisé
    }

    /**
     * Méthode permettant la gestion du lancement du programme Python
     * Le main.py est appelé une fois pour les deux fenêtres SolarEdge et AM107
     * Si les deux fenêtres sont fermées, le programme Python est arrêté
     * Si le programme Python est déjà en cours d'exécution, on ne le relance pas
     * Crée un environnement virtuel, installe les dépendances et lance le script Python
     * Ici on utilise python3 mais il est possible de devoir changer vers python en fonction de la machine
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
                    // Chemin vers le script Python et le fichier requirements.txt
                    String scriptPath = "../Python/main.py";
                    String requirementsPath = "../Python/requirements.txt";
                    String venvPath = "../Python/venv";

                    // Commande pour créer l'environnement virtuel
                    ProcessBuilder pbCreateVenv = new ProcessBuilder("python3", "-m", "venv", venvPath);
                    pbCreateVenv.redirectErrorStream(true);
                    Process processCreateVenv = pbCreateVenv.start();
                    processCreateVenv.waitFor();

                    // Déterminer le chemin vers pip en fonction du système d'exploitation
                    String pipPath;
                    if (System.getProperty("os.name").toLowerCase().contains("win")) {
                        pipPath = venvPath + "\\Scripts\\pip.exe";
                    } else {
                        pipPath = venvPath + "/bin/pip";
                    }

                    // Commande pour installer les dépendances
                    ProcessBuilder pbInstallDeps = new ProcessBuilder(pipPath, "install", "-r", requirementsPath);
                    pbInstallDeps.redirectErrorStream(true);
                    Process processInstallDeps = pbInstallDeps.start();
                    processInstallDeps.waitFor();

                    // Commande pour lancer le script Python
                    String pythonPath;
                    if (System.getProperty("os.name").toLowerCase().contains("win")) {
                        pythonPath = venvPath + "\\Scripts\\python.exe";
                    } else {
                        pythonPath = venvPath + "/bin/python";
                    }
                    ProcessBuilder pbRunScript = new ProcessBuilder(pythonPath, scriptPath);
                    pbRunScript.redirectErrorStream(true);
                    Process processRunScript = pbRunScript.start();
                    pythonProcess = processRunScript;

                    // Affiche la sortie standard du programme Python
                    new Thread(() -> {
                        try {
                            java.io.BufferedReader reader = new java.io.BufferedReader(
                                    new java.io.InputStreamReader(processRunScript.getInputStream()));
                            String line = "";
                            while ((line = reader.readLine()) != null) {
                                System.out.println("Sortie Python : " + line);
                            }
                        } catch (java.io.IOException e) {
                            System.err.println("Erreur lors de la lecture de la sortie standard du programme Python : "
                                    + e.getMessage());
                            e.printStackTrace();
                        }
                    }).start();

                } catch (IOException | InterruptedException e) {
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
