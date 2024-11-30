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
import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.scene.chart.CategoryAxis;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ResourceBundle;

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
    private int sizeTimeStamp;

    @FXML
    private LineChart<String, Integer> lineChart;

    @FXML
    private CategoryAxis xAxis; // Axe des catégories (dates)

    @FXML
    private NumberAxis yAxis; // Axe numérique (énergie)

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
        this.sizeTimeStamp = 0;
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
    // System.out.println("Controlleur chargé avec succès");
    // // loadConfig();
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
                "Etes vous sur de vouloir quitter la fenêtre ?", null, AlertType.CONFIRMATION)) {
            this.sEdgeBorderPane.doStopSolarEdge();
            this.containingStage.close();
        }
    }

    /**
     * initialisation du graphique
     */
    public void initialize() {
        System.out.println("Controlleur chargé avec succès");
        this.loadUpdateHistoric();

    }

    /**
     * Méthode permettant de charger l'historique des données du fichier
     * résultat python
     */
    public void loadUpdateHistoric() {
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(new File("../resultat/resultatSolar.json"));
            JsonNode currentPower = root.get("currentPower");
            JsonNode lastUpdateTime = root.get("lastUpdateTime");
            if (currentPower != null && lastUpdateTime != null) {

                if (this.sizeTimeStamp != lastUpdateTime.size()) {
                    this.sizeTimeStamp = lastUpdateTime.size();

                    XYChart.Series<String, Integer> serie = new XYChart.Series<>();
                    serie.setName("Évolution de l'énergie récupérée");

                    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss"); // Format uniquement pour
                                                                                               // heure
                                                                                               // et minute et secondes

                    for (int i = 0; i < lastUpdateTime.size(); i++) {
                        String rawDate = lastUpdateTime.get(i).asText();
                        String formattedTime = extractTime(rawDate, timeFormatter); // Appel de la fonction pour
                                                                                    // extraire
                                                                                    // l'heure

                        double energie = currentPower.get(i).asDouble();
                        System.out.println("Heure : " + formattedTime + ", Énergie : " + energie);

                        serie.getData().add(new XYChart.Data<>(formattedTime, (int) energie));
                    }

                    Platform.runLater(() -> {
                        lineChart.getData().clear(); // Efface les anciennes données
                        xAxis.getCategories().clear(); // Nettoie les anciennes catégories
                        lineChart.getData().add(serie); // Ajoute la nouvelle série
                        xAxis.setLabel("Heure (h:m:s)"); // Définit le label de l'axe X
                    });
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Fonction utilitaire pour extraire l'heure et les minutes d'une date ISO.
     *
     * @param rawDate   La date brute sous forme de chaîne.
     * @param formatter Le format souhaité pour l'heure.
     * @return L'heure et les minutes formatées.
     */
    private String extractTime(String rawDate, DateTimeFormatter formatter) {
        try {
            // Créer un formatteur adapté au format "2024-11-27 10:48:25"
            DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            LocalDateTime dateTime = LocalDateTime.parse(rawDate, inputFormatter); // Parse avec le format personnalisé
            return dateTime.format(formatter); // Format vers HH:mm
        } catch (Exception e) {
            System.err.println("Erreur de formatage de la date : " + rawDate);
            return rawDate; // Retourne la date brute en cas d'échec
        }
    }

}
