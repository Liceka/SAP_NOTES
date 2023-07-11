*&---------------------------------------------------------------------*
*&  Include           Z_SMART_LBA_F01
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

    lb1 = '**PRINT**'.
    lb2 = 'ADD'.
    lb3 = 'SEND'.
  
    CLEAR :
             gv_vbeln,
             gt_info.
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
  
  
    SELECT  vbak~vbeln,            "Sales and Distribution Document Number
            vbak~kunnr,            "Customer Number
            kna1~name1,            "Name
            kna1~adrnr,            "Name
            kna1~stras,            "House number and street
            kna1~pstlz,            "Postal Code
            kna1~ort01,            "City
            kna1~land1,            "Country Key
            t005t~landx,           "Country Name
            vbap~posnr,            "Item number of the SD document
            vbap~arktx,            "Short text for sales order item
            vbap~kwmeng,           "Cumulative Order Quantity in Sales Units
            vbap~netwr,            "Net Value in Document Currency
            vbak~cmwae             "Currency key of credit control area
  
  
      FROM vbak
              INNER JOIN vbap ON vbap~vbeln = vbak~vbeln
          LEFT OUTER JOIN kna1 ON kna1~kunnr = vbak~kunnr
          LEFT OUTER JOIN t005t ON t005t~land1 = kna1~land1
  
      INTO TABLE @gt_info
             WHERE vbak~vbeln = @p_vbeln
             AND t005t~spras = 'EN'
      ORDER BY vbak~vbeln, vbap~posnr.
  
  
  ENDFORM.
  
  
  *&---------------------------------------------------------------------*
  *&      Form  SMARTFORM
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM call_smartform .
  
    gv_vbeln = p_vbeln.
  
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
  *     CLIENT                  = SY-MANDT
        id                      = id
        language                = language
        name                    = gv_vbeln
        object                  = object
  *     ARCHIVE_HANDLE          = 0
  *     LOCAL_CAT               = ' '
  * IMPORTING
  *     HEADER                  =
  *     OLD_LINE_COUNTER        =
      TABLES
        lines                   = lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
  
  
    IF sy-subrc <> 0.
      MESSAGE : 'The text line can not be read' TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  
  
    lv_sf_name = 'Z_VBELN_LBA'.
  
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = lv_sf_name
        variant            = ' '
        direct_call        = ' '
      IMPORTING
        fm_name            = lv_fname
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  
  ENDFORM.
  
  
  FORM preview_smartform.
  
    ls_control-preview = 'X'.
    ls_output-tdnoprev = ' '.
  
  
  *  Appel du smartform
    CALL FUNCTION lv_fname
      EXPORTING
        lines              = lines
        it_info            = gt_info
        control_parameters = ls_control
        output_options     = ls_output
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  SEND_EMAIL
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM send_email .
  
    DATA : ls_job_info TYPE ssfcrescl.
  
    ls_control-no_dialog = 'X'.
    ls_control-getotf    = 'X'.
    ls_control-langu     = sy-langu.
  
    CALL FUNCTION lv_fname
      EXPORTING
        lines              = lines
        it_info            = gt_info
        control_parameters = ls_control
        output_options     = ls_output
      IMPORTING
        job_output_info    = ls_job_info
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  
    DATA : lv_otf      TYPE xstring,
           lv_filesize TYPE i.
  
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
      IMPORTING
        bin_file              = lv_otf
        bin_filesize          = lv_filesize
      TABLES
        otf                   = ls_job_info-otfdata
        lines                 = lines
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        err_bad_otf           = 4
        OTHERS                = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  
  
  
    CALL METHOD cl_document_bcs=>xstring_to_solix
      EXPORTING
        ip_xstring = lv_otf
      RECEIVING
        rt_solix   = gt_pdf_data.
  
  
    DATA : it_email_content  TYPE bcsy_text,
           lr_document       TYPE REF TO cl_document_bcs,
           lr_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL,
  
           lr_send_request   TYPE REF TO cl_bcs,
           lv_recep          TYPE adr6-smtp_addr VALUE IS INITIAL,
  
           lo_send_request   TYPE REF TO cl_bcs,
           lo_sender         TYPE REF TO if_sender_bcs VALUE IS INITIAL,
           lo_recipient      TYPE REF TO if_recipient_bcs VALUE IS INITIAL,
           lv_recipient      TYPE adr6-smtp_addr VALUE IS INITIAL,
           lv_sent_to_all(1) TYPE c VALUE IS INITIAL.
  
  
    APPEND 'Find enclosed attached the smartform' TO it_email_content.
    APPEND 'Best regards' TO it_email_content.
  
    lr_document = cl_document_bcs=>create_document(
                                     i_type    = 'RAW'
                                     i_text    = it_email_content
                                     i_subject = 'Smartform'  ) .
  
  
    lr_document->add_attachment( i_attachment_type    = 'PDF'
                                 i_attachment_subject = 'Smartform.PDF'
                                 i_att_content_hex    =  gt_pdf_data  ).
  
    "pass the docuement to send request
    lo_send_request = cl_bcs=>create_persistent( ).
  *    CATCH cx_send_req_bcs.  "
    lo_send_request->set_document( lr_document ).
    "Create sender
    lo_sender = cl_sapuser_bcs=>create( sy-uname ).
    "assign sender
    lo_send_request->set_sender( i_sender = lo_sender ).
    "Create recipient
    lv_recipient = p_recevr. " recipient address
    "assign recipient
    lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_recipient ).
    "set recipient
    lo_send_request->add_recipient(
      EXPORTING
        i_recipient  = lo_recipient       " Recipient of Message
        i_express    = 'X' ).             " Send As Express Message
  
    lo_send_request->send(
    EXPORTING
    i_with_error_screen = 'X'
    RECEIVING
    result = lv_sent_to_all ).
  
    IF sy-subrc = 0.
      COMMIT WORK.
      MESSAGE : 'Success' TYPE 'I'.
    ELSE.
      MESSAGE : 'The Email can''t be sent' TYPE 'I'.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  ADD_ATTACHMENT
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM add_attachment .
  
  
    DATA : ls_job_info TYPE ssfcrescl.
  
    ls_control-no_dialog = 'X'.
    ls_control-getotf    = 'X'.
    ls_control-langu     = sy-langu.
  
    CALL FUNCTION lv_fname
      EXPORTING
        lines              = lines
        it_info            = gt_info
        control_parameters = ls_control
        output_options     = ls_output
      IMPORTING
        job_output_info    = ls_job_info
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  
    DATA : lv_otf      TYPE xstring,
           lv_filesize TYPE i.
  
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
      IMPORTING
        bin_file              = lv_otf
        bin_filesize          = lv_filesize
      TABLES
        otf                   = ls_job_info-otfdata
        lines                 = lines
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        err_bad_otf           = 4
        OTHERS                = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  
  
  
    CALL METHOD cl_document_bcs=>xstring_to_solix
      EXPORTING
        ip_xstring = lv_otf
      RECEIVING
        rt_solix   = gt_pdf_data.
  
  
    DATA :      ls_lporb      TYPE sibflporb,
                lv_objtyp     TYPE so_obj_tp,
                lt_bapirettab TYPE bapirettab,
                lt_cont       TYPE soli_tab.
  
    gv_vbeln = p_file.
  
    lv_objtyp = 'EXT'.
    ls_lporb-instid = gv_vbeln.
    ls_lporb-typeid = 'BUS2032'.
    ls_lporb-catid  = 'BO'.
  
  
    CALL FUNCTION 'SO_SOLIXTAB_TO_SOLITAB'
      EXPORTING
        ip_solixtab = gt_pdf_data[]
      IMPORTING
        ep_solitab  = lt_cont[].
  
  
    CALL METHOD zcl_gos_lba=>gos_attach_file_solitab
      EXPORTING
        iv_name            = 'SMARTFORMS.PDF'
        iv_content_solitab = lt_cont[]
        is_lporb           = ls_lporb
        iv_objtp           = lv_objtyp
        iv_filelength      = lv_filesize
        iv_objname         = 'SMARTFORMS_LBA'
        iv_ext             = 'PDF'
      RECEIVING
        rt_messages        = lt_bapirettab.
  
    IF sy-subrc = 0.
      COMMIT WORK.
      MESSAGE : 'Success' TYPE 'I'.
  
  ****************ATTACHMENT DISPLAYING**************************
  
  
      DATA: lo_bitem     TYPE REF TO cl_sobl_bor_item,
            lo_container TYPE REF TO cl_gui_container.
  
  
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
  
  
    ELSE.
      MESSAGE : 'Error' TYPE 'I'.
  
  ****************ERROR DISPLAYING**************************
  
    DATA: lo_alv           TYPE REF TO cl_salv_table,
          lo_message       TYPE REF TO cx_salv_msg.
  
    TRY.
        CALL METHOD cl_salv_table=>factory(
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = lt_bapirettab ).
      CATCH cx_salv_msg INTO lo_message.
    ENDTRY.
  
  
    ENDIF.
  
  
  
  
  ENDFORM.