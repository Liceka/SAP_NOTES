**Exercice 1 : Palyndrome Regex**

NOM PROGRAMME : [P001](../PALINDROME_REGEX/Z_PALINDROME_LBA.abap)
FICHIER : ![001](../00_EXERCICES/EXO_ABAP_1_Palyndrom_Regexp.txt)

- Vérifier que la chaine de caractère rentrée est un palindrome ou non 
(un palyndrom est un mot qui peut se lire à l'envers , exemple "radar" ou "non")

- Vérifier que la chaine de caractères est de ce type : 
"AIRCRAFT-XXXYY" avec XXX (3 à 5 chiffres quelconques et YY 2 Lettres quelconques)


**Exercice 2 : Récupération factures**

NOM PROGRAMME : [P002](../EXO_ALLIANCE/Z_EXO_LBA.abap)
FICHIER : ![002](../00_EXERCICES/EXO_ABAP_2_For_All_Entries.docx)

- Récupération des factures FI ayant un poste client sur une société donnée,
créées depuis une date donnée.

Récupération des entêtes
Récupération des postes de facture FI
Récupération des données des pièces de référence

Les pièces de référence peuvent être de 2 types : facture ou pièce FI
Récupération des factures de référence
Récupération des pièces FI de référence

- Restitution sout format ALV des champs avec couleurs

Ajouter un champ de saisie d'un fichier en local pour sauvegarde de l'ALV
Ajouter un bouton de traitement sur l'ALV
Quand le bouton "Export" est activé, un fichier CSV doit être créé avec les données de l'ALV.

**Exercice 3 : Envois fichier par mail**

NOM PROGRAMME : [P003a](../ENVOI_FICHIER_MAIL_WITH_CLASS/Z_EMAIL_LBA.abap) Avec utilisation de classes.
                [P003a](../ENVOI_FICHIER_MAIL_WITH_MODULE_FONCTION/Z_PROGRAM_003_FGI.abap) Avec modules fonction
FICHIER : ![003](../00_EXERCICES/EXO_ABAP_3_Mails.docx)

- Création d'un programme pour envoyer un fichier depuis AL11 (serveur) par e-mail 

**Exercice 4 : Afficher pièce jointe commande achat**

NOM PROGRAMME : [P004](../EXO_ALLIANCE/Z_GOS_LBA.abap) Avec utilisation de classes.
FICHIER : ![004](../00_EXERCICES/EXO_ABAP_4_Afficher_PJ_de_PO.txt)

EN ME23N il est possible d'afficher les commande d'achat (Table EKKO/EKPO via EBELN etc) -> bouton "Autre commande"
Dans la partie service objet (bouton jaune tout en haut a gauche de la fiche de commande d'achat), il est possible de voir et enregistrer des pièces jointes liés à une commande d'achat spécifique.

Dans cet exercice on souhaite à partir d'une saisie d'un ou plusieurs numéro de document d'achat (EKKO-EBELN) , afficher la liste des pièces jointes dans un ALV , et de pouvoir sélectioner une en double clickant pour l'afficher/la télécharger.

**Exercice 5 : Mise à jour commande client**

NOM PROGRAMME : [P005](../EXO_ALLIANCE/Z_MAJ_LBA.abap)
FICHIER : ![005](../00_EXERCICES/EXO_ABAP_5_ALV_Editable_et_Bapi.docx)

Créer un programme ABAP qui permet de mettre à jour un champ spécifique dans une commande client (VA02). 
Le bouton SAVE permettra de mettre à jour la SO.
Afficher les valeurs mises à jour dans un rapport ALV. 
Dans ce rapport ALV, ajouter un champ "Message" pour indiquer que le Sales Order (SO) a été mis à jour.

**Exercice 5 BIS : Création Pattern**

NOM DU PROGRAMME AVEC EXEMPLE PATTERN : [P005b](../EXO_ALLIANCE/Z_PATTERN_LBA.abap)
NOM DU PATTERN : Z_CART_LBA.
NOM DU MODULE FONCTION : [P005b](../EXO_ALLIANCE/Z_CART_LBA_EDITOR_EXIT.abap)
FICHIER : ![005b](../00_EXERCICES/EXO_ABAP_5_Bis_Patterns.docx)

LINK : ![005](https://dev-workbench.com/es/blog/abap-workbench-tricks-dynamic-patterns)

On crée un pattern et on écrit *$&$MUSTER pour envoyer au module fonction

IMAGE : ![005](.../00_RESSOURCES/01_PATTERN.png)

Créer le module fonction sans oublier de mettre dans TABLES :  BUFFER TYPE  RSWSOURCET

**Exercice 6 : Modifier Date SO**

NOM DU PROGRAMME : [P006](../EXO_ALLIANCE/Z_DATE_LBA.abap)

Le but de l’exo est de modifier la delivery date (ETDAT), de tous les items d'une SO (même objet/bapi que l’exo précédent , tables VBAK/VBAP)
SCR :Ecran numéro de commande (VBELN) , date de delivery (ETDAT)

Exemple : VA03 Pour afficher commande
SO de test : 17789

**Exercice 7 : Upload + Dowload + Send a file**

NOM DU PROGRAMME : [P007](../EXO_ALLIANCE/Z_EXERCICE_LBA.abap)

Afficher la liste des pièces attachées d'une commande
Charger vers le serveur un fichier, enregistrer sur le pc un fichier, envoyer par mail un fichier

**Exercice 8 : Smarforms**
NOM DU PROGRAMME : [P008](../EXO_ALLIANCE/Z_SMART_LBA.abap)
NOM DU SMARTFORM : Z_VBELN_LBA.
FICHIER : ![008](../00_EXERCICES/EXO_ABAP_7_smartforms.docx)

Créer un smartform d'une commande de vente en affichant adresse, posts, text, total.

**Exercice 9 : Envoi du Smarforms en PDF par mail et sur la commande VA02**

NOM DU PROGRAMME : [P009](../EXO_ALLIANCE/Z_SMARTMAIL_LBA.abap)
NOM DU SMARTFORM : Z_VBELN_LBA. (Créé au programme 008)

Envoyer le Smartform créé sur le programme précédent en PDF par mail et/ou l'ajouter dans les pièces attachées de la commande.
