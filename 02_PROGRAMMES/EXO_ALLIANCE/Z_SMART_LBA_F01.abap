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
  
  
    IF sy-subrc = 0.
  
      PERFORM smartform.
  
    ELSE.
  
      MESSAGE : 'No data found' TYPE 'I' DISPLAY LIKE 'E'.
  
    ENDIF.
  
  ENDFORM.
  
  
  *&---------------------------------------------------------------------*
  *&      Form  SMARTFORM
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM smartform .
  
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
    ls_control-preview = 'X'.
    ls_output-tdnoprev = ' '.
  
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