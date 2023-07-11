*&---------------------------------------------------------------------*
*&  Include           Z_MAIL_LBA_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  RETRIEVE_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM retrieve_file .

    OPEN DATASET p_file FOR INPUT IN TEXT MODE ENCODING NON-UNICODE.
  
    IF sy-subrc = 0.
      DO.
        READ DATASET p_file INTO gs_tab.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        gt_tab-rec = gs_tab.
        APPEND gs_tab TO gt_tab.
      ENDDO.
  
  
      WRITE : 'Ok file'.
    ELSE.
      WRITE : 'No file'.
    ENDIF.
    CLOSE DATASET p_file.
  
  
  * Pour passer en mode binaire qui permet de convertir le fichier en pls lignes.
     OPEN DATASET p_file FOR INPUT IN BINARY MODE.
  
     IF sy-subrc = 0.
  
    READ DATASET p_file INTO gv_xstring.
  
    ENDIF.
    CLOSE DATASET p_file.
  
  
  
  
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
  
    DATA : lt_file_data TYPE soli_tab.
  
  
    DATA : lo_document           TYPE REF TO cl_document_bcs VALUE IS INITIAL,
           lo_document_exception TYPE REF TO cx_document_bcs,
           lo_send_request       TYPE REF TO cl_bcs,
           lo_sender             TYPE REF TO if_sender_bcs VALUE IS INITIAL,
           lo_recipient          TYPE REF TO if_recipient_bcs VALUE IS INITIAL,
           lv_recipient          TYPE adr6-smtp_addr VALUE IS INITIAL,
           lv_sent_to_all(1)     TYPE c VALUE IS INITIAL,
           lt_content_text       TYPE soli_tab,
           ltx_content_text      TYPE solix_tab,
           lt_message_body       TYPE bcsy_text VALUE IS INITIAL.
  
    APPEND 'Find enclosed attached file' TO lt_message_body.
    APPEND 'Best regards' TO lt_message_body.
  
  
  
  ** La table finale doit être typé soli_tab
  *  LOOP AT gt_tab INTO DATA(lv_itab).
  *    DATA(lt_soli) =  cl_bcs_convert=>string_to_soli( CONV string( lv_itab-rec ) ).
  *    DATA(lt_solix) =  cl_bcs_convert=>xstring_to_solix( CONV xstring( lv_itab-rec ) ).
  *
  ** On fait CONV string pour convertir la lv_itab en string.
  *    APPEND LINES OF lt_soli TO lt_content_text.
  *    APPEND LINES OF lt_solix TO ltx_content_text.
  *  ENDLOOP.
  
  
  
    TRY.
  
        CREATE OBJECT lo_document.
  
  
        lo_document = cl_document_bcs=>create_document(
                        i_type         = 'RAW'
                        i_subject      = 'CSV file'
                        i_text         =  lt_message_body ).
      CATCH cx_document_bcs INTO lo_document_exception.
        lo_document_exception->get_text( ).
    ENDTRY.
  
    IF gt_tab IS NOT INITIAL.
  
        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer            = gv_xstring
  *         APPEND_TO_TABLE   = ' '
  *         IMPORTING
  *         OUTPUT_LENGTH     =
          tables
            binary_tab        = contents_bin.
  
      TRY.
          lo_document->add_attachment(
            EXPORTING
              i_attachment_type     = 'TXT'             " Document Class for Attachment
              i_attachment_subject  = 'Data1.txt'       " Attachment Title
              i_att_content_hex    = contents_bin ).    " Content (Text-Like)
  
        CATCH cx_document_bcs INTO lo_document_exception.
          lo_document_exception->get_text( ).
      ENDTRY.
  
          "pass the docuement to send request
          lo_send_request = cl_bcs=>create_persistent( ).
  *    CATCH cx_send_req_bcs.  "
          lo_send_request->set_document( lo_document ).
          "Create sender
          lo_sender = cl_sapuser_bcs=>create( sy-uname ).
  
          "assign sender
          lo_send_request->set_sender( i_sender = lo_sender ).
          "Create recipient
          lv_recipient = p_mail. " recipient address
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
  
  
  
  
      COMMIT WORK.
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
  
  
    TRY.
  
        CREATE OBJECT go_regex
          EXPORTING
            pattern     = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
            ignore_case = abap_true.
  
  
    go_matcher = go_regex->create_matcher( text = p_mail ). "On récupère le mail dans le parameter
  
        CATCH cx_address_bcs
        INTO go_exception.
        go_exception->get_text( ).
  
    ENDTRY.
  
  
    IF go_matcher->match( ) IS INITIAL.
      gv_msg = 'Email address is invalid'.
      gv_receiv_email = abap_false.
    ELSE.
      gv_msg = 'Email address is valid'.
      gv_receiv_email = abap_true.
    ENDIF.
  
    MESSAGE gv_msg TYPE 'I'.
  
  
  
  ENDFORM.