*&---------------------------------------------------------------------*
*& Include          ZJLMF_PROJECT_01_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form data_extraction
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_extraction.

    DATA: lv_fileline TYPE string.
    lv_fileline = p_lfile.
  
    CALL FUNCTION 'GUI_UPLOAD'
      EXPORTING
        filename = lv_fileline
        filetype = 'ASC'
      TABLES
        data_tab = gt_line.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form data_preparation
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  
  FORM data_preparation.
  
    DATA: lr_doc_type TYPE RANGE OF tvarvc-low.
  
    SELECT sign
    opti
    low
    high
    FROM tvarvc
    INTO TABLE lr_doc_type
    WHERE name = 'ZTYPE_DOC_JLMF' AND type = 'S'.
  
    IF lines( gt_line ) > 1.
  
      DELETE gt_line INDEX 1.
  
      LOOP AT gt_line ASSIGNING FIELD-SYMBOL(<fs_line>).
  
        SPLIT <fs_line>-fileline AT ';' INTO TABLE DATA(lt_split_csv).
        SPLIT lt_split_csv[ 1 ] AT 'P' INTO TABLE DATA(lt_split_id).
  
        IF lt_split_csv IS NOT INITIAL AND lines( lt_split_csv ) = 14  AND lt_split_csv[ 2 ] IN lr_doc_type.
  
          APPEND INITIAL LINE TO gt_file ASSIGNING FIELD-SYMBOL(<fs_file>).
  
          IF <fs_file> IS ASSIGNED.
  
            <fs_file>-compteur_commande   = lt_split_csv[ 1 ].
            <fs_file>-doc_type            = lt_split_csv[ 2 ].
            <fs_file>-sales_org           = lt_split_csv[ 3 ].
            <fs_file>-distr_chan          = lt_split_csv[ 4 ].
            <fs_file>-sect_act            = lt_split_csv[ 5 ].
            <fs_file>-partn_role_ag       = lt_split_csv[ 6 ].
            <fs_file>-partn_numb_ag       = lt_split_csv[ 7 ].
            <fs_file>-partn_role_we       = lt_split_csv[ 8 ].
            <fs_file>-partn_num_we        = lt_split_csv[ 9 ].
            <fs_file>-itm_numb            = lt_split_csv[ 10 ].
            <fs_file>-material            = lt_split_csv[ 11 ].
            <fs_file>-plant               = lt_split_csv[ 12 ].
            <fs_file>-quantity            = lt_split_csv[ 13 ].
            <fs_file>-quantity_unit       = lt_split_csv[ 14 ].
            <fs_file>-id_com              = lt_split_id[ 1 ].
            <fs_file>-id_post             = lt_split_id[ 2 ].
  
          ENDIF.
  
        ENDIF.
  
      ENDLOOP.
  
    ENDIF.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form data_verification
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  
  FORM data_verification.
  
    SELECT vbak~vkorg,
    vbak~vtweg,
    vbak~spart,
    knvp~parvw,
    knvp~kunnr,
    vbap~posnr,
    mara~matnr,
    vbak~bukrs_vf
    FROM vbak
    INNER JOIN vbap ON vbap~vbeln = vbak~vbeln
    INNER JOIN knvp ON knvp~kunnr = vbak~kunnr
    INNER JOIN mara ON mara~matnr = vbap~matnr
    INTO TABLE @DATA(lt_select).
  
    DATA: ls_select LIKE LINE OF lt_select,
          index     TYPE i VALUE '1',
          v         TYPE boolean VALUE 't'.
  
    LOOP AT gt_file ASSIGNING FIELD-SYMBOL(<fs_file>).
      v = 't'.
  
      READ TABLE lt_select TRANSPORTING NO FIELDS
      WITH KEY vkorg = <fs_file>-sales_org.
  
      IF sy-subrc = 0.
        READ TABLE lt_select TRANSPORTING NO FIELDS
        WITH KEY vtweg = <fs_file>-distr_chan.
  
        IF sy-subrc = 0.
          READ TABLE lt_select TRANSPORTING NO FIELDS
          WITH KEY spart = <fs_file>-sect_act.
  
          IF sy-subrc = 0.
            READ TABLE lt_select TRANSPORTING NO FIELDS
            WITH KEY parvw = <fs_file>-partn_role_ag.
  
            IF sy-subrc = 0.
              READ TABLE lt_select TRANSPORTING NO FIELDS
              WITH KEY kunnr = <fs_file>-partn_numb_ag.
  
              IF sy-subrc = 0.
                READ TABLE lt_select TRANSPORTING NO FIELDS
                WITH KEY parvw = <fs_file>-partn_role_we.
  
                IF sy-subrc = 0.
                  READ TABLE lt_select TRANSPORTING NO FIELDS
                  WITH KEY kunnr = <fs_file>-partn_num_we.
  
                  IF sy-subrc = 0.
                    READ TABLE lt_select TRANSPORTING NO FIELDS
                    WITH KEY posnr = <fs_file>-itm_numb.
  
                    IF sy-subrc = 0.
                      READ TABLE lt_select TRANSPORTING NO FIELDS
                      WITH KEY matnr = <fs_file>-material.
  
                      IF sy-subrc = 0.
                        READ TABLE lt_select TRANSPORTING NO FIELDS
                        WITH KEY bukrs_vf = <fs_file>-plant.
  
                        IF sy-subrc = 0.
  
                        ELSE.
                          v = 'f' .
                        ENDIF.
                      ELSE.
                        v = 'f' .
                      ENDIF.
                    ELSE.
                      v = 'f' .
                    ENDIF.
                  ELSE.
                    v = 'f' .
                  ENDIF.
                ELSE.
                  v = 'f' .
                ENDIF.
              ELSE.
                v = 'f' .
              ENDIF.
            ELSE.
              v = 'f' .
            ENDIF.
          ELSE.
            v = 'f' .
          ENDIF.
        ELSE.
          v = 'f' .
        ENDIF.
      ELSE.
        v = 'f' .
      ENDIF.
      IF v = 'f' .
        DELETE gt_file INDEX index.
        index = index - 1.
      ENDIF.
      index = index + 1.
    ENDLOOP.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form client_order_creation
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  
  FORM client_order_creation.
  
    DATA: ls_file  TYPE zsjlmf_file_01.
  
    DATA: lv_salesdocument   TYPE bapivbeln-vbeln.
  
    DATA: lt_return          TYPE TABLE OF bapiret2,
  
          lt_order_items_in  TYPE TABLE OF bapisditm,
          lt_order_items_inx TYPE TABLE OF bapisditmx,
          lt_order_partners  TYPE TABLE OF bapiparnr,
  
          lt_schedules       TYPE TABLE OF bapischdl,
          lt_schedulesx      TYPE TABLE OF bapischdlx,
  
          lt_conditions      TYPE TABLE OF bapicond,
          lt_conditionsx     TYPE TABLE OF bapicondx.
  
    DATA: ls_return           TYPE bapiret2,
          ls_order_header_in  TYPE bapisdhd1,
          ls_order_header_inx TYPE bapisdhd1x,
  
          ls_order_items_in   TYPE bapisditm,
          ls_order_items_inx  TYPE bapisditmx,
          ls_order_partners   LIKE bapiparnr,
          ls_schedules        TYPE bapischdl,
          ls_schedulesx       TYPE bapischdlx,
          ls_conditions       TYPE bapicond,
          ls_conditionsX      TYPE bapicondx.
  
    ls_order_header_inx-ref_1        = 'X'.
    ls_order_header_inx-doc_type     = 'X'.
    ls_order_header_inx-sales_org    = 'X'.
    ls_order_header_inx-distr_chan   = 'X'.
    ls_order_header_inx-division     = 'X'.
    ls_order_header_inx-req_date_h   = 'X'.
    ls_order_header_inx-updateflag   = 'I'.
  
    ls_order_items_inx-itm_number    = 'X'.
    ls_order_items_inx-material      = 'X'.
    ls_order_items_inx-plant         = 'X'.
    ls_order_items_inx-target_qty    = 'X'.
    ls_order_items_inx-po_unit       = 'X'.
  
    ls_schedulesx-itm_number         = 'X'.
    ls_schedulesx-dlv_date           = 'X'.
  
    LOOP AT gt_file INTO ls_file.
  
      SELECT DISTINCT * FROM @gt_file AS lt_file
      WHERE id_com = @ls_file-id_com
      INTO TABLE @DATA(it_grp).
  
      DO 1 TIMES.
  
        CLEAR:
        ls_order_header_in,
        ls_order_items_in,
        ls_schedules,
  
        lt_order_items_in,
        lt_schedules,
        lt_return.
  
        LOOP AT it_grp ASSIGNING FIELD-SYMBOL(<fs_file>).
  
          ls_order_header_in-ref_1       = <fs_file>-compteur_commande.
          ls_order_header_in-doc_type    = <fs_file>-doc_type.
          ls_order_header_in-sales_org   = <fs_file>-sales_org.
          ls_order_header_in-distr_chan  = <fs_file>-distr_chan.
          ls_order_header_in-division    = <fs_file>-sect_act.
          ls_order_header_in-req_date_h  = sy-datum.
  
          ls_order_items_in-itm_number   = <fs_file>-itm_numb.
          ls_order_items_in-material     = <fs_file>-material.
          ls_order_items_in-plant        = <fs_file>-plant.
          ls_order_items_in-target_qty   = <fs_file>-quantity.
  
          APPEND ls_order_items_in TO lt_order_items_in.
          APPEND ls_order_items_inx TO lt_order_items_inx.
  
          ls_order_partners-partn_role   = <fs_file>-partn_role_ag.
          ls_order_partners-partn_numb   = <fs_file>-partn_numb_ag.
  
          APPEND ls_order_partners TO lt_order_partners.
  
          ls_order_partners-partn_role   = <fs_file>-partn_role_we.
          ls_order_partners-partn_numb   = <fs_file>-partn_num_we.
  
          APPEND ls_order_partners TO lt_order_partners.
  
          ls_schedules-itm_number        =  <fs_file>-itm_numb.
          ls_schedules-dlv_date          =  sy-datum + 5.
  
          APPEND ls_schedules TO lt_schedules.
          APPEND ls_schedulesx TO lt_schedulesx.
  
        ENDLOOP.
  
        CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
          EXPORTING
            salesdocumentin     = ''
            order_header_in     = ls_order_header_in
            order_header_inx    = ls_order_header_inx
          IMPORTING
            salesdocument       = lv_salesdocument
          TABLES
            return              = lt_return
            order_items_in      = lt_order_items_in
            order_items_inx     = lt_order_items_inx
            order_partners      = lt_order_partners
            order_schedules_in  = lt_schedules
            order_schedules_inx = lt_schedulesx.
  
        READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
  
        IF sy-subrc = 0.
          APPEND ls_return TO gt_return.
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ELSE.
          ls_return-type = 'S'.
          ls_return-message = 'Commande:' && <fs_file>-compteur_commande && ' VBELN:' && lv_salesdocument && ' QUANTITY: ' && ls_order_items_in-target_qty && ' Créé avec succés'.
  
          APPEND ls_return TO gt_return.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
        ENDIF.
  
        DELETE gt_file WHERE id_com = ls_file-id_com.
  
      ENDDO.
  
    ENDLOOP.
  
    TRY.
  
        CALL SCREEN 9003.
  
  *
  *
  *      DATA : lo_alv           TYPE REF TO cl_salv_table,
  *             lo_alv_functions TYPE REF TO cl_salv_functions,
  *             lo_columns       TYPE REF TO cl_salv_columns_table,
  *             message          TYPE REF TO cx_salv_msg.
  *
  *      cl_salv_table=>factory(
  *      IMPORTING
  *        r_salv_table = lo_alv
  *      CHANGING
  *        t_table      = gt_return ).
  *
  *      lo_alv_functions = lo_alv->get_functions( ).
  *      lo_alv_functions->set_all( abap_true ).
  *
  *      lo_columns = lo_alv->get_columns( ).
  *      lo_columns->set_optimize( abap_true ).
  *
  *      lo_alv->display( ).
  
  *    CATCH cx_salv_msg INTO message.
    ENDTRY.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form display_client_order
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  
  FORM display_client_order .
  
    DATA : lv_post TYPE ntgew,
           lv_comm TYPE f.
  
  ******************************  Déclaration des données  ****************************************
    DATA : lt_display TYPE TABLE OF ty_final,
           ls_display LIKE LINE OF lt_display.
  
  *******************************  Séléction des champs  ***************************************
    SELECT vbak~vbeln,                                                               " Numéro de la commande de vente
           vbak~auart,                                                               " Type de doc. De vente
           vbak~erdat,                                                               " Date de création de la commande
           vbak~erzet,                                                               " Heure de création
           vbak~vdatu,                                                               " Date de livraison souhaitée
           vbak~vkorg,                                                               " Organisation commerciale
           vbak~vtweg,                                                               " Canal de distribution
           vbak~spart,                                                               " Secteur d’activité
           vbap~kunnr_ana,                                                           " Client donneur d’ordre
           kna1~name1,                                                               " Nom du donneur d’ordre
           vbap~kunwe_ana,                                                           " Client réceptionnaire
           kna1~name2,                                                               " Nom du client réceptionnaire
           kna1~pstlz && @space && kna1~ort01 && @space && kna1~land1 AS address,    " KNA1 - Adresse du client réceptionnaire (Code postal + Ville + Pays)
           vbap~posnr,                                                               " Numéro de poste Com.
           vbap~matnr,                                                               " Article
           makt~maktx,                                                               " Désignation article
           vbap~werks,                                                               " Division
           vbap~zmeng,                                                               " Quantité commandée
           vbap~zieme,                                                               " Unité de quantité
           mara~ntgew,                                                               " Poids net de l’article
           mara~gewei                                                               " Unité de poids
  *         vbap~zmeng * mara~ntgew AS pt_post,                                       " Poids total du poste
  *         mara~ntgew                                 " Poids total de la commande
  
  ******************************  Depuis les tables  ****************************************
      FROM vbak
      INNER JOIN vbap ON vbap~vbeln = vbak~vbeln
      LEFT OUTER JOIN kna1 ON kna1~kunnr = vbap~kunnr_ana
      LEFT OUTER JOIN makt ON makt~matnr = vbap~matnr
                     AND makt~spras = @sy-langu
      LEFT OUTER JOIN mara ON mara~matnr = makt~matnr
      WHERE vbak~auart IN @s_auart
        AND vbak~vbeln IN @s_vbeln
        AND vbak~vkorg IN @s_vkorg
        AND vbak~vtweg IN @s_vtweg
        AND vbak~spart IN @s_spart
        AND vbap~kunnr_ana IN @s_kunnr
        AND vbap~matnr IN @s_matnr
        AND vbap~werks IN @s_werks
        AND vbak~erdat IN @s_erdat
      ORDER BY vbak~erdat DESCENDING, vbak~erzet DESCENDING
      INTO TABLE @t_ty_final.
  
  ****************************  Tentative d'ajout d'un poid total de la commande sans GROUP BY   ******************************************
  *  LOOP AT t_ty_final ASSIGNING FIELD-SYMBOL(<fs_display>).
  *    AT NEW vbeln.
  *      CLEAR ls_display.
  *    ENDAT.
  *    MOVE <fs_display> TO ls_display.
  *    ls_display-pt_comm = ls_display-pt_comm + <fs_display>-pt_post.
  *    APPEND ls_display TO lt_display.
  *  ENDLOOP.
  
  
  ****************************  Calcul poids des postes + poids total de la commande   ******************************************
    LOOP AT t_ty_final ASSIGNING FIELD-SYMBOL(<fs_final>).
      AT NEW vbeln.
        CLEAR <fs_final>-pt_comm.
      ENDAT.
  
      LOOP AT t_ty_final ASSIGNING FIELD-SYMBOL(<fs_final2>) WHERE vbeln = <fs_final>-vbeln.
        <fs_final2>-pt_post = <fs_final2>-po_quant * <fs_final2>-ntgew.
        <fs_final>-pt_comm =  <fs_final>-pt_comm  + <fs_final2>-pt_post.
      ENDLOOP.
    ENDLOOP.
  
  
    TRY.
  
        CALL SCREEN 9003.
  
  
  
  *      DATA :lo_alv           TYPE REF TO cl_salv_table,
  *            lo_alv_functions TYPE REF TO cl_salv_functions,
  *            lo_columns       TYPE REF TO cl_salv_columns_table,
  *            message          TYPE REF TO cx_salv_msg.
  *
  *      cl_salv_table=>factory(
  *      IMPORTING
  *        r_salv_table = lo_alv
  *      CHANGING
  *        t_table      = t_ty_final ).
  *
  *      lo_alv_functions = lo_alv->get_functions( ).
  *      lo_alv_functions->set_all( abap_true ).
  *
  *      lo_columns = lo_alv->get_columns( ).
  *      lo_columns->set_optimize( abap_true ).
  *
  *      lo_alv->display( ).
  *
  *    CATCH cx_salv_msg INTO message.
    ENDTRY.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Module STATUS_9001 OUTPUT
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  MODULE status_9001 OUTPUT.
    SET PF-STATUS 'STATUT_GUI_9003'.
  * SET TITLEBAR 'xxx'.
  ENDMODULE.
  *&---------------------------------------------------------------------*
  *&      Module  USER_COMMAND_9001  INPUT
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  MODULE user_command_9001 INPUT.
  
    CASE sy-ucomm.
      WHEN 'BACK' OR 'CANCEL'.
        LEAVE TO SCREEN 0.
      WHEN 'EXIT'.
        LEAVE PROGRAM.
      WHEN OTHERS.
    ENDCASE.
  
  ENDMODULE.
  *&---------------------------------------------------------------------*
  *& Module DISPLAY_FINAL OUTPUT
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  MODULE display_final OUTPUT.
  
  *  " Déclaration des objets nécessaires pour remplir le container
  *  DATA : lo_custom_container TYPE REF TO cl_gui_custom_container,
  *         lo_alv_grid         TYPE REF TO cl_gui_alv_grid.
  *
  *
  *  " Récupération du nom du container dans le Dynpro 9001
  *  lo_custom_container = NEW cl_gui_custom_container( container_name = 'CONTAINER1' ).
  *
  *  " Création de l'objet ALV GRID avec pour Custom Container l'objet crée juste avant
  *  lo_alv_grid =  NEW cl_gui_alv_grid( i_parent = lo_custom_container ).
  *
  *  " Création du Field Catalogue
  *  DATA lt_fieldcat_grid TYPE lvc_t_fcat.
  *  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
  *    EXPORTING
  *      i_structure_name       = 'ZPROJ_ALV_KDE'
  *    CHANGING
  *      ct_fieldcat            = lt_fieldcat_grid
  *    EXCEPTIONS
  *      inconsistent_interface = 1
  *      program_error          = 2
  *      OTHERS                 = 3.
  *  IF sy-subrc <> 0.
  *    FREE lt_fieldcat_grid.
  *  ENDIF.
  *
  *  " Utilisation d'une méthode de l'objet crée LO_ALV_GRID pour affichage dans le CONTAINER
  *  lo_alv_grid->set_table_for_first_display(
  *    CHANGING
  *      it_outtab = t_ty_final
  *      it_fieldcatalog = lt_fieldcat_grid
  *    EXCEPTIONS
  *      invalid_parameter_combination = 1
  *      program_error = 2
  *      too_many_lines = 3
  *      OTHERS = 4 ).
  *  IF sy-subrc <> 0.
  *    RETURN.
  *  ENDIF.
  
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
  
  *Gestion des colonnes de mon objet ALV via l''objet go_colums
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
  
  FORM hotspot_event USING lv_row    TYPE i
                           lv_column TYPE fieldname.
  
  *On récupère le numéro de la ligne
    READ TABLE t_ty_final ASSIGNING FIELD-SYMBOL(<fs_cv>) INDEX lv_row.
  
    IF sy-subrc IS INITIAL.
      IF <fs_cv>-check IS INITIAL.
        <fs_cv>-check = 'X'.
      ELSE.
        CLEAR <fs_cv>-check.
      ENDIF.
    ENDIF.
  
    go_alv->refresh( ).
  
  ENDFORM.
  
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
      ls_header-name1     = <fs_cv>-name1.
      ls_header-kunwe = <fs_cv>-kunwe.
      ls_header-name2     = <fs_cv>-name2.
      ls_header-address    = <fs_cv>-address.
  
      APPEND ls_header TO lt_header.
  
      LOOP AT t_ty_final ASSIGNING FIELD-SYMBOL(<fs_cv2>) WHERE vbeln = <fs_cv>-vbeln.
        ls_item-posnr    = <fs_cv2>-posnr.
        ls_item-matnr    = <fs_cv2>-matnr.
        ls_item-maktx    = <fs_cv2>-maktx.
        ls_item-werks    = <fs_cv2>-werks.
        ls_item-po_quant = <fs_cv2>-po_quant.
        ls_item-po_unit    = <fs_cv2>-po_unit.
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
        lv_formname = 'ZADOBE_FORM_LBA'.
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
  *&---------------------------------------------------------------------*
  *& Module STATUS_9003 OUTPUT
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  MODULE status_9002 OUTPUT.
    SET PF-STATUS 'STATUT_GUI_9003'.
  * SET TITLEBAR 'xxx'.
  ENDMODULE.
  
  MODULE user_command_9002 INPUT.
  
    CASE sy-ucomm.
      WHEN 'BACK' OR 'CANCEL'.
        LEAVE TO SCREEN 0.
      WHEN 'EXIT'.
        LEAVE PROGRAM.
      WHEN OTHERS.
    ENDCASE.
  
  ENDMODULE.
  *&---------------------------------------------------------------------*
  *& Module DISPLAY_BAPI OUTPUT
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  MODULE display_bapi OUTPUT.
  * SET PF-STATUS 'STATUT_GUI_9002'.
  * SET TITLEBAR 'xxx'.
    " Déclaration des objets nécessaires pour remplir le container
    DATA : lo_custom_container2 TYPE REF TO cl_gui_custom_container,
           lo_alv_grid2         TYPE REF TO cl_gui_alv_grid.
  
    " Récupération du nom du container dans le Dynpro 9001
    lo_custom_container2 = NEW cl_gui_custom_container( container_name = 'CONTAINER2' ).
  
    " Création de l'objet ALV GRID avec pour Custom Container l'objet crée juste avant
    lo_alv_grid2 =  NEW cl_gui_alv_grid( i_parent = lo_custom_container2 ).
  
    " Création du Field Catalogue
    DATA lt_fieldcat_grid2 TYPE lvc_t_fcat.
  
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'BAPIRET2'
      CHANGING
        ct_fieldcat            = lt_fieldcat_grid2
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      FREE lt_fieldcat_grid2.
    ENDIF.
  
    " Utilisation d'une méthode de l'objet crée LO_ALV_GRID pour affichage dans le CONTAINER
    lo_alv_grid2->set_table_for_first_display(
      CHANGING
        it_outtab = gt_return
        it_fieldcatalog = lt_fieldcat_grid2
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error = 2
        too_many_lines = 3
        OTHERS = 4 ).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
  
  
  ENDMODULE.
  
  MODULE status_9003 OUTPUT.
    SET PF-STATUS 'STATUT_GUI_9003'.
  * SET TITLEBAR 'xxx'.
  ENDMODULE.
  
  *&---------------------------------------------------------------------*
  *&      Module  USER_COMMAND_9003  INPUT
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  MODULE user_command_9003 INPUT.
  
    CASE sy-ucomm.
      WHEN 'BACK' OR 'CANCEL'.
        LEAVE TO SCREEN 0.
      WHEN 'EXIT'.
        LEAVE PROGRAM.
      WHEN OTHERS.
    ENDCASE.
  
    CASE sy-ucomm.
      WHEN 'SUB1'.
        number1 = '9001'.
      WHEN 'SUB2'.
        number1 = '9004'.
      WHEN 'SUB3'.
        number2 = '9002'.
      WHEN 'SUB4'.
        number2 = '9005'.
    ENDCASE.
  
  ENDMODULE.
  *&---------------------------------------------------------------------*
  *& Form batch_input
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  
  * EXERCICE :
  
  *1/ Réussir à créer une commande de vente manuellement via la transaction VA01
  * Et identifier les champs obligatoires pour permettre la création
  
  *2/ Identifier le nom des zones dynpro et des écrans correspondant
  * pour contruire votre enchainement de BATCH INUPU (Perform bdc_dynpro et bdc-field)
  
  *3/ Remplacer les valeurs en "dur" que vous aurez utilisé dans votre BI par les valeurs
  *contenues dans le fichier texte
  
  FORM batch_input .
  
    PERFORM BDC_dynpro  USING 'SAPMV45A' '0101'. " using : nom du programe et nom du dynpro utilisé
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'VBAK-AUART'. " On se met sur le zone COMMANDE CLIENT
    PERFORM BDC_field   USING 'VBAK-AUART' 'JRE'. " Dans le champs où le curseur est placé, entre la valeur JRE
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'VBAK-VKORG'. " On se met sur le zone ORGANISATION COMMERCIALE
    PERFORM BDC_field   USING 'VBAK-VKORG' '1710'. " Dans le champs où le curseur est placé, entre la valeur 1710
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'VBAK-VTWEG'. " On se met sur le zone CANAL DE DISTRIBUTION
    PERFORM BDC_field   USING 'VBAK-VTWEG' '10'. " Dans le champs où le curseur est placé, entre la valeur 10
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'VBAK-SPART'. " On se met sur le zone SECTEUR D'ACTIVITE
    PERFORM BDC_field   USING 'VBAK-SPART' '00'. " Dans le champs où le curseur est placé, entre la valeur 00
  
    PERFORM BDC_dynpro  USING 'SAPMV45A' '4001'. " using : nom du programe et nom du dynpro utilisé
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'KUAGV-KUNNR'. " On se met sur le zone DONNEUR D'ORDRE
    PERFORM BDC_field   USING 'KUAGV-KUNNR' 'USCU_S04'. " Dans le champs où le curseur est placé, entre la valeur 10
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'KUWEV-KUNNR'. " On se met sur le zone RECEPTIONNAIRE
    PERFORM BDC_field   USING 'KUWEV-KUNNR' 'USCU_L01'. " Dans le champs où le curseur est placé, entre la valeur 10
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'VBKD-BSTKD'. " On se met sur le zone REFERENCE CLIENT
    PERFORM BDC_field   USING 'VBKD-BSTKD' '10'. " Dans le champs où le curseur est placé, entre la valeur 10
  
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'VBAK-AUGRU'. " On se met sur le zone REFERENCE CLIENT
    PERFORM BDC_field   USING 'VBAK-AUGRU' '006'. " Dans le champs où le curseur est placé, entre la valeur 10
  
  *     PERFORM BDC_dynpro  USING 'BDC_SUBSCR' 'SAPMV45A'. Pour utiliser le sous-écran
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'RV45A-MABNR(01)'. " On se met sur le zone ARTICLE
    PERFORM BDC_field   USING 'RV45A-MABNR(01)' 'TG11'. " Dans le champs où le curseur est placé, entre la valeur 10
  
    PERFORM BDC_field   USING 'BDC_CURSOR' 'RV45A-KWMENG(01)'. " On se met sur le zone QUANTITE
    PERFORM BDC_field   USING 'RV45A-KWMENG(01)' '10'. " Dans le champs où le curseur est placé, entre la valeur 10
  
    PERFORM BDC_dynpro  USING 'SAPMV45A' '4001'. " using : nom du programe et nom du dynpro utilisé
  
    PERFORM BDC_field   USING 'BDC_OKCODE' '=SICH'. " Clique pour enregistrer
  
  
    CALL TRANSACTION 'VA01' USING bdctab MODE 'E'. "Utilise la transaction des créations des articles MM01 avec les éléments de la table BDCTAB
  
  
  ENDFORM.
  
  FORM BDC_dynpro USING program dynpro.
  
    CLEAR bdctab.
  
    bdctab-program = program.
    bdctab-dynpro = dynpro.
    bdctab-dynbegin = 'X'.
  
    APPEND bdctab.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form BDC_field
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM BDC_field USING fnam fval.
  
    CLEAR bdctab.
    bdctab-fnam = fnam.
    bdctab-fval = fval.
    APPEND bdctab.
  
  ENDFORM.