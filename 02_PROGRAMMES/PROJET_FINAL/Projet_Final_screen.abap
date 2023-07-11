*&---------------------------------------------------------------------*
*& Include          Z_POEC_INTEG_LBA_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-001.

PARAMETERS : p_file TYPE localfile,"Paramètre pour sélectionner un fichier local
             p_test AS CHECKBOX DEFAULT 'X'. "Pour simuler l'insertion du fichier


SELECTION-SCREEN END OF BLOCK B01.


* On configure le paramètre fichier PC pour ouvrir une fenêtre d'exploraion
* pour récupérer le fichier PC :

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

CALL FUNCTION 'F4_FILENAME' "Local upload
EXPORTING
  program_name  = syst-cprog
  dynpro_number = syst-dynnr
  field_name    = 'p_file'
IMPORTING
  file_name     = p_file.