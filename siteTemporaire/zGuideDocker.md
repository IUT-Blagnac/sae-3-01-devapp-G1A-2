# Lancer le serveur

## Installer docker

- Windows

  - Docker desktop (le plus courant)
  - Insatller wsl
    - ouvrir un powershell ou cmd rentrer la commande :

      - wsl --install
        Cette commande install la distribution ubuntu par defaut
      - wsl --install -d Distribution Name

        Remplacer Distribution Name par la distribution de votre choix

## Se connecter dans le terminal wsl pour cela dans un terminal
  ```
  bash 
  ou
  votre distribution.exe (ex ubuntu.exe)
  ```

# Pour ubuntu 
## Add Docker's official GPG key:
```
sudo apt-get update
```
```
sudo apt-get install ca-certificates curl
```
```
sudo install -m 0755 -d /etc/apt/keyrings
```
```
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
```
```
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

## Add the repository to Apt sources:
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

## Créez le groupe docker 

```
sudo groupadd docker
```

## Ajoutez votre utilisateur actuel au groupe docker

```
sudo usermod -aG docker $USER
```

## Lancer le service docker 

```
sudo service docker start
```

## Commandes

Votre terminal doit être ouvert dans le même repertoire que votre dockerfile et votre docker-compose.yml

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
