*&---------------------------------------------------------------------*
*& Report  Z_PO_VPI
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_po_vpi.

CONSTANTS lc_zekko TYPE tabname VALUE 'ZEKKO_VPI'.
CONSTANTS lc_zekpo TYPE tabname VALUE 'ZEKPO_VPI'.

TYPES : ty_zekko TYPE zekko_vpi.
TYPES : ty_zekpo TYPE zekpo_vpi.

TYPES : BEGIN OF ty_global,
          ebeln TYPE ebeln,
          bstyp TYPE bstyp,
          aedat TYPE aedat,
          ernam TYPE ernam,
          waers TYPE waers,
          ebelp TYPE ebelp,
          matnr TYPE matnr,
          werks TYPE werks_d,
          menge TYPE bstmg,
          netpr TYPE bprei,
          netwr TYPE bwert,
          meins TYPE bstme,
        END OF ty_global,
        tty_global TYPE STANDARD TABLE OF ty_global.


TYPES : tty_zekko TYPE STANDARD TABLE OF ty_zekko.
TYPES : tty_zekpo TYPE STANDARD TABLE OF ty_zekpo.

DATA wol_salv TYPE REF TO cl_salv_table.
DATA: wtl_global TYPE tty_global,
      wsl_global TYPE ty_global.
DATA: wtl_zekpo TYPE tty_zekpo,
      wsl_zekpo TYPE ty_zekpo.
DATA: wtl_zekko TYPE tty_zekko,
      wsl_zekko TYPE ty_zekko.
DATA wvl_error TYPE boolean.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE text-001.
PARAMETERS p_file TYPE string.
PARAMETERS p_test TYPE xfeld AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f4_file CHANGING p_file.

START-OF-SELECTION.
**********************************************************************
***  GET_DATA
**********************************************************************
  cl_gui_frontend_services=>gui_upload(
    EXPORTING
      filename                = p_file    " Name of file
*    filetype                = 'ASC'    " File Type (ASCII, Binary)
      has_field_separator     = abap_true    " Columns Separated by Tabs in Case of ASCII Upload
      dat_mode                = abap_true    " Numeric and date fields are in DAT format in WS_DOWNLOAD
    CHANGING
      data_tab                = wtl_global    " Transfer table for file contents
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19 ).
  IF sy-subrc <> 0.
    CLEAR wtl_global.
  ENDIF.

**********************************************************************
***   MAPPING
**********************************************************************
  SORT wtl_global BY ebeln ebelp.
  LOOP AT wtl_global ASSIGNING FIELD-SYMBOL(<fsl_glob>).
    wsl_global = <fsl_glob>.
    AT NEW ebeln.
*  nouvelle commande
      MOVE-CORRESPONDING wsl_global TO wsl_zekko.
      APPEND wsl_zekko TO wtl_zekko.
    ENDAT.
    wsl_zekpo = CORRESPONDING #( wsl_global ).
    APPEND wsl_zekpo TO wtl_zekpo.
  ENDLOOP.


**********************************************************************
***   INSERT DDB
**********************************************************************
  LOOP AT wtl_zekko INTO wsl_zekko.
    CLEAR wvl_error.
    INSERT (lc_zekko) FROM wsl_zekko.
    IF sy-subrc = 0.
      LOOP AT wtl_zekpo INTO wsl_zekpo WHERE ebeln = wsl_zekko-ebeln.

        INSERT (lc_zekpo) FROM wsl_zekpo.
        IF sy-subrc <> 0.
          wvl_error = abap_true.
        ENDIF.
      ENDLOOP.
    ELSE.
      wvl_error = abap_true.
    ENDIF.

    IF wvl_error = abap_false.
      FORMAT COLOR OFF.
      WRITE : /  wsl_zekko-ebeln, 'created'.
      IF p_test = abap_true.
        ROLLBACK WORK.
      ELSE.
        COMMIT WORK.
      ENDIF.
    ELSE.
      FORMAT COLOR 6.
      WRITE : / wsl_zekko-ebeln, 'not created'.
      ROLLBACK WORK.
    ENDIF.
  ENDLOOP.

*&---------------------------------------------------------------------*
*&      Form  F4_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_FILE  text
*----------------------------------------------------------------------*
FORM f4_file  CHANGING pv_file TYPE string.

  DATA wvl_rc TYPE i.
  DATA wtl_tab TYPE filetable.

  cl_gui_frontend_services=>file_open_dialog(
    CHANGING
      file_table              = wtl_tab    " Table Holding Selected Files
      rc                      = wvl_rc    " Return Code, Number of Files or -1 If Error Occurred
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5 ).
  IF sy-subrc = 0.
    TRY.
        pv_file = wtl_tab[ 1 ]-filename.
      CATCH cx_sy_itab_line_not_found.
        CLEAR pv_file.
    ENDTRY.
  ENDIF.

ENDFORM.  "F4_FILE
