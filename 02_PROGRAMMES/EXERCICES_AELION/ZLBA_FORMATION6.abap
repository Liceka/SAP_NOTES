*&---------------------------------------------------------------------*
*& Report ZLBA_FORMATION6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLBA_FORMATION6.

*Programme qui permet de récupérer les commandes d'achat et les postes
*et d'afficher les numéros de commandes, numéro article, langues, désignation articlue
*sélection via un module fonction
*
INCLUDE zlba_formation6_top. "Déclaration de mes variables globales
INCLUDE zlba_formation6_scr. "SCREEN Déclaration de notre écran de sélection
INCLUDE zlba_formation6_f01. "Traitements effectués sur les données (sélection de données, affichage des données...)

START-OF-SELECTION.

PERFORM select_data.

END-OF-SELECTION.