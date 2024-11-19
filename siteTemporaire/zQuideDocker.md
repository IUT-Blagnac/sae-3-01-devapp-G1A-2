# Lancer le serveur

## Installer docker

- Windows

  - Docker desktop (le plus courant)
  - Docker cli avec wsl2 (wsl permet de supporter une distribution linux ubuntu ou debian et de pouvoir executer des commandes unix )
  - Insatller wsl

    - ouvrir un powershell ou cmd rentrer la commande :

      - wsl --install
        Cette commande install la distribution ubuntu par defaut
      - wsl --install -d Distribution Name

        Remplacer Distribution Name par la distribution de votre choix

## Commandes

```
 docker compose up -d
```

## Pages

- phpMyAdmin
  - http://localhost:8081
- site web
  - http://localhost:8080

## Pas besoins de configurer la connection a la bd elle est déjà faite .

## Si vous rencontrer un problèmes avec docker n'hésitez pas a m'envoyer un message j'esserais de vous aider

Si la synchronisation entre le site et la bd ne fonctionne pas esseyer

```
docker-compose build
puis reexecuter la commande
docker compose up -d
```
