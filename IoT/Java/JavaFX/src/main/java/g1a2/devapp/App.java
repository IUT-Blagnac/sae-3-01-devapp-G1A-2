package g1a2.devapp;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

public class App extends Application {
    @Override
    public void start(Stage stage) throws IOException {
        // Charge le fichier FXML
        FXMLLoader fxmlLoader = new FXMLLoader(App.class.getResource("./view/menu.fxml"));
        Scene scene = new Scene(fxmlLoader.load());
        // Définit le titre de la fenêtre
        stage.setTitle("Gestion des Bâtiments");
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }
}
