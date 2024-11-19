module g1a2.devapp {
    requires javafx.controls;
    requires javafx.fxml;


    opens g1a2.devapp to javafx.fxml;
    exports g1a2.devapp;
}