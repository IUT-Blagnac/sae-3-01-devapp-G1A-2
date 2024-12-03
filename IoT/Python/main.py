import json
import threading
import paho.mqtt.subscribe as subscribe
from datetime import datetime
import os
import signal
import sys

def sigterm_handler(signal, frame):
    print("Arrêt du script Python")
    # Effectuer des opérations de nettoyage ici si nécessaire
    sys.exit(0)

signal.signal(signal.SIGTERM, sigterm_handler)


server = str()
topic = list()
salle = list()
dataVoulu = dict()
frequence = int()

os.chdir(os.path.dirname(os.path.abspath(__file__)))

'''
Fonction qui vérifie l'existence des fichiers de résultat, de cache et d'alerte et les crée s'ils n'existent pas.
'''
def verifFichier():
    fichiers = {
        "../resultat/resultatAM107.json": {},
        "../resultat/resultatSolar.json": {},
        "../resultat/alerteAM107.json": {},
        "cache/cache_am107.json": {},
        "cache/cache_solaredge.json": {}
    }
    for fichier, contenu in fichiers.items():
        try:
            with open(fichier, 'r', encoding='utf-8') as file:
                json.load(file)
        except FileNotFoundError:
            with open(fichier, 'w', encoding='utf-8') as file:
                json.dump(contenu, file, ensure_ascii=False, indent=4)
                print(f"Fichier {fichier} créé")

'''
Fonction qui vérifie la cohérence des données dans le fichier de résultat par rapport à la configuration.
'''
def verifCoherenceConfigResultat():
    with open("../resultat/resultatAM107.json", 'r+', encoding='utf-8') as file:
        data = json.load(file)
        for room in data:
            if room not in salle and "all" not in salle:
                print(f"La salle {room} n'est pas dans la configuration")
                data = {}
        file.seek(0)
        file.write(json.dumps(data, ensure_ascii=False, indent=4))
        file.truncate()

'''
Fonction qui charge la configuration depuis le fichier config.json et initialise les variables globales.
Cette fonction crée un fichier de configuration par défaut si le fichier config.json n'existe pas.
'''
def config():
    print("Chargement de la config...")
    try:
        with open("../config.json", 'r', encoding='utf-8') as file:
            data = json.load(file)
            global server, topic, salle, dataVoulu, frequence
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
        with open("../config.json", 'w', encoding='utf-8') as file:
            data = {
                "server": "mqtt.iut-blagnac.fr",
                "topic" : ["AM107/by-room/#", "solaredge/blagnac/#"],
                "salle": ["all"],
                "data": {"temperature": 30, "humidity": 30, "co2": 1800, "illumination": 20},
                "frequence": 10
            }
            json.dump(data, file, ensure_ascii=False, indent=4)
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
        try:
            if type == "AM107":  # Traitement des données AM107
                # Traitement des données AM107
                ecrireCacheAm107(data, "cache/cache_am107.json")
            elif type == "SolarEdge":
                # Traitement des données SolarEdge
                ecrireCacheSolaredge(data, "cache/cache_solaredge.json")
        except Exception as e:
            print(f"Erreur dans le traitement des données: {e}")
    except Exception as e:
        print(f"Erreur dans la réception du message : {e}")


'''
Fonction qui ajoute une alerte dans le fichier d'alerte en cas de dépassement de seuil. (Ne prend pas en compte la fréquence = ajoute directement au fichier d'alerte)
'''
def alerteAM107(room, capteur, valeur):
    with open("../resultat/alerteAM107.json", "r+", encoding='utf-8') as file:
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
            
            if "timestamp" not in fichierJson[room]:
                fichierJson[room]["timestamp"] = []
                
            fichierJson[room][capteur].append(valeur)
            if datetime.now().strftime("%Y-%m-%d %H:%M:%S") not in fichierJson[room]["timestamp"]:
                fichierJson[room]["timestamp"].append(datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
            
        except Exception as e:
            print(f"Erreur dans la récupération des données: {e}")
            return

        file.seek(0)
        file.write(json.dumps(fichierJson, ensure_ascii=False, indent=4))
        file.truncate()

'''
Fonction qui écrit les données dans le fichier cache.
'''
def ecrireCacheAm107(data: dict, fichier: str):
    with open(fichier, "r+", encoding='utf-8') as file:
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
        file.write(json.dumps(fichierJson, ensure_ascii=False, indent=4))
        file.truncate()
        
'''
Fonction qui écrit les données dans le fichier cache.
'''
def ecrireCacheSolaredge(data: dict, fichier: str):
    # Charger le fichier JSON existant
    with open(fichier, "r+", encoding='utf-8') as file:
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
        file.write(json.dumps(fichierJson, ensure_ascii=False, indent=4))
        file.truncate()
        
'''
Fontion qui ajoute les données du cache dans le fichier de résultat.
'''
def appendCacheToResultatAm107(fichierCache: str, fichierResultat: str):
    with open(fichierCache, "r", encoding='utf-8') as file:
        try:
            content = file.read()
            if content:
                fichierJson = json.loads(content)
            else:
                return
        except json.JSONDecodeError:
            return

    with open(fichierResultat, "r+", encoding='utf-8') as file:
        try:
            content = file.read()
            if content:
                resultatJson = json.loads(content)
            else:
                resultatJson = {}
        except json.JSONDecodeError:
            resultatJson = {}

        try:
            for room, data in fichierJson.items():
                if room not in resultatJson:
                    resultatJson[room] = data
                else:
                    for capteur, valeurs in data.items():
                        if capteur not in resultatJson[room]:
                            resultatJson[room][capteur] = valeurs
                        else:
                            resultatJson[room][capteur] += valeurs

        except Exception as e:
            print(f"Erreur dans la récupération des données: {e}")
            return

        file.seek(0)
        file.write(json.dumps(resultatJson, ensure_ascii=False, indent=4))
        file.truncate()
        
    # Vider le fichier cache
    with open(fichierCache, "w", encoding='utf-8') as file:
        file.write("{}")
        
'''
Fontion qui ajoute les données du cache dans le fichier de résultat.
'''
def appendCacheToResultatSolaredge(fichierCache: str, fichierResultat: str):
    with open(fichierCache, "r", encoding='utf-8') as file:
        try:
            content = file.read()
            if content:
                fichierJson = json.loads(content)
            else:
                return
        except json.JSONDecodeError:
            return

    with open(fichierResultat, "r+", encoding='utf-8') as file:
        try:
            content = file.read()
            if content:
                resultatJson = json.loads(content)
            else:
                resultatJson = {}
        except json.JSONDecodeError:
            resultatJson = {}

        try:
            # Si le fichier est vide, on copie son contenu dans resultatJson
            if not resultatJson:
                resultatJson = fichierJson
            else:
                # Vérifie si "lastUpdateTime" existe et contient de nouveaux timestamps
                if "lastUpdateTime" in fichierJson:
                    for timestamp in fichierJson["lastUpdateTime"]:
                        if timestamp not in resultatJson["lastUpdateTime"]:
                            resultatJson["lastUpdateTime"].append(timestamp)
                            # Ajout des autres valeurs associées à ce timestamp
                            for key in fichierJson:
                                if key == "lastUpdateTime":
                                    continue
                                if key not in resultatJson:
                                    resultatJson[key] = []
                                if key in fichierJson:
                                    index = fichierJson["lastUpdateTime"].index(timestamp)
                                    resultatJson[key].append(fichierJson[key][index])
                                else:
                                    resultatJson[key].append(None)
                                    
        except Exception as e:
            print(f"Erreur dans la récupération des données: {e}")
            return

        file.seek(0)
        file.write(json.dumps(resultatJson, ensure_ascii=False, indent=4))
        file.truncate()

    # Vider le fichier cache
    with open(fichierCache, "w", encoding='utf-8') as file:
        file.write("{}")
       
'''
Fonction qui écrit les données dans le fichier de résultat.
C'est ici que l'on relance le timer pour la prochaine écriture. (fréquence = temps entre chaque écriture)
''' 
def ecriture():
    print("Transfert ...")
    appendCacheToResultatAm107("cache/cache_am107.json", "../resultat/resultatAM107.json")
    appendCacheToResultatSolaredge("cache/cache_solaredge.json", "../resultat/resultatSolar.json")
    timer = threading.Timer(frequence, ecriture)
    timer.start()

'''
Fonction qui permet de s'abonner à un topic et de traiter les messages reçus.
'''
def thread_subscribe(type, topic):
    subscribe.callback(lambda client, userdata, message: on_message_print(type, message), topic, hostname=server)

# Initialisation
verifFichier()
verifCoherenceConfigResultat()
config()

# Création des threads pour chaques topic et comportement attendu (on a donc un thread par topic soit 2 threads), un thread pour l'écriture des données et un timer pour la fréquence
threads = []
timer = threading.Timer(frequence, ecriture)
print(f"timer start {frequence}")
timer.start()
for elt in topic:
    thread = threading.Thread(target=thread_subscribe, args=(elt["type"], elt["topic"]))
    threads.append(thread)
    thread.start()