*&---------------------------------------------------------------------*
*& Report ZLBA_FORMATION1
*&---------------------------------------------------------------------*
*& Date Création / Auteur / Motif
*& 24.04.2023 / LBA (Aelion) / Création progamme PROJET ABAP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

    DATA : lv_filename TYPE string.
    *En double cliquant sur GUI_UPLAOD, on voit que le filename doit être de type string.
    *On crée donc une variante lv_filename pour transférer le p_file.
    
    lv_filename = p_file.
    
      CALL FUNCTION 'GUI_UPLOAD'
        EXPORTING
          filename                = lv_filename
          filetype                = 'ASC'
    
        tables
          data_tab                = gt_file
    
        exceptions
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
          others                  = 17.
    
      IF sy-subrc <> 0.
    * Implement suitable error handling here
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
    
      DATA : lv_dummy TYPE string.  "Variable qui sert juste à récupérer la 2ème partie de l'ID COM
    
      DELETE gt_file INDEX 1.
    
      LOOP AT gt_file ASSIGNING FIELD-SYMBOL(<lfs_file>).
        SPLIT <lfs_file>-line AT ';' INTO TABLE DATA(lt_split_csv).
        IF  lines( lt_split_csv ) NE 14.
          CONTINUE.
        ENDIF.
    
        IF lt_split_csv IS NOT INITIAL.
          APPEND INITIAL LINE TO gt_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
    
          IF <lfs_data> IS ASSIGNED.
            SPLIT lt_split_csv[ 1 ] AT 'P' INTO <lfs_data>-id_com lv_dummy.
            <lfs_data>-doc_type      = lt_split_csv[ 2 ].
            <lfs_data>-sales_org     = lt_split_csv[ 3 ].
            <lfs_data>-distr_chan    = lt_split_csv[ 4 ].
            <lfs_data>-sect_act      = lt_split_csv[ 5 ].
            <lfs_data>-partn_role_ag = lt_split_csv[ 6 ].
            <lfs_data>-partn_numb_ag = lt_split_csv[ 7 ].
            <lfs_data>-partn_role_we = lt_split_csv[ 8 ].
            <lfs_data>-partn_numb_we = lt_split_csv[ 9 ].
            <lfs_data>-itm_numb      = lt_split_csv[ 10 ].
            <lfs_data>-material      = lt_split_csv[ 11 ].
            <lfs_data>-plant         = lt_split_csv[ 12 ].
            <lfs_data>-quantity      = lt_split_csv[ 13 ].
            <lfs_data>-quantity_unit = lt_split_csv[ 14 ].
          ENDIF.
        ENDIF.
    
        ENDLOOP.
    
    ENDFORM.
    *&---------------------------------------------------------------------*
    *& Form insert_data
    *&---------------------------------------------------------------------*
    *& text
    *&---------------------------------------------------------------------*
    *& -->  p1        text
    *& <--  p2        text
    *&---------------------------------------------------------------------*
    
    FORM insert_data .
    
      DATA: ls_vbakso TYPE zvbak_so.
      DATA: lt_vbakso TYPE STANDARD TABLE OF zvbak_so.
      DATA: ls_vbapso TYPE zvbap_so.
      DATA: lt_vbapso TYPE STANDARD TABLE OF zvbap_so.
      DATA: ls_header TYPE bapisdhead1.
      DATA: ls_headerx TYPE bapisdhead1x.
      DATA: lt_return TYPE TABLE OF bapiret2.
      DATA: lt_item TYPE TABLE OF bapisditem.
      DATA: lt_itemx TYPE TABLE OF bapisditemx.
      DATA: lt_partners TYPE TABLE OF bapipartnr.
      DATA: lv_vbeln TYPE vbeln.
      DATA: ls_partners LIKE LINE OF lt_partners.
      DATA: lS_item LIKE LINE OF lt_item.
      DATA: lS_itemx LIKE LINE OF lt_itemx.
      DATA: lv_num_com TYPE zid_com_po.
    
    
      LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
    
        " Nettoie les variables
        CLEAR : ls_header, ls_headerx, ls_vbakso, ls_partners, lt_item, lt_itemx, lt_partners, lt_vbakso, lt_vbapso, lt_return.
    
        " Evite de recréer des commandes en doublon
        IF <lfs_data>-id_com = lv_num_com.
          CONTINUE.
        ENDIF.
        lv_num_com = <lfs_data>-id_com.
    
        " Alimentation du Header
        ls_header-doc_type = <lfs_data>-doc_type.
        ls_header-sales_org = <lfs_data>-sales_org.
        ls_header-distr_chan = <lfs_data>-distr_chan.
        ls_header-division = <lfs_data>-sect_act.
        ls_header-req_date_h = sy-datum.
    
        ls_headerx-doc_type = 'X'.
        ls_headerx-sales_org = 'X'.
        ls_headerx-distr_chan = 'X'.
        ls_headerx-division = 'X'.
        ls_headerx-req_date_h = 'X'.
        ls_headerx-updateflag = 'I'.
    
        ls_partners-partn_numb = <lfs_data>-partn_numb_ag.
        ls_partners-partn_role = <lfs_data>-partn_role_ag.
        APPEND ls_partners TO lt_partners.
        ls_partners-partn_numb = <lfs_data>-partn_numb_we.
        ls_partners-partn_role = <lfs_data>-partn_role_we.
        APPEND ls_partners TO lt_partners.
    
        ls_vbakso-mandt  = sy-mandt.
        ls_vbakso-doc_type = <lfs_data>-doc_type.
        ls_vbakso-sales_org = <lfs_data>-sales_org.
        ls_vbakso-distr_chan = <lfs_data>-distr_chan.
        ls_vbakso-sect_act =  <lfs_data>-sect_act.
        ls_vbakso-partn_role_ag = <lfs_data>-partn_role_ag.
        ls_vbakso-partn_numb_ag = <lfs_data>-partn_numb_ag.
        ls_vbakso-partn_role_we = <lfs_data>-partn_role_we.
        ls_vbakso-partn_numb_we = <lfs_data>-partn_numb_we.
    
        APPEND ls_vbakso TO lt_vbakso.
    
        LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<lfs_data2>) WHERE id_com = <lfs_data>-id_com.
    
          CLEAR: ls_item, ls_itemx, ls_vbapso.
    
          ls_item-itm_number = <lfs_data2>-itm_numb.
          ls_item-material = <lfs_data2>-material.
          ls_item-plant = <lfs_data2>-plant.
          ls_item-target_qty = <lfs_data2>-quantity.
          ls_item-target_qu = <lfs_data2>-quantity_unit.
          APPEND ls_item TO lt_item.
          ls_itemx-itm_number = 'X'.
          ls_itemx-material = 'X'.
          ls_itemx-plant = 'X'.
          ls_itemx-target_qty = 'X'.
          ls_itemx-target_qu = 'X'.
          ls_itemx-updateflag = 'I'.
          APPEND ls_itemx TO lt_itemx.
    
          ls_vbapso-mandt = sy-mandt.
          ls_vbapso-itm_numb = <lfs_data2>-itm_numb.
          ls_vbapso-material = <lfs_data2>-material.
          ls_vbapso-plant = <lfs_data2>-plant.
          ls_vbapso-quantity = <lfs_data2>-quantity.
          ls_vbapso-quantity_unit = <lfs_data2>-quantity_unit.
    
          APPEND ls_vbapso TO lt_vbapso.
    
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
            sales_partners   = lt_partners.
    
    * vérification table return
        LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<lfs_return>) WHERE type = 'E' OR type = 'A'.
          EXIT.
        ENDLOOP.
    
        IF sy-subrc = 0.
    *      erreur
          WRITE 'La commande correspondant à l''id :  ' && <lfs_data>-id_com && ' n''a pas pu être créée.'.
          SKIP.
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    
        ELSE.
    *      succès
          WRITE 'Le numéro de commande n° : ' && lv_vbeln && ' a été créé.'.
          SKIP.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    
          IF p_test <> 'X'. " Si la case Test n'est pas coché
            LOOP AT lt_vbapso ASSIGNING FIELD-SYMBOL(<fs_vbapso>).
              <fs_vbapso>-vbeln = lv_vbeln.
            ENDLOOP.
            READ TABLE lt_vbakso ASSIGNING FIELD-SYMBOL(<fs_vbakso>) INDEX 1.
            IF sy-subrc = 0.
              <fs_vbakso>-vbeln = lv_vbeln.
            ENDIF.
            INSERT zvbak_so FROM TABLE lt_vbakso ACCEPTING DUPLICATE KEYS.
            IF sy-subrc = 0.
              INSERT zvbap_so FROM TABLE lt_vbapso ACCEPTING DUPLICATE KEYS.
            ENDIF.
          ENDIF.
        ENDIF.
    
      ENDLOOP.
    
    ENDFORM.
    
    
    *FORM insert_data .
    *
    *DATA : ls_vbakso TYPE zvbak_so, "ZVBAK_SO est une table d'entête créer en SE11 en Table de BDD
    *       lt_vbakso TYPE STANDARD TABLE OF zvbak_so,
    *       ls_vbapso TYPE zvbap_so, "ZVBAP_SO est une table de posts créer en SE11 en Table de BDD
    *       lt_vbapso TYPE STANDARD TABLE OF zvbak_so.
    *
    *  LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
    *    ls_vbakso-id_com = <lfs_data>-id_com.
    *    ls_vbakso-doc_type = <lfs_data>-doc_type.
    *    ls_vbakso-sales_org = <lfs_data>-sales_org.
    *    ls_vbakso-distr_chan = <lfs_data>-distr_chan.
    *    ls_vbakso-sect_act =  <lfs_data>-sect_act.
    *    ls_vbakso-partn_role_ag = <lfs_data>-partn_role_ag.
    *    ls_vbakso-partn_numb_ag = <lfs_data>-partn_numb_ag.
    *    ls_vbakso-partn_role_we = <lfs_data>-partn_role_we.
    *    ls_vbakso-partn_numb_we = <lfs_data>-partn_numb_we.
    *
    *    APPEND ls_vbakso TO lt_vbakso.
    *
    *    ls_vbapso-id_com = <lfs_data>-id_com.
    *    ls_vbapso-itm_numb = <lfs_data>-itm_numb.
    *    ls_vbapso-material = <lfs_data>-material.
    *    ls_vbapso-plant = <lfs_data>-plant.
    *    ls_vbapso-quantity = <lfs_data>-quantity.
    *    ls_vbapso-quantity_unit = <lfs_data>-quantity_unit.
    *
    *    APPEND ls_vbapso TO lt_vbapso.
    *
    *  ENDLOOP.
    *
    *SORT lt_vbakso by id_com. "On tri la table par id_com pour pouvoir supprimer les doublons
    *
    **On supprime les doublons qui se suivent (C'est pour ça qu'on tri avant). Sinon on ne pourra pas remplir la table de BDD
    **car l id_com est la clé de la table et on ne peut avoir plusieurs clés identiques
    *DELETE ADJACENT DUPLICATES FROM lt_vbakso COMPARING id_com.
    *
    *
    **Avec insert on ajoute dans la BDD, si on ajoute dans une table locale on fait APPEND
    *INSERT zvbak_so FROM TABLE lt_vbakso ACCEPTING DUPLICATE KEYS. "On a mis ACCEPTING... pour que quand on teste le code
    *"on puisse ajouter pls fois les mêmes car normalement on ne peut pas avoir 2 fois la même clé
    *
    *IF sy-subrc = 0.
    *
    *INSERT zvbap_so FROM TABLE lt_vbapso.
    *
    *ENDIF.
    *
    *ENDFORM.