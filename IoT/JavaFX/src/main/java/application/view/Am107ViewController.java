package application.view;

import java.io.File;
import java.util.List;
import java.util.Map;

import application.control.Am107BorderPane;
import application.tools.AlertUtilities;
import javafx.fxml.FXML;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Menu;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;
import model.RootData;
import model.SalleData;

import com.fasterxml.jackson.databind.ObjectMapper;

public class Am107ViewController {

    private Am107BorderPane am107BorderPane;
    private Stage containingStage;
    private Map<String, SalleData> sallesCapteurs;

    @FXML
    private Menu menuBar;

    @FXML
    private ScrollPane scrollPaneGraphiques;

    /**
     * Initialisation du contrôleur de vue AppMainFrameController.
     *
     * @param _containingStage Stage contenant le fichier XML contrôlé.
     * @param _dbmf            Contrôleur de navigation principal.
     */
    public void initContext(Stage _containingStage, Am107BorderPane _dbmf) {
        this.am107BorderPane = _dbmf;
        this.containingStage = _containingStage;
        this.configure();
    }

    /**
     * Affichage de la fenêtre.
     */
    public void displayDialog() {
        this.containingStage.show();
    }

    /**
     * Configuration des événements de fermeture.
     */
    private void configure() {
        this.containingStage.setOnCloseRequest(this::closeWindow);
    }

    /**
     * Méthode de fermeture de la fenêtre.
     *
     * @param e Evénement de fermeture.
     */
    private void closeWindow(WindowEvent e) {
        if (AlertUtilities.confirmYesCancel(this.containingStage, "Quitter l'application",
                "Etes-vous sûr de vouloir quitter la fenêtre ?", null, AlertType.CONFIRMATION)) {
            this.am107BorderPane.doStopAm107();
            this.containingStage.close();
            System.out.println("Fenêtre AM107 fermée.");
        }
        e.consume();
    }

    /**
     * Initialisation des données et des graphiques.
     */
    public void initialize() {
        System.out.println("Contrôleur chargé avec succès.");
        loadSallesEtCapteursFromResultatJSON();
        initializeGraphiquesParCapteur();
    }

    /**
     * Chargement des salles et capteurs à partir du fichier JSON.
     */
    private void loadSallesEtCapteursFromResultatJSON() {
        System.out.println("Chargement des salles depuis le fichier resultatAM107.json...");
        ObjectMapper mapper = new ObjectMapper();
        try {
            RootData rootData = mapper.readValue(new File("../resultat/resultatAM107.json"), RootData.class);
            this.sallesCapteurs = rootData.getSalles();
            System.out.println("Salles et capteurs chargés avec succès : " + this.sallesCapteurs.keySet());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Initialisation des graphiques pour chaque capteur.
     */
    private void initializeGraphiquesParCapteur() {
        VBox vboxGraphiques = new VBox();
        this.scrollPaneGraphiques.setContent(vboxGraphiques);

        // Liste des capteurs à gérer
        List<String> capteurs = List.of("temperature", "humidity", "co2", "illumination", "activity", "pression");

        for (String capteur : capteurs) {
            NumberAxis xAxis = new NumberAxis();
            NumberAxis yAxis = new NumberAxis();
            xAxis.setLabel("Temps");
            yAxis.setLabel(capteur);

            LineChart<Number, Number> lineChart = new LineChart<>(xAxis, yAxis);
            lineChart.setTitle("Graphique de " + capteur);

            // Ajouter les données de chaque salle au graphique
            for (String salle : this.sallesCapteurs.keySet()) {
                SalleData salleData = this.sallesCapteurs.get(salle);

                XYChart.Series<Number, Number> series = new XYChart.Series<>();
                series.setName(salle);

                List<Double> data = null;
                switch (capteur) {
                    case "temperature":
                        data = salleData.getTemperature();
                        break;
                    case "humidity":
                        data = salleData.getHumidity();
                        break;
                    case "co2":
                        data = salleData.getCo2();
                        break;
                    case "illumination":
                        data = salleData.getIllumination();
                        break;
                    case "activity":
                        data = salleData.getActivity();
                        break;
                    case "pression":
                        data = salleData.getPression();
                        break;
                }

                if (data != null) {
                    for (int i = 0; i < data.size(); i++) {
                        series.getData().add(new XYChart.Data<>(i, data.get(i)));
                    }
                    lineChart.getData().add(series);
                }
            }

            vboxGraphiques.getChildren().add(lineChart);
        }
    }

    public void refreshGraphiques() {
        System.out.println("Rafraîchissement des graphiques...");
        loadSallesEtCapteursFromResultatJSON(); // Recharger les données depuis le JSON.
    
        List<String> capteurs = List.of("temperature", "humidity", "co2", "illumination", "activity", "pression");
        VBox vboxGraphiques = (VBox) this.scrollPaneGraphiques.getContent();
    
        for (int i = 0; i < capteurs.size(); i++) {
            String capteur = capteurs.get(i);
            LineChart<Number, Number> lineChart;
    
            // Vérifier si le graphique existe déjà pour ce capteur.
            if (i < vboxGraphiques.getChildren().size()) {
                lineChart = (LineChart<Number, Number>) vboxGraphiques.getChildren().get(i);
            } else {
                // Si le graphique n'existe pas encore, le créer.
                NumberAxis xAxis = new NumberAxis();
                NumberAxis yAxis = new NumberAxis();
                xAxis.setLabel("Temps");
                yAxis.setLabel(capteur);
    
                lineChart = new LineChart<>(xAxis, yAxis);
                lineChart.setTitle("Graphique de " + capteur);
                lineChart.setLegendVisible(true); // Assure que la légende est toujours visible.
                vboxGraphiques.getChildren().add(lineChart);
            }
    
            // Rafraîchir ou ajouter les séries pour les salles.
            for (String salle : this.sallesCapteurs.keySet()) {
                SalleData salleData = this.sallesCapteurs.get(salle);
    
                XYChart.Series<Number, Number> series = lineChart.getData().stream()
                        .filter(s -> s.getName().equals(salle))
                        .findFirst()
                        .orElseGet(() -> {
                            // Ajouter une nouvelle série si elle n'existe pas encore.
                            XYChart.Series<Number, Number> newSeries = new XYChart.Series<>();
                            newSeries.setName(salle);
                            lineChart.getData().add(newSeries);
                            return newSeries;
                        });
    
                // Récupérer les nouvelles données pour ce capteur et cette salle.
                List<Double> data = null;
                switch (capteur) {
                    case "temperature":
                        data = salleData.getTemperature();
                        break;
                    case "humidity":
                        data = salleData.getHumidity();
                        break;
                    case "co2":
                        data = salleData.getCo2();
                        break;
                    case "illumination":
                        data = salleData.getIllumination();
                        break;
                    case "activity":
                        data = salleData.getActivity();
                        break;
                    case "pression":
                        data = salleData.getPression();
                        break;
                }
    
                // Mettre à jour les données dans la série.
                if (data != null) {
                    int currentSize = series.getData().size(); // Taille actuelle de la série.
                    for (int j = currentSize; j < data.size(); j++) {
                        XYChart.Data<Number, Number> dataPoint = new XYChart.Data<>(j, data.get(j));
                        dataPoint.setNode(createHoverableNode(salle)); // Associe le noeud interactif.
                        series.getData().add(dataPoint);
                    }
                }
            }
        }
    }
    
    /**
     * Crée un noeud interactif pour afficher la salle lors du survol.
     *
     * @param salle Nom de la salle associée au point.
     * @return Node personnalisé avec tooltip pour la salle.
     */
    private javafx.scene.Node createHoverableNode(String salle) {
        javafx.scene.control.Label label = new javafx.scene.control.Label();
        label.setStyle("-fx-background-color: white; -fx-padding: 5px; -fx-border-color: black;");
        label.setText(salle);
        label.setVisible(false);
    
        // Event de souris pour afficher la salle au survol.
        javafx.scene.Group group = new javafx.scene.Group(label);
        group.setOnMouseEntered(e -> label.setVisible(true));
        group.setOnMouseExited(e -> label.setVisible(false));
    
        return group;
    }
}
