package model;

import java.util.HashMap;
import java.util.HashSet;

public class Config {
    private HashSet<String> topic;
    private String server;
    private HashSet<String> salle;
    private HashMap<String, Float> data;
    private int frequence;

    // Getters et setters
    public HashSet<String> getTopic() {
        return topic;
    }

    public void setTopic(HashSet<String> topic) {
        this.topic = topic;
    }

    public String getServer() {
        return server;
    }

    public void setServer(String server) {
        this.server = server;
    }

    public HashSet<String> getSalle() {
        return salle;
    }

    public void setSalle(HashSet<String> salle) {
        this.salle = salle;
    }

    public HashMap<String, Float> getData() {
        return data;
    }

    public void setData(HashMap<String, Float> data) {
        this.data = data;
    }

    public int getFrequence() {
        return frequence;
    }

    public void setFrequence(int frequence) {
        this.frequence = frequence;
    }
}