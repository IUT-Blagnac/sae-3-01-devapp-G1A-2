import json
import threading
import paho.mqtt.subscribe as subscribe
from datetime import datetime
import time

server = str()
topic = list()
salle = list()
dataVoulu = dict()
frequence = int()

def verifFichier():
    fichiers = {
        "resultatAM107.json": {},
        "resultatSolar.json": {},
        "alerteAM107.json": {},
    }
    for fichier, contenu in fichiers.items():
        try:
            with open(fichier, 'r') as file:
                json.load(file)
        except FileNotFoundError:
            with open(fichier, 'w') as file:
                json.dump(contenu, file, indent=4)
                print(f"Fichier {fichier} créé")


def config():
    """
    Charge la configuration depuis le fichier JSON et initialise les variables globales.
    """
    print("Chargement de la config...")
    try:
        with open("config.json", 'r') as file:
            data = json.load(file)
            global server, topic, salle, dataVoulu, seuil
            topic = [{"type": "AM107", "topic": t} if "AM107" in t else {"type": "SolarEdge", "topic": t} for t in data.get("topic")]
            server = data.get("server")
            salle = data.get("salle")
            dataVoulu = data.get("data")
            frequence = data.get("frequence")
            print("Config chargée avec succès")
            print(f"Serveur : {server}, Topic : {topic}")
    except Exception as e:
        # Créer un fichier de configuration par défaut
        print(f"Erreur lors du chargement de la config : {e}")
        print("Création d'un fichier de configuration par défaut...")
        with open("config.json", 'w') as file:
            data = {
                "server": "mqtt.iut-blagnac.fr",
                "topic" : ["AM107/by-room/#", "solaredge/blagnac/#"],
                "salle": ["all"],
                "data": {"temperature": 30, "humidity": 30, "co2": 1800, "illumination": 20},
                "frequence": 10
            }
            json.dump(data, file, indent=4)
        print("Fichier de configuration par défaut créé avec succès")

'''                
Fonction qui traite les messages reçus et dispatche le traitement en fonction du type de message.
'''
def on_message_print(type, message):
    try:
        payload = message.payload.decode()
        if not payload:
            raise ValueError("Le payload est vide")
        data = json.loads(payload)
        print(data)  # debug

        try:
            if type == "AM107":  # Traitement des données AM107
                # Traitement des données AM107
                traitement_am107(data)
            elif type == "SolarEdge":
                # Traitement des données SolarEdge
                traitement_solaredge(data)
        except Exception as e:
            print(f"Erreur dans le traitement des données: {e}")
    except Exception as e:
        print(f"Erreur dans la réception du message : {e}")



def alerteAM107(room, capteur, valeur):
    with open("alerteAM107.json", "r+") as file:
        try:
            content = file.read()
            if content:
                fichierJson = json.loads(content)
            else:
                fichierJson = {}
        except json.JSONDecodeError:
            fichierJson = {}

        try:
            if room not in fichierJson:
                fichierJson[room] = {}

            if capteur not in fichierJson[room]:
                fichierJson[room][capteur] = []

            fichierJson[room][capteur].append(valeur)

        except Exception as e:
            print(f"Erreur dans la récupération des données: {e}")
            return

        file.seek(0)
        file.write(json.dumps(fichierJson, indent=4))
        file.truncate()

def traitement_am107(data):
    with open("resultatAM107.json", "r+") as file:
        try:
            content = file.read()
            if content:
                fichierJson = json.loads(content)
            else:
                fichierJson = {}
        except json.JSONDecodeError:
            fichierJson = {}

        try:
            # Extraire les métadonnées pour obtenir la salle
            room = None
            for elt in data:
                if "room" in elt:  # Vérifier si l'élément contient la clé "room"
                    room = elt["room"]
                    break  # On a trouvé la salle, on peut sortir de la boucle

            # Arreter le traitement si la salle n'est pas dans la liste des salles à traiter
            if room not in salle and "all" not in salle:
                return

            # Initialiser la salle dans le fichier JSON si elle n'existe pas
            if room not in fichierJson:
                fichierJson[room] = {}

            # Ajouter les données voulues à la salle
            for elt in data:
                for capteur, valeur in elt.items():
                    if capteur in dataVoulu:
                        # Initialise la liste si la clé n'existe pas encore
                        if capteur not in fichierJson[room]:
                            fichierJson[room][capteur] = []
                        # Ajoute la valeur dans le JSON d'alerte si la valeur dépasse le seuil donné
                        if valeur > dataVoulu[capteur]:
                            alerteAM107(room, capteur, valeur)
                        fichierJson[room][capteur].append(valeur)

            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            if "timestamp" not in fichierJson[room]:
                fichierJson[room]["timestamp"] = []
            fichierJson[room]["timestamp"].append(timestamp)

        except Exception as e:
            print(f"Erreur dans la récupération des données: {e}")
            return

        file.seek(0)
        file.write(json.dumps(fichierJson, indent=4))
        file.truncate()


'''
Fonction qui traite les données SolarEdge.
'''
def traitement_solaredge(data):
    # Charger le fichier JSON existant
    with open("resultatSolar.json", "r+") as file:
        try:
            content = file.read()
            fichierJson = json.loads(content) if content else {}
        except json.JSONDecodeError:
            fichierJson = {}

        try:
            # Récupérer le timestamp du message reçu
            new_timestamp = data.get("lastUpdateTime")
            if not new_timestamp:
                print("Aucun timestamp trouvé dans les données reçues.")
                return

            # Vérifier si le timestamp est déjà présent
            if "lastUpdateTime" in fichierJson and new_timestamp in fichierJson["lastUpdateTime"]:
                print("Timestamp déjà enregistré, message ignoré.")
                return

            # Si le timestamp est nouveau, l'ajouter
            if "lastUpdateTime" not in fichierJson:
                fichierJson["lastUpdateTime"] = []
            fichierJson["lastUpdateTime"].append(new_timestamp)

            # Ajouter les données liées
            for key, value in data.items():
                if key == "lastUpdateTime" or key == "measuredBy":
                    continue  # Ignorer le timestamp et les métadonnées

                # Initialiser la clé si elle n'existe pas
                if key not in fichierJson:
                    fichierJson[key] = []

                # Vérifier si la valeur est un objet (par exemple {"energy": 3261347})
                if isinstance(value, dict):
                    # Extraire la première clé du dictionnaire et prendre la valeur associée
                    for sub_key, sub_value in value.items():
                        fichierJson[key].append(sub_value)
                else:
                    # Sinon, ajouter la valeur directement
                    fichierJson[key].append(value)

            # Remplir les clés manquantes avec des `None` pour maintenir les longueurs cohérentes
            max_length = len(fichierJson["lastUpdateTime"])
            for key in fichierJson:
                while len(fichierJson[key]) < max_length:
                    fichierJson[key].append(None)

        except Exception as e:
            print(f"Erreur dans la récupération des données SolarEdge: {e}")
            return

        # Sauvegarder dans le fichier JSON
        file.seek(0)
        file.write(json.dumps(fichierJson, indent=4))
        file.truncate()




'''
Fonction qui permet de s'abonner à un topic et de traiter les messages reçus.
'''
def thread_subscribe(type, topic):
    subscribe.callback(lambda client, userdata, message: on_message_print(type, message), topic, hostname=server)
    #time.sleep(frequence)

# Initialisation
verifFichier()
config()

# Création des threads pour chaques topic et comportement attendu
threads = []
for elt in topic:
    thread = threading.Thread(target=thread_subscribe, args=(elt["type"], elt["topic"]))
    threads.append(thread)
    thread.start()

# Attente de la fin de tous les threads (optionnel)
for thread in threads:
    thread.join()