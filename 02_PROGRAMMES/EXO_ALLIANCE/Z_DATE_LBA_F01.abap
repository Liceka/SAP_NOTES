*&---------------------------------------------------------------------*
*&  Include           Z_DATE_LBA_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DATA_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_initialization .

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_data .

  SELECT vbap~vbeln vbap~posnr vbep~edatu vbep~etenr vbep~TDDAT vbep~MBDAT vbep~LDDAT vbep~WADAT
  FROM vbap
  INNER JOIN vbep ON vbap~vbeln = vbep~vbeln AND vbap~posnr = vbep~posnr
  "and vbap~posnr = vbep~posnr
  INTO TABLE gt_type
  WHERE vbap~vbeln = p_vbeln.

  gv_date = p_etdat.


  LOOP AT gt_type ASSIGNING FIELD-SYMBOL(<lfs_type>).

    gs_new-vbeln = <lfs_type>-vbeln.
    gs_new-posnr = <lfs_type>-posnr.
    gs_new-edatu = gv_date.
    gs_new-etenr = <lfs_type>-etenr.
    gs_new-TDDAT = <lfs_type>-TDDAT.
    gs_new-MBDAT = <lfs_type>-MBDAT.
    gs_new-LDDAT = <lfs_type>-LDDAT.
    gs_new-WADAT = <lfs_type>-WADAT.

    APPEND gs_new  TO gt_new.

  ENDLOOP.


  DATA:   lo_alv           TYPE REF TO cl_salv_table,
          lo_alv_functions TYPE REF TO cl_salv_functions,
          lo_columns       TYPE REF TO cl_salv_columns_table,
          lo_message       TYPE REF TO cx_salv_msg.

  TRY.
      CALL METHOD cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = gt_new ).

      lo_alv_functions = lo_alv->get_functions( ).
      lo_alv_functions->set_all( abap_true ).
      lo_columns = lo_alv->get_columns( ).
      lo_columns->set_optimize( abap_true ).
      lo_alv->display( ).

    CATCH cx_salv_msg INTO lo_message.
  ENDTRY.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAVE_MODIFICATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_modification .

  DATA :   lt_return TYPE TABLE OF bapiret2.

  DATA :   ls_order_header_in  LIKE  bapisdh1,
           ls_order_header_inx LIKE  bapisdh1x.

  DATA :   ls_order_item_in  TYPE  bapisditm,
           lt_order_item_in  TYPE TABLE OF bapisditm,

           ls_order_item_inx TYPE  bapisditmx,
           lt_order_item_inx TYPE TABLE OF bapisditmx,

           ls_order_keys     TYPE  bapisdkey,
           lt_order_keys     TYPE TABLE OF bapisdkey.

  DATA :   ls_schedule_lines  TYPE  bapischdl,
           lt_schedule_lines  TYPE TABLE OF bapischdl,

           ls_schedule_linesx TYPE  bapischdlx,
           lt_schedule_linesx TYPE TABLE OF bapischdlx.


  gv_date = p_etdat.

  IF gv_date IS NOT INITIAL.

    LOOP AT gt_new ASSIGNING FIELD-SYMBOL(<lfs_new>).
*    READ TABLE gt_old ASSIGNING FIELD-SYMBOL(<lfs_old>) WITH KEY vbeln = <lfs_outtab>-vbeln
*                                                                 posnr = <lfs_outtab>-posnr
*                                                                 abgru = <lfs_outtab>-abgru.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      ls_order_header_in-ref_doc = <lfs_new>-vbeln.
      ls_order_header_inx-ref_doc = 'X'.

      ls_order_header_inx-updateflag = 'U'.

      ls_order_item_in-ref_doc = <lfs_new>-vbeln.
      ls_order_item_inx-ref_doc = 'X'.

      ls_order_item_in-itm_number = <lfs_new>-posnr.
      ls_order_item_inx-itm_number = <lfs_new>-posnr.
*      ls_order_item_inx-itm_number = 'X'.


      APPEND ls_order_item_in  TO lt_order_item_in.
      APPEND ls_order_item_inx TO lt_order_item_inx.

      ls_schedule_linesx-updateflag  = 'U'.

      ls_schedule_lines-itm_number = <lfs_new>-posnr.
      ls_schedule_linesx-itm_number = <lfs_new>-posnr.
*      ls_schedule_linesx-itm_number = 'X'.

      ls_schedule_lines-sched_line = <lfs_new>-etenr.
      ls_schedule_linesx-sched_line = <lfs_new>-etenr.
*      ls_schedule_linesx-sched_line = 'X'.

      ls_schedule_lines-req_date = <lfs_new>-edatu .
      ls_schedule_linesx-req_date = 'X'.

      ls_schedule_lines-DLV_DATE = <lfs_new>-edatu .
      ls_schedule_linesx-DLV_DATE = 'X'.

      ls_schedule_lines-date_type = '1'.
      ls_schedule_linesx-date_type = 'X'.

* Transport planning time
      ls_schedule_lines-tp_date = <lfs_new>-tddat.
      ls_schedule_linesx-tp_date = 'X'.

* Material Staging time
      ls_schedule_lines-ms_date = <lfs_new>-mbdat.
      ls_schedule_linesx-ms_date = 'X'.
*
* Loading time

      ls_schedule_lines-load_date = <lfs_new>-lddat.
      ls_schedule_linesx-load_date = 'X'.

* Time of goods Issue
      ls_schedule_lines-gi_date = <lfs_new>-wadat.
      ls_schedule_linesx-gi_date = 'X'.

*ls_schedule_lines-PLAN_SCHED_TYPE bapischdl

      APPEND ls_schedule_lines  TO lt_schedule_lines.
      APPEND ls_schedule_linesx  TO lt_schedule_linesx.


      ls_order_keys-doc_number = <lfs_new>-vbeln.
      ls_order_keys-itm_number = <lfs_new>-posnr.
      ls_order_keys-sched_lin = <lfs_new>-etenr.


      APPEND ls_order_keys     TO lt_order_keys.

      CLEAR : ls_order_item_in,
              ls_order_item_inx,
              ls_schedule_lines,
              ls_schedule_linesx,
              ls_order_keys.

    ENDLOOP.

    IF lt_schedule_lines IS NOT INITIAL.

      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = p_vbeln
*          order_header_in  = ls_order_header_in
          order_header_inx = ls_order_header_inx
*         SIMULATION       =
*         BEHAVE_WHEN_ERROR           = ' '
*         INT_NUMBER_ASSIGNMENT       = ' '
*         LOGIC_SWITCH     =
*         NO_STATUS_BUF_INIT          = ' '
        TABLES
          return           = lt_return
*          order_item_in    = lt_order_item_in
*          order_item_inx   = lt_order_item_inx
*         PARTNERS         =
*         PARTNERCHANGES   =
*         PARTNERADDRESSES =
*         ORDER_CFGS_REF   =
*         ORDER_CFGS_INST  =
*         ORDER_CFGS_PART_OF          =
*         ORDER_CFGS_VALUE =
*         ORDER_CFGS_BLOB  =
*         ORDER_CFGS_VK    =
*         ORDER_CFGS_REFINST          =
          schedule_lines   = lt_schedule_lines
          schedule_linesx  = lt_schedule_linesx
*         ORDER_TEXT       =
*          order_keys       = lt_order_keys
*         CONDITIONS_IN    =
*         CONDITIONS_INX   =
*         EXTENSIONIN      =
*         EXTENSIONEX      =
        .

    ENDIF.

    CLEAR : lt_order_item_in,
            lt_order_item_inx,
            lt_order_keys.

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<lfs_return>) WHERE type = 'E' OR type = 'A'.

    ENDLOOP.

    IF sy-subrc = 0.

      ROLLBACK WORK.

      MESSAGE : 'Error !! The modifications can''t be update on DB.' TYPE 'I' DISPLAY LIKE 'E' .


      DATA:   lo_alv           TYPE REF TO cl_salv_table,
              lo_alv_functions TYPE REF TO cl_salv_functions,
              lo_columns       TYPE REF TO cl_salv_columns_table,
              lo_message       TYPE REF TO cx_salv_msg.

      TRY.
          CALL METHOD cl_salv_table=>factory(
            IMPORTING
              r_salv_table = lo_alv
            CHANGING
              t_table      = lt_return ).

          lo_alv_functions = lo_alv->get_functions( ).
          lo_alv_functions->set_all( abap_true ).
          lo_columns = lo_alv->get_columns( ).
          lo_columns->set_optimize( abap_true ).
          lo_alv->display( ).

        CATCH cx_salv_msg INTO lo_message.
      ENDTRY.



    ELSE.

      COMMIT WORK.

      MESSAGE : 'Success' TYPE 'I'.


      TRY.
          CALL METHOD cl_salv_table=>factory(
            IMPORTING
              r_salv_table = lo_alv
            CHANGING
              t_table      = lt_return ).

          lo_alv_functions = lo_alv->get_functions( ).
          lo_alv_functions->set_all( abap_true ).
          lo_columns = lo_alv->get_columns( ).
          lo_columns->set_optimize( abap_true ).
          lo_alv->display( ).

        CATCH cx_salv_msg INTO lo_message.
      ENDTRY.

    ENDIF.

  ELSE.

    MESSAGE : 'MISSING NEW DELIVERY DATE' TYPE 'I' DISPLAY LIKE 'E'.

  ENDIF.

ENDFORM.