*&---------------------------------------------------------------------*
*&  Include           Z_PROGRAM_003_FGI_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b000 WITH FRAME TITLE TEXT-000.

  PARAMETERS: p_file_n TYPE string OBLIGATORY DEFAULT 'Data1',
              p_path_f TYPE string OBLIGATORY DEFAULT 'C:\usr\sap\put\PGTO 07.01.2020.txt',
              p_receiv TYPE string OBLIGATORY DEFAULT 'lisa.bagues@alliance4u.fr',
              p_sender TYPE string OBLIGATORY DEFAULT 'frederic.giustini@alliance4u.fr',
              p_subjec TYPE string OBLIGATORY DEFAULT 'Hello !'.

              SELECTION-SCREEN SKIP.

  PARAMETERS: p_desc_m TYPE string OBLIGATORY DEFAULT '(づ ◕‿◕ )づ   ⌗(́◉◞౪◟◉‵⌗)'.

SELECTION-SCREEN END OF BLOCK b000.