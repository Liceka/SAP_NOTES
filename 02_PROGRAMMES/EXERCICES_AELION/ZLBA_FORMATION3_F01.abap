*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION3_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM select_data .

    DATA : lt_vbak TYPE TABLE OF ty_vbak,
           lt_vbap TYPE TABLE OF ty_vbap,
           lt_makt TYPE TABLE OF ty_makt,
           lt_kna1 TYPE TABLE OF ty_kna1.
  *         ls_vbak TYPE ty_vbak,
  *         ls_vbap TYPE ty_vbap,
  *         ls_makt TYPE ty_makt,
  *         ls_kna1 TYPE ty_kna1.
  
  
  
    SELECT vbeln erdat vkorg vtweg spart netwr waerk
      FROM vbak
      INTO TABLE lt_vbak
      WHERE vbeln IN s_vbeln.
  
  
  * TABLES : ztfinal.
  
    SELECT vbeln posnr matnr charg kunnr_ana netwr waerk
      FROM vbap
      INTO TABLE lt_vbap
      FOR ALL ENTRIES IN lt_vbak
      WHERE vbeln = lt_vbak-vbeln
      AND matnr IN s_matnr
      AND charg IN s_charg
      AND kunnr_ana IN s_kunnr.
  
  
    SELECT matnr maktx
      FROM makt
      INTO TABLE lt_makt
      FOR ALL ENTRIES IN lt_vbap
      WHERE matnr = lt_vbap-matnr.
  *   AND matnr IN s_matnr.
  
    SELECT kunnr name1 stras pstlz ort01 land1
      FROM kna1
      INTO TABLE lt_kna1
      FOR ALL ENTRIES IN lt_vbap
      WHERE kunnr = lt_vbap-kunnr_ana.
  
    PERFORM merge_data USING lt_vbak
                             lt_vbap
                             lt_makt
                             lt_kna1.
  
  
  ENDFORM.
  
  *ENDFORM.
  **&---------------------------------------------------------------------*
  **& Form merge_data
  **&---------------------------------------------------------------------*
  **& text
  **&---------------------------------------------------------------------*
  **& -->  p1        text
  **& <--  p2        text
  **&---------------------------------------------------------------------*
  *FORM merge_data .
  
  FORM merge_data  USING    ut_vbak TYPE ty_t_vbak
                            ut_vbap TYPE ty_t_vbap
                            ut_makt TYPE ty_t_makt
                            ut_kna1 TYPE ty_t_kna1.
  
    DATA : ls_final LIKE LINE OF gt_final,
           ls_vbak  TYPE ty_vbak,
           ls_vbap  TYPE ty_vbap,
           ls_makt  TYPE ty_makt,
           ls_kna1  TYPE ty_kna1.
  
    LOOP AT ut_vbak INTO ls_vbak.
      CLEAR ls_final.
        ls_final-vbeln = ls_vbak-vbeln.
          ls_final-erdat = ls_vbak-erdat.
          ls_final-vkorg = ls_vbak-vkorg.
          ls_final-vtweg = ls_vbak-vtweg.
          ls_final-spart = ls_vbak-spart.
          ls_final-netwr_a = ls_vbak-netwr_a.
          ls_final-waerk_a = ls_vbak-waerk_a.
  
  
       LOOP AT ut_vbap INTO ls_vbap WHERE vbeln = ls_vbak-vbeln.
          ls_final-posnr = ls_vbap-posnr.
          ls_final-matnr = ls_vbap-matnr.
          ls_final-charg = ls_vbap-charg.
          ls_final-kunnr_ana = ls_vbap-kunnr_ana.
  
          READ TABLE ut_makt INTO ls_makt WITH KEY matnr = ls_vbap-matnr.
          IF sy-subrc = 0.
            ls_final-maktx = ls_makt-maktx.
            ENDIF.
  
           READ TABLE ut_kna1 INTO ls_kna1 WITH KEY kunnr = ls_vbap-kunnr_ana.
          IF sy-subrc = 0.
            ls_final-name1 = ls_kna1-name1.
            CONCATENATE ls_kna1-stras ls_kna1-pstlz ls_kna1-ort01 ls_kna1-land1
            INTO ls_final-adresse SEPARATED BY space.
  
            APPEND ls_final TO gt_final.
            ENDIF.
  
  
  
  
  
    ENDLOOP.
  ENDLOOP.
  
  *
  *  DATA : sfinal LIKE LINE OF gt_final.
  *  LOOP AT ut_vbak INTO ls_vbak.
  *    LOOP AT ut_vbap INTO ls_vbap.
  **      LOOP AT gt_final ASSIGNING FIELD-SYMBOL(<fs_makt>).
  ***        LOOP AT gt_final ASSIGNING FIELD-SYMBOL(<fs_kna1>).
  **        CLEAR zsfinal.
  *      READ TABLE ut_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>) WITH KEY vbeln = <fs_vbak>-vbeln.
  *      READ TABLE ut_makt ASSIGNING FIELD-SYMBOL(<fs_makt>) WITH KEY posnr = <fs_vbap>-posnr.
  *      READ TABLE ut_kna1 ASSIGNING FIELD-SYMBOL(<fs_kna1>) WITH KEY matnr = <fs_makt>-matnr.
  **          READ TABLE ut_kna1 ASSIGNING FIELD-SYMBOL(<fs_kna1>) WITH KEY kunnr = <fs_kna1>-kunnr.
  *      IF sy-subrc = 0.
  *        zsfinal-vbeln = <fs_vbak>-vbeln.
  *        zsfinal-erdat = <fs_vbak>-erdat.
  *        zsfinal-vkorg = <fs_vbak>-vkorg.
  *        zsfinal-vtweg = <fs_vbak>-vtweg.
  *        zsfinal-spart = <fs_vbak>-spart.
  *        zsfinal-netwr_a = <fs_vbak>-netwr_a.
  *        zsfinal-waerk_a = <fs_vbak>-waerk_a.
  *        zsfinal-posnr = <fs_vbap>-psnr.
  *        zsfinal-mtnr = <fs_vbap>-matnr.
  *        zsfinal-charg = <fs_vbap>-charg.
  *        zsfinal-kunnr_ana = <fs_vbap>-kunnr_ana.
  *        zsfinal-netwr_b = <fs_vbakp>-netwr_b.
  *        zsfinal-waerk_b = <fs_vbap>-waerk_b.
  *        zsfinal-maktx = <fs_makt>-maktx.
  *        zsfinal-name1 = <fs_kna1t>-name1.
  *        CONCATENATE stras pstlz ort01 land1 INTO zadresse SEPARATED BY space.
  *
  *        APPEND zsfinal TO gt_final.
  *      ENDIF.
  *
  *    ENDLOOP.
  *  ENDLOOP.
  *ENDLOOP.
  *ENDLOOP.
  
  ENDFORM.