package model;

import com.fasterxml.jackson.annotation.JsonAnySetter;

import java.util.HashMap;
import java.util.Map;

public class RootData {
    private Map<String, SalleData> salles = new HashMap<>();

    // Getter pour accéder aux salles
    public Map<String, SalleData> getSalles() {
        return salles;
    }

    // Setter JSON dynamique pour enregistrer les salles
    @JsonAnySetter
    public void addSalle(String key, SalleData salleData) {
        this.salles.put(key, salleData);
    }
}
