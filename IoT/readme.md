# Application JavaFX

## Prérequis

- Java Development Kit (JDK) 21 ou supérieur
- Maven 3.6 ou supérieur
- JavaFX SDK 21

## Installation

1. **Cloner le dépôt** :
    ```sh
    git clone <URL_DU_DEPOT>
    cd <NOM_DU_REPERTOIRE>
    ```

2. **Configurer le Maven Wrapper** (pas nécessaire normalement) :
    ```sh
    mvn -N io.takari:maven:wrapper
    ```

## Compilation et exécution

1. **Naviguer vers le répertoire du projet** :
    ```sh
    cd IoT/JavaFX/JavaFX
    ```

2. **Nettoyer et compiler le projet** :
    ```sh
    mvn clean install
    ```

3. **Exécuter l'application** :
    ```sh
    mvn javafx:run
    ```

## Structure du projet

- `src/main/java/g1a2/devapp/HelloApplication.java` : Point d'entrée de l'application.
- `src/main/resources/g1a2/devapp/hello-view.fxml` : Fichier FXML pour la vue.
- `pom.xml` : Fichier de configuration Maven.

## Dépendances

Le fichier `pom.xml` inclut les dépendances suivantes :
- `javafx-controls`
- `javafx-fxml`