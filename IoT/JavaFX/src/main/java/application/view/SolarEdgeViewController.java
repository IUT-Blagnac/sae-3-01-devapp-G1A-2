package application.view;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

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

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.XYChart;

import java.net.URL;
import java.util.ResourceBundle;

public class SolarEdgeViewController implements Initializable {

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

    @FXML
    private LineChart<String, Integer> lineChart;

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

    // @FXML
    // public void initialize() {
    //     System.out.println("Controlleur chargé avec succès");
    //     // loadConfig();
    // }

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

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        System.out.println("Controlleur chargé avec succès");

        // Création et ajout de données fictives au graphique
        XYChart.Series<String, Integer> serie = new XYChart.Series<>();
        serie.setName("Évolution de l'énergie récupérée");

        try {
            ObjectMapper mapper = new ObjectMapper();
        
            JsonNode root = mapper.readTree(new File("../resultat/resultatSolar.json"));
            JsonNode currentPower = root.get("currentPower");
            JsonNode lastUpdateTime = root.get("lastUpdateTime");

            if (lastUpdateTime.size() == currentPower.size()) {
                for (int i = 0; i<lastUpdateTime.size(); i++) {
                    String date = lastUpdateTime.get(i).asText();
                    double energie = currentPower.get(i).asDouble();

                    System.out.println("Affichages des données");
                    System.out.println("Date : " + date);
                    System.out.println("Energie : " + energie);

                    // Ajouter les valeurs dans les données graphiques
                    serie.getData().add(new XYChart.Data<>(date, (int) energie));
                }
            }
            else {
                System.out.println("Les tailles des tableaux ne sont pas égales");
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        lineChart.getData().add(serie);

        // // Ajout de données fictives (heures de la journée et watts)
        // serie.getData().add(new XYChart.Data<>("00:00", 50));
        // serie.getData().add(new XYChart.Data<>("02:00", 75));
        // serie.getData().add(new XYChart.Data<>("04:00", 60));
        // serie.getData().add(new XYChart.Data<>("06:00", 90));
        // serie.getData().add(new XYChart.Data<>("08:00", 120));
        // serie.getData().add(new XYChart.Data<>("10:00", 200));
        // serie.getData().add(new XYChart.Data<>("12:00", 300));
        // serie.getData().add(new XYChart.Data<>("14:00", 250));
        // serie.getData().add(new XYChart.Data<>("16:00", 400));
        // serie.getData().add(new XYChart.Data<>("18:00", 350));
        // serie.getData().add(new XYChart.Data<>("20:00", 220));
        // serie.getData().add(new XYChart.Data<>("22:00", 150));

        // // Ajouter la série au graphique
        // lineChart.getData().add(serie);
    }

}
