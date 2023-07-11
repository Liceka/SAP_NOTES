*&---------------------------------------------------------------------*
*& Include          Z_POEC_LBA_SCR
*&---------------------------------------------------------------------*



SELECTION-SCREEN BEGIN OF BLOCK B01 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : s_ebeln FOR ZEKKO_LBA-ebeln MATCHCODE OBJECT ZEBELN_LBA.
SELECT-OPTIONS : s_matnr FOR ZEKPO_LBA-matnr MATCHCODE OBJECT ZMATNR_LBA.

SELECTION-SCREEN END OF BLOCK B01.
