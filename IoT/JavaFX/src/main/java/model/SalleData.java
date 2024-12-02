package model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SalleData {
    private List<Double> temperature;
    private List<Double> humidity;
    private List<Double> co2;
    private List<Double> illumination;
    private List<Double> activity;
    private List<Double> pression;
    private List<String> timestamp;

    // Getters et setters
    public List<Double> getTemperature() {
        return temperature;
    }

    public void setTemperature(List<Double> temperature) {
        this.temperature = temperature;
    }

    public List<Double> getHumidity() {
        return humidity;
    }

    public void setHumidity(List<Double> humidity) {
        this.humidity = humidity;
    }

    public List<Double> getCo2() {
        return co2;
    }

    public void setCo2(List<Double> co2) {
        this.co2 = co2;
    }

    public List<Double> getIllumination() {
        return illumination;
    }

    public void setIllumination(List<Double> illumination) {
        this.illumination = illumination;
    }

    public List<Double> getActivity() {
        return activity;
    }

    public void setActivity(List<Double> activity) {
        this.activity = activity;
    }

    public List<Double> getPression() {
        return pression;
    }

    public void setPression(List<Double> pression) {
        this.pression = pression;
    }

    public List<String> getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(List<String> timestamp) {
        this.timestamp = timestamp;
    }

    public Map<String, Boolean> getCapteurs() {
        Map<String, Boolean> capteurs = new HashMap<>();

        // Vérifie la disponibilité des différents capteurs
        capteurs.put("temperature", temperature != null && !temperature.isEmpty());
        capteurs.put("humidity", humidity != null && !humidity.isEmpty());
        capteurs.put("co2", co2 != null && !co2.isEmpty());
        capteurs.put("illumination", illumination != null && !illumination.isEmpty());
        capteurs.put("activity", activity != null && !activity.isEmpty());
        capteurs.put("pression", pression != null && !pression.isEmpty());

        return capteurs;
    }

}
