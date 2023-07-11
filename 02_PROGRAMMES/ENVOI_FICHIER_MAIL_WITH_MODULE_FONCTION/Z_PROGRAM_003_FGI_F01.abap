*&---------------------------------------------------------------------*
*&  Include           Z_PROGRAM_003_FGI_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DATA_INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA_INITIALIZATION .

    CLEAR: gt_file_d.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  DATA_RETRIEVE
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM DATA_RETRIEVE .
  
    gv_file_p = p_path_f.
  
    OPEN DATASET gv_file_p FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  
    IF sy-subrc = 0.
      DO.
        READ DATASET gv_file_p INTO gv_file_d.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
  
        gt_file_d-rec = gv_file_d.
        APPEND gt_file_d.
      ENDDO.
  
      CLOSE DATASET gv_file_p.
    ELSE.
      MESSAGE 'File not found' TYPE 'E' DISPLAY LIKE 'I'.
    ENDIF.
  
    OPEN DATASET gv_file_p FOR INPUT IN BINARY MODE.
    READ DATASET gv_file_p INTO gv_xstring.
    CLOSE DATASET gv_file_p.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  DATA_REGEX
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM DATA_REGEX .
  
    if cl_abap_matcher=>matches( pattern = gv_regex_pattern text = p_receiv ).
      gv_receiv_email = abap_true.
    ELSE.
      MESSAGE 'Invalid receiver email address' TYPE 'E' DISPLAY LIKE 'I'.
      gv_receiv_email = abap_false.
    ENDIF.
  
    if cl_abap_matcher=>matches( pattern = gv_regex_pattern text = p_sender ).
      gv_sender_email = abap_true.
    ELSE.
      MESSAGE 'Invalid receiver email address' TYPE 'E' DISPLAY LIKE 'I'.
      gv_sender_email = abap_false.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  DATA_SEND_API
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM DATA_SEND_API .
  
    " HEADER
    APPEND 'objheader'    TO object_header.
  
    " CORE MESSAGE
    APPEND 'data1.csv'    TO contents_txt.
    APPEND 'Wesh'         TO contents_txt.
  
    " (DOCUMENT DATA) TITLE & DESCRIPTION
    DESCRIBE TABLE contents_txt     LINES txt_lines.
    READ TABLE contents_txt         INDEX txt_lines.
    document_data-obj_name          = p_file_n.
    document_data-obj_descr         = p_desc_m.
    document_data-doc_size          = ( txt_lines - 1 ) * 255 + STRLEN( contents_txt ).
  
    " (PACKING LIST) MAIN TEXT PARAMETERS
    CLEAR packing_list-transf_bin.
    packing_list-head_start         = 0.
    packing_list-head_num           = 0.
    packing_list-body_start         = 1.
    packing_list-body_num           = txt_lines.
    packing_list-doc_type           = 'RAW'.
    packing_list-obj_name           = 'data1.txt'.
    packing_list-obj_descr          = 'data1.txt'.
    APPEND packing_list.
    CLEAR packing_list.
  
    contents_bin[]                  = gt_file_d[].
  
    " (PACKING LIST) ATTACHMENT PARAMETERS
    DESCRIBE TABLE contents_bin LINES txt_lines.
    packing_list-doc_size           = txt_lines * 255.
    packing_list-transf_bin         = 'X'.
    packing_list-head_start         = 0.
    packing_list-head_num           = 0.
    packing_list-body_start         = 1.
    packing_list-body_num           = txt_lines.
    packing_list-doc_type           = 'TXT'.
    packing_list-obj_name           = 'data1.txt'.
    packing_list-obj_descr          = 'data1.txt'.
    APPEND packing_list.
    CLEAR packing_list.
  
    " RECEIVERS
    receivers-receiver              = p_receiv.
    receivers-rec_type              = 'U'.
    APPEND receivers.
    CLEAR receivers.
  
  
        CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
          EXPORTING
            buffer            = gv_xstring
  *         APPEND_TO_TABLE   = ' '
  *         IMPORTING
  *         OUTPUT_LENGTH     =
          tables
            binary_tab        = contents_bin.
  
    " SEND THE MAIL OUT
    CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
      EXPORTING
        DOCUMENT_DATA              = document_data
        PUT_IN_OUTBOX              = 'X'
        COMMIT_WORK                = 'X'
  * IMPORTING
  *     SENT_TO_ALL                =
  *     NEW_OBJECT_ID              =
      TABLES
        PACKING_LIST               = packing_list
        OBJECT_HEADER              = object_header
        CONTENTS_BIN               = contents_bin
        CONTENTS_TXT               = contents_txt
  *     CONTENTS_HEX               =
  *     OBJECT_PARA                =
  *     OBJECT_PARB                =
        RECEIVERS                  = receivers
      EXCEPTIONS
        TOO_MANY_RECEIVERS         = 1
        DOCUMENT_NOT_SENT          = 2
        DOCUMENT_TYPE_NOT_EXIST    = 3
        OPERATION_NO_AUTHORIZATION = 4
        PARAMETER_ERROR            = 5
        X_ERROR                    = 6
        ENQUEUE_ERROR              = 7
        OTHERS                     = 8.
  
    IF SY-SUBRC = 0.
      MESSAGE 'Email sent successfully.' TYPE 'S'.
      COMMIT WORK.
  *    SUBMIT rsconn01 WITH MODE = 'INT' AND RETURN.
    ELSE.
      MESSAGE 'Error sending email:' && sy-subrc TYPE 'E' DISPLAY LIKE 'I'.
      ROLLBACK WORK.
    ENDIF.
  
  ENDFORM.