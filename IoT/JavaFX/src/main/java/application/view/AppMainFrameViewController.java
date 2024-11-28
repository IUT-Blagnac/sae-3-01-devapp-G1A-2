package application.view;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.UUID;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import application.control.AppMainFrame;
import application.tools.AlertUtilities;
import javafx.beans.property.FloatProperty;
import javafx.beans.property.SimpleFloatProperty;
import javafx.fxml.FXML;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.text.Text;
import javafx.scene.control.CheckBox;
import javafx.scene.control.CheckMenuItem;
import javafx.scene.control.Label;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;
import javafx.util.StringConverter;
import javafx.util.converter.IntegerStringConverter;

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
    private TextField frequencTextField;

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


    // Actions

    @FXML
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

    private void bindSeuilFields() {
        bindTextFieldToFloatProperty(seuilTempField, seuilTemp);
        bindTextFieldToFloatProperty(seuilHumField, seuilHum);
        bindTextFieldToFloatProperty(seuilActField, seuilAct);
        bindTextFieldToFloatProperty(seuilCo2Field, seuilCo2);
        bindTextFieldToFloatProperty(seuilIllField, seuilIll);
        bindTextFieldToFloatProperty(seuilPresField, seuilPres);
    }

    private void disableFieldsIfUnchecked() {
        seuilTempField.setDisable(!temperature.isSelected());
        seuilHumField.setDisable(!humidity.isSelected());
        seuilActField.setDisable(!activity.isSelected());
        seuilCo2Field.setDisable(!co2.isSelected());
        seuilIllField.setDisable(!illumination.isSelected());
        seuilPresField.setDisable(!pression.isSelected());
    }

    private void loadCheckBoxFromData(){
        temperature.setSelected(data.containsKey("temperature"));
        humidity.setSelected(data.containsKey("humidity"));
        activity.setSelected(data.containsKey("activity"));
        co2.setSelected(data.containsKey("co2"));
        illumination.setSelected(data.containsKey("illumination"));
        pression.setSelected(data.containsKey("pression"));
    }

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
            this.data.put("pression", seuilPres.getValue());
        } else {
            this.data.remove("pression");
        }
    }

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
                        }
                        else {
                            this.salle.remove(checkMenuItem.getText());
                            System.out.println("Salle retirée : " + checkMenuItem.getText());
                        }
                    }
                }
            }
        }
        System.out.println("Salles : " + this.salle);
    }

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
            config = mapper.readValue(new File("../config.json"), Config.class);
    
            // Récupération des attributs de config.json vers les attributs de la classe
            this.server = config.getServer();
            this.topic = config.getTopic();
            this.salle = config.getSalle();
            chargeSallesVisuellement(); // Coche les salles déjà sélectionnées (celle de la config)
            this.data = config.getData();
            loadCheckBoxFromData();
            disableFieldsIfUnchecked();
            this.frequence = config.getFrequence();
            this.frequencTextField.setText(String.valueOf(frequence));

            this.tfServer.setText(server);
            this.tfServer.setPromptText("Adresse du serveur MQTT");
            this.tfServer.setEditable(true);

            // Initialiser les propriétés de seuil à partir de la configuration
            seuilTemp.set(config.getData().getOrDefault("temperature", 0.0f));
            seuilHum.set(config.getData().getOrDefault("humidity", 0.0f));
            seuilAct.set(config.getData().getOrDefault("activity", 0.0f));
            seuilCo2.set(config.getData().getOrDefault("co2", 0.0f));
            seuilIll.set(config.getData().getOrDefault("illumination", 0.0f));
            seuilPres.set(config.getData().getOrDefault("pression", 0.0f));
    
            System.out.println("Configuration chargée");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @FXML
    private void dechargeConfig() {
        ObjectMapper mapper = new ObjectMapper();
        Config config = new Config();
        config.setServer(tfServer.getText());

        valideSalles();
        config.setSalle(salle);

        config.setFrequence(frequence);

        config.setData(data);
        valideData();

        config.setTopic(topic);

        frequence = Integer.parseInt(frequencTextField.getText());
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

    @FXML
    private void afficheAttributs() {
        System.out.println("Serveur : " + tfServer.getText());
        System.out.println("Topic : " + topic);
        System.out.println("Salle : " + salle);
        System.out.println("Frequence : " + frequence);
        System.out.println("Data : " + data);
    }

    @FXML
    private void doLaunchSolarEdge() {
        System.out.println("Lancement de l'application Solar Edge");
        this.dbmfDialogController.solarDisplay();

    }

    @FXML
    private void testConnection() {
        String broker = tfServer.getText();
        String clientId = UUID.randomUUID().toString();
        System.out.println("Tentative de connexion au broker MQTT : " + broker + " avec l'ID client : " + clientId);
    
        try {
            // Création du client MQTT
            MqttClient client = new MqttClient(broker, clientId);
            
            // Configuration de la callback pour traiter les événements MQTT
            client.setCallback(new MqttCallback() {
                @Override
                public void connectionLost(Throwable cause) {
                    testResuLabel.setText("Connexion perdue !");
                }
    
                @Override
                public void messageArrived(String topic, MqttMessage message) throws Exception {
                    testResuLabel.setText("Succès : Message reçu : " + new String(message.getPayload()));
                }
    
                @Override
                public void deliveryComplete(IMqttDeliveryToken token) {
                    System.out.println("Message envoyé... (Pas utile dans l'interface)");
                }
            });
    
            // Connexion au broker
            client.connect();
            System.out.println("Connexion au broker réussie !");
            
            // Souscription à un topic
            String topic = "#";
            int qos = 1; // Qualité de service
            client.subscribe(topic, qos);
            System.out.println("Souscription au topic : " + topic);
    
            // Affiche un résultat dans l'interface
            testResuLabel.setText("Connexion et souscription réussies.");
    
            // Ferme le client après 5 secondes
            new Thread(() -> {
                try {
                    Thread.sleep(5000); // Attendre 5 secondes
                    if (client.isConnected()) {
                        client.disconnect();
                        System.out.println("Client MQTT déconnecté.");
                        testResuLabel.setText("Client MQTT fermé après 5 secondes.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    System.err.println("Erreur lors de la fermeture du client MQTT : " + e.getMessage());
                }
            }).start();
    
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Erreur lors de la connexion MQTT : " + e.getMessage());
            testResuLabel.setText("Erreur : " + e.getMessage());
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
