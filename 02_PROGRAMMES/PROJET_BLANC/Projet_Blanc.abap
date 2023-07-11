*&---------------------------------------------------------------------*
*& Report ZLBA_PROJECT_BLANC
*&---------------------------------------------------------------------*
*& Date Création / Auteur / Motif
*& 24.04.2023 / LBA (Aelion) / Création progamme PROJET ABAP
*&---------------------------------------------------------------------*


REPORT ZLBA_PROJECT_BLANC.

INCLUDE zlba_project_blanc_top.
INCLUDE zlba_project_blanc_scr.
INCLUDE zlba_project_blanc_f01.

START-OF-SELECTION.

PERFORM get_data. "Perform pour récupérer les données
PERFORM prepare_data. "Perform pour réorganiser les données
PERFORM insert_data. "Perform pour insérer les données