*&---------------------------------------------------------------------*
*& Include          ZZ_DYNPRO_KDE_2_TOP
*&---------------------------------------------------------------------*

DATA : gv_vbeln TYPE vbak-vbeln.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          ernam TYPE vbak-ernam,
          erdat TYPE vbak-erdat,
          erzet TYPE vbak-erzet,
          auart TYPE vbak-auart,
        END OF ty_vbak,
        BEGIN OF ty_mara,
          matnr TYPE mara-matnr,
          maktx TYPE makt-maktx,
        END OF ty_mara.

DATA : gs_vbak         TYPE ty_vbak,
       gv_matnr        TYPE matnr,
       gv_matnr_intern TYPE boolean,
       gv_matnr_extern TYPE boolean,
       gv_list_matnr   TYPE matnr,
       gv_matnr_select TYPE matnr,
       gv_maktx_select TYPE makt-maktx,
       gt_mara         TYPE TABLE OF ty_mara,
       gv_modif        TYPE boolean.