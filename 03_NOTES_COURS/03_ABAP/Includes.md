Toujours 3 includes dans le programme :

```ABAP
INCLUDE zlba_formation3_top. "Déclaration de mes variables globales
INCLUDE zlba_formation3_scr. "SCREEN Déclaration de notre écran de sélection
INCLUDE zlba_formation3_f01. "Traitements effectués sur les données (sélection de données, affichage des données...)

START-OF-SELECTION.


END-OF-SELECTION.

```

Ensuite il faut faire un start-selection pour démarrer le programme.



ROUTINE = PERFOM

Pour structurer/organiser le programme

Petite boite qu'on range dans des includes qui sont des grandes boites

PERFORM SELECT DATA

