*&---------------------------------------------------------------------*
*&  Include           Z_GOS_LBA_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECTION-SCREEN SKIP. "Pour sauter une ligne

PARAMETERS p_ebeln TYPE ekpo-ebeln OBLIGATORY DEFAULT '4500018469'.

SELECTION-SCREEN SKIP. "Pour sauter une ligne

SELECTION-SCREEN : END OF BLOCK b1.