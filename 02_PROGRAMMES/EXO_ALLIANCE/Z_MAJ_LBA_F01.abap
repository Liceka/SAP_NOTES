*&---------------------------------------------------------------------*
*&  Include           Z_MAJ_LBA_F01
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

    CLEAR : gt_outtab,
            gt_old.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  SELECT_DATA
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  
  
  FORM create_and_init_alv CHANGING pt_outtab LIKE gt_outtab[]
                                    pt_fieldcat TYPE lvc_t_fcat
                                    ps_layout TYPE lvc_s_layo.
  
    DATA: lt_exclude TYPE ui_functions.
  
    CREATE OBJECT g_custom_container
      EXPORTING
        container_name = g_container.
    CREATE OBJECT g_grid
      EXPORTING
        i_parent = g_custom_container.
  
  * Build fieldcat and set columns ABGRU
  * edit enabled.
    PERFORM build_fieldcat CHANGING pt_fieldcat.
  
  *§2.Optionally restrict generic functions to 'change only'.
  *   (The user shall not be able to add new lines).
    PERFORM exclude_tb_functions CHANGING lt_exclude.
  
  
    SELECT vbak~vbeln vbap~posnr vbap~abgru
      FROM vbak
      INNER JOIN vbap ON vbak~vbeln = vbap~vbeln
      INTO TABLE pt_outtab UP TO g_max ROWS
      WHERE vbak~vbeln = p_vbeln.
  
    CALL METHOD g_grid->set_table_for_first_display
      EXPORTING
        is_layout            = ps_layout
        it_toolbar_excluding = lt_exclude
      CHANGING
        it_fieldcatalog      = pt_fieldcat
        it_outtab            = pt_outtab.
  
  * set editable cells to ready for input
    CALL METHOD g_grid->set_ready_for_input
      EXPORTING
        i_ready_for_input = 1.
  
  
  *§3.Optionally register ENTER to raise event DATA_CHANGED.
  *   (Per default the user may check data by using the check icon).
    CALL METHOD g_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_enter.
  
    CREATE OBJECT g_event_receiver.
    SET HANDLER g_event_receiver->handle_data_changed FOR g_grid.
  
  ENDFORM.
  
  FORM build_fieldcat CHANGING pt_fieldcat TYPE lvc_t_fcat.
  
    DATA ls_fcat TYPE lvc_s_fcat.
  
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZSSALES'
      CHANGING
        ct_fieldcat      = pt_fieldcat.
  
    LOOP AT pt_fieldcat INTO ls_fcat.
      IF    ls_fcat-fieldname EQ 'ABGRU'.
  
  *§1.Set status of columns ABGRU to editable.
        ls_fcat-edit = 'X'.
  
  * Field 'checktable' is set to avoid shortdumps that are caused
  * by inconsistend data in check tables. You may comment this out
  * when the test data of the flight model is consistent in your system.
        ls_fcat-checktable = '!'.  "do not check foreign keys
  
        MODIFY pt_fieldcat FROM ls_fcat.
      ENDIF.
    ENDLOOP.
  
  ENDFORM.
  
  FORM exclude_tb_functions CHANGING pt_exclude TYPE ui_functions.
  * Only allow to change data not to create new entries (exclude
  * generic functions).
  
    DATA ls_exclude TYPE ui_func.
  
    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
    APPEND ls_exclude TO pt_exclude.
    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
    APPEND ls_exclude TO pt_exclude.
    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
    APPEND ls_exclude TO pt_exclude.
    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
    APPEND ls_exclude TO pt_exclude.
    ls_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row.
    APPEND ls_exclude TO pt_exclude.
  
  ENDFORM.
  *---------------------------------------------------------------------*
  *       MODULE PBO OUTPUT                                             *
  *---------------------------------------------------------------------*
  MODULE pbo OUTPUT.
    SET PF-STATUS 'MAIN100'.
    SET TITLEBAR 'MAIN100'.
  *  IF g_custom_container IS INITIAL.
    PERFORM create_and_init_alv CHANGING gt_outtab
                                         gt_fieldcat
                                         gs_layout.
  *  ENDIF.
  
    gt_old[] = gt_outtab[].
  
  ENDMODULE.
  *---------------------------------------------------------------------*
  *       MODULE PAI INPUT                                              *
  *---------------------------------------------------------------------*
  MODULE pai INPUT.
    save_ok = ok_code.
    CLEAR ok_code.
    CASE save_ok.
      WHEN 'EXIT'.
        PERFORM exit_program.
      WHEN 'SAVE'.
        IF
        gt_old[] <> gt_outtab[].
          PERFORM save_modifications.
        ENDIF.
      WHEN 'REFRESH'.
  
        CLEAR : gt_outtab,
                gt_old.
  
        LEAVE TO SCREEN 0.
  
  
      WHEN OTHERS.
  *     do nothing
    ENDCASE.
  ENDMODULE.
  *---------------------------------------------------------------------*
  *       FORM EXIT_PROGRAM                                             *
  *---------------------------------------------------------------------*
  FORM exit_program.
    LEAVE PROGRAM.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  SAVE_MODIFICATIONS.
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM save_modifications .
  
    DATA :   lt_return TYPE TABLE OF bapiret2.
  
    DATA :   ls_order_header_in  LIKE  bapisdh1,
             ls_order_header_inx LIKE  bapisdh1x.
  
    DATA :   ls_order_item_in  TYPE  bapisditm,
             lt_order_item_in  TYPE TABLE OF bapisditm,
  
             ls_order_item_inx TYPE  bapisditmx,
             lt_order_item_inx TYPE TABLE OF bapisditmx,
  
             ls_order_keys     TYPE  bapisdkey,
             lt_order_keys     TYPE TABLE OF bapisdkey.
  
    LOOP AT gt_outtab ASSIGNING FIELD-SYMBOL(<lfs_outtab>).
      READ TABLE gt_old ASSIGNING FIELD-SYMBOL(<lfs_old>) WITH KEY vbeln = <lfs_outtab>-vbeln
                                                                   posnr = <lfs_outtab>-posnr
                                                                   abgru = <lfs_outtab>-abgru.
      IF sy-subrc = 0.
        CONTINUE.
      ENDIF.
  
      ls_order_header_in-ref_doc = <lfs_outtab>-vbeln.
      ls_order_header_inx-ref_doc = 'X'.
  
      ls_order_header_inx-updateflag = 'U'.
  
      ls_order_item_in-ref_doc = <lfs_outtab>-vbeln.
      ls_order_item_inx-ref_doc = 'X'.
  
      ls_order_item_in-itm_number = <lfs_outtab>-posnr.
      ls_order_item_inx-itm_number = 'X'.
  
      ls_order_item_in-reason_rej = <lfs_outtab>-abgru.
      ls_order_item_inx-reason_rej = 'X'.
  
      APPEND ls_order_item_in  TO lt_order_item_in.
      APPEND ls_order_item_inx TO lt_order_item_inx.
  
  
      ls_order_keys-doc_number = <lfs_outtab>-vbeln.
      ls_order_keys-itm_number = <lfs_outtab>-posnr.
  
  
      APPEND ls_order_keys     TO lt_order_keys.
  
      CLEAR : ls_order_item_in,
              ls_order_item_inx,
              ls_order_keys.
  
    ENDLOOP.
  
    IF lt_order_item_in IS NOT INITIAL.
  
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = p_vbeln
          order_header_in  = ls_order_header_in
          order_header_inx = ls_order_header_inx
  *       SIMULATION       =
  *       BEHAVE_WHEN_ERROR           = ' '
  *       INT_NUMBER_ASSIGNMENT       = ' '
  *       LOGIC_SWITCH     =
  *       NO_STATUS_BUF_INIT          = ' '
        TABLES
          return           = lt_return
          order_item_in    = lt_order_item_in
          order_item_inx   = lt_order_item_inx
  *       PARTNERS         =
  *       PARTNERCHANGES   =
  *       PARTNERADDRESSES =
  *       ORDER_CFGS_REF   =
  *       ORDER_CFGS_INST  =
  *       ORDER_CFGS_PART_OF          =
  *       ORDER_CFGS_VALUE =
  *       ORDER_CFGS_BLOB  =
  *       ORDER_CFGS_VK    =
  *       ORDER_CFGS_REFINST          =
  *       SCHEDULE_LINES   =
  *       SCHEDULE_LINESX  =
  *       ORDER_TEXT       =
          order_keys       = lt_order_keys
  *       CONDITIONS_IN    =
  *       CONDITIONS_INX   =
  *       EXTENSIONIN      =
  *       EXTENSIONEX      =
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
  
    LOOP AT gt_outtab ASSIGNING FIELD-SYMBOL(<lfs_outtab2>).
      READ TABLE gt_old ASSIGNING FIELD-SYMBOL(<lfs_old2>) WITH KEY vbeln = <lfs_outtab>-vbeln
                                                                   posnr = <lfs_outtab>-posnr
                                                                   abgru = <lfs_outtab>-abgru.
      IF sy-subrc = 0.
        CONTINUE.
      ENDIF.
  
        gs_rapport-vbeln = <lfs_outtab2>-vbeln.
        gs_rapport-posnr = <lfs_outtab2>-posnr.
        gs_rapport-abgru = <lfs_outtab2>-abgru.
        gs_rapport-mess = 'The reason for rejection has been updated on DB'.
  
        APPEND gs_rapport TO gt_rapport.
  
      ENDLOOP.
  
  
      TRY.
          CALL METHOD cl_salv_table=>factory(
            IMPORTING
              r_salv_table = lo_alv
            CHANGING
              t_table      = gt_rapport ).
  
          lo_alv_functions = lo_alv->get_functions( ).
          lo_alv_functions->set_all( abap_true ).
          lo_columns = lo_alv->get_columns( ).
          lo_columns->set_optimize( abap_true ).
          lo_alv->display( ).
  
        CATCH cx_salv_msg INTO lo_message.
      ENDTRY.
  
  
  
    ENDIF.
  
  
    CLEAR lt_return.
  
  
  
  ENDFORM.