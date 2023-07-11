  
*Exemple de badi
  
  METHOD if_ex_me_process_po_cust~process_header.

    DATA: lt_tvarvc TYPE STANDARD TABLE OF tvarvc,
          lr_bukrs  TYPE RANGE OF bukrs,
          ls_bukrs  LIKE LINE OF lr_bukrs,
          lv_bukrs  TYPE bukrs,
          ls_header TYPE mepoheader.

    SELECT * FROM tvarvc
      INTO TABLE lt_tvarvc
      WHERE name = 'zcom_achat'
      AND type = 'S'.

    IF sy-subrc = 0.

      LOOP AT lt_tvarvc ASSIGNING FIELD-SYMBOL(<fs_tvarvc>).
        ls_bukrs-sign = <fs_tvarvc>-sign.
        ls_bukrs-option = <fs_tvarvc>-opti.
        ls_bukrs-low = <fs_tvarvc>-low.

        APPEND ls_bukrs TO lr_bukrs.

      ENDLOOP.

    ENDIF.

    ls_header = im_header->get_data( ).

    IF ls_header-bukrs NOT IN lr_bukrs.
      MESSAGE e017(zkde_mess).

    ENDIF.


  ENDMETHOD.


*Autre exemple :


  method IF_EX_LE_SHP_DELIVERY_PROC~CHANGE_FIELD_ATTRIBUTES.
  

    DATA : ls_attribute TYPE shp_screen_attributes.


    IF is_likp-kunnr = 'USCU_L10'.
      ls_attribute-name = 'LIPSD-G_LFIMG'.
      ls_attribute-input = 0.
      ls_attribute-invisible = 1.
      APPEND ls_attribute TO ct_field_attributes.
      ls_attribute-name = 'LIPS-BRGEW'.
      ls_attribute-input = 0.
      ls_attribute-invisible = 1.
      APPEND ls_attribute TO ct_field_attributes.
    ENDIF.

  endmethod.