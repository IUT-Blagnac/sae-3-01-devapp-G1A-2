package application.view;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import application.control.Am107BorderPane;
import application.tools.AlertUtilities;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.fxml.FXML;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.MenuBar;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;
import javafx.util.Duration;
import model.RootData;
import model.SalleData;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Am107ViewController {

    private Am107BorderPane am107BorderPane;
    private Stage containingStage;
    private Map<String, SalleData> sallesCapteurs;
    private Map<String, JsonNode> alertePrecedentes = new HashMap<>();
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm"); //Pour plus tard, j'attend les autres commit avant de toucher à ça

    @FXML
    private ScrollPane scrollPaneGraphiques;

    @FXML
    private VBox vBoxAlerte;

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
        getAllAlerte();
        Timeline timeline = new Timeline(new KeyFrame(Duration.seconds(30), event -> updateAlertes()));
        timeline.setCycleCount(Timeline.INDEFINITE);
        timeline.play();
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
            xAxis.setLabel("Date");
            // Elargir l'axe des ordonnées 
            xAxis.setUpperBound(xAxis.getBoundsInLocal().getWidth()+100);
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
                        XYChart.Data<Number, Number> dataPoint = new XYChart.Data<>(i, data.get(i));
                        
                        // Set the hoverable node
                        dataPoint.setNode(createHoverableNode(salle));
                
                        series.getData().add(dataPoint);
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
    
        List<String> capteurs = List.of("temperature", "humidity", "co2", "illumination", "activity", "pressure");
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
                    series.getData().clear(); // Clear old data before updating
                    for (int j = 0; j < data.size(); j++) {
                        XYChart.Data<Number, Number> dataPoint = new XYChart.Data<>(j, data.get(j));
                        
                        // Set the hoverable node
                        dataPoint.setNode(createHoverableNode(salle));
                        
                        series.getData().add(dataPoint);
                    }
                }
            }
        }
    }
    
    private javafx.scene.Node createHoverableNode(String salle) {
        javafx.scene.control.Label label = new javafx.scene.control.Label(salle);
        label.setStyle("-fx-background-color: white; -fx-padding: 5px; -fx-border-color: black;");
        label.setVisible(false);
    
        // Le cercle utilisé pour représenter le point
        javafx.scene.shape.Circle point = new javafx.scene.shape.Circle(5);
        point.setStyle("-fx-fill: blue; -fx-stroke: black;");
    
        // Gestionnaire pour afficher et cacher le label
        point.setOnMouseEntered(event -> label.setVisible(true));
        point.setOnMouseExited(event -> label.setVisible(false));
    
        // Utilisation d'un groupe pour encapsuler le point et le label
        javafx.scene.Group group = new javafx.scene.Group(point, label);
    
        // Déplacement du label pour qu'il ne chevauche pas le point
        label.translateXProperty().bind(point.translateXProperty().add(10));
        label.translateYProperty().bind(point.translateYProperty().subtract(10));
    
        return group;
    }

    public void getAllAlerte() {
        try {
            // Lire le fichier JSON
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode data = objectMapper.readTree(new File("../resultat/alerteAM107.json"));

            // Obtenir les noms des salles
            List<String> keys = new ArrayList<>();
            data.fieldNames().forEachRemaining(keys::add);

            // Liste pour suivre les menus et salles modifiés
            Set<String> menusModifies = new HashSet<>();
            Set<String> sallesModifiees = new HashSet<>();

            // Vérifier les changements depuis la dernière mise à jour
            for (String key : keys) {
                JsonNode currentData = data.get(key);
                JsonNode alertePrecedentesNode = alertePrecedentes.get(key);

                if (!currentData.equals(alertePrecedentesNode)) { // Si les données ont changé
                    sallesModifiees.add(key);

                    // Identifier le menu parent
                    if (key.startsWith("B")) menusModifies.add("B");
                    else if (key.startsWith("C")) menusModifies.add("C");
                    else if (key.startsWith("E")) menusModifies.add("E");
                    else menusModifies.add("Autres");
                }
            }

            // Mettre à jour les données précédentes
            alertePrecedentes.clear();
            keys.forEach(key -> alertePrecedentes.put(key, data.get(key)));

            // Séparer les salles par préfixe
            List<String> B = keys.stream().filter(key -> key.startsWith("B")).collect(Collectors.toList());
            List<String> C = keys.stream().filter(key -> key.startsWith("C")).collect(Collectors.toList());
            List<String> E = keys.stream().filter(key -> key.startsWith("E")).collect(Collectors.toList());
            List<String> Other = keys.stream()
                    .filter(key -> !key.startsWith("A") && !key.startsWith("B") && !key.startsWith("C") && !key.startsWith("E"))
                    .collect(Collectors.toList());

            // Listes des préfixes pour créer les menus
            List<String> prefixes = Arrays.asList("B", "C", "E", "Autres");

            // Création des menus
            for (String prefix : prefixes) {
                Menu menu = new Menu(prefix);

                // Mettre en valeur le menu si des salles ont changé
                if (menusModifies.contains(prefix)) {
                    menu.setStyle("-fx-text-fill: green;");
                }

                List<String> salles;
                switch (prefix) {
                    case "B":
                        salles = B;
                        break;
                    case "C":
                        salles = C;
                        break;
                    case "E":
                        salles = E;
                        break;
                    default:
                        salles = Other;
                        break;
                }

                for (String salle : salles) {
                    MenuItem menuItem = new MenuItem(salle);

                    // Mettre en valeur la salle si elle a changé
                    if (sallesModifiees.contains(salle)) {
                        menuItem.setStyle("-fx-font-weight: bold; -fx-text-fill: green;");
                    }

                    // Ajouter un gestionnaire d'événements pour afficher les alertes
                    menuItem.setOnAction(event -> afficherToutesAlertesPourSalle(data, salle));
                    menu.getItems().add(menuItem);
                }

                MenuBar menuBar = new MenuBar();
                menuBar.getMenus().add(menu);
                vBoxAlerte.getChildren().add(menuBar);
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Erreur lors de la lecture ou du traitement du fichier JSON.");
        }
    }

    // Méthode pour afficher toutes les alertes d'une salle spécifique
    private void afficherToutesAlertesPourSalle(JsonNode data, String salle) {
        try {
            // Récupérer les données de la salle
            JsonNode alerte = data.get(salle);

            // Construire un message contenant toutes les alertes
            StringBuilder alertesMessage = new StringBuilder("Alertes pour la salle " + salle + " :\n");
            if (alerte != null) {
                alerte.fields().forEachRemaining(entry -> {
                    String key = entry.getKey();
                    JsonNode values = entry.getValue();
                    alertesMessage.append(key).append(" : ").append(values.toString()).append("\n");
                });
            } else {
                alertesMessage.append("Aucune alerte.");
            }

            // Afficher les alertes dans une boîte de dialogue
            Alert alert = new Alert(Alert.AlertType.INFORMATION);
            alert.setTitle("Détails des Alertes");
            alert.setHeaderText("Salle : " + salle);
            alert.setContentText(alertesMessage.toString());
            alert.showAndWait();

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Erreur lors de l'affichage des alertes pour la salle " + salle);
        }
    }

    /**
    * Méthode pour mettre à jour les alertes dynamiquement.
    */
    public void updateAlertes() {
        vBoxAlerte.getChildren().clear();
        getAllAlerte();
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
