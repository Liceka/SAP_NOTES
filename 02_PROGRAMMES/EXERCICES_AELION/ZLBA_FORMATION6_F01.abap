*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION6_F01
*&---------------------------------------------------------------------*

*Programme qui permet de récupérer les commandes d'achat et les postes
*et d'afficher les numéros de commandes, numéro article, langues, désignation articlue
*sélection via un module fonction

*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select_data .
  * 1ère methode avec jointures :
  
  *  SELECT ekko~ebeln, ekko~aedat, makt~maktx, ekpo~* FROM ekko
  *      INNER JOIN ekpo ON ekpo~ebeln = ekko~ebeln
  *      INNER JOIN makt ON makt~matnr = ekpo~matnr
  *    INTO TABLE @gt_final
  *    WHERE ekko~ebeln IN @s_ebeln
  *      AND ekpo~matnr IN @s_matnr
  *    AND makt~spras = @p_spras.
  *
  ** 2eme methode : avec plusieurs select / FOR ALL ENTRIES
  *
  *  SELECT ebeln, aedat
  *    FROM ekko
  *    INTO TABLE @DATA(lt_ekko)
  *    WHERE ebeln IN @s_ebeln.
  *
  *  SELECT *
  *    FROM ekpo
  *    INTO TABLE @DATA(lt_ekpo)
  *    FOR ALL ENTRIES IN @lt_ekko
  *    WHERE ebeln = @lt_ekko-ebeln
  *    AND matnr IN @s_matnr.
  *
  **on doit rajouter le matnr dans le select pour faire le lien avec celui du dessus
  *  SELECT matnr, maktx
  *    FROM makt
  *    INTO TABLE @DATA(lt_makt)
  *    FOR ALL ENTRIES IN @lt_ekpo
  *    WHERE matnr = @lt_ekpo-matnr
  *    AND spras = @p_spras.
  *
  ** Cette 2eme methode nécessite de rassembler ensuite les données
  *  DATA : ls_final LIKE LINE OF gt_final.
  *
  *  LOOP AT lt_ekko INTO DATA(ls_ekko). "On ne met pas de @, c'est que pour les inner join
  *    ls_final-ebeln1 = ls_ekko-ebeln.
  *    ls_final-aedat1 = ls_ekko-aedat.
  *
  *    LOOP AT lt_ekpo INTO DATA(ls_ekpo)
  *      WHERE ebeln = ls_ekko-ebeln.
  *      MOVE-CORRESPONDING  ls_ekpo TO ls_final.
  *      "On va faire un read car on a récupété les élements des 2 clés donc on a forcément qu'1 ligne en retour.
  *      "QUand on fait un read, on doit vérifier qu'il a récupéré les infos avec sy-subrc
  *      READ TABLE lt_makt into data(ls_makt) WITH KEY matnr = ls_ekpo-matnr.
  *      IF sy-subrc = 0.
  *        ls_final-maktx = ls_makt-maktx.
  *        ENDIF.
  *       APPEND ls_final to gt_final.
  *
  *    ENDLOOP.
  *
  *    ENDLOOP.
  
  
  
  
  
  * DATA : lv_spras TYPE spras.
  *  lv_spras = 'F'.
  *  DATA : lt_maktx TYPE zty_t_makt.
  *  DATA : lt_mara TYPE ztmara.
  *
  *  SELECT matnr mtart brgew gewei FROM mara INTO TABLE lt_mara.
  *  IF sy-subrc = 0.
  *    CALL FUNCTION 'ZDES_MAT_KDE'
  *      EXPORTING
  *        i_spras  = lv_spras
  *        it_mara  = lt_mara
  *      IMPORTING
  *        et_maktx = lt_maktx.
  *
  *  ENDIF.
  
  * AVEC LE CALL FUNCTION
  
  CALL FUNCTION 'Z_LBA_COMM'
    EXPORTING
      i_ebeln        = s_ebeln[]
      i_matnr        = s_matnr[]
      i_spras        = p_spras
   IMPORTING
     ET_FINAL =       gt_final.
  
  
  DATA : lo_alv TYPE REF TO cl_salv_table.
  
  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = lo_alv
    CHANGING
      t_table      = gt_final.
  
  CALL METHOD lo_alv->display.
  
  ENDFORM.
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  **SELECT ekko~ebeln, ekpo~matnr, ekko~spras, ekpo~txz01
  **    FROM ekko
  **    INNER JOIN ekpo ON ekpo~ebeln = ekko~ebeln
  **  INTO TABLE @DATA(lt_comm).
  *
  *
  **SELECT * FROM ekko
  *
  *FORM select_data.
  ***
  *  DATA : lt_ekko TYPE TABLE OF zdmacommande,
  *         lt_ekpo TYPE TABLE OF zdmacommande.
  **         lt_spras TYPE ty_t_ekko,
  **         lt_txz01 TYPE ty_t_ekkpo.
  **
  *  SELECT ebeln aedat
  *         FROM ekko
  *         INTO TABLE lt_EKKO
  *         WHERE ebeln IN s_ebeln.
  *
  *  SELECT *
  *    FROM ekpo
  *    INTO TABLE lt_ekpo
  *    FOR ALL ENTRIES IN lt_ekko
  *    WHERE ebeln = lt_ekko-ebeln.
  *
  *  IF sy-subrc = 0.
  *    CALL FUNCTION 'Z_LBA_COMM'
  *      EXPORTING
  *        i_spras  = lv_spras
  *        it_mara  = lt_mara
  *      IMPORTING
  *        et_maktx = lt_maktx.
  *
  *
  ** IF sy-subrc = 0.
  **    CALL FUNCTION 'Z_LBA_COMM'
  **      EXPORTING
  **        i_ebeln  = lt_ebeln
  **        i_matnr   = lt_matnr
  **        i_spras   = lt_spras
  **        i_txz01   = lt_txz01
  **      IMPORTING
  **        et_maktx = lt_maktx.
  **
  **  ENDIF.
  *
  **  SELECT matnr mtart brgew gewei FROM mara INTO TABLE lt_mara.
  **  IF sy-subrc = 0.
  **    CALL FUNCTION 'ZDES_MAT_KDE'
  **      EXPORTING
  **        i_spras  = lv_spras
  **        it_mara  = lt_mara
  **      IMPORTING
  **        et_maktx = lt_maktx.
  **
  **  ENDIF.
  **
  *ENDFORM.
  **