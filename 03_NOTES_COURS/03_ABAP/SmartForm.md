# Smartforms: *Formulaires*

SAP Smart Forms est utilisé pour créer et gérer des formulaires pour l'impression en masse dans les systèmes SAP. En tant que support de sortie, SAP Smart Forms prend en charge une imprimante, un fax, un e-mail ou Internet (en utilisant la sortie XML générée).

3 types
Correspond à ce qui va être imprimé (facture, etiquettes...)

Fonctionnent en 3 parties : la transaction NACE permet de gérer
- Objet métier
- Le formulaire en lui même
- La partie programme/impression pour appeler le formulaire via un module fonction et qui permet d'avoir un aperçu du formulaire.

[Explications et Tuto](https://www.guru99.com/smart-forms.html)


 ### 1. : SAP SCRIPT
___

Transaction : SAPSCRIPT [SE71]
Plus utilisé aujourd'hui
Les SmartForms sont plus faciles à développer, à maintenir et à transporter que SAP Script



### 2. : SMARTFORMS
___

Le formulaire passe par 3 paramétrages :
1/ Transaction métier : exemple : Affichage facture en VA03
2/ L'édition de cet objet / facture est pilotée par le paramétrage effectué dans la transaction NACE
3/ Application / Catégorie de message => Programme d'impression associé à un formulaire

Transaction : [NACE] : Condition de pilotage des messsages 

Le programme va être appelé par la transaction standart et va lancer le formulaire.


Chaque fois que nous créons des formulaires intelligents, SAP crée/génère un module de fonction. Contrairement aux scripts SAP, SAP FORMS vous permet de changer de langue.

Transaction : [SMARTFORMS]


1- A gauche : fenêtre de navigation
2- Au milieu : fenêtre de maintenance qui affiche les attributs des éléments
3- A droite : la mise en page

[Acceuil du smartform](https://drive.google.com/file/d/1zNgc_9iYMXpfWr3HPRVmaoznMP73uPKf/view?usp=share_link)

Déclarations de données globales : les données définies ici peuvent être utilisées dans l'ensemble du formulaire intelligent à des fins de codage.

Interface de formulaire : Ici, toutes les données qui seront transmises au smartform à partir du programme d'impression sont définies.

[Se78] : Gestion des graphiques des formulaires, pour l'image d'arrière-plan et les graphiques, on peut sélectionner des images bitmap en noir et blanc ou en couleur et les stocker sous forme de textes standard

Elements
1objet metier: facture, commande associé à un programme d'impression
Programme associé à formulaire

La fenêtre MAIN peut être aggrandit à souhait donc elle est utilisé pour les posts



1/ Transaction métier : exemple : Affichage facture en VA03
2/ L'édition de cet objet / facture est pilotée par le paramétrage effectué dans la transaction NACE
3/ Application / Catégorie de message => Programme d'impression associé à un formulaire

Mettre le texte entre & pour que l'éditeur comprenne que c'est une variable et pas du texte


[Smartform](C:\Users\Aelion\Desktop\LISA\00_RESSOURCES\SMARTFORMS_01.png)


Pour débeugger, nom du module fonction qui a créé le smartform.

[Environemment] [Nom du module fonction]
[Se37] pour le débeugger

[se63] TRADUCTION OBJET ABAP, autre texte, SAPscript, smartform
mettre le nom du smartform

[SE10] TEXTE STANDARD

Il faut récupérer le nom du module fonciton dans environnement.


### 3. : ADOBE

Transaction SFP

L'interface est dissocié de l'interface, on peut faire plusieurs formulaires avec l'interface, en prenant seulement les informations souhaitées.

Appel du formulaire
___


