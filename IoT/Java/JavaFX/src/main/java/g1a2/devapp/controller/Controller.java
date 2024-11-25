package g1a2.devapp.controller;

import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;
//import com.fasterxml.jackson.databind.ObjectMapper;


public class Controller {

    @FXML
    private TextField server;
    @FXML
    private Button buttonTestConnection;
    
    @FXML
    public void initialize() {
        System.out.println("Controlleur chargé avec succès");
        server.setText("localhost");
        server.setEditable(true);
        //loadConfig();
    }
    
//    private String loadConfig() {
        
//   }

}
