*&---------------------------------------------------------------------*
*&  Include           Z_MAIL_LBA_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECTION-SCREEN SKIP. "Pour sauter une ligne

PARAMETERS p_file TYPE string OBLIGATORY DEFAULT 'C:\usr\sap\put\PGTO 07.01.2020.txt'.

SELECTION-SCREEN SKIP. "Pour sauter une ligne

PARAMETER p_mail TYPE string OBLIGATORY DEFAULT 'lisa.bagues@alliance4u.fr'.

SELECTION-SCREEN : END OF BLOCK b1.