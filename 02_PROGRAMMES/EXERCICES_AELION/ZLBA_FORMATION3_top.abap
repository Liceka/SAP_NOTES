*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION3_TOP
*&---------------------------------------------------------------------*



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