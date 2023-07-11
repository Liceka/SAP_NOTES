*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION6_TOP
*&---------------------------------------------------------------------*

*Programme qui permet de récupérer les commandes d'achat et les postes
*et d'afficher les numéros de commandes, numéro article, langues, désignation articlue
*sélection via un module fonction


*on doit mettre les tables quand on met des select option dans le top

TABLES : ekko, ekpo.


* création du modèle :
TYPES : BEGIN OF ty_final,
          ebeln1 TYPE ekko-ebeln,
          aedat1 TYPE ekko-aedat,
          maktx  TYPE makt-maktx.
          INCLUDE STRUCTURE ekpo.
TYPES END OF ty_final.
* création de la table à partir du modèle :
DATA : gt_final TYPE TABLE OF ty_final.