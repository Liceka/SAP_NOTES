*&---------------------------------------------------------------------*
*&  Include           Z_004_UWU_
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

    CLEAR: lta_sood.
  
    lb1 = ' ٩(◕‿◕)۶   DISPLAY   ٩(◕‿◕)۶'.
    lb2 = 'Upload'.
    lb3 = 'Download'.
    lb4 = 'ヽ(ヅ)ノ'.
  
  *  PERFORM attachments_list.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  ATTACHMENTS_LIST
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  *FORM attachments_list .
  *
  *  DATA: lt_bapirettab TYPE bapirettab.
  *
  *  ls_lporb-instid = p_key.
  *  ls_lporb-typeid = p_type.
  *  ls_lporb-catid  = p_catid.
  *
  *  CALL METHOD zcl_gos_lba=>gos_get_file_list
  *    EXPORTING
  *      is_lporb      = ls_lporb
  *    IMPORTING
  *      t_attachments = lta_sood
  *      rt_messages   = lt_bapirettab.
  *
  *  IF lt_bapirettab[] IS INITIAL.
  *    DATA dec_kb TYPE p.
  *
  *    LOOP AT lta_sood INTO lwa_sood.
  *
  *      dec_kb = lwa_sood-objlen / 1024.
  *      IF dec_kb < 1.
  *        dec_kb = 1.
  *      ENDIF.
  *      WRITE: / lwa_sood-objdes, dec_kb, 'kb', ' ', lwa_sood-acnam.
  *    ENDLOOP.
  *  ENDIF.
  *
  *
  *ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  ATTACHMENTS_DISPLAYING
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM attachments_displaying .
  
    ls_lporb-instid = p_key.
    ls_lporb-typeid = p_type.
    ls_lporb-catid  = p_catid.
  
    IF sy-subrc = 0.
  
      CALL METHOD zcl_gos_lba=>get_bitem
        EXPORTING
          is_lporb = ls_lporb
        RECEIVING
          ro_bitem = lo_bitem.
  
      CALL METHOD zcl_gos_lba=>set_object
        EXPORTING
          is_lporb = ls_lporb.
  
      CALL METHOD zcl_gos_lba=>display_attachments
        EXPORTING
          io_container = lo_container.
  
    ENDIF.
  
  **********************************************************************
  ***************** AVEC AFFICHAGE ALV  ************
  
  *  DATA: lo_alv           TYPE REF TO cl_salv_table,
  *        lo_alv_functions TYPE REF TO cl_salv_functions,
  *        lo_columns       TYPE REF TO cl_salv_columns_table,
  *        lo_message       TYPE REF TO cx_salv_msg,
  *        lr_events        TYPE REF TO cl_salv_events_table,
  *        lo_events        TYPE REF TO lcl_event_handler.
  *
  *  TRY.
  *      CALL METHOD cl_salv_table=>factory(
  *        IMPORTING
  *          r_salv_table = lo_alv
  *        CHANGING
  *          t_table      = lta_sood ).
  *
  *      lo_alv_functions = lo_alv->get_functions( ).
  *      lo_alv_functions->set_all( abap_true ).
  *
  *      lo_columns = lo_alv->get_columns( ).
  *      lo_columns->set_optimize( abap_true ).
  *
  *      lr_events = lo_alv->get_event( ).
  *      CREATE OBJECT lo_events.
  *      SET HANDLER lcl_event_handler=>double_click FOR lr_events.
  *
  *      lo_alv->display( ).
  *
  *    CATCH cx_salv_msg INTO lo_message.
  *  ENDTRY.
  
  
  
  **********************************************************************
  ***************** AVEC POPUP STANDARD  ************
  **  MESSAGE 'PERFORM attachments_displaying' TYPE 'I'.
  *
  *    DATA : go_manager   TYPE REF TO cl_gos_manager,
  *         lp_no_commit TYPE        sgs_cmode,
  *         gp_service   TYPE        sgs_srvnam,
  *         gs_object    TYPE        borident.
  *
  *  DATA  gs_bc_object TYPE sibflpor.
  *  DATA: gs_service_selection TYPE sgos_sels,
  *        gt_service_selection TYPE tgos_sels.
  *
  **** go_manager related bor object and key
  * " key field for ex. document no
  * gs_object-objkey  = p_key.
  * " bor object that you created at swo1
  *  gs_object-objtype = p_type.
  *
  *  CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
  *    IMPORTING
  *      own_logical_system             = gs_object-logsys
  *    EXCEPTIONS
  *      own_logical_system_not_defined = 1
  *      OTHERS                         = 2.
  *
  **** Which service we''re gonna use
  *
  *"" For Attaching Document
  **  gp_service = 'PCATTA_CREA'.
  *"" Display and change documents
  *  gp_service = 'VIEW_ATTA'.
  *
  **** Create Instance
  *  CREATE OBJECT go_manager
  *    EXPORTING
  *      ip_no_commit = lp_no_commit
  *      is_object    = gs_object.
  *
  **** Start Service
  *  CALL METHOD go_manager->start_service_direct
  *    EXPORTING
  *      ip_service       = gp_service
  *      is_object        = gs_object
  *    EXCEPTIONS
  *      no_object        = 1
  *      object_invalid   = 2
  *      execution_failed = 3
  *      OTHERS           = 4.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  ATTACHMENTS_UPLOADING
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM attachments_uploading .
  
    DATA: g_filename    TYPE string,
          g_attsize     TYPE wsrm_error-wsrm_direction,
          it_content    LIKE STANDARD TABLE OF soli,
          ta_srgbtbrel  TYPE STANDARD TABLE OF srgbtbrel, wa_srgbtbrel TYPE srgbtbrel,
          lta_sood      TYPE STANDARD TABLE OF sood, lwa_sood TYPE sood,
          dec_kb        TYPE p,
          ls_lporb      TYPE sibflporb,
          lv_objtyp     TYPE so_obj_tp,
          lt_bapirettab TYPE bapirettab.
  
    lv_objtyp = 'EXT'.
    ls_lporb-instid = p_key.
    ls_lporb-typeid = p_type.
    ls_lporb-catid  = p_catid.
  
    MOVE  p_file TO g_filename.
  
    CALL FUNCTION 'GUI_UPLOAD'
      EXPORTING
        filename   = g_filename
        filetype   = 'BIN'
      IMPORTING
        filelength = g_attsize
      TABLES
        data_tab   = it_content.
  
    IF sy-subrc EQ 0.
      CALL METHOD zcl_gos_lba=>gos_attach_file_solitab
        EXPORTING
          iv_name            = g_filename
          iv_content_solitab = it_content
          is_lporb           = ls_lporb
          iv_objtp           = lv_objtyp
          iv_filelength      = g_attsize
          iv_objname         = p_nam
          iv_ext             = p_ext
        RECEIVING
          rt_messages        = lt_bapirettab.
    ENDIF.
  
    CALL METHOD zcl_gos_lba=>gos_get_file_list
      EXPORTING
        is_lporb      = ls_lporb
      IMPORTING
        t_attachments = lta_sood
        rt_messages   = lt_bapirettab.
  
    IF lt_bapirettab[] IS INITIAL.
  
      MESSAGE: p_nam &&'.'&& p_ext &&' has been added into PO  ' && p_key && ' attached files'  TYPE 'I'.
    ELSE.
  
      MESSAGE: p_nam &&'.'&& p_ext &&' could not be added into PO  ' && p_key && ' attached files'  TYPE 'I' DISPLAY LIKE 'E'.
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  ATTACHMENTS_DOWNLOADING
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM attachments_downloading .
  
    DATA: ta_srgbtbrel  TYPE STANDARD TABLE OF srgbtbrel,
          wa_srgbtbrel  TYPE srgbtbrel,
          lta_sood      TYPE STANDARD TABLE OF sood,
          lwa_sood      TYPE sood,
          dec_kb        TYPE p,
          ls_lporb      TYPE sibflporb,
          lt_bapirettab TYPE bapirettab.
  
    ls_lporb-instid = p_key.
    ls_lporb-typeid = p_type.
    ls_lporb-catid  = p_catid.
  
    CALL METHOD zcl_gos_lba=>gos_get_file_list
      EXPORTING
        is_lporb      = ls_lporb
      IMPORTING
        t_attachments = lta_sood
        rt_messages   = lt_bapirettab.
  
    IF lt_bapirettab[] IS INITIAL.
      LOOP AT lta_sood INTO lwa_sood.
        CALL METHOD zcl_gos_lba=>gos_download_file_to_gui
          EXPORTING
            file_path   = p_dll
            attachment  = lwa_sood
          IMPORTING
            rt_messages = lt_bapirettab.
  
      ENDLOOP.
  
      MESSAGE: p_nam &&'.'&& p_ext &&' has been dowloading into  ' && p_dll TYPE 'I'.
    ELSE.
  
      MESSAGE: p_nam &&'.'&& p_ext &&' could not be dowloading into  ' && p_dll TYPE 'I' DISPLAY LIKE 'E'.
  
    ENDIF.
  
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *&      Form  CONTROL_EMAIL
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM control_email .
  
    CLEAR gv_msg.
    CLEAR gv_receiv_email.
    TRY.
  
        CREATE OBJECT go_regex
          EXPORTING
            pattern     = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
            ignore_case = abap_true.
  
  
        go_matcher = go_regex->create_matcher( text = p_recevr ). "On récupère le mail dans le parameter
  
      CATCH cx_address_bcs
      INTO go_exception.
        go_exception->get_text( ).
  
    ENDTRY.
  
  
    IF go_matcher->match( ) IS INITIAL.
      gv_msg = 'Email address is invalid'.
      gv_receiv_email = abap_false.
      MESSAGE gv_msg TYPE 'I'  DISPLAY LIKE 'E'.
    ELSE.
      gv_msg = 'Ok'.
      gv_receiv_email = abap_true.
  
  *    MESSAGE gv_msg TYPE 'I'.
  
    ENDIF.
  
  
  ENDFORM.
  
  
  *&---------------------------------------------------------------------*
  *&      Form  ATTACHMENTS_EMAILING
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM attachments_emailing .
  
    DATA: ls_lporb TYPE sibflporb.
    DATA: lt_bapirettab TYPE bapirettab.
  
    ls_lporb-instid = p_key.
    ls_lporb-typeid = p_type.
    ls_lporb-catid  = p_catid.
  
    CALL METHOD zcl_gos_lba=>gos_get_file_list
      EXPORTING
        is_lporb      = ls_lporb
      IMPORTING
        t_attachments = lta_sood
        rt_messages   = lt_bapirettab.
  
    IF lt_bapirettab[] IS INITIAL.
      DATA dec_kb TYPE p.
  
      LOOP AT lta_sood INTO lwa_sood.
        dec_kb = lwa_sood-objlen / 1024.
        IF dec_kb < 1.
          dec_kb = 1.
        ENDIF.
        WRITE: / lwa_sood-objdes, dec_kb, 'kb', ' ', lwa_sood-acnam.
  
        CLEAR t_receivers.
        t_receivers-receiver = p_recevr.
        t_receivers-rec_type = 'U'.
        APPEND t_receivers.
  
        CALL METHOD zcl_gos_lba=>gos_email_attached_file
          EXPORTING
            folder_region = 'B'
            doctp         = lwa_sood-objtp
            docyr         = lwa_sood-objyr
            docno         = lwa_sood-objno
            t_receivers   = t_receivers[]
          IMPORTING
            rt_messages   = lt_bapirettab.
  
      ENDLOOP.
  
      MESSAGE : 'The attachments into ' && 'PO' && ' ' && p_key && ' has been sent on email : ' && p_recevr  TYPE 'I'.
    ELSE.
  
      MESSAGE : 'The attachments into ' && 'PO' && ' '  && p_key && ' could not be sent on email : ' && p_recevr  TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  
  
  ENDFORM.