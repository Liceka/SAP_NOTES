*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION4_TOP
*&---------------------------------------------------------------------*
DATA : gt_final2 TYPE ztfinal_2.
*   On peut aussi déclarer :    gt_final TYPE TABLE OF zsfinal.

TABLES : likp, lips, vbrk.

TYPES : BEGIN OF ty_likp,
          vbeln TYPE likp-vbeln,
          vstel TYPE likp-vstel,
          vkorg TYPE likp-vkorg,
          erdat TYPE likp-erdat,
        END OF ty_likp,
        ty_t_likp TYPE TABLE OF ty_likp.

TYPES : BEGIN OF ty_lips,
          vbeln TYPE lips-vbeln,
          posnr TYPE lips-posnr,
          matnr TYPE lips-matnr,
          werks TYPE lips-werks,
          lfimg TYPE lips-lfimg,
          meins TYPE lips-meins,
        END OF ty_lips,
        ty_t_lips TYPE TABLE OF ty_lips.

TYPES : BEGIN OF ty_vbrk,
          vbelnf TYPE vbrk-vbeln,
          fkart  TYPE vbrk-fkart,
          fkdat  TYPE vbrk-fkdat,
          waerk  TYPE vbrk-waerk,
        END OF ty_vbrk,
        ty_t_vbrk TYPE TABLE OF ty_vbrk.

TYPES : BEGIN OF ty_vbrp,
          vbelnf TYPE vbrp-vbeln,
          vgbel  TYPE vbrp-vgbel,
          vgpos  TYPE vbrp-vgpos,
          posnrf TYPE vbrp-posnr,
          fkimg  TYPE vbrp-fkimg,
          vrkme  TYPE vbrp-vrkme,
          ntgew  TYPE vbrp-ntgew,
          gewei  TYPE vbrp-gewei,
          netwr  TYPE vbrp-netwr,
        END OF ty_vbrp,
        ty_t_vbrp TYPE TABLE OF ty_vbrp.


TYPES : BEGIN OF ty_marc,
          matnr TYPE marc-matnr,
          werks TYPE marc-werks,
          ekgrp TYPE marc-ekgrp,
          lvorm TYPE marc-lvorm,
        END OF ty_marc,
        ty_t_marc TYPE TABLE OF ty_marc.





* 6/ Commentez tout votre code et déclarez un modèle permettant de récupérer dans la même table interne

*    la date de création de la facture
* le type de factture
*    + la totalité des champs de la VBRP