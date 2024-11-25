package g1a2.devapp.controller;

import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.TextField;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.io.File;

import com.fasterxml.jackson.databind.ObjectMapper;

import g1a2.devapp.model.Config;


public class Controller {

    private ArrayList<String> topic;
    private String server;
    private ArrayList<String> salle;
    private int frequence;
    private HashMap<String, Integer> data;

    @FXML
    private TextField tfServer;
    @FXML
    private Button buttonTestConnection;
    
    @FXML
    public void initialize() {
        System.out.println("Controlleur chargé avec succès");
        loadConfig();
    }
    
    private void loadConfig() {
        ObjectMapper mapper = new ObjectMapper();
        this.tfServer.setText("localhost");
        try {
            System.out.println("Working Directory = " + System.getProperty("user.dir"));
            Config config = mapper.readValue(new File("../../config.json"), Config.class);
            tfServer.setText(config.getServer());
            tfServer.setEditable(true);
            tfServer.setDisable(false);
            tfServer.setPromptText(config.getServer());
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}
