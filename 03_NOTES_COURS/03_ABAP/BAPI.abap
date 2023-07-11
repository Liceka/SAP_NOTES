  DATA: lv_vbeln      LIKE vbak-vbeln,
        ls_header     TYPE bapisdhead1,
        ls_headerx    LIKE bapisdhead1x,
        lt_item       TYPE STANDARD TABLE OF bapisditem,
        ls_item       LIKE LINE OF lt_item,
        lt_itemx      TYPE STANDARD TABLE OF bapisditemx,
        ls_itemx      LIKE LINE OF lt_itemx,
        lt_partner    TYPE STANDARD TABLE OF bapipartnr,
        ls_partner    LIKE LINE OF lt_partner,
        lt_return     TYPE STANDARD TABLE OF bapiret2.


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

      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
        EXPORTING
          input          = <fs_data2>-quantity_unit
          language       = sy-langu
        IMPORTING
          output         = <fs_data2>-quantity_unit
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.

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