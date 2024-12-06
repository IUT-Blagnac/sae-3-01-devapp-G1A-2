package application.view;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.UUID;
import org.eclipse.paho.client.mqttv3.MqttClient;
import application.control.AppMainFrame;
import application.tools.AlertUtilities;
import javafx.beans.property.FloatProperty;
import javafx.beans.property.SimpleFloatProperty;
import javafx.fxml.FXML;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.CheckMenuItem;
import javafx.scene.control.Label;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;
import com.fasterxml.jackson.databind.ObjectMapper;
import model.Config;

/**
 * Controller JavaFX de la view dailybankmainframe.
 *
 */
public class AppMainFrameViewController {

    private HashSet<String> topic;
    private String server;
    private HashSet<String> salle;
    private HashMap<String, Float> data;
    private int frequence; // TO CHANGE
    private ObjectMapper mapper;
    private Config config;
    private Boolean isSolarEdge = false;
    private Boolean isAm107 = false;

    // Contrôleur de Dialogue associé à AppMainFrameController
    private AppMainFrame dbmfDialogController;

    // Fenêtre physique ou est la scène contenant le fichier xml contrôlé par this
    private Stage containingStage;

    // Données de la fenêtre

    // Manipulation de la fenêtre

    /**
     * Initialisation du contrôleur de vue AppMainFrameController.
     *
     * @param _containingStage Stage qui contient le fichier xml contrôlé par
     *                         AppMainFrameController
     * @param _dbmf            Contrôleur de Dialogue qui réalisera les opérations
     *                         de navigation ou calcul
     * @param _dbstate         Etat courant de l'application
     */
    public void initContext(Stage _containingStage, AppMainFrame _dbmf) {
        this.dbmfDialogController = _dbmf;
        this.containingStage = _containingStage;
        this.configure();
    }

    /**
     * Affichage de la fenêtre.
     */
    public void displayDialog() {
        this.containingStage.show();
    }

    /*
     * Configuration de DailyBankMainFrameController. Fermeture par la croix,
     */
    private void configure() {
        this.containingStage.setOnCloseRequest(e -> this.closeWindow(e));
    }

    /*
     * Méthode de fermeture de la fenêtre par la croix.
     *
     * @param e Evénement associé (inutilisé pour le moment)
     *
     * @return null toujours (inutilisé)
     */
    private Object closeWindow(WindowEvent e) {
        this.doQuit();
        e.consume();
        return null;
    }

    // Attributs FXML
    @FXML
    private Label testResuLabel;

    @FXML
    private TextField tfServer;

    @FXML
    private TextField frequenceTextField;

    @FXML
    private Menu choixSalles;
    @FXML
    private CheckBox temperature;
    @FXML
    private CheckBox humidity;
    @FXML
    private CheckBox activity;
    @FXML
    private CheckBox co2;
    @FXML
    private CheckBox illumination;
    @FXML
    private CheckBox pression;

    @FXML
    private TextField seuilTempField;
    @FXML
    private TextField seuilHumField;
    @FXML
    private TextField seuilActField;
    @FXML
    private TextField seuilCo2Field;
    @FXML
    private TextField seuilIllField;
    @FXML
    private TextField seuilPresField;

    private FloatProperty seuilTemp = new SimpleFloatProperty();
    private FloatProperty seuilHum = new SimpleFloatProperty();
    private FloatProperty seuilAct = new SimpleFloatProperty();
    private FloatProperty seuilCo2 = new SimpleFloatProperty();
    private FloatProperty seuilIll = new SimpleFloatProperty();
    private FloatProperty seuilPres = new SimpleFloatProperty();

    @FXML
    private Button launchSolarEdgeBtn;

    @FXML
    private Button launchAm107Btn;

    // Actions

    /*
     * Initialisation du contrôleur de vue AppMainFrameController.
     */
    public void initialize() {
        System.out.println("Controlleur chargé avec succès");
        initializeConfig();

        temperature.selectedProperty().addListener((obs, oldVal, newVal) -> seuilTempField.setDisable(!newVal));
        humidity.selectedProperty().addListener((obs, oldVal, newVal) -> seuilHumField.setDisable(!newVal));
        activity.selectedProperty().addListener((obs, oldVal, newVal) -> seuilActField.setDisable(!newVal));
        co2.selectedProperty().addListener((obs, oldVal, newVal) -> seuilCo2Field.setDisable(!newVal));
        illumination.selectedProperty().addListener((obs, oldVal, newVal) -> seuilIllField.setDisable(!newVal));
        pression.selectedProperty().addListener((obs, oldVal, newVal) -> seuilPresField.setDisable(!newVal));
        bindSeuilFields();

        this.testResuLabel.setText("");
    }

    /**
     * Méthode permettant de lier un TextField à une propriété FloatProperty.
     * 
     * @param textField TextField à lier
     * @param property  Propriété à lier
     */
    private void bindTextFieldToFloatProperty(TextField textField, FloatProperty property) {
        // Binding bidirectionnel entre le TextField et la propriété
        textField.textProperty().bindBidirectional(property, new javafx.util.StringConverter<>() {
            @Override
            public String toString(Number value) {
                return value == null ? "" : value.toString();
            }

            @Override
            public Float fromString(String value) {
                try {
                    return Float.parseFloat(value);
                } catch (NumberFormatException e) {
                    return 0.0f; // Valeur par défaut en cas d'entrée invalide
                }
            }
        });
    }

    /**
     * Méthode permettant de lier les champs de saisie des seuils (TextField) aux valeurs dans le code.
     */
    private void bindSeuilFields() {
        bindTextFieldToFloatProperty(seuilTempField, seuilTemp);
        bindTextFieldToFloatProperty(seuilHumField, seuilHum);
        bindTextFieldToFloatProperty(seuilActField, seuilAct);
        bindTextFieldToFloatProperty(seuilCo2Field, seuilCo2);
        bindTextFieldToFloatProperty(seuilIllField, seuilIll);
        bindTextFieldToFloatProperty(seuilPresField, seuilPres);
    }

    /**
     * Méthode permettant de désactiver les champs de saisie des seuils si la case
     * correspondante n'est pas cochée.
     */
    private void disableFieldsIfUnchecked() {
        seuilTempField.setDisable(!temperature.isSelected());
        seuilHumField.setDisable(!humidity.isSelected());
        seuilActField.setDisable(!activity.isSelected());
        seuilCo2Field.setDisable(!co2.isSelected());
        seuilIllField.setDisable(!illumination.isSelected());
        seuilPresField.setDisable(!pression.isSelected());
    }

    /**
     * Méthode permettant de charger les CheckBox à partir de la configuration.
     */
    private void loadCheckBoxFromData() {
        temperature.setSelected(data.containsKey("temperature"));
        humidity.setSelected(data.containsKey("humidity"));
        activity.setSelected(data.containsKey("activity"));
        co2.setSelected(data.containsKey("co2"));
        illumination.setSelected(data.containsKey("illumination"));
        pression.setSelected(data.containsKey("pressure"));
    }

    /**
     * Méthode permettant de synchroniser les données du config avec les CheckBox visuelles.
     */
    private void valideData() {
        if (temperature.isSelected()) {
            this.data.put("temperature", seuilTemp.getValue());
        } else {
            this.data.remove("temperature");
        }

        if (humidity.isSelected()) {
            this.data.put("humidity", seuilHum.getValue());
        } else {
            this.data.remove("humidity");
        }

        if (activity.isSelected()) {
            this.data.put("activity", seuilAct.getValue());
        } else {
            this.data.remove("activity");
        }

        if (co2.isSelected()) {
            this.data.put("co2", seuilCo2.getValue());
        } else {
            this.data.remove("co2");
        }

        if (illumination.isSelected()) {
            this.data.put("illumination", seuilIll.getValue());
        } else {
            this.data.remove("illumination");
        }

        if (pression.isSelected()) {
            this.data.put("pressure", seuilPres.getValue());
        } else {
            this.data.remove("pressure");
        }
    }

    /**
     * Méthode permettant de synchroniser les salles cochées avec la configuration. (On récupère les salles de la config et on les coche)
     */
    private void chargeSallesVisuellement() {
        // Parcours les menus
        for (MenuItem categorie : choixSalles.getItems()) {
            if (categorie instanceof Menu) {
                // Parcours les salles
                for (MenuItem salle : ((Menu) categorie).getItems()) {
                    // Si la salle est dans la liste des salles, on la coche
                    if (salle instanceof CheckMenuItem) {
                        CheckMenuItem checkMenuItem = (CheckMenuItem) salle;
                        checkMenuItem.setSelected(false);
                        if (this.salle.contains(checkMenuItem.getText())) {
                            checkMenuItem.setSelected(true);
                        }
                    }
                }
            }
        }
    }

    /**
     * Méthode permettant de valider les salles cochées dans la configuration. (On récupère les salles cochées et on les ajoute à la liste des salles de la config)
     */
    private void valideSalles() {
        for (MenuItem categorie : choixSalles.getItems()) {
            if (categorie instanceof Menu) {
                for (MenuItem salle : ((Menu) categorie).getItems()) {
                    if (salle instanceof CheckMenuItem) {
                        CheckMenuItem checkMenuItem = (CheckMenuItem) salle;
                        // Si la salle est cochée, on l'ajoute à la liste des salles
                        if (checkMenuItem.isSelected()) {
                            this.salle.add(checkMenuItem.getText());
                            System.out.println("Salle ajoutée : " + checkMenuItem.getText());
                        } else {
                            this.salle.remove(checkMenuItem.getText());
                            System.out.println("Salle retirée : " + checkMenuItem.getText());
                        }
                    }
                }
            }
        }
        System.out.println("Salles : " + this.salle);
    }

    /**
     * Méthode permettant d'initialiser la configuration à partir du fichier config.json.
     * Cette initialisation lance les méthodes de chargement des salles et des données comme chargeSallesVisuellement() ou loadCheckBoxFromData()...
     */
    private void initializeConfig() {
        try {
            // Initialisation des attributs (utilisés dans la configuration)
            this.server = new String();
            this.topic = new HashSet<String>();
            this.salle = new HashSet<String>();
            this.data = new HashMap<String, Float>();

            // Créer un objet semblable au config.json
            mapper = new ObjectMapper();
            System.out.println("Répertoire courant : " + new File(".").getAbsolutePath());
            this.config = mapper.readValue(new File("../config.json"), Config.class);

            // Récupération des attributs de config.json vers les attributs de la classe
            this.server = config.getServer();
            this.topic = config.getTopic();
            this.salle = config.getSalle();
            chargeSallesVisuellement(); // Coche les salles déjà sélectionnées (celle de la config)
            this.data = config.getData();
            loadCheckBoxFromData();
            disableFieldsIfUnchecked();
            this.frequence = config.getFrequence();
            this.frequenceTextField.setText(String.valueOf(frequence));

            this.tfServer.setText(server);
            this.tfServer.setPromptText("Adresse du serveur MQTT");
            this.tfServer.setEditable(true);

            // Initialiser les propriétés de seuil à partir de la configuration
            seuilTemp.set(config.getData().getOrDefault("temperature", 0.0f));
            seuilHum.set(config.getData().getOrDefault("humidity", 0.0f));
            seuilAct.set(config.getData().getOrDefault("activity", 0.0f));
            seuilCo2.set(config.getData().getOrDefault("co2", 0.0f));
            seuilIll.set(config.getData().getOrDefault("illumination", 0.0f));
            seuilPres.set(config.getData().getOrDefault("pressure", 0.0f));

            System.out.println("Configuration chargée");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Action de sauvegarde de la configuration.
     * Cette méthode permet de sauvegarder la configuration dans le fichier config.json.
     * Elle permet aussi de réinitialiser le fichier resultatAM107.json en tronquant le fichier et écrivant un {} dedans.
     */
    @FXML
    private void dochargeConfig() {
        // Hard reset resultatAM107.json en tronquant le fichier et écrivant un {}
        // dedans
        String filePath = "../resultat/resultatAM107.json"; // Remplacez par le chemin de votre fichier
        try (FileWriter writer = new FileWriter(filePath)) {
            writer.write("{}");
            System.out.println("Le fichier a été écrit avec succès.");
        } catch (IOException e) {
            System.err.println("Erreur lors de l'écriture dans le fichier : " + e.getMessage());
        }

        ObjectMapper mapper = new ObjectMapper();
        this.config = new Config();

        config.setServer(tfServer.getText());

        valideSalles();
        config.setSalle(salle);

        config.setFrequence(frequence);

        config.setData(data);
        valideData();

        config.setTopic(topic);

        frequence = Integer.parseInt(frequenceTextField.getText());
        System.out.println("La frequence est : " + frequence);
        config.setFrequence(frequence);
        try {
            mapper.writeValue(new File("../config.json"), config);
            System.out.println("Configuration enregistrée");
            System.out.println(config);
        } catch (IOException e) {
            System.out.println("Erreur lors de l'écriture dans le fichier de configuration");
            e.printStackTrace();
        }
    }

    /**
     * Méthode permettant de lancer l'application AM107.
     * Cette méthode permet de lancer l'application AM107 en désactivant le bouton de lancement de l'application AM107.
     * Elle permet aussi de gérer le lancement du programme Python et d'ajouter un écouteur pour détecter la fermeture de la fenêtre.
     */
    @FXML
    private void doLaunchAM107() {
        System.out.println("Lancement de l'application AM107");
        this.isAm107 = true;
        this.launchAm107Btn.setDisable(true); // Désactiver le bouton

        // Ouvrir la fenêtre AM107 et obtenir son Stage
        System.out.println(this.config + "okokokoko");
        if (this.config == null) {
            System.out.println("Configuration nulle");
        }
        Stage am107Stage = this.dbmfDialogController.am107Display(this.config); // passage de la config en param

        // Mettre à jour l'état dans AppMainFrame
        this.dbmfDialogController.setAm107Running(true);

        // Gérer le lancement du programme Python
        this.dbmfDialogController.gestionLancementPython();

        // Ajouter un écouteur pour détecter la fermeture de la fenêtre
        am107Stage.setOnHiding(event -> onAm107Closed());
    }

    /**
     * Méthode permettant de gérer la fermeture de la fenêtre AM107
     * Dégrise le bouton de lancement de la fenêtre AM107
     * Set l'état d'ouverture de la fenêtre à false dans l'AppMainFrame
     */
    private void onAm107Closed() {
        System.out.println("Fenêtre AM017 fermée");
        this.isAm107 = false;
        this.launchAm107Btn.setDisable(false); // dégrise le bouton de lancement
        System.out.println("Valeur du boolean isAM107 apres la fermeture de la fenetre : " + this.isAm107);
        this.dbmfDialogController.setAm107Running(isAm107);
        this.dbmfDialogController.testIfWindowsAreAllClosed();
        // Set l'état d'ouverture de la fenêtre à false
        // dans l'AppMainFrame
    }

    /**
     * Méthode permettant de lancer l'application SolarEdge.
     * Cette méthode permet de lancer l'application SolarEdge en désactivant le bouton de lancement de l'application SolarEdge.
     * Elle permet aussi de gérer le lancement du programme Python et d'ajouter un écouteur pour détecter la fermeture de la fenêtre.
     */
    @FXML
    private void doLaunchSolarEdge() {
        System.out.println("Lancement de l'application Solar Edge");
        this.isSolarEdge = true;
        this.launchSolarEdgeBtn.setDisable(true); // Désactiver le bouton

        // Ouvrir la fenêtre Solar Edge et obtenir son Stage
        Stage solarEdgeStage = this.dbmfDialogController.solarDisplay();

        // Mettre à jour l'état dans AppMainFrame
        this.dbmfDialogController.setSolarEdgeRunning(true);

        // Gérer le lancement du programme Python
        this.dbmfDialogController.gestionLancementPython();

        // Ajouter un écouteur pour détecter la fermeture de la fenêtre
        solarEdgeStage.setOnHiding(event -> onSolarEdgeClosed());
    }

    /**
     * Méthode permettant de gérer la fermeture de la fenêtre solarEdge
     * Dégrise le bouton de lancement de la fenêtre solarEdge
     * Set l'état d'ouverture de la fenêtre à false dans l'AppMainFrame
     */
    private void onSolarEdgeClosed() {
        System.out.println("Fenêtre Solar Edge fermée");
        this.isSolarEdge = false;
        this.launchSolarEdgeBtn.setDisable(false); // dégrise le bouton de lancement
        System.out.println("Valeur du boolean isSolarEdge apres la fermeture de la fenetre : " + this.isSolarEdge);
        this.dbmfDialogController.setSolarEdgeRunning(this.isSolarEdge); // Set l'état d'ouverture de la fenêtre à false
                                                                         // dans l'AppMainFrame
        this.dbmfDialogController.testIfWindowsAreAllClosed();
    }

    /**
     * Méthode de debug permettant d'afficher les attributs de la classe.
     */
    @FXML
    private void afficheAttributs() {
        System.out.println("Serveur : " + tfServer.getText());
        System.out.println("Topic : " + topic);
        System.out.println("Salle : " + salle);
        System.out.println("Frequence : " + frequence);
        System.out.println("Data : " + data);
    }

    /**
     * Action permettant de tester la connexion au serveur MQTT en appelant la méthode testConnectionMqtt().
     */
    @FXML
    private void testConnection() {
        Thread t = new Thread(() -> testConnectionMqtt());
        t.start();
    }

    /**
     * Méthode permettant de tester la connexion au serveur MQTT.
     * Cette méthode permet de tester la connexion au serveur MQTT en créant un client MQTT et en essayant de se connecter.
     * Elle permet aussi d'afficher un message de réussite ou d'échec de la connexion.
     */
    private void testConnectionMqtt() {
        MqttClient client = null;
        try {
            client = new MqttClient("tcp://" + tfServer.getText(), UUID.randomUUID().toString());
            client.connect();
            System.out.println("Connexion réussie");
            javafx.application.Platform.runLater(() -> testResuLabel.setText("Connexion réussie"));
        } catch (Exception e) {
            System.out.println("Connexion échouée");
            javafx.application.Platform.runLater(() -> testResuLabel.setText("Connexion échouée"));
        } finally {
            if (client != null) {
                try {
                    client.disconnect();
                    client.close();
                } catch (Exception e) {
                    System.out.println("Essayez avec un bon nom de serveur.");
                }
            }
        }
    }

    /*
     * Action menu quitter. Demander une confirmation puis fermer la fenêtre (donc
     * l'application car fenêtre principale).
     */
    @FXML
    private void doQuit() {

        if (AlertUtilities.confirmYesCancel(this.containingStage, "Quitter l'application",
                "Etes vous sur de vouloir quitter l'appli ?", null, AlertType.CONFIRMATION)) {
            this.containingStage.close();
        }
    }

}
