*&---------------------------------------------------------------------*
*& Report  Z_GOS_LBA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

*Dans cet exercice on souhaite à partir d'une saisie d'un ou plusieurs numéro de document d'achat (EKKO-EBELN), 
*afficher la liste des pièces jointes dans un ALV , et de pouvoir sélectioner une en double clickant pour l'afficher/la télécharger.

REPORT Z_GOS_LBA.


INCLUDE Z_GOS_LBA_TOP.
INCLUDE Z_GOS_LBA_SCR.

INCLUDE Z_GOS_LBA_LCL.
INCLUDE Z_GOS_LBA_F01.

START-OF-SELECTION.

PERFORM POPUP.
*PERFORM ALV.
*PERFORM ALV2.