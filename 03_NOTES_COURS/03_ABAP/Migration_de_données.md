# Outils de miragtion de données: *LSMW/batch input/CallTransaction/SHDB*


 ## 1. Définitions des outils:
___

Intégration, migration des données sur SAP, pour passer d'un ancien systeme à SAP ou mettre à jour ses données
Technique de migration de données en masse

Venir implanter, ajouter, transférer, récupérer de données pour intégrer dans systeme SAP

La BAPI est par exemple une technique d'intégration pour migrer les données à partir d'un fichier venu d'une source externe, elle crée un objet métier dans la base de données


## 2. Batch input

[EXEMPLE](../../02_PROGRAMMES/BATCH_INPUT/Programme_patch_input.abap)


Chacune des manipulations va être simulée comme si on rentrait les valeurs une par une dans la transaction VA01 par ex. et on va le traduire en code

Pour créer des transaction SAP génériquement 
 2 étapes :
 - Mise en forme des données : identifer les données minimum qui vont être utile pour créer l'objet
 - Intégration des données via simulation de la transaction standart

Il faut utiliser une table interne de structure BDCDATA, pas desoin de structure pour la remplir car c'est une table avec entête (with header line)
Chaque ligne correspond a une action faite dans l'écran comme si on le rentrait manuellement
Pour chaque nouvel écran, une occurence (une ligne) est créée dans la table (program, dunpro, dunbegin (X) FNAM (nom du champ),FVAL (valeur du champs)) On rempli les 3 premiers au début et une fois qu'on est sur l'écran on rempli FNAM et FVAL


```ABAP
VOIR FICHIER PROGRAMME_PATCH_INPUT.ABAP

PERFORM BDC_dynpro  USING 'SAPMV45A' '0101'. " on doit d'abord donner le nom du programme et de l'écran

  PERFORM BDC_field   USING 'BDC_CURSOR' 'VBAK-AUART'. " On positionne le curseur sur COMMANDE CLIENT
  PERFORM BDC_field   USING 'VBAK-AUART' 'JRE'. " Dans le champs où le curseur est placé, on entre la valeur JRE


  FORM BDC_dynpro USING program dynpro.

  CLEAR bdctab.

  bdctab-program = program.
  bdctab-dynpro = dynpro.
  bdctab-dynbegin = 'X'.

  APPEND bdctab.


ENDFORM.

FORM BDC_field USING fnam fval.

  CLEAR bdctab.
  bdctab-fnam = fnam.
  bdctab-fval = fval.
  APPEND bdctab.

ENDFORM.
```

Pour voir dans le DEBEUG l'action du cliq : Sy-ucomm ou ok-code


## 3. SHDB : enregistrement d'un batch input
___


SHDB : Transaction qui permet de faire des enregistrement des simulations des manipulations

Tout préparer avant pour être prêt lors de l'enregistrement car il ne faut pas faire des maniupaltions inutiles.

Transaction SHDB
Nouvel enregistrement
Nom enregistrement
Code transaction (qui va s'ouvrir une fois l'enregistrement lancé)
Lancer enregistrement

A la fin, cliquer sur enregitrer

Revenir sur la transaction SHDB
-On peut stocker l'enregistrement dans un fichier
-Ou le transformer en module fonction
-Ou le transférer dans un programme


Pour aller plus vite et reprendre une commande d'achat (par exemple) déjà créé :
- Transaction commande achat : ME21N
- Activer synthèse des documents
- Variante de sélection
- Commandes d'achat
- Choisir un document d'achat + valider (horloge)
- Cliq sur le doc achat à gauche
- Cliq sur Reprendre et modifier si besoin
- Enregistrer

On peut faire cette opération de copie en faisant un enregistrement.

## 4. LSMW : Importer données non SAP vers SAP
___

4 façons d'importer les données dans SAP :
- Patch input
- BAPI
- IDOC doc où on va stocker les données (contener qui va permettre de transférer les infos à SAP)
- Entrée directe

Aller dans la transaction LSMW, écrire les noms, puis feuille blanche 2x, puis F8 après avoir rajouté les desctiptions

[Valider]

[Batch input recording]

[recordings : overview] (Logo Montagne)

[Page blanche], rentrer les descriptions
et lancer la transaction VA01
Terminer l'enregistrement avec la disquette.

La ligne orange