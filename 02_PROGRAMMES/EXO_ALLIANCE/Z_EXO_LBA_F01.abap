*&---------------------------------------------------------------------*
*&  Include           Z_EXO_LBA_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_data .

    *On vide toutes les tables et les structures crées pour partir de zéro à chaque début de programme
      CLEAR : gt_bkpf, gs_bseg, gt_bseg, gs_bseg, gt_final, gs_final, gt_bkpf_key, gt_vbrk_key.
    
    
    *On sélectionne les données dans la table d''entête dans une table globale
      SELECT bukrs belnr gjahr bldat awtyp awkey awkey awkey awkey usnam waers
        FROM bkpf
        INTO TABLE gt_bkpf
        WHERE bkpf~bldat >= p_date
     "La sélection se fait sur une date égale ou supérieure à la date renseignée dans le Parameters
        AND bkpf~bukrs = p_comp
    *    AND bkpf~bukrs in p_comp "Au cas où on met un select option pour faire une recherche avec valeur vide
        AND bkpf~belnr IN s_numb
        AND ( bkpf~awtyp = 'VBRK' OR bkpf~awtyp = 'BKPF' ). "On filtre déjà dans le select les bonnes infos
    
      IF gt_bkpf IS NOT INITIAL. "Si on a trouvé des infos dans l'entête, on va chercher les postes, sinon ça sert à rien
    
        SELECT bukrs belnr gjahr buzei bschl koart wrbtr
          FROM bseg
          INTO TABLE gt_bseg
          FOR ALL ENTRIES IN gt_bkpf "A ne pas oublier car il faut faire la sélection sur toute les entrées trouvées dans ls select précédent
          WHERE bukrs = gt_bkpf-bukrs "On fait le lien avec les 3 clés pour insérer les valeurs dans la bonne ligne
          AND belnr = gt_bkpf-belnr
          AND gjahr = gt_bkpf-gjahr.
    
      ENDIF.
    
    
      SORT gt_bseg BY bukrs belnr gjahr." On trie la table des postes avec les clés
    
    *On filtre les comptes clients "D" .On ne filtre pas plus tôt car s'il y a 1 poste sur la commande
    *  où il y a "D" on doit aussi récupérer les autres
      LOOP AT gt_bseg INTO gs_bseg WHERE koart = 'D'.
    
    *On lit la table d''entête pour chaque poste où il y a D qu'on met dans la structure d'entête
        READ TABLE gt_bkpf INTO gs_bkpf WITH KEY belnr = gs_bseg-belnr bukrs = gs_bseg-bukrs gjahr = gs_bseg-gjahr .
    
    *On vide la strcture finale pour la remplir avec les nouvelles valeurs.
        CLEAR gs_final.
    
    
        gs_final-bukrs = gs_bkpf-bukrs.
        gs_final-belnr = gs_bkpf-belnr.
        gs_final-gjahr = gs_bkpf-gjahr.
        gs_final-bldat = gs_bkpf-bldat.
        gs_final-awtyp = gs_bkpf-awtyp.
        gs_final-waers = gs_bkpf-waers.
    
        CASE gs_bkpf-awtyp.
    
          WHEN 'BKPF'.
    *Si Awtyp= BKPF ca veut dire que c''est une pièce FI, AWKEY est la concaténation
    *des 3 références ci dessous qu''on sépare dans 3 colonnes
            gs_bkpf_key = gs_bkpf-awkey.
    * On récupère le Awkey dans une structure pour plus tard remplir le ESNAM/USNAM
    * Il va automatiquement séparer le EWKEY dans 3 cases de la structure car l''élément de donnée renseigne la longeur de chaque élément de la structure
            gs_final-awkey = gs_bkpf-awkey+10(4). "Reference company code
            gs_final-awkey2 = gs_bkpf-awkey2+0(10). "Reference Document Number
            gs_final-awkey3 = gs_bkpf-awkey3+14(4). "Reference Fiscal Year
    
    
            APPEND gs_bkpf_key TO gt_bkpf_key.
            CLEAR gs_bkpf_key.
    
          WHEN 'VBRK'.
    *Si Awtyp= VBRK ca veut dire que c''est une facture, AWKEY est la concaténation
    *des 3 références ci dessous qu''on sépare dans 3 colonnes
            gs_vbrk_key = gs_bkpf-awkey.
            gs_final-awkey4 = gs_bkpf-awkey4. "Reference Facture
    
    
            APPEND gs_vbrk_key TO gt_vbrk_key.
            CLEAR: gs_vbrk_key.
    
          WHEN OTHERS.
    * On ne rentre que les données où AWTYP = VBRK ou BKPF donc si c''est différent, sors de la loop.
            CONTINUE.
    
        ENDCASE.
    
    
        LOOP AT gt_bseg INTO gs_bseg WHERE belnr = gs_bseg-belnr AND bukrs = gs_bseg-bukrs AND gjahr = gs_bseg-gjahr.
    * On récupère les infos des posts en précisant les clés
          gs_final-buzei = gs_bseg-buzei.
          gs_final-bschl = gs_bseg-bschl.
          gs_final-koart = gs_bseg-koart.
          gs_final-wrbtr = gs_bseg-wrbtr.
    
    
          APPEND gs_final TO gt_final.
    
    
        ENDLOOP.
      ENDLOOP.
    
    *Si on a des valeurs dans la table, selectionne les données dans une autre table où on ajoute le nom du créateur
      IF gt_bkpf_key IS NOT INITIAL .
        SELECT belnr, bukrs, gjahr, usnam
           FROM bkpf
          INTO TABLE @DATA(gt_bkpf_name)
          FOR ALL ENTRIES IN @gt_bkpf_key
          WHERE bukrs = @gt_bkpf_key-bukrs
          AND belnr = @gt_bkpf_key-belnr
          AND gjahr = @gt_bkpf_key-gjahr.
    
        IF sy-subrc = 0.
          SORT gt_bkpf_name BY bukrs belnr gjahr. "On tri la table pour ensuite faire un BINARY SEARCH
        ENDIF.
    
      ENDIF.
    
    *Si on a des valeurs dans la table, selectionne les données dans une autre table où on ajoute le nom du créateur
      IF gt_vbrk_key IS NOT INITIAL .
        SELECT vbeln, ernam
           FROM vbrk
          INTO TABLE @DATA(gt_vbrk_name)
          FOR ALL ENTRIES IN @gt_vbrk_key
          WHERE vbeln = @gt_vbrk_key-vbeln.
    
        IF sy-subrc = 0.
          SORT gt_vbrk_name BY vbeln. "On tri la table pour ensuite faire un BINARY SEARCH
        ENDIF.
    
      ENDIF.
    
    
    * On va chercher le nom du créateur de commande par rapport à l'année de création qu'on a récupérer dans
    * la table bkpf-name ou vbrk-name, on fait le lien avec les clés
      LOOP AT gt_final ASSIGNING FIELD-SYMBOL(<lfs_final>).
        CASE <lfs_final>-awtyp.
          WHEN 'BKPF'.
            READ TABLE gt_bkpf_name ASSIGNING FIELD-SYMBOL(<lfs_bkpf_name>) WITH KEY belnr = <lfs_final>-awkey2
                                                                                   bukrs = <lfs_final>-awkey
                                                                                   gjahr = <lfs_final>-awkey3
                                                                                   BINARY SEARCH.
            IF sy-subrc = 0.
    
              <lfs_final>-usnam = <lfs_bkpf_name>-usnam.
    
            ENDIF.
    
    
          WHEN 'VBRK'.
            READ TABLE gt_vbrk_name ASSIGNING FIELD-SYMBOL(<lfs_vbrk_name>) WITH KEY vbeln = <lfs_final>-awkey4
                                                                                     BINARY SEARCH.
    
            IF sy-subrc = 0.
    
              <lfs_final>-usnam = <lfs_vbrk_name>-ernam.
    
            ENDIF.
    
          WHEN OTHERS.
            CONTINUE.
        ENDCASE.
      ENDLOOP.
    
    ENDFORM.
    *&---------------------------------------------------------------------*
    *&      Form  DISPLAY_DATA
    *&---------------------------------------------------------------------*
    *       text
    *----------------------------------------------------------------------*
    *  -->  p1        text
    *  <--  p2        text
    *----------------------------------------------------------------------*
    FORM display_data .
    
    
    
      DATA : lo_alv           TYPE REF TO cl_salv_table,
             lo_alv_functions TYPE REF TO cl_salv_functions,
             lo_columns       TYPE REF TO cl_salv_columns_table,
             lo_column        TYPE REF TO cl_salv_column_table.
    
      " ALV EVENTS pour le cliq sur l'export
      DATA: gr_events TYPE REF TO cl_salv_events_table,
            go_events TYPE REF TO lcl_class_handler.
    
      DATA color TYPE lvc_s_colo.
    
    
      TRY.
          cl_salv_table=>factory(
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = gt_final ).
    
    
    * Methode pour utiliser le nouveau statut GUI créé avec le bouton d''EXPORT
    * On a copié un STATUT GUI trouvé dans les exemples et ajouté le bouton au lieu de tout recréer.
          CALL METHOD lo_alv->set_screen_status
            EXPORTING
              report        = sy-repid
              pfstatus      = 'STATUT_GUI_ALV'
              set_functions = cl_salv_table=>c_functions_all.
    
    * Affiches toutes les fonctions
          lo_alv_functions = lo_alv->get_functions( ).
          lo_alv_functions->set_all( abap_true ).
    
    * Opitimise la largeur des colonnes
          lo_columns = lo_alv->get_columns( ).
          lo_columns->set_optimize( 'X' ).
    
    * Ajoute la couleur et change le nom de la colonne
          lo_column ?= lo_columns->get_column( 'BUKRS' ).
          color-col = 6. "Met la couleur rouge
          lo_column->set_color( color ).
          lo_column->set_short_text( 'CompCode' ).
          lo_column->set_medium_text( 'Company Code' ).
    *  lo_column->SET_OUTPUT_LENGTH( '12' ). "Pour définir une largeur de colonne si on fait pas OPTIMIZE
    
          lo_column ?= lo_columns->get_column( 'BELNR' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'DocNumber' ).
          lo_column->set_medium_text( 'Document Number' ).
    
          lo_column ?= lo_columns->get_column( 'GJAHR' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'FiscalYear' ).
          lo_column->set_medium_text( 'Fiscal Year' ).
    
          lo_column ?= lo_columns->get_column( 'BLDAT' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'DocDate' ).
          lo_column->set_medium_text( 'Document Date' ).
    
          lo_column ?= lo_columns->get_column( 'AWTYP' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'RefTrans' ).
          lo_column->set_medium_text( 'Ref.Transaction' ).
    
          lo_column ?= lo_columns->get_column( 'AWKEY' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'RefCompany' ).
          lo_column->set_medium_text( 'Ref.Company' ).
    
          lo_column ?= lo_columns->get_column( 'AWKEY2' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'RefDocNumb' ).
          lo_column->set_medium_text( 'Ref.Document Number' ).
    
          lo_column ?= lo_columns->get_column( 'AWKEY3' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'FiscYear' ).
          lo_column->set_medium_text( 'Ref.Fiscal Year' ).
    
          lo_column ?= lo_columns->get_column( 'AWKEY4' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'RefFact' ).
          lo_column->set_medium_text( 'Ref.Facture' ).
    
          lo_column ?= lo_columns->get_column( 'USNAM' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'CréaRef' ).
          lo_column->set_medium_text( 'Créateur Référence' ).
          lo_column->set_long_text( 'Créateur Référence' ).
    
          lo_column ?= lo_columns->get_column( 'BUZEI' ).
          color-col = 4. "A partir de là met la couleur bleur
          lo_column->set_color( color ).
          lo_column->set_short_text( 'LineItem' ).
          lo_column->set_medium_text( 'Line Item' ).
    
          lo_column ?= lo_columns->get_column( 'BSCHL' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'PostKey' ).
          lo_column->set_medium_text( 'Posting Key' ).
    
          lo_column ?= lo_columns->get_column( 'KOART' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'AccType' ).
          lo_column->set_medium_text( 'Account Type' ).
    
          lo_column ?= lo_columns->get_column( 'WAERS' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'Currency' ).
          lo_column->set_medium_text( 'Currency').
    
          lo_column ?= lo_columns->get_column( 'WRBTR' ).
          lo_column->set_color( color ).
          lo_column->set_short_text( 'Amount' ).
          lo_column->set_medium_text( 'Amount').
    
    * Evenement pour le cliq sur le nouveau bouton EXPORT
    * Voir l''include Z_EXO_LBA_LCL pour la DEFINITION et IMPEMENTATION de la classe
          gr_events = lo_alv->get_event( ).
          CREATE OBJECT go_events.
          SET HANDLER go_events->on_user_command FOR gr_events.
    
          lo_alv->display( ).
        CATCH cx_root.
          MESSAGE 'Error in Creating Table' TYPE 'E'.
      ENDTRY.
    
    ENDFORM.
    *&---------------------------------------------------------------------*
    *&      Form  EXPORT_ALV
    *&---------------------------------------------------------------------*
    *       text
    *----------------------------------------------------------------------*
    *      -->P_E_SALV_FUNCTION  text
    *      -->P_TEXT_I08  text
    *----------------------------------------------------------------------*
    FORM export_alv  USING i_function TYPE salv_de_function
                           i_text     TYPE string.
    * Le perform se trouve dans l''implémentation de la classe dans Z_EXO_LBA_LCL
      CASE i_function.
        WHEN 'EXPORT'. "Quand on clique sur EXPORT, enclanche le PERFORM ci-dessous
          PERFORM data_download.
      ENDCASE.
    
    ENDFORM.
    *&---------------------------------------------------------------------*
    *&      Form  DATA_DOWNLOAD
    *&---------------------------------------------------------------------*
    *       text
    *----------------------------------------------------------------------*
    *  -->  p1        text
    *  <--  p2        text
    *----------------------------------------------------------------------*
    FORM data_download .
    
      DATA: lv_filename TYPE string.
            lv_filename = p_file. "On récupère le chemin d'acces écris dans le parameter
    
      CALL FUNCTION 'GUI_DOWNLOAD' "Fonction pour exporter un fichier
        EXPORTING
          filename              = lv_filename
          filetype              = 'ASC'
          write_field_separator = ';'
        TABLES
          data_tab              = gt_final
        EXCEPTIONS
          OTHERS                = 1.
    
    
    ENDFORM.