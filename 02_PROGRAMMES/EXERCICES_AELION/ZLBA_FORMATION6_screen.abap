*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION6_SCR
*&---------------------------------------------------------------------*

*Programme qui permet de récupérer les commandes d'achat et les postes
*et d'afficher les numéros de commandes, numéro article, langues, désignation articlue
*sélection via un module fonction



SELECT-OPTIONS : s_ebeln FOR ekko-ebeln,
                s_matnr FOR ekpo-matnr.
PARAMETERS : p_spras TYPE makt-spras OBLIGATORY.