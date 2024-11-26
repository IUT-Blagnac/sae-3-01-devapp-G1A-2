package application.view;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;

import application.control.AppMainFrame;
import application.control.SolarEdgeBorderPane;
import application.tools.AlertUtilities;
import javafx.fxml.FXML;
import javafx.scene.chart.LineChart;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;
import model.Config;

public class SolarEdgeViewController {

    // private ArrayList<String> topic;
    // private String server;
    // private List<String> salle = new ArrayList<>();
    // private int frequence;
    // private HashMap<String, Integer> data;
    // private ObjectMapper mapper;
    // private Config config;

    // Contrôleur de Dialogue associé à AppMainFrameController
    private SolarEdgeBorderPane sEdgeBorderPane;

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
    public void initContext(Stage _containingStage, SolarEdgeBorderPane _dbmf) {
        this.sEdgeBorderPane = _dbmf;
        this.containingStage = _containingStage;
        this.configure();
    }

    /**
     * Affichage de la fenêtre.
     */
    public void displayDialog() {
        this.containingStage.showAndWait();
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
    private LineChart<String, Number> graphicSolar; // changer le type String au besoin

    // @FXML
    // private Button stopThreadBtn;

    // @FXML
    // private TextField tfServer;
    // @FXML
    // private Button buttonTestConnection;

    // @FXML
    // private Button launchSolarEdgeBtn;

    // Actions

    @FXML
    public void initialize() {
        System.out.println("Controlleur chargé avec succès");
        // loadConfig();
    }

    // private void loadConfig() {
    // this.tfServer.setText("localhost");
    // try {
    // mapper = new ObjectMapper();
    // config = mapper.readValue(new File("../config.json"), Config.class);
    // salle = config.getSalle();
    // tfServer.setText(config.getServer());
    // tfServer.setEditable(true);
    // tfServer.setDisable(false);
    // tfServer.setPromptText(config.getServer());
    // config.setSalle(salle);
    // } catch (IOException e) {
    // e.printStackTrace();
    // }
    // }

    // @FXML
    // private void saveConfig() {
    // ObjectMapper mapper = new ObjectMapper();
    // Config config = new Config();
    // config.setServer(tfServer.getText());
    // config.setSalle(salle);
    // config.setFrequence(frequence);
    // config.setData(data);
    // config.setTopic(topic);
    // try {
    // mapper.writeValue(new File("../../config.json"), config);
    // System.out.println("Configuration enregistrée");
    // System.out.println(config);
    // } catch (IOException e) {
    // System.out.println("Erreur lors de l'écriture dans le fichier de
    // configuration");
    // e.printStackTrace();
    // }
    // }

    /**
     * @FXML
     *       private void testConnection() {
     *       String broker = tfServer.getText();
     *       String clientId = UUID.randomUUID().toString();
     *       MqttClient client = new MqttClient(broker, clientId);
     *       String topic = "#";
     *       int qos = 1;
     *       client.subscribe(topic, qos);
     * 
     *       client.setCallback(new MqttCallback() {
     * @Override
     *           public void connectionLost(Throwable cause) {
     *           System.out.println("Connection lost");
     *           }
     * 
     * @Override
     *           public void messageArrived(String topic, MqttMessage message)
     *           throws Exception {
     *           System.out.println("Message arrived: " + new
     *           String(message.getPayload()));
     *           }
     * 
     * @Override
     *           public void deliveryComplete(IMqttDeliveryToken token) {
     *           System.out.println("Delivery complete");
     *           }
     *           });
     *           }
     */

    /*
     * Action menu quitter. Demander une confirmation puis fermer la fenêtre (donc
     * l'application car fenêtre principale).
     */
    @FXML
    private void doQuit() {

        if (AlertUtilities.confirmYesCancel(this.containingStage, "Quitter l'application",
                "Etes vous sur de vouloir quitter l'appli ?", null, AlertType.CONFIRMATION)) {
            this.sEdgeBorderPane.doStopSolarEdge();
            this.containingStage.close();
        }
    }

    // @FXML
    // private void stopThread() {
    // this.sEdgeBorderPane.doStopSolarEdge();
    // }

}
