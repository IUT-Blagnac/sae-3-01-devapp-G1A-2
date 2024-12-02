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
import javafx.scene.control.MenuItem;
import javafx.scene.control.ScrollPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;
import model.RootData;
import model.SalleData;

import com.fasterxml.jackson.databind.ObjectMapper;

public class Am107ViewController {

    // Contrôleur de Dialogue associé à AppMainFrameController
    private Am107BorderPane am107BorderPane;

    // Fenêtre physique ou est la scène contenant le fichier xml contrôlé par this
    private Stage containingStage;

    private Map<String, SalleData> sallesCapteurs;

    @FXML
    private Menu menuBar;

    @FXML
    private ScrollPane scrollPaneGraphiques;

    @FXML
    private ScrollPane scrollPaneAlertes;

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
    public void initContext(Stage _containingStage, Am107BorderPane _dbmf) {
        this.am107BorderPane = _dbmf;
        this.containingStage = _containingStage;
        this.configure();
    }

    /**
     * Affichage de la fenêtre.
     */
    public void displayDialog() {
        // this.containingStage.showAndWait();
        this.containingStage.show(); // test en show uniquement pour éviter l'attente bloquante
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

    // Actions

    @FXML
    private void doQuit() {
        if (AlertUtilities.confirmYesCancel(this.containingStage, "Quitter l'application",
                "Etes-vous sûr de vouloir quitter la fenêtre ?", null, AlertType.CONFIRMATION)) {
            this.containingStage.close(); // Ferme la fenêtre correctement
            System.out.println("Fenêtre AM107 fermée, bouton réactivé");
        }
    }

    /**
     * Méthode permettant de charger l'historique des données du fichier résultat
     * python
     * initialisation du graphique
     */
    public void initialize() {
        System.out.println("Controlleur chargé avec succès");
        loadSallesEtCapteursFromResultatJSON();
        loadSalleFiltre();
        initalizeGraphique();
    }

    /**
     * Initialisation des graphiques pour chaque salle et chaque capteur
     */
    private void initalizeGraphique() {
        VBox vboxGraphiques = new VBox();
        this.scrollPaneGraphiques.setContent(vboxGraphiques);

        // Ici on initialise les hboxes pour chaque salle (une hbox est une sorte de
        // container horizontal)
        for (String salle : this.sallesCapteurs.keySet()) {
            HBox hboxSalle = new HBox();
            hboxSalle.setSpacing(10);

            for (String capteur : this.sallesCapteurs.get(salle).getCapteurs().keySet()) {
                addGraphiqueToHBox(hboxSalle, salle, capteur); // Génére un graphique pour chaque capteur
            }

            vboxGraphiques.getChildren().add(hboxSalle); // Ajoute le container de la salle à la liste des containers
                                                         // (en gros la VBox est un gros container vertical qui contient
                                                         // les containers horizontaux de chaque salle (comme si on
                                                         // empiler des rectangles))
        }
    }

    /**
     * Chargement des salles et des capteurs à partir du fichier JSON
     */
    public void loadSallesEtCapteursFromResultatJSON() {
        System.out.println("Chargement des salles depuis le fichier resultatAM107.json");
        ObjectMapper mapper = new ObjectMapper();
        try {
            System.out.println("Répertoire courant : " + new File(".").getAbsolutePath());

            RootData rootData = mapper.readValue(new File("../resultat/resultatAM107.json"), RootData.class);

            // sallesCapteurs contient un dict de salles et de capteurs disponibles
            this.sallesCapteurs = rootData.getSalles();
            System.out.println("Salles et capteurs chargés avec succès");
            System.out.println("Salles et capteurs : " + this.sallesCapteurs);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Ajout d'un graphique à une HBox (crée dynamiquement un graphique pour une
     * salle et un capteur)
     *
     * @param hbox    HBox à laquelle ajouter le graphique (donc l'endroit où
     *                afficher le graphique) (chaque HBox représente une salle et
     *                contient les graphiques des capteurs)
     * @param salle   Nom de la salle
     * @param capteur Nom du capteur
     */
    public void addGraphiqueToHBox(HBox hbox, String salle, String capteur) {
        SalleData salleData = this.sallesCapteurs.get(salle);
        System.out.println("Affichage du graphique pour la salle " + salle + " et le capteur " + capteur);

        NumberAxis xAxis = new NumberAxis();
        NumberAxis yAxis = new NumberAxis();
        xAxis.setLabel("Temps");
        yAxis.setLabel(capteur);

        LineChart<Number, Number> lineChart = new LineChart<>(xAxis, yAxis);
        lineChart.setTitle("Graphique de " + capteur + " pour la salle " + salle);

        XYChart.Series<Number, Number> series = new XYChart.Series<>();
        series.setName(capteur);

        List<Double> data = null;

        // Selon le capteur, récupérer les bonnes données
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
            default:
                System.out.println("Capteur non reconnu");
                return;
        }

        // Vérification si les données ne sont pas vides avant de créer un graphique
        if (data != null && !data.isEmpty()) {
            // Ajout des points de données dans la série
            for (int i = 0; i < data.size(); i++) {
                series.getData().add(new XYChart.Data<>(i, data.get(i)));
            }
            lineChart.getData().add(series);
            hbox.getChildren().add(lineChart);
        } else {
            System.out.println("Aucune donnée disponible pour le capteur " + capteur + " de la salle " + salle);
        }
    }

    /**
     * Chargement des salles dans le menu de filtrage en haut à droite de la fenetre
     */
    private void loadSalleFiltre() {
        System.out.println("Chargement des salles dans le menu");
        for (String salle : this.sallesCapteurs.keySet()) {
            System.out.println("Ajout de la salle " + salle);
            Menu menuSalle = new Menu(salle);
            this.menuBar.getItems().add(menuSalle);

            // Ajout des capteurs pour chaque salle
            for (String capteur : this.sallesCapteurs.get(salle).getCapteurs().keySet()) {
                System.out.println("Ajout du capteur " + capteur);
                MenuItem menuItem = new MenuItem(capteur);
                menuSalle.getItems().add(menuItem);
                menuItem.setOnAction(e -> filterCapteurGraphiques(salle, capteur)); // si on clique sur le capteur, on
                                                                                    // affiche le graphique du capteur
                                                                                    // (spécifique à la salle)
            }
            menuSalle.setOnAction(e -> filterSalleGraphiques(salle)); // si on clique sur la salle, on affiche tous les
                                                                      // graphiques de la salle
        }
    }

    private void filterCapteurGraphiques(String salle, String capteur) {
        VBox vboxGraphiques = (VBox) this.scrollPaneGraphiques.getContent();

        // Parcourir toutes les salles (HBox)
        for (int i = 0; i < vboxGraphiques.getChildren().size(); i++) {
            HBox hboxSalle = (HBox) vboxGraphiques.getChildren().get(i);

            // Si l'HBox ne correspond pas à la salle sélectionnée, passer à la suivante
            if (hboxSalle.getChildren().isEmpty()
                    || !((LineChart) hboxSalle.getChildren().get(0)).getTitle().contains(salle)) {
                continue;
            }

            // Parcourir les graphiques de la salle
            for (int j = 0; j < hboxSalle.getChildren().size(); j++) {
                LineChart chart = (LineChart) hboxSalle.getChildren().get(j);

                // Si le titre du graphique correspond au capteur sélectionné
                if (chart.getTitle().contains(capteur)) {
                    chart.setVisible(true); // Afficher le graphique du capteur sélectionné
                    // Faire défiler le ScrollPane jusqu'à ce graphique
                    scrollToGraphique(chart);
                } else {
                    chart.setVisible(false);
                }
            }
        }
    }

    /**
     * Faire défiler le ScrollPane jusqu'à un graphique spécifique
     *
     * @param chart Graphique à afficher
     */
    private void scrollToGraphique(LineChart chart) {
        VBox vboxGraphiques = (VBox) this.scrollPaneGraphiques.getContent();

        int index = vboxGraphiques.getChildren().indexOf(chart.getParent()); // Trouver l'HBox contenant le graphique
        if (index != -1) {
            double scrollHeight = this.scrollPaneGraphiques.getHeight();
            double contentHeight = vboxGraphiques.getHeight();
            double scrollPosition = Math.min((double) index / vboxGraphiques.getChildren().size(), 1.0);
            this.scrollPaneGraphiques.setVvalue(scrollPosition);
        }
    }

    /**
     * Filtrer les graphiques pour afficher uniquement ceux de la salle sélectionnée
     *
     * @param salle Nom de la salle à afficher
     */
    private void filterSalleGraphiques(String salle) {
        VBox vboxGraphiques = (VBox) this.scrollPaneGraphiques.getContent();

        // Parcourir toutes les salles (HBox)
        for (int i = 0; i < vboxGraphiques.getChildren().size(); i++) {
            HBox hboxSalle = (HBox) vboxGraphiques.getChildren().get(i);

            // Si l'HBox ne correspond pas à la salle sélectionnée, la masquer
            if (hboxSalle.getChildren().isEmpty()
                    || !((LineChart) hboxSalle.getChildren().get(0)).getTitle().contains(salle)) {
                hboxSalle.setVisible(false);
            } else {
                hboxSalle.setVisible(true); // Afficher la salle sélectionnée
                scrollToSalle(hboxSalle); // Scroll jusqu'à la salle
            }
        }
    }

    /**
     * Faire défiler le ScrollPane jusqu'à une salle spécifique
     *
     * @param hboxSalle HBox de la salle à afficher
     */
    private void scrollToSalle(HBox hboxSalle) {
        VBox vboxGraphiques = (VBox) this.scrollPaneGraphiques.getContent();

        int index = vboxGraphiques.getChildren().indexOf(hboxSalle);
        if (index != -1) {
            double scrollHeight = this.scrollPaneGraphiques.getHeight();
            double contentHeight = vboxGraphiques.getHeight();
            double scrollPosition = Math.min((double) index / vboxGraphiques.getChildren().size(), 1.0);
            this.scrollPaneGraphiques.setVvalue(scrollPosition);
        }
    }

    /**
     * Afficher toutes les salles et tous les graphiques (ne marche pas
     * correctement) #TODO
     */
    @FXML
    private void afficherToutesLesSalles() {
        VBox vboxGraphiques = (VBox) this.scrollPaneGraphiques.getContent();

        for (int i = 0; i < vboxGraphiques.getChildren().size(); i++) {
            HBox hboxSalle = (HBox) vboxGraphiques.getChildren().get(i);
            hboxSalle.setVisible(true); // Rendre la salle visible
        }
    }

    /**
     * Rafraîchir les graphiques avec les nouvelles données
     */
    public void refreshGraphiques() {
        System.out.println("Rafraîchissement des graphiques");

        // Récupérer le VBox contenant tous les graphiques
        VBox vboxGraphiques = (VBox) this.scrollPaneGraphiques.getContent();

        // Parcourir chaque HBox (chaque salle)
        for (int i = 0; i < vboxGraphiques.getChildren().size(); i++) {
            HBox hboxSalle = (HBox) vboxGraphiques.getChildren().get(i);

            // Parcourir chaque graphique dans cette salle (HBox)
            for (int j = 0; j < hboxSalle.getChildren().size(); j++) {
                LineChart<Number, Number> lineChart = (LineChart<Number, Number>) hboxSalle.getChildren().get(j);

                // Récupérer la salle et le capteur à partir du titre du graphique
                String salle = lineChart.getTitle().split(" ")[6];
                String capteur = lineChart.getTitle().split(" ")[2];
                System.out
                        .println("Rafraîchissement du graphique pour la salle " + salle + " et le capteur " + capteur);

                // Récupérer les nouvelles données du capteur
                SalleData salleData = this.sallesCapteurs.get(salle);
                List<Double> data = null;

                // Selon le capteur, récupérer les bonnes données
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
                    default:
                        System.out.println("Capteur non reconnu");
                        break;
                }

                // Mettre à jour la série du graphique avec les nouvelles données
                if (data != null) {
                    XYChart.Series<Number, Number> series = lineChart.getData().get(0); // On suppose qu'il y a une
                                                                                        // seule série
                    series.getData().clear(); // Effacer les anciennes données
                    for (int k = 0; k < data.size(); k++) {
                        // Ajouter les nouvelles données
                        series.getData().add(new XYChart.Data<>(k, data.get(k)));
                    }
                }
            }
        }
    }

    // Manque les alertes
    // Fix le bug de l'affichage des graphiques après filtrage
    // Manque le délire de Thread pour refresh les graphiques à une certaine
    // fréquence, je pense qu'on fera avec un timer qui va juste appeler la méthode
    // refreshGraphiques() toutes les x secondes
    // Demander au prof si on peux ? pcq au final je fais aucun Thread qui contient
    // les graphiques, je les crée directement dans la méthode initalize() et je les
    // affiche directement
    // Le refresh est giga énervé, il regénère tous les graphiques à chaque fois,
    // c'est pas ouf, possible de faire mieux en faisant une méthode qui met à jour
    // les données des graphiques en lui donnant le graphique qu'on veux update
    // Du coup en utilisant la méthode de la ligne au dessus on pourra faire un
    // thread qui regarde toutes les x secondes si les données ont changées et si
    // oui il update les graphiques qui ont changés uniquement
}