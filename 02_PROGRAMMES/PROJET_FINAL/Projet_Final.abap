*&---------------------------------------------------------------------*
*& Report Z_POEC_INTEG_LBA
*&---------------------------------------------------------------------*
*& Date Création / Auteur / Motif
*& 27.04.2023 / LBA (Aelion) / Création progamme PROJET ABAP
*&---------------------------------------------------------------------*


REPORT Z_POEC_INTEG_LBA.


INCLUDE Z_POEC_INTEG_LBA_TOP.
INCLUDE Z_POEC_INTEG_LBA_SCR.
INCLUDE Z_POEC_INTEG_LBA_F01.

START-OF-SELECTION.

PERFORM get_data. "Perform pour récupérer les données
PERFORM prepare_data. "Perform pour réorganiser les données
PERFORM insert_data. "Perform pour insérer les données