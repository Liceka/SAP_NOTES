*&---------------------------------------------------------------------*
*&  Include           Z_DATE_LBA_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-001.

PARAMETERS : p_vbeln TYPE vbap-vbeln DEFAULT '17789' OBLIGATORY,
             p_etdat TYPE vbep-edatu.

SELECTION-SCREEN END OF BLOCK B01.