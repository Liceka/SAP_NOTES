*&---------------------------------------------------------------------*
*&  Include           Z_004_UWU_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b000 WITH FRAME TITLE text-000.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF BLOCK b100 WITH FRAME TITLE text-100.


    PARAMETERS: p_key   TYPE swo_typeid      OBLIGATORY DEFAULT '4500018469' MATCHCODE OBJECT z_matchcode_ekko_fgi,
                p_type  TYPE swo_objtyp      OBLIGATORY DEFAULT 'BUS2012',
                p_catid TYPE sibflporb-catid OBLIGATORY DEFAULT 'BO'.


    SELECTION-SCREEN SKIP 2.
    SELECTION-SCREEN PUSHBUTTON 31(31) lb1 USER-COMMAND pb1.
    SELECTION-SCREEN SKIP.


    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(15) text-001 FOR FIELD p_rad1.
      PARAMETERS: p_rad1 RADIOBUTTON GROUP rb1 USER-COMMAND fcode DEFAULT 'X'.
      SELECTION-SCREEN COMMENT 31(7) text-002 FOR FIELD p_rad2.
      PARAMETERS: p_rad2 RADIOBUTTON GROUP rb1.
    SELECTION-SCREEN END OF LINE.


  SELECTION-SCREEN END OF BLOCK b100.


  SELECTION-SCREEN SKIP.


  SELECTION-SCREEN BEGIN OF BLOCK b200 WITH FRAME TITLE text-200.


    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(15) text-003 FOR FIELD p_rad3 MODIF ID sc1.
      PARAMETERS: p_rad3 RADIOBUTTON GROUP rb2 USER-COMMAND fcode DEFAULT 'X' MODIF ID sc1.
      PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY DEFAULT 'C:\Users\Public\Downloads\DATA_FILE.csv' MODIF ID sc1.
      SELECTION-SCREEN PUSHBUTTON 66(9) lb2 USER-COMMAND pb2 MODIF ID sc1.
    SELECTION-SCREEN END OF LINE.

        SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(17) text-007 FOR FIELD p_nam MODIF ID sc1.
      PARAMETERS: p_nam TYPE string OBLIGATORY DEFAULT 'File' MODIF ID sc1.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(17) text-008 FOR FIELD p_ext MODIF ID sc1.
      PARAMETERS: p_ext TYPE string OBLIGATORY DEFAULT 'CSV' MODIF ID sc1.
    SELECTION-SCREEN END OF LINE.


    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(15) text-004 FOR FIELD p_rad4 MODIF ID sc1.
      PARAMETERS: p_rad4 RADIOBUTTON GROUP rb2 MODIF ID sc1.
      PARAMETERS: p_dll  TYPE CHAR100 OBLIGATORY DEFAULT 'C:\Users\Public\Downloads\PUT' MODIF ID sc1.
      SELECTION-SCREEN PUSHBUTTON 66(9) lb3 USER-COMMAND pb3 MODIF ID sc1.
    SELECTION-SCREEN END OF LINE.


  SELECTION-SCREEN END OF BLOCK b200.


  SELECTION-SCREEN BEGIN OF BLOCK b300 WITH FRAME TITLE text-300.


    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(17) text-005 FOR FIELD p_recevr MODIF ID sc2.
      PARAMETERS: p_recevr TYPE so_recname      OBLIGATORY DEFAULT 'lisa.bagues@alliance4u.fr' MODIF ID sc2.
      SELECTION-SCREEN PUSHBUTTON 66(9) lb4 USER-COMMAND pb4 MODIF ID sc2.
    SELECTION-SCREEN END OF LINE.


    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(17) text-006 FOR FIELD p_sender MODIF ID sc2.
      PARAMETERS: p_sender TYPE so_recname      OBLIGATORY DEFAULT 'frederic.giustini@alliance4u.fr' MODIF ID sc2.
    SELECTION-SCREEN END OF LINE.


  SELECTION-SCREEN END OF BLOCK b300.


  SELECTION-SCREEN SKIP.


SELECTION-SCREEN END OF BLOCK b000.

AT SELECTION-SCREEN.

  CASE sscrfields.
    WHEN 'PB1'.
      PERFORM attachments_displaying.
    WHEN 'PB2'.
      IF p_rad3 = 'X'.
        PERFORM attachments_uploading.
      ENDIF.
    WHEN 'PB3'.
      IF p_rad4 = 'X'.
        PERFORM attachments_downloading.
      ENDIF.
    WHEN 'PB4'.
      PERFORM control_email.

      IF gv_receiv_email = abap_true.
      PERFORM attachments_emailing.
      ENDIF.

  ENDCASE.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.

    IF p_rad2 = 'X' AND screen-group1 = 'SC1'.
      screen-active = 0.
      MODIFY SCREEN.
    ELSEIF p_rad1 = 'X' AND screen-group1 = 'SC2'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.

  ENDLOOP.

  LOOP AT SCREEN.
    IF screen-name = 'P_FILE'.
      IF p_rad3 IS NOT INITIAL.
        screen-input  = 1.
      ELSE.
        screen-input  = 0.
      ENDIF.
      MODIFY SCREEN.
    ELSEIF screen-name = 'P_DLL'.
      IF p_rad4 IS NOT INITIAL.
        screen-input = 1.
      ELSE.
        screen-input  = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'f4_filename'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = 'p_file'
    IMPORTING
      file_name     = p_file.