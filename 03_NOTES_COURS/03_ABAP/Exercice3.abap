*1) Dans la partie principale, on met dans l'ordre dans lequel le code va être lu.
*En incluant chaque tiroir créé.

REPORT zlba_formation3.

INCLUDE zlba_formation3_top. "Déclaration de mes variables globales
INCLUDE zlba_formation3_scr. "SCREEN Déclaration de notre écran de sélection
INCLUDE zlba_formation3_f01. "Traitements effectués sur les données (sélection de données, affichage des données...)

START-OF-SELECTION.

PERFORM select_data.

END-OF-SELECTION.


*2) Faire l'affichage dans SCREAN : 
*ex :

SELECT-OPTIONS : s_vbeln FOR vbak-vbeln OBLIGATORY.
SELECT-OPTIONS : s_matnr FOR vbap-matnr.
SELECT-OPTIONS : s_charg FOR vbap-charg.
SELECT-OPTIONS : s_kunnr FOR vbap-kunnr_ana.

PARAMETERS : p_for AS CHECKBOX.

*On met des select-option quand on veut un choix multiple dans l'affichage client.
*Quand on met un PARAMETERS, on ne peut mettre qu'une seule valeur et si le client ne met aucune valeur, 
*il va chercher dans la table une valeur vide. On peut sinon mettre un select-option pour que quand c'est vide, ça lit toutes les lignes.

*3) Remplir le top pour faire les déclarations globales 

*On va créer le squelette du tableau afin de pouvoir ensuite recueillir les données dans F01
*Ex :

DATA : gt_final TYPE ztfinal.
*   On peut aussi déclarer :    gt_final TYPE TABLE OF zsfinal.

TABLES : vbak, vbap, kna1.


TYPES : BEGIN OF ty_vbak,
          vbeln   TYPE vbak-vbeln,
          erdat   TYPE vbak-erdat,
          vkorg   TYPE vbak-vkorg,
          vtweg   TYPE vbak-vtweg,
          spart   TYPE vbak-spart,
          netwr_a TYPE vbak-netwr,
          waerk_a TYPE vbak-waerk,
        END OF ty_vbak,
        ty_t_vbak type table of ty_vbak,

        BEGIN OF ty_vbap,
          vbeln     TYPE vbap-vbeln,
          posnr     TYPE vbap-posnr,
          matnr     TYPE vbap-matnr,
          charg     TYPE vbap-charg,
          kunnr_ana TYPE vbap-kunnr_ana,
          netwr_b   TYPE vbap-netwr,
          waerk_b   TYPE vbap-waerk,
        END OF ty_vbap,
        ty_t_vbap type table of ty_vbap,

        BEGIN OF ty_makt,
          matnr TYPE makt-matnr,
          maktx TYPE makt-maktx,
        END OF ty_makt,
        ty_t_makt type table of ty_makt,

        BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
          stras TYPE kna1-stras,
          pstlz TYPE kna1-pstlz,
          ort01 TYPE kna1-ort01,
          land1 TYPE kna1-land1,
        END OF ty_kna1,
        ty_t_kna1 type table of ty_kna1.

*Dans le F01 :

        FORM select_data .

              DATA : lt_vbak TYPE TABLE OF ty_vbak,
                     lt_vbap TYPE TABLE OF ty_vbap,
                     lt_makt TYPE TABLE OF ty_makt,
                     lt_kna1 TYPE TABLE OF ty_kna1.
            *         ls_vbak TYPE ty_vbak,
            *         ls_vbap TYPE ty_vbap,
            *         ls_makt TYPE ty_makt,
            *         ls_kna1 TYPE ty_kna1.
            
            
            
              SELECT vbeln erdat vkorg vtweg spart netwr waerk
                FROM vbak
                INTO TABLE lt_vbak
                WHERE vbeln IN s_vbeln.
            
              SELECT vbeln posnr matnr charg kunnr_ana netwr waerk
                FROM vbap
                INTO TABLE lt_vbap
                FOR ALL ENTRIES IN lt_vbak
                WHERE vbeln = lt_vbak-vbeln
                AND matnr IN s_matnr
                AND charg IN s_charg
                AND kunnr_ana IN s_kunnr.

              SELECT matnr maktx
                FROM makt
                INTO TABLE lt_makt
                FOR ALL ENTRIES IN lt_vbap
                WHERE matnr = lt_vbap-matnr.
            *   AND matnr IN s_matnr.
            
              SELECT kunnr name1 stras pstlz ort01 land1
                FROM kna1
                INTO TABLE lt_kna1
                FOR ALL ENTRIES IN lt_vbap
                WHERE kunnr = lt_vbap-kunnr_ana.
            
              PERFORM merge_data USING lt_vbak
                                       lt_vbap
                                       lt_makt
                                       lt_kna1.
            
            
            ENDFORM.
            
            *ENDFORM.
            **&---------------------------------------------------------------------*
            **& Form merge_data
            **&---------------------------------------------------------------------*
            **& text
            **&---------------------------------------------------------------------*
            **& -->  p1        text
            **& <--  p2        text
            **&---------------------------------------------------------------------*
            *FORM merge_data .
            
            FORM merge_data  USING    ut_vbak TYPE ty_t_vbak
                                      ut_vbap TYPE ty_t_vbap
                                      ut_makt TYPE ty_t_makt
                                      ut_kna1 TYPE ty_t_kna1.
            
              DATA : ls_final LIKE LINE OF gt_final,
                     ls_vbak  TYPE ty_vbak,
                     ls_vbap  TYPE ty_vbap,
                     ls_makt  TYPE ty_makt,
                     ls_kna1  TYPE ty_kna1.
            
              LOOP AT ut_vbak INTO ls_vbak.
                CLEAR ls_final.
                  ls_final-vbeln = ls_vbak-vbeln.
                    ls_final-erdat = ls_vbak-erdat.
                    ls_final-vkorg = ls_vbak-vkorg.
                    ls_final-vtweg = ls_vbak-vtweg.
                    ls_final-spart = ls_vbak-spart.
                    ls_final-netwr_a = ls_vbak-netwr_a.
                    ls_final-waerk_a = ls_vbak-waerk_a.
            
            
                 LOOP AT ut_vbap INTO ls_vbap WHERE vbeln = ls_vbak-vbeln.
                    ls_final-posnr = ls_vbap-posnr.
                    ls_final-matnr = ls_vbap-matnr.
                    ls_final-charg = ls_vbap-charg.
                    ls_final-kunnr_ana = ls_vbap-kunnr_ana.
            
                    READ TABLE ut_makt INTO ls_makt WITH KEY matnr = ls_vbap-matnr.
                    IF sy-subrc = 0.
                      ls_final-maktx = ls_makt-maktx.
                      ENDIF.
            
                     READ TABLE ut_kna1 INTO ls_kna1 WITH KEY kunnr = ls_vbap-kunnr_ana.
                    IF sy-subrc = 0.
                      ls_final-name1 = ls_kna1-name1.
                      CONCATENATE ls_kna1-stras ls_kna1-pstlz ls_kna1-ort01 ls_kna1-land1
                      INTO ls_final-adresse SEPARATED BY space.
            
                      APPEND ls_final TO gt_final.
                      ENDIF.
            
            
            
            
            
              ENDLOOP.
            ENDLOOP.
            
            *
            *  DATA : sfinal LIKE LINE OF gt_final.
            *  LOOP AT ut_vbak INTO ls_vbak.
            *    LOOP AT ut_vbap INTO ls_vbap.
            **      LOOP AT gt_final ASSIGNING FIELD-SYMBOL(<fs_makt>).
            ***        LOOP AT gt_final ASSIGNING FIELD-SYMBOL(<fs_kna1>).
            **        CLEAR zsfinal.
            *      READ TABLE ut_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>) WITH KEY vbeln = <fs_vbak>-vbeln.
            *      READ TABLE ut_makt ASSIGNING FIELD-SYMBOL(<fs_makt>) WITH KEY posnr = <fs_vbap>-posnr.
            *      READ TABLE ut_kna1 ASSIGNING FIELD-SYMBOL(<fs_kna1>) WITH KEY matnr = <fs_makt>-matnr.
            **          READ TABLE ut_kna1 ASSIGNING FIELD-SYMBOL(<fs_kna1>) WITH KEY kunnr = <fs_kna1>-kunnr.
            *      IF sy-subrc = 0.
            *        zsfinal-vbeln = <fs_vbak>-vbeln.
            *        zsfinal-erdat = <fs_vbak>-erdat.
            *        zsfinal-vkorg = <fs_vbak>-vkorg.
            *        zsfinal-vtweg = <fs_vbak>-vtweg.
            *        zsfinal-spart = <fs_vbak>-spart.
            *        zsfinal-netwr_a = <fs_vbak>-netwr_a.
            *        zsfinal-waerk_a = <fs_vbak>-waerk_a.
            *        zsfinal-posnr = <fs_vbap>-psnr.
            *        zsfinal-mtnr = <fs_vbap>-matnr.
            *        zsfinal-charg = <fs_vbap>-charg.
            *        zsfinal-kunnr_ana = <fs_vbap>-kunnr_ana.
            *        zsfinal-netwr_b = <fs_vbakp>-netwr_b.
            *        zsfinal-waerk_b = <fs_vbap>-waerk_b.
            *        zsfinal-maktx = <fs_makt>-maktx.
            *        zsfinal-name1 = <fs_kna1t>-name1.
            *        CONCATENATE stras pstlz ort01 land1 INTO zadresse SEPARATED BY space.
            *
            *        APPEND zsfinal TO gt_final.
            *      ENDIF.
            *
            *    ENDLOOP.
            *  ENDLOOP.
            *ENDLOOP.
            *ENDLOOP.
            
            ENDFORM.