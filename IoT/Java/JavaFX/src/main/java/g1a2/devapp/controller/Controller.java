package g1a2.devapp.controller;

import javafx.fxml.FXML;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ComboBox;
import javafx.scene.layout.VBox;

public class Controller {

    @FXML
    private ComboBox<String> buildingComboBox; // ComboBox pour sélectionner le bâtiment

    @FXML
    private VBox roomCheckBoxContainer; // Conteneur pour les CheckBoxes des salles

    @FXML
    public void initialize() {
        // Ajout des bâtiments au menu déroulant
        buildingComboBox.getItems().addAll("Bâtiment A", "Bâtiment B", "Bâtiment C", "Bâtiment D");

        // Listener pour mettre à jour les salles lorsqu'un bâtiment est sélectionné
        buildingComboBox.getSelectionModel().selectedItemProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null) {
                updateRooms(newValue);

                // Réouvrir le menu déroulant après sélection
                buildingComboBox.show();
            }
        });
    }

    /**
     * Met à jour les cases à cocher en fonction du bâtiment sélectionné.
     *
     * @param building Le bâtiment sélectionné dans la ComboBox.
     */
    private void updateRooms(String building) {
        // Efface les salles précédemment affichées
        roomCheckBoxContainer.getChildren().clear();

        // Ajoute les cases à cocher correspondant au bâtiment sélectionné
        switch (building) {
            case "Bâtiment A" -> roomCheckBoxContainer.getChildren().addAll(
                    createRoomCheckBox("A101"),
                    createRoomCheckBox("A102"),
                    createRoomCheckBox("A103"),
                    createRoomCheckBox("A201")
            );
            case "Bâtiment B" -> roomCheckBoxContainer.getChildren().addAll(
                    createRoomCheckBox("B001"),
                    createRoomCheckBox("B103"),
                    createRoomCheckBox("B112"),
                    createRoomCheckBox("B217")
            );
            case "Bâtiment C" -> roomCheckBoxContainer.getChildren().addAll(
                    createRoomCheckBox("C001"),
                    createRoomCheckBox("C006"),
                    createRoomCheckBox("C102")
            );
            case "Bâtiment D" -> roomCheckBoxContainer.getChildren().addAll(
                    createRoomCheckBox("D001"),
                    createRoomCheckBox("D205"),
                    createRoomCheckBox("D306")
            );
        }
    }

    /**
     * Crée une case à cocher pour une salle spécifique.
     *
     * @param roomName Nom de la salle.
     * @return Une instance de CheckBox configurée pour la salle donnée.
     */
    private CheckBox createRoomCheckBox(String roomName) {
        CheckBox checkBox = new CheckBox(roomName);
        checkBox.setOnAction(event -> handleRoomSelection(roomName, checkBox.isSelected()));
        return checkBox;
    }

    /**
     * Gère les actions lorsque l'utilisateur sélectionne ou désélectionne une salle.
     *
     * @param roomName Nom de la salle.
     * @param isSelected État sélectionné ou non.
     */
    private void handleRoomSelection(String roomName, boolean isSelected) {
        if (isSelected) {
            System.out.println("Salle sélectionnée : " + roomName);
        } else {
            System.out.println("Salle désélectionnée : " + roomName);
        }
    }
}
