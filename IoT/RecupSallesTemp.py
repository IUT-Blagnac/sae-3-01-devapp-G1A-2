import json, os

def recupSalleToFXML():
    with open("IoT/resultat/resultatAM107.json", "r") as fichier:
        data = json.load(fichier)
        l = []
        for key in data:
            l.append(str(key))
        B = [ elt for elt in l if elt.startswith("B")]
        C = [ elt for elt in l if elt.startswith("C")]
        E = [ elt for elt in l if elt.startswith("E")]
        Other = list(set(l) - set(B) - set(C) - set(E))
        print('                              <Menu mnemonicParsing="false" text="Bâtiment B">')
        print('                                  <items>')
        for elt in B:
            print(f'                                    <CheckMenuItem mnemonicParsing="false" text="{elt}" />')
        print('                                  </items>')
        print('                              </Menu>')
        print('                              <Menu mnemonicParsing="false" text="Bâtiment C">')
        print('                                  <items>')
        for elt in C:
            print(f'                                    <CheckMenuItem mnemonicParsing="false" text="{elt}" />')
        print('                                  </items>')
        print('                              </Menu>')
        print('                              <Menu mnemonicParsing="false" text="Bâtiment E">')
        print('                                  <items>')
        for elt in E:
            print(f'                                    <CheckMenuItem mnemonicParsing="false" text="{elt}" />')
        print('                                  </items>')
        print('                              </Menu>')
        print('                              <Menu mnemonicParsing="false" text="Autres">')
        print('                                  <items>')
        for elt in Other:
            print(f'                                    <CheckMenuItem mnemonicParsing="false" text="{elt}" />')
        print('                                  </items>')
        print('                              </Menu>')
        print('                           <Menu mnemonicParsing="false" text="Tous">')
        print('                              <items>')
        print('                                <CheckMenuItem mnemonicParsing="false" text="Oui ?" />')
        print('                              </items>')
        print('                           </Menu>')
        
def recupSalleJava():
    with open("IoT/resultat/resultatAM107.json", "r") as fichier:
        data = json.load(fichier)
        l = []
        for key in data:
            l.append(str(key))
        B = [ elt for elt in l if elt.startswith("B")]
        C = [ elt for elt in l if elt.startswith("C")]
        E = [ elt for elt in l if elt.startswith("E")]
        Other = list(set(l) - set(B) - set(C) - set(E))
        print()

recupSalleToFXML()