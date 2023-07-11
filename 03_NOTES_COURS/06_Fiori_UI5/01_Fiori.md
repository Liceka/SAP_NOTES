# Fiori: *Détails*

Support de cours : [Formation - SAPUI5 FIORI.pptx]

### 1. Stratégie
Simplifier ce qu'on a dans SAP pour avoir tout ce que l'utilisateur a besoin mais sans plus

Technologie web, compatible

SAP fourni des applis dejà prêtes assez simpliste, +700Apps disponibles sur ECC, possibilité des les personnaliser

Catalogue SAP FIORI :
https://fioriappslibrary.hana.ondemand.com/sap/fix/externalViewer/


> Nouvelle expérience utilisateur au travers de:
- La création de nouvelles applications
- La création de nouveaux outils


> Refonte d’application provenant du SAP GUI ou Web Dynpro ABAP
- Nouveau style, thème, couleurs
- Nouveau launchpad : portail d'application, permet de centraliser les applications

### 2. Principe
Design 1-1-3 pour chaque application
L'application doit être pensé pour :
1 utilisateur
1 scénario
3 écrans enchainés (jamais plus de 3 écrans)

Démo SAP:
https://www.sap.com/cmp/td/sap-cloud-platform-trial.html

### 3. Caractétistiques d'une application :

- Role-based: 1 app = 1 action = 1 objet métier

- Responsive: multi device (mobile, tablettes, PC…)

- Simple: 1 app = 3 écrans

- Coherent: application intuitive

- Delightful: nouveau design pour capter l’utilisateur

# Fiori: *Architecture p.9*

Infrastucture BTP, mettre un max d'infos sur le cloud, base de données

BAS : IDE (éditeur de texte) qui permet de créer l'application ébergé sur le CLOUD

> Repose sur les technologies Web standard:
- HTML5
- Javascript : gestion des évènements
- JQuery : Librairie qui permet de faire du javascript, pour gagner du temps à coder
- CSS : Apparence, couleur...


> Framework SAP UI5
- Bibliothèque d’éléments
- Core UI5, modèle MVC


> Modèle de données provenant de:
- Web Service (API publique, Odata, REST, SAP Gateway…)
- Modèles embarqués

## Possibilité de créer une application sous plusieurs formes:

> Application FIORI dans le launchpad SAP:
- Sous format de tuile
- Respecté le « Code » SAP
- Accessible via Navigateur


> Application Hybride
- Contenu développé en SAP UI5
- Encapsulé dans un framework Android/IOS
- Permet d’accéder aux fonctionnalités natives du téléphone
