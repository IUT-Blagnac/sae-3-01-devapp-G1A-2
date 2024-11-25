package g1a2.devapp.model;

import java.util.List;
import java.util.Map;

public class Config {
    private List<String> topic;
    private String server;
    private List<String> salle;
    private Map<String, Integer> data;
    private int frequence;

    // Getters et setters
    public List<String> getTopic() {
        return topic;
    }

    public void setTopic(List<String> topic) {
        this.topic = topic;
    }

    public String getServer() {
        return server;
    }

    public void setServer(String server) {
        this.server = server;
    }

    public List<String> getSalle() {
        return salle;
    }

    public void setSalle(List<String> salle) {
        this.salle = salle;
    }

    public Map<String, Integer> getData() {
        return data;
    }

    public void setData(Map<String, Integer> data) {
        this.data = data;
    }

    public int getFrequence() {
        return frequence;
    }

    public void setFrequence(int frequence) {
        this.frequence = frequence;
    }
}