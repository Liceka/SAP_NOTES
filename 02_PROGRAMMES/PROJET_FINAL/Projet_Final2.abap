*&---------------------------------------------------------------------*
*& Report Z_POEC_LBA
*&---------------------------------------------------------------------*
*& Date Cr�ation / Auteur / Motif
*& 27.04.2023 / LBA (Aelion) / Cr�ation progamme PROJET ABAP
*&---------------------------------------------------------------------*


REPORT Z_POEC_LBA.


INCLUDE Z_POEC_LBA_TOP.
INCLUDE Z_POEC_LBA_SCR.
INCLUDE Z_POEC_LBA_CLASS.
INCLUDE Z_POEC_LBA_F01.


START-OF-SELECTION.

PERFORM select_data.
