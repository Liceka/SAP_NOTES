*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION4_F01
*&---------------------------------------------------------------------*

FORM select_data .
    *TABLES : mara, marc.
    
      DATA : lt_likp TYPE TABLE OF ty_likp,
             lt_lips TYPE TABLE OF ty_lips,
             lt_vbrp TYPE TABLE OF ty_vbrp,
             lt_vbrk TYPE TABLE OF ty_vbrk,
             lt_marc TYPE TABLE OF ty_marc.
    
    
    
      SELECT vbeln vstel vkorg erdat
        FROM likp
        INTO TABLE lt_likp
        WHERE vbeln IN s_vbeln.
    
    
      IF sy-subrc <> 0. "je n'ai pas trouvé les numéro de livraison
        MESSAGE TEXT-001 TYPE 'E'. " type 'E' veut dire Erreur donc le programme s'arrête
      ENDIF.
    
      "ou en utilisant check (qui sert de if et exit en meme temps) le check quitte le tiroir et non le programme.
      "Du coup il va continuer les autres tiroirs.
      "check sy-subrc = 0.
    
    
    
      IF p_suppr IS INITIAL.
        SELECT lips~vbeln lips~posnr lips~matnr lips~werks lips~lfimg lips~meins
          FROM lips
          INNER JOIN mara ON mara~matnr = lips~matnr
          INTO TABLE lt_lips
          FOR ALL ENTRIES IN lt_likp
          WHERE lips~vbeln = lt_likp-vbeln
          AND lips~matnr IN s_matnr
          AND lips~werks IN s_werks
          AND mara~lvorm = ' '.
      ELSE.
        SELECT vbeln posnr matnr werks lfimg meins
            FROM lips
            INTO TABLE lt_lips
            FOR ALL ENTRIES IN lt_likp
            WHERE vbeln = lt_likp-vbeln
            AND matnr IN s_matnr
            AND werks IN s_werks.
      ENDIF.
    
    
      SELECT vbeln vgbel vgpos posnr fkimg vrkme ntgew gewei netwr
         FROM vbrp
        INTO TABLE lt_vbrp
        FOR ALL ENTRIES IN lt_lips
       WHERE vgbel = lt_lips-vbeln
        AND vgpos = lt_lips-posnr.
    
      SELECT vbeln fkart fkdat waerk
        FROM vbrk
        INTO TABLE lt_vbrk
        FOR ALL ENTRIES IN lt_vbrp
        WHERE vbeln = lt_vbrp-vbelnf
        AND vbeln IN s_vbelnf.
    
      SELECT matnr ekgrp lvorm
        FROM marc
    *    INNER JOIN mara ON mara-lvorm = marc-lvorm
        INTO TABLE lt_marc
        FOR ALL ENTRIES IN lt_lips
        WHERE matnr = lt_lips-matnr
        AND werks = lt_lips-werks.
    *    and lvorm is not initial
    *    AND lvorm = 0.
    
      PERFORM merge_data USING lt_likp
                                lt_lips
                                lt_vbrk
                                lt_vbrp
                                lt_marc.
    ENDFORM.
    *&---------------------------------------------------------------------*
    *& Form merge_data
    *&---------------------------------------------------------------------*
    *& text
    *&---------------------------------------------------------------------*
    *&      --> LT_LIKP
    *&      --> LT_LIPS
    *&      --> LT_VBRK
    *&      --> LT_VBRP
    *&      --> LT_MARC
    *&---------------------------------------------------------------------*
    FORM merge_data  USING    ut_likp TYPE ty_t_likp
                              ut_lips TYPE ty_t_lips
                              ut_vbrk TYPE ty_t_vbrk
                              ut_vbrp TYPE ty_t_vbrp
                              ut_marc TYPE ty_t_marc.
    
      DATA : lsfinal_2 LIKE LINE OF gt_final2,
             ls_likp   TYPE ty_likp,
             ls_lips   TYPE ty_lips,
             ls_vbrk   TYPE ty_vbrk,
             ls_vbrp   TYPE ty_vbrp,
             ls_marc   TYPE ty_marc.
    
      SORT ut_lips BY vbeln. " perme tde trier les résultats avec le vbeln
    
    * DATA : lv_date  TYPE dats,
    *         lv_date2 TYPE STRING.
    *
    *  lv_date = sy-datum. "AAAAMMJJ  20230302
    *
    *
    *  CONCATENATE lv_date+6(2) lv_date+4(2) lv_date(4) INTO lv_date2 SEPARATED BY '.'.
    *
    *  write : lv_date2.
    
      LOOP AT ut_likp INTO ls_likp.
        CLEAR lsfinal_2.
        lsfinal_2-vbeln = ls_likp-vbeln.
        lsfinal_2-vstel = ls_likp-vstel.
        lsfinal_2-vkorg = ls_likp-vkorg.
        lsfinal_2-erdat = ls_likp-erdat.
        CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum(4) INTO lsfinal_2-datejour SEPARATED BY '/'.
    
        LOOP AT ut_lips INTO ls_lips WHERE vbeln = ls_likp-vbeln.
          lsfinal_2-posnr = ls_lips-posnr.
          lsfinal_2-matnr = ls_lips-matnr.
          lsfinal_2-werks = ls_lips-werks.
          lsfinal_2-lfimg = ls_lips-lfimg.
          lsfinal_2-meins = ls_lips-meins.
    *      lsfinal_2-lvorm = ls_lips-lvorm.
    
          READ TABLE ut_marc INTO ls_marc WITH KEY matnr = ls_lips-matnr werks = ls_lips-werks.
          IF sy-subrc = 0.
    
            lsfinal_2-ekgrp = ls_marc-ekgrp.
    
          ENDIF.
    
          READ TABLE ut_vbrp INTO ls_vbrp WITH KEY vgbel = ls_lips-vbeln vgpos = ls_lips-posnr.
          IF sy-subrc = 0.
            lsfinal_2-vbelnf = ls_vbrp-vbelnf.
            lsfinal_2-posnrf = ls_vbrp-posnrf.
            lsfinal_2-fkimg = ls_vbrp-fkimg.
            lsfinal_2-vrkme = ls_vbrp-vrkme.
            lsfinal_2-ntgew = ls_vbrp-ntgew.
            lsfinal_2-gewei = ls_vbrp-gewei.
            lsfinal_2-netwr = ls_vbrp-netwr.
    
            READ TABLE ut_vbrk INTO ls_vbrk WITH KEY vbelnf = ls_vbrp-vbelnf.
            IF sy-subrc = 0.
              "lsfinal_2-vbelnf = ls_vbrk-vbelnf.
              lsfinal_2-fkart = ls_vbrk-fkart.
              lsfinal_2-fkdat = ls_vbrk-fkdat.
              lsfinal_2-waerk = ls_vbrk-waerk.
            ENDIF.
    
            APPEND lsfinal_2 TO gt_final2.
    
          ENDIF.
    
        ENDLOOP.
    
      ENDLOOP.
    
    *  CALL METHOD cl_salv_table=>factory
    *      IMPORTING
    *        r_salv_table = lo_alv
    *      CHANGING
    *        t_table      = gt_final2.
    *
    *    CALL METHOD lo_alv->display.
    *
    
    
    *    READ TABLE ut_lips into ls_lips with key
    ENDFORM.
    *&---------------------------------------------------------------------*
    *& Form display_data
    *&---------------------------------------------------------------------*
    *& text
    *&---------------------------------------------------------------------*
    *& -->  p1        text
    *& <--  p2        text
    *&---------------------------------------------------------------------*
    FORM display_data .
      DATA : lo_alv TYPE REF TO cl_salv_table.
    
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = gt_final2.
    
      CALL METHOD lo_alv->display.
    
    ENDFORM.
    
    *PERFORM play_data.
    *
    **&---------------------------------------------------------------------*
    **& Form play_data
    **&---------------------------------------------------------------------*
    **& text
    **&---------------------------------------------------------------------*
    **& -->  p1        text
    **& <--  p2        text
    **&---------------------------------------------------------------------*
    *
    *"Exemple piyr utilisation du fiel symbol ou de la modification de la structure :
    *
    *FORM play_data .
    *
    *    LOOP AT gtfinal_2 INTO DATA(ls_final).
    *    ls_finalerdat = '20230101'.
    *    ls_finalfkart = 'S1'.
    *    ls_finalfkimg = '200'.
    *    MODIFY gtfinal_2 FROM ls_final TRANSPORTING erdat fkart fkimg WHERE vbeln = lsfinal_2-vbeln.
    *  ENDLOOP.
    *
    *  "OU
    *
    *  LOOP AT gtfinal_2 ASSIGNING FIELD-SYMBOL(<fs_final>).
    *    ls_finalerdat = '20230101'.
    *    ls_finalfkart = 'S1'.
    *    ls_finalfkimg = '200'.
    *  ENDLOOP.
    *
    *
    *ENDFORM.