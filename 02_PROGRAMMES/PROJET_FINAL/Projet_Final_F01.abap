*&---------------------------------------------------------------------*
*& Include          Z_POEC_INTEG_LBA_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

    DATA : lv_filename TYPE string. " Variable qui va récupérer les données du fichier
  
    lv_filename = p_file.
  
  
    CALL FUNCTION 'GUI_UPLOAD'
      EXPORTING
        filename                = lv_filename
        filetype                = 'ASC'
      TABLES
        data_tab                = gt_file
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
        OTHERS                  = 17.
  
    IF sy-subrc <> 0.
  * Implement suitable error handling here
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form prepare_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM prepare_data .
  
  
  
    LOOP AT gt_file ASSIGNING FIELD-SYMBOL(<fsl_file>).
      SPLIT <fsl_file>-line AT cl_abap_char_utilities=>horizontal_tab INTO TABLE DATA(lt_split_csv). "On sépare au niveau des tabulations
  
  
      IF lt_split_csv IS NOT INITIAL.
        APPEND INITIAL LINE TO gt_data ASSIGNING FIELD-SYMBOL(<fsl_data>).
  
        IF <fsl_data> IS ASSIGNED.
          <fsl_data>-ebeln = lt_split_csv[ 1 ].
          <fsl_data>-bstyp = lt_split_csv[ 2 ].
  
          DATA(lv_aedat) = lt_split_csv[ 3 ].
          REPLACE ALL OCCURRENCES OF '.' IN lv_aedat WITH ''.
          DATA(lv_aedat_new) = lv_aedat+4(4) && lv_aedat+2(2) && lv_aedat(2).
          <fsl_data>-aedat = lv_aedat_new.
  
  *      <fsl_data>-aedat = lt_split_csv[ 3 ].
          <fsl_data>-ernam = lt_split_csv[ 4 ].
          <fsl_data>-waers = lt_split_csv[ 5 ].
          <fsl_data>-ebelp = lt_split_csv[ 6 ].
          <fsl_data>-matnr = lt_split_csv[ 7 ].
          <fsl_data>-werks = lt_split_csv[ 8 ].
  
          DATA(lv_value) = condense( lt_split_csv[ 9 ] ).
          REPLACE ALL OCCURRENCES OF '.' IN lv_value WITH ''. "On enlève les points 1.000,000 devient 1000,000
          TRANSLATE lv_value USING ',.'. "On modifie les , en . : 1000,000 devient 1000.000
          <fsl_data>-menge = lv_value.
  
  
          DATA(lv_value2) = condense( lt_split_csv[ 10 ] ). "On enlève les points 1.000,000 devient 1000,000
          REPLACE ALL OCCURRENCES OF '.' IN lv_value2 WITH ''. "On modifie les , en . : 1000,000 devient 1000.000
          TRANSLATE lv_value2 USING ',.'.
          <fsl_data>-netpr = lv_value2.
  
  
          DATA(lv_value3) = condense( lt_split_csv[ 11 ] ). "On enlève les points 1.000,000 devient 1000,000
          REPLACE ALL OCCURRENCES OF '.' IN lv_value3 WITH ''. "On modifie les , en . : 1000,000 devient 1000.000
          TRANSLATE lv_value3 USING ',.'.
          <fsl_data>-netwr = lv_value3.
  
          TRY.
              DATA(lv_meins) = lt_split_csv[ 12 ].
            CATCH cx_sy_itab_line_not_found. "S'il y a une tab en fin de ligne, on crée quand même la case avec un espace
              CLEAR lv_meins.
          ENDTRY.
          <fsl_data>-meins = lv_meins.
  
  
  
        ENDIF.
      ENDIF.
  
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form insert_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM insert_data .
  
    DATA: lv_ebeln     TYPE ekko-ebeln,
          lv_ebeln2    TYPE ekpo-ebeln,
          lv_ebelp2    TYPE ekpo-ebelp,
          ls_ekko      TYPE zekko_lba,
          ls_ekpo      TYPE zekpo_lba,
          lt_ekko      TYPE TABLE OF zekko_lba,
          lt_ekpo      TYPE TABLE OF zekpo_lba,
          ls_ekpo2     TYPE zekpo_lba.
  
  *  IF p_test = 'X'.
  
    CLEAR: lv_ebeln, lv_ebelp2.
  
    LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fsl_data>).
  
      CLEAR : ls_ekko, ls_ekpo.
  
      IF <fsl_data>-ebeln = lv_ebeln. "Pour ne créer qu'une ligne d'entête
        CONTINUE.
      ENDIF.
      lv_ebeln = <fsl_data>-ebeln.
  
      " Alimentation de l'entête
  
      ls_ekko-mandt = sy-mandt.
      ls_ekko-ebeln = <fsl_data>-ebeln.
      ls_ekko-bstyp = <fsl_data>-bstyp.
      ls_ekko-aedat = <fsl_data>-aedat.
      ls_ekko-ernam = <fsl_data>-ernam.
      ls_ekko-waers = <fsl_data>-waers.
  
      APPEND ls_ekko TO lt_ekko.
      WRITE : / lv_ebeln && ' created '.
  
      LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fsl_data2>) WHERE ebeln = <fsl_data>-ebeln.
  
        IF lv_ebeln2 = <fsl_data2>-ebeln AND lv_ebelp2 = <fsl_data2>-ebelp.
          DELETE lt_ekpo WHERE ebeln = <fsl_data2>-ebeln.
          DELETE lt_ekko WHERE ebeln = <fsl_data2>-ebeln.
          WRITE : / lv_ebeln2 && ' not created ' COLOR 6.
          CONTINUE.
        ELSE.
  
          " Alimentation des posts
          ls_ekpo-mandt = sy-mandt.
          ls_ekpo-ebeln = <fsl_data2>-ebeln.
          ls_ekpo-ebelp = <fsl_data2>-ebelp.
          ls_ekpo-matnr = <fsl_data2>-matnr.
          ls_ekpo-werks = <fsl_data2>-werks.
          ls_ekpo-menge = <fsl_data2>-menge.
          ls_ekpo-netpr = <fsl_data2>-netpr.
          ls_ekpo-netwr = <fsl_data2>-netwr.
          ls_ekpo-meins = <fsl_data2>-meins.
  
          lv_ebeln2 = <fsl_data2>-ebeln.
          lv_ebelp2 = <fsl_data2>-ebelp.
  
          APPEND ls_ekpo TO lt_ekpo.
  
        ENDIF.
  
        CLEAR ls_ekpo.
  
      ENDLOOP.
  
    ENDLOOP.
  
    IF p_test IS INITIAL.
      INSERT zekko_lba FROM TABLE lt_ekko ACCEPTING DUPLICATE KEYS.
      INSERT zekpo_lba FROM TABLE lt_ekpo ACCEPTING DUPLICATE KEYS.
    ENDIF.
  
  
  
  *  DATA : lo_alv           TYPE REF TO cl_salv_table,
  *         lo_alv_functions TYPE REF TO cl_salv_functions.
  *
  *  cl_salv_table=>factory(
  *  IMPORTING
  *  r_salv_table = lo_alv
  *  CHANGING
  *  t_table      = lt_ekko ).
  *
  *  lo_alv_functions = lo_alv->get_functions( ).
  *  lo_alv_functions->set_all( abap_true ).
  *
  *
  *  lo_alv->display( ).
  *
  *  cl_salv_table=>factory(
  *  IMPORTING
  *  r_salv_table = lo_alv
  *  CHANGING
  *  t_table      = lt_ekpo ).
  *
  *  lo_alv_functions = lo_alv->get_functions( ).
  *  lo_alv_functions->set_all( abap_true ).
  *
  *
  *  lo_alv->display( ).
  
  
  *    LOOP AT gt_ekko ASSIGNING FIELD-SYMBOL(<fsl_message_test>).
  *      WRITE:/ <fsl_message_test>-ebeln, ' created'.
  *    ENDLOOP.
  *
  *  ELSE.
  *
  *    INSERT zekko_lba FROM TABLE gt_ekko ACCEPTING DUPLICATE KEYS.
  *    INSERT zekpo_lba FROM TABLE gt_ekpo ACCEPTING DUPLICATE KEYS.
  *
  *    LOOP AT gt_ekko ASSIGNING FIELD-SYMBOL(<fsl_message>).
  *      WRITE:/ <fsl_message>-ebeln, ' created'.
  *    ENDLOOP.
  
  ENDFORM.