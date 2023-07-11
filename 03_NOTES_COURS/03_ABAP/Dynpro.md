# Les dynpros

Les dynpros sont les différentes écrans, onglets...
Le Dynpro 1000 est l'écran créé automatiquement par SAP


Dans information technique on peut avoir le numéro d'écran, l'ID de paramètre, nom du programme

On va utiliser le Screen Painter pour ajouter, placer les boutons...

**PROCESS BEFOR OUTPUT** :
Tout ce qui se passe avant le chargement

**PROCESS AFTER INPUT** : 
Une fois que l'action de l'utilisateur a été déclenché.

Définir un nom **PF-STATUS** pour chaque bouton pour pouvoir l'utiliser dans le code avec un titre

```ABAP
PROCESS BEFORE OUTPUT.
 MODULE STATUS_9001.

PROCESS AFTER INPUT.
 MODULE USER_COMMAND_9001.
 ```


> ## **EXERCICE NUMERO 1**
___

- Créer un programme
- Cliq droit sur le nom de l'objet à gauche, créé un dynpro et on donne un numéro à l'écran
- Ecrire une description
- Activer

[Image Création écran](https://drive.google.com/file/d/1D9RbY-wQEQ_5DQCheXOQz18ZuJE067lL/view?usp=share_link)



- Ecrire dans le programme 

```ABAP
REPORT ZZ_DYNPRO_LBA_1.

START-OF-SELECTION.

CALL SCREEN 9001.

```
- Cliq droit sur le programme et créer un STATUT GUI : permet d'avoir les onglets etc...
Ecrire un nom de statut, une désignation et laisser sur statut dialogue.

[Image Création Statut GUI ](https://drive.google.com/file/d/17gfVMgyyeMWOoKXg3OjSAXs4ZbvmvIb-/view?usp=share_link)

- Dans touche de fonction, afficher la barre d'outil et donner un nom aux onglets qu'on va utiliser

- Dans la partie barre d'outil d'app, dans position 1-7, écrire "MESSAGE", double cliquer dessus et mettre un descriptif et mettre un nom d'icone existant (ici ICON_ACTIVITY).

- Double cliq sur ne noméro d'écran dans le programme.
Ca va ouvrir le code de l'écran

Décommenter les modules
Double cliquer sur le 1er module (stats_9001) pour le créer, le créer dans F01

- Dans F01 : Décommenter SET PF-STATUS et mettre le nom du statut GUI donné précedemment

- Idem pour le user_command_9001

Variable qui stoque l'action sur SAP s'apelle sy-ucomm

- Ecrire dans le module le code suivant :

```ABAP
MODULE user_command_9001 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'MESSAGE'.
      MESSAGE 'Bonjour' TYPE 'I'.
    WHEN OTHERS.
  ENDCASE.


ENDMODULE.
```

Mettre un WHEN OTHERS dans le CASE sinon message d'erreur.

Cliquer sur le dynpro 9001 à gauche, puis sur l'onglet Mise en forme pour ouvrir le SCREEN PAINTER

[Image mise en forme](https://drive.google.com/file/d/1n6wQLcOZ6t3lzjAM2vZC1jrKyEypQbQW/view?usp=share_link)


```ABAP
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'MESSAGE'.
      MESSAGE 'Bonjour' TYPE 'I'.
    WHEN 'EXEC'.
      SET PARAMETER ID 'AUN' FIELD gv_vbeln.
      CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
      WHEN OTHERS.
  ENDCASE.
  ```

  On a ajouté "SET PARAMETER..." pour que lorsqu'on écrit un numéro d'article (VBELN) dans la case, ça nous affiche la transaction VA03 (CALL TRANSACTION...).

  [image de l'écran d'affichage](https://drive.google.com/file/d/1hOLllBdxvgS4Va_f5807C7gEPtPk08r_/view?usp=share_link)

  [image affichage transaction](https://drive.google.com/file/d/1jByNXG9pehls4Z09a7Ap3jpQF30Jm2L4/view?usp=share_link)

On va créer un 2eme écran qui affiche certaines valeurs qu'on veut récupérer par rapport au numéro de commande rentré dans l'écran 1.

On ajoute un onglet dans le statu Gui du 1er écran qui permettra d'afficher le 2eme écran (ici nommé DISPLAY)

[image onglet display](https://drive.google.com/file/d/1LaeQBMYZgQe6ppl3bp5FE4Ae_RWenI0T/view?usp=share_link)

On ajoute le select dans le USER_COMMAND de l'écran 1 :

```ABAP
MODULE user_command_9001 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'MESSAGE'.
      MESSAGE 'Bonjour' TYPE 'I'.
    WHEN 'EXEC'.
      SET PARAMETER ID 'AUN' FIELD gv_vbeln.
      CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
    WHEN 'DISPLAY'.
*      SET PARAMETER ID 'AUN' FIELD gv_vbeln.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gv_vbeln
        IMPORTING
          output = gv_vbeln.

      SELECT SINGLE vbeln, erdat, auart, ernam
        FROM vbak
        WHERE vbeln = @gv_vbeln
        INTO @gs_vbak.


      CALL SCREEN 9002.

    WHEN OTHERS.
  ENDCASE.


ENDMODULE.
```

On a ajouté le module fonction "CONVERSION_EXIT_ALPHA_INPUT" pour convertir le numéro de commande entré comme le numéro de commande SAP (il ajoute plein de 0000 devant), pour cela :
SE16N, table VBACK, Autre fonction, activé la vue technique, colonne EXIT (pour conversion de format), double cliq sur le nom du EXIT et on copie le nom du module fonction.

On appelle le module fonction avec "modele" (ici avant le select) et il va faire la conversion dans le bon format automatiquement



Ensuite on va créer le 2eme écran dans le screen painter pour pouvoir afficher le résultat, dans STATUT GUI, on rajoute les onglets de retour, exit....

On crée des zones d'édition et dans NOM, on met le nom de la variable créé pour qu'il nous affiche le résultat du select.

[image créer zone edition](https://drive.google.com/file/d/1rIlmc73k3zaIRtEb8NcD4pWf1Ky6jff9/view?usp=share_link)

Attention, ici pour la date, il faut changer le format dans attribut quand on crée la zone de saisie


Pour grouper des radios boutons, séletionner les 2 et cliq droit, groupe de case d'option et DEFINIR.

[image grouper radio boutons =](https://drive.google.com/file/d/1jHPOV0Rb_f2lEDCPFLxrajSSQwP9-27v/view?usp=share_link)

SCREEN est une table avec entête
Une table avec entête est une table avec la première ligne vide qui va recevoir les informations du LOOP
On a donc pas besoin de créer une structure



