*&---------------------------------------------------------------------*
*& Report ZLBA_FORMATION3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlba_formation3.

INCLUDE zlba_formation3_top. "Déclaration de mes variables globales
INCLUDE zlba_formation3_scr. "SCREEN Déclaration de notre écran de sélection
INCLUDE zlba_formation3_f01. "Traitements effectués sur les données (sélection de données, affichage des données...)

START-OF-SELECTION.

PERFORM select_data.

end-OF-SELECTION.