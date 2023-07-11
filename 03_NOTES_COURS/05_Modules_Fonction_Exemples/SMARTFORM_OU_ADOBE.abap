MODULE display_final OUTPUT.
  go_custom_container = NEW cl_gui_custom_container( container_name = 'CONTAINER1' ).

  TRY.
      CALL METHOD cl_salv_table=>factory(
        EXPORTING
          r_container    = go_custom_container
          container_name = 'CONTAINER1'
        IMPORTING
          r_salv_table   = go_alv
        CHANGING
          t_table        = t_ty_final ).
    CATCH cx_salv_msg INTO go_message.
  ENDTRY.


  "On appelle la méthode d'une classe : affiche moi le tableau
  go_alv_functions = go_alv->get_functions( )."Récupère les fonctions dans la methode et stocke les dans mon objet
  go_alv_functions->set_all( abap_true ). "Active les tous


* Custom Button Function for print smartform
  go_alv_functions->add_function( name = 'PRINT_SF'
                                 icon = 'ICON_PRINT'
                                 text = 'Imprimer une Commande de Vente'
                                 tooltip = 'Imprimer un formulaire smartform'
                                 position = if_salv_c_function_position=>right_of_salv_functions ).

* Custom Button Function for print adobe
  go_alv_functions->add_function( name = 'PRINT_ADOBE'
                                 icon = 'ICON_PRINT'
                                 text = 'Imprimer le formulaire ADOBE'
                                 tooltip = 'Imprimer un formulaire Adobe'
                                 position = if_salv_c_function_position=>right_of_salv_functions ).

*Gestion des colonnes de mon objet ALV via l'objet go_colums
  go_columns = go_alv->get_columns( ).
  go_columns->set_optimize( abap_true ).

*Ajout d'une checkbox hotspot via l'objet go_column
  go_column ?= go_columns->get_column('CHECK').
  go_column->set_cell_type( if_salv_c_cell_type=>checkbox_hotspot ).
  go_column->set_icon( if_salv_c_bool_sap=>true ).

  gr_events = go_alv->get_event( ).

  CREATE OBJECT go_events.

  "Element qui permet de récupérer le cliq sur la ligne
  SET HANDLER go_events->m_hotspot      FOR gr_events. "Abonne l'objet go_events à la méthode hotspot (méthode dans la class ZKDE...
  "Element qui permet de récupérer
  SET HANDLER go_events->m_usercommand FOR gr_events. "Abonne l'objet go_events à la méthode usercommand


  go_alv->display( ).
ENDMODULE.



FORM usercommand_event USING i_ucomm TYPE salv_de_function.

  DATA : ls_control TYPE ssfctrlop,
         ls_output  TYPE ssfcompop.


**************************** Données pour SMARTFORM ******************************************
  DATA : lt_header          TYPE ztcv_header_mda,
         ls_header          LIKE LINE OF lt_header,
         lt_item            TYPE ztcv_item_mda,
         ls_item            LIKE LINE OF lt_item,
         lv_fname           TYPE rs38l_fnam,         "Code du module fonction associé au smartform
         lv_sf_name         TYPE tdsfname,           "Nom smartform

***************************** Données pour ADOBE *****************************************
         ls_sfpoutputparams TYPE sfpoutputparams,
         ls_docparams       TYPE sfpdocparams,
         ls_pdf_file        TYPE fpformoutput,
         lv_formname        TYPE fpname,
         lv_fmname          TYPE funcname,
         lv_mseg            TYPE string,
         lv_w_cx_root       TYPE REF TO cx_root.     " Exceptions class





  READ TABLE t_ty_final ASSIGNING FIELD-SYMBOL(<fs_cv>) WITH KEY check = 'X'.
  IF sy-subrc = 0.
    ls_header-vbeln = <fs_cv>-vbeln.
    ls_header-auart = <fs_cv>-auart.
    ls_header-erdat = <fs_cv>-erdat.
    ls_header-erzet = <fs_cv>-erzet.
    ls_header-vdatu = <fs_cv>-vdatu.
    ls_header-vkorg = <fs_cv>-vkorg.
    ls_header-vtweg = <fs_cv>-vtweg.
    ls_header-spart = <fs_cv>-spart.
    ls_header-kunnr = <fs_cv>-kunnr.
    ls_header-name1 = <fs_cv>-name1.
    ls_header-kunwe = <fs_cv>-kunwe.
    ls_header-name2 = <fs_cv>-name2.
    ls_header-address = <fs_cv>-address.

    APPEND ls_header TO lt_header.

    LOOP AT t_ty_final ASSIGNING FIELD-SYMBOL(<fs_cv2>) WHERE vbeln = <fs_cv>-vbeln.
      ls_item-posnr    = <fs_cv2>-posnr.
      ls_item-matnr    = <fs_cv2>-matnr.
      ls_item-maktx    = <fs_cv2>-maktx.
      ls_item-werks    = <fs_cv2>-werks.
      ls_item-po_quant = <fs_cv2>-po_quant.
      ls_item-po_unit  = <fs_cv2>-po_unit.
      ls_item-ntgew    = <fs_cv2>-ntgew.
      ls_item-gewei    = <fs_cv2>-gewei.
      ls_item-pt_post = <fs_cv2>-pt_post.
      ls_item-pt_comm  = <fs_cv2>-pt_comm.
      APPEND ls_item TO lt_item.
    ENDLOOP.
  ENDIF.

  CASE i_ucomm.
    WHEN 'PRINT_SF'.

    lv_sf_name = 'ZCOMV_LBA'.
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

      "Appel du smartform
      CALL FUNCTION lv_fname
        EXPORTING
          iT_header          = lt_header
          it_item            = lt_item
          control_parameters = ls_control
          output_options     = ls_output
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.

    WHEN 'PRINT_ADOBE'.
      lv_formname = 'ZADOBE_FORM_KDE'.
      ls_sfpoutputparams-dest     = 'LP01'.
*      ls_sfpoutputparams-nodialog = 'X'.
      ls_sfpoutputparams-preview  = 'X'.

      CALL FUNCTION 'FP_JOB_OPEN'
        CHANGING
          ie_outputparams = ls_sfpoutputparams
        EXCEPTIONS
          cancel          = 1
          usage_error     = 2
          system_error    = 3
          internal_error  = 4
          OTHERS          = 5.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      TRY .
          CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
            EXPORTING
              i_name     = lv_formname
            IMPORTING
              e_funcname = lv_fmname.

        CATCH cx_root INTO lv_w_cx_root.
          lv_mseg = lv_w_cx_root->get_text( ).
          MESSAGE lv_mseg TYPE 'E'.

      ENDTRY.

      MOVE: sy-langu TO ls_docparams-langu.

      CALL FUNCTION lv_fmname
        EXPORTING
          /1bcdwb/docparams = ls_docparams
          is_header         = ls_header
          it_item           = lt_item
*    IMPORTING
*         /1bcdwb/formoutput = ls_pdf_file
        EXCEPTIONS
          usage_error       = 1
          system_error      = 2
          internal_error    = 3
          OTHERS            = 4.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     e_result             =
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    WHEN OTHERS.

  ENDCASE.

ENDFORM.