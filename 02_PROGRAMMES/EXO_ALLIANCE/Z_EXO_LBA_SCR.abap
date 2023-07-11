*&---------------------------------------------------------------------*
*&  Include           Z_EXO_LBA_SCR
*&---------------------------------------------------------------------*

TABLES : bkpf.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

PARAMETERS p_comp TYPE bukrs OBLIGATORY. "Numéro de société
*SELECT-OPTIONS p_comp FOR bkpf-bukrs . "Au cas où on met un select option pour faire une recherche avec valeur vide
SELECT-OPTIONS s_numb FOR bkpf-belnr.
SELECTION-SCREEN SKIP. "Pour sauter une ligne
PARAMETER p_date TYPE bldat DEFAULT '20180101'.

SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.

* Paramètre pour télécharger un fichier dans un dossier local
PARAMETERS : p_file TYPE string DEFAULT 'C:\Users\Public\Downloads\data_file.csv'.


SELECTION-SCREEN END OF BLOCK b2.