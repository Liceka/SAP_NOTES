
*&---------------------------------------------------------------------*
*& Include          ZPROJ_INTER_2023_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form create_sales_order
*&---------------------------------------------------------------------*

FORM create_sales_order .

  DATA: lv_vbeln      LIKE vbak-vbeln,
        ls_header     TYPE bapisdhead1,
        ls_headerx    LIKE bapisdhead1x,
        lt_item       TYPE STANDARD TABLE OF bapisditem,
        ls_item       LIKE LINE OF lt_item,
        lt_itemx      TYPE STANDARD TABLE OF bapisditemx,
        ls_itemx      LIKE LINE OF lt_itemx,
        lt_partner    TYPE STANDARD TABLE OF bapipartnr,
        ls_partner    LIKE LINE OF lt_partner,
        lt_return     TYPE STANDARD TABLE OF bapiret2,
        lr_auart      TYPE RANGE OF auart,
        ls_auart      LIKE LINE OF lr_auart,
        lt_tvarvc     TYPE STANDARD TABLE OF tvarvc,
        ls_log        TYPE bal_s_log,
        ls_msg        TYPE bal_s_msg,
        ls_log_handle TYPE balloghndl,
        lt_log_handle TYPE bal_t_logh,
        lv_id_com     TYPE  zid_com_po.

  CONSTANTS : lc_object TYPE balobj_d VALUE 'ZPROJ_CV'.



* Récupération des types de commandes autorisés pour la création des commandes de vente
  SELECT  * FROM tvarvc
  INTO TABLE lt_tvarvc
  WHERE name = 'ZPROJ_CV_AUART'
  AND   type = 'S'.
  IF sy-subrc = 0.



* On construit un range à partir de cette liste
    LOOP AT lt_tvarvc ASSIGNING FIELD-SYMBOL(<fs_tvarvc>).
      ls_auart-sign   = <fs_tvarvc>-sign.
      ls_auart-option = <fs_tvarvc>-opti.
      ls_auart-low    = <fs_tvarvc>-low.
      APPEND ls_auart TO lr_auart.
    ENDLOOP.
  ENDIF.



  ls_log-object = 'ZLOG_PROJ'.          "Object name
  ls_log-aluser = sy-uname.        "Username
  ls_log-alprog = sy-repid.          "report name


  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = ls_log
    IMPORTING
      e_log_handle            = ls_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.



  IF sy-subrc <> 0.
* Implement suitable error handling here
    EXIT.
  ENDIF.


  LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
    CLEAR : ls_header, ls_headerx, ls_partner, lt_partner , lt_item, lt_itemx, lt_return, lv_vbeln, ls_msg.

    IF <fs_data>-id_com = lv_id_com.
      CONTINUE.
    ENDIF.

    lv_id_com = <fs_data>-id_com.
    CHECK <fs_data>-doc_type IN lr_auart.


    ls_header-doc_type = <fs_data>-doc_type.
    ls_header-sales_org = <fs_data>-sales_org.
    ls_header-distr_chan = <fs_data>-distr_chan.
    ls_header-division = <fs_data>-sect_act.
    ls_header-req_date_h = sy-datum + 5.

    ls_headerx-doc_type = 'X'.
    ls_headerx-sales_org =  'X'.
    ls_headerx-distr_chan =  'X'.
    ls_headerx-division =  'X'.
    ls_headerx-req_date_h = 'X'.
    ls_headerx-updateflag = 'I'.

    ls_partner-partn_numb = <fs_data>-partn_numb_ag.
    ls_partner-partn_role = <fs_data>-partn_role_ag.

    APPEND ls_partner TO lt_partner.

    ls_partner-partn_numb = <fs_data>-partn_numb_we.
    ls_partner-partn_role = <fs_data>-partn_role_we.

    APPEND ls_partner TO lt_partner.

    LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data2>)
      WHERE id_com = <fs_data>-id_com.
      ls_item-itm_number = <fs_data2>-itm_numb.
      ls_item-material = <fs_data2>-material.
      ls_item-plant = <fs_data2>-plant.
      ls_item-target_qty =  <fs_data2>-quantity.
      ls_item-target_qu = <fs_data2>-quantity_unit.

      APPEND ls_item TO lt_item.

      ls_itemx-itm_number = 'X'.
      ls_itemx-material = 'X'.
      ls_itemx-plant = 'X'.
      ls_itemx-target_qty =  'X'.
      ls_itemx-target_qu = 'X'.
      ls_itemx-updateflag = 'I'.

      APPEND ls_itemx TO lt_itemx.

    ENDLOOP.

    CALL FUNCTION 'BAPI_SALESDOCU_CREATEFROMDATA1'
      EXPORTING
        sales_header_in  = ls_header
        sales_header_inx = ls_headerx
      IMPORTING
        salesdocument_ex = lv_vbeln
      TABLES
        return           = lt_return
        sales_items_in   = lt_item
        sales_items_inx  = lt_itemx
        sales_partners   = lt_partner.

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) WHERE type = 'E' OR type = 'A'.
      EXIT.
    ENDLOOP.

    IF sy-subrc = 0. "si c'est égal à 0, ERREUR!
      ls_msg-msgty = 'E'.
      ls_msg-msgid = 'ZKDE_MESS'.
      ls_msg-msgno = 012.
      ls_msg-msgv1 = <fs_data>-id_com.
      ROLLBACK WORK.
    ELSE.          "sinon si diffent de 0 alors succès.
      ls_msg-msgty = 'S'.
      ls_msg-msgid = 'ZKDE_MESS'.
      ls_msg-msgno = 013.
      ls_msg-msgv1 = lv_vbeln.
      ls_msg-msgv2 = <fs_data>-id_com.
      COMMIT WORK AND WAIT.
    ENDIF.
    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = ls_log_handle
        i_s_msg          = ls_msg
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.
    IF sy-subrc = 0.
      INSERT ls_log_handle INTO TABLE lt_log_handle.
* Implement suitable error handling here
    ENDIF.

  ENDLOOP.

  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_client         = sy-mandt
      i_save_all       = 'X'
      i_t_log_handle   = lt_log_handle
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


** On prépare la log applicative pour pouvoir l'alimenter à la suite de la BAPI
*  CLEAR : ls_log, ls_log_handle, lt_log_handle.
*
*  ls_log-object = lc_object.  " Object name
*  ls_log-aluser = sy-uname.   " Username
*  ls_log-alprog = sy-repid.   " Report name
*
*  CALL FUNCTION 'BAL_LOG_CREATE'
*    EXPORTING
*      i_s_log                 = ls_log
*    IMPORTING
*      e_log_handle            = ls_log_handle
*    EXCEPTIONS
*      log_header_inconsistent = 1
*      OTHERS                  = 2.
*  IF sy-subrc = 0.
*
** On boucle sur chacune des lignes de la table
*    LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*      CLEAR : ls_header, ls_headerx, ls_partner, lt_partner , lt_item, lt_itemx, lt_return, lv_vbeln, ls_msg.
** On vérifie que le type de commande de la ligne fait partie des types de commandes autorisés
** Si ce n'est pas le cas, on ignore la ligne et on passe à la prochaine occurence de la table
*      CHECK <fs_data>-doc_type IN lr_auart.
*
*   IF <fs_data>-id_com = lv_id_com.
*      CONTINUE.
*    ENDIF.
*
*    AT NEW id_com.
*      lv_id_com = <fs_data>-id_com.
*    ENDAT.


** Sales document type
*      ls_header-doc_type = <fs_data>-doc_type.
*      ls_headerx-doc_type = 'X'.
** Sales organization
*      ls_header-sales_org = <fs_data>-sales_org.
*      ls_headerx-sales_org = 'X'.
** Distribution channel
*      ls_header-distr_chan = <fs_data>-distr_chan.
*      ls_headerx-distr_chan = 'X'.
** Division / secteur d'activité
*      ls_header-division = <fs_data>-sect_act.
*      ls_headerx-division = 'X'.
*      ls_headerx-updateflag = 'I'.
** Date de livraison souhaitée
*      ls_header-req_date_h = sy-datum + 5.
*      ls_headerx-req_date_h = 'X'.
*
**------Partner data--------------------------------------*
** On part du principe que les partenaires sont les mêmes pour tous les postes d'une même commande
** Donc on mappe la table de partenaires comme une donnée d'entête
** Sold to
*      ls_partner-partn_role = <fs_data>-partn_role_ag.
*      ls_partner-partn_numb = <fs_data>-partn_numb_ag.
*      APPEND ls_partner TO lt_partner.
** Ship to
*      ls_partner-partn_role = <fs_data>-partn_role_we.
*      ls_partner-partn_numb = <fs_data>-partn_numb_we.
*      APPEND ls_partner TO lt_partner.
*
*      LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data2>) WHERE id_com = <fs_data>-id_com.
*        " On mappe les données de poste
*        CLEAR : ls_item, ls_itemx.
** ITEM DATA
*        ls_itemx-updateflag = 'I'.
*** Line item number.
*        ls_item-itm_number = <fs_data2>-itm_numb.
*        ls_itemx-itm_number = 'X'.
** Material
*        ls_item-material = <fs_data2>-material.
*        ls_itemx-material = 'X'.
** Plant
*        ls_item-plant = <fs_data2>-plant.
*        ls_itemx-plant = 'X'.
** Quantity
*        ls_item-target_qty = <fs_data2>-quantity.
*        ls_itemx-target_qty = 'X'.
*        ls_item-target_qu = <fs_data2>-quantity_unit.
*        ls_itemx-target_qu = 'X'.
*
*        APPEND ls_item TO lt_item.
*        APPEND ls_itemx TO lt_itemx.
*
*      ENDLOOP.
*
** On appelle la BAPI pour créer la commande de vente
*      CALL FUNCTION 'BAPI_SALESDOCU_CREATEFROMDATA1'
*        EXPORTING
*          sales_header_in  = ls_header
*          sales_header_inx = ls_headerx
*        IMPORTING
*          salesdocument_ex = lv_vbeln
*        TABLES
*          return           = lt_return
*          sales_items_in   = lt_item
*          sales_items_inx  = lt_itemx
*          sales_partners   = lt_partner.
*      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) WHERE type = 'E' OR type = 'A'.
*        EXIT.
*      ENDLOOP.
*      IF sy-subrc = 0.
*        ls_msg-msgty = 'E'.
*        ls_msg-msgid = 'ZKDE_MESS'.
*        ls_msg-msgno =  012.
*        ls_msg-msgv1 = <fs_data>-id_com.
*        ROLLBACK WORK.
*      ELSE.
*        ls_msg-msgty = 'S'.
*        ls_msg-msgid = 'ZKDE_MESS'.
*        ls_msg-msgno =  013.
*        ls_msg-msgv1 = lv_vbeln.
*        ls_msg-msgv2 = <fs_data>-id_com.
*        COMMIT WORK AND WAIT.
*      ENDIF.
*
*      CALL FUNCTION 'BAL_LOG_MSG_ADD'
*        EXPORTING
*          i_log_handle     = ls_log_handle
*          i_s_msg          = ls_msg
*        EXCEPTIONS
*          log_not_found    = 1
*          msg_inconsistent = 2
*          log_is_full      = 3
*          OTHERS           = 4.
*      IF sy-subrc EQ 0.
*        INSERT ls_log_handle INTO TABLE lt_log_handle.
*      ENDIF.
*
*    ENDLOOP.
*
****Save message
*    CALL FUNCTION 'BAL_DB_SAVE'
*      EXPORTING
*        i_client         = sy-mandt
*        i_save_all       = 'X'
*        i_t_log_handle   = lt_log_handle
*      EXCEPTIONS
*        log_not_found    = 1
*        save_not_allowed = 2
*        numbering_error  = 3
*        OTHERS           = 4.
*    IF sy-subrc EQ 0.
*      CLEAR : lt_log_handle.
*    ENDIF.
*
*  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select_data.

* Select avec jointure sur VBAK VBAP KNA1 MARA MAKT

  DATA : lv_post TYPE ntgew,
         lv_comm TYPE f.

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
      AND vbap~werks IN @s_plant
      AND vbak~erdat IN @s_erdat
    ORDER BY vbak~erdat DESCENDING, vbak~erzet DESCENDING
    INTO TABLE @gt_cv.
  IF sy-subrc <> 0.
    MESSAGE e000(zkde_mess).
  ENDIF.

****************************  Calcul poids des postes + poids total de la commande   ******************************************
  LOOP AT gt_cv ASSIGNING FIELD-SYMBOL(<fs_cv>).
    AT NEW vbeln.
      CLEAR <fs_cv>-pds_tot.
    ENDAT.

    LOOP AT gt_cv ASSIGNING FIELD-SYMBOL(<fs_cv2>) WHERE vbeln = <fs_cv>-vbeln.
      <fs_cv2>-pds_post = <fs_cv2>-zmeng * <fs_cv2>-ntgew.
      <fs_cv>-pds_tot =  <fs_cv>-pds_tot  + <fs_cv2>-pds_post.
    ENDLOOP.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_data.

  DATA: lo_alv           TYPE REF TO cl_salv_table,
        lr_events        TYPE REF TO cl_salv_events_table,
        lo_events        TYPE REF TO ycl_event,
        lo_alv_functions TYPE REF TO cl_salv_functions,
        lo_columns       TYPE REF TO cl_salv_columns_table,
        lo_message       TYPE REF TO cx_salv_msg.

  TRY.
      CALL METHOD cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = gt_cv ).
    CATCH cx_salv_msg INTO lo_message.
  ENDTRY.


  lo_alv_functions = lo_alv->get_functions( ).
  lo_alv_functions->set_all( abap_true ).

  lo_columns = lo_alv->get_columns( ).
  lo_columns->set_optimize( abap_true ).

  lr_events = lo_alv->get_event( ).

  CREATE OBJECT lo_events.
  SET HANDLER lo_events->m_double_click FOR lr_events.
  SET HANDLER lo_events->m_hotspot      FOR lr_events.

  lo_alv->display( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form Init_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM Init_data .

  " On initialise toutes les variables globales
  CLEAR : gt_file, gt_cv, gt_data, gt_alv.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data_from_file
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data_from_file .

  DATA: lv_filename TYPE rlgrap-filename,
        lv_string   TYPE string,
        ls_file     LIKE LINE OF gt_file.

* Si l'option "fichier local" a été choisie par l'utilisateur
  IF p_rad1 = 'X'.

    lv_string = p_fname.
* On appelle de MF pour récupérer le contenu du fichier CSV dans une table interne
    CALL FUNCTION 'GUI_UPLOAD'
      EXPORTING
        filename                = lv_string
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
      CLEAR gt_file.
      MESSAGE e011(zkde_mess).
    ENDIF.
  ENDIF.

* Si l'option "fichier serveur" a été sélectionné par l'utilisateur
  IF p_rad2 = 'X'.
    CONCATENATE p_lpath p_lname INTO lv_filename SEPARATED BY '/'.
    TRANSLATE lv_filename TO LOWER CASE.
    OPEN DATASET lv_filename FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc IS INITIAL.
      DO.
        CLEAR ls_file.
        READ DATASET lv_filename INTO ls_file-line.
        IF sy-subrc = 0.
          APPEND ls_file TO gt_file.
        ELSE.
          EXIT.
        ENDIF.
      ENDDO.
    ENDIF.
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

  DATA : lv_dummy TYPE string.  "Variable inutile qui sert juste à récupérer la 2ème partie de l'ID COM

  DELETE gt_file INDEX 1.

  LOOP AT gt_file ASSIGNING FIELD-SYMBOL(<fs_file>).
    SPLIT <fs_file>-line AT ';' INTO TABLE DATA(lt_split_csv).
    IF  lines( lt_split_csv ) NE 14.
      CONTINUE.
    ENDIF.

    IF lt_split_csv IS NOT INITIAL.
      APPEND INITIAL LINE TO gt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF <fs_data> IS ASSIGNED.
        SPLIT lt_split_csv[ 1 ] AT 'P' INTO <fs_data>-id_com lv_dummy.
        <fs_data>-doc_type      = lt_split_csv[ 2 ].
        <fs_data>-sales_org     = lt_split_csv[ 3 ].
        <fs_data>-distr_chan    = lt_split_csv[ 4 ].
        <fs_data>-sect_act = lt_split_csv[ 5 ].
        <fs_data>-partn_role_ag = lt_split_csv[ 6 ].
        <fs_data>-partn_numb_ag = lt_split_csv[ 7 ].
        <fs_data>-partn_role_we = lt_split_csv[ 8 ].
        <fs_data>-partn_numb_we = lt_split_csv[ 9 ].
        <fs_data>-itm_numb      = lt_split_csv[ 10 ].
        <fs_data>-material      = lt_split_csv[ 11 ].
        <fs_data>-plant         = lt_split_csv[ 12 ].
        <fs_data>-quantity      = lt_split_csv[ 13 ].
        <fs_data>-quantity_unit = lt_split_csv[ 14 ].
      ENDIF.
    ENDIF.

  ENDLOOP.

ENDFORM.

FORM double_click_event USING lv_row    TYPE i
                        lv_column TYPE lvc_fname.

  DATA : ls_cv LIKE LINE OF gt_cv.

  READ TABLE gt_cv INTO ls_cv INDEX lv_row.
  IF sy-subrc = 0.
    IF lv_column = 'VBELN' AND ls_cv-vbeln IS NOT INITIAL.
      SET PARAMETER ID 'AUN' FIELD ls_cv-vbeln.
      CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
    ENDIF.
  ENDIF.


ENDFORM.

*FORM hotspot_event USING lv_row    TYPE i
*                         lv_column TYPE fieldname.
*
*  DATA : lo_col TYPE REF TO cl_salv_column_table.
*
*  TRY.
*      lo_col ?= go_cols->get_column( 'VBELN' ).
*    CATCH cx_salv_not_found.
*      MESSAGE e052(sy) WITH lv_column.
*  ENDTRY.
*
*  IF lo_col IS BOUND.
*    lo_col->set_cell_type( if_salv_c_cell_type=>hotspot ).
*  ENDIF.
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_data .

* Un seul check à titre d'exemple.

  "Récupération des articles existants en BDD
  SELECT matnr FROM mara INTO TABLE @DATA(lt_mara).

* Vérification de l'existence des articles présents dans le fichier

  LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
    READ TABLE lt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>) WITH KEY matnr = <fs_data>-material.
    IF sy-subrc <> 0.
      " Si l'article du fichier n'existe pas dans la table LT_MARA et donc dans la BDD
      " On vide le champ MATERIAL pour une suppression ultérieure de la ligne
      CLEAR <fs_data>-material.
    ENDIF.
  ENDLOOP.

  " On supprime de la table GT_DATA les lignes dont le champ Material est vide
  DELETE gt_data WHERE material IS INITIAL.


ENDFORM.
