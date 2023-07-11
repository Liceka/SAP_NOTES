*&---------------------------------------------------------------------*
*&  Include           Z_EXO_LBA_TOP
*&---------------------------------------------------------------------*

TYPES : BEGIN OF ty_bkpf,

bukrs  TYPE bkpf-bukrs, "Company Code
belnr  TYPE bkpf-belnr, "Document Number
gjahr  TYPE bkpf-gjahr, "Fiscal Year
bldat  TYPE bkpf-bldat, "Document Date
awtyp  TYPE bkpf-awtyp, "Ref. Transactn
awkey  TYPE bkpf-awkey, "Reference company code
awkey2 TYPE bkpf-awkey, "Reference Document Number
awkey3 TYPE bkpf-awkey, "Reference Fiscal Year
awkey4 TYPE bkpf-awkey, "Reference Facture
usnam  TYPE bkpf-usnam, "Créateur pièce réf OU VBRK-ERNAM
waers  TYPE bkpf-waers, "Currency

END OF ty_bkpf.

TYPES :       BEGIN OF ty_bseg,

      bukrs TYPE bseg-bukrs, "Company Code
      belnr TYPE bseg-belnr, "Document Number
      gjahr TYPE bseg-gjahr, "Fiscal Year
      buzei TYPE bseg-buzei, "Line item
      bschl TYPE bseg-bschl, "Posting key
      koart TYPE bseg-koart, "Account Type
      wrbtr TYPE bseg-wrbtr, "Amount


    END OF ty_bseg.

TYPES : BEGIN OF ty_final,

bukrs  TYPE bkpf-bukrs, "Company Code
belnr  TYPE bkpf-belnr, "Document Number
gjahr  TYPE bkpf-gjahr, "Fiscal Year
bldat  TYPE bkpf-bldat, "Document Date
awtyp  TYPE bkpf-awtyp, "Ref. Transactn
awkey  TYPE bkpf-awkey, "Reference company code
awkey2 TYPE bkpf-awkey, "Reference Document Number
awkey3 TYPE bkpf-awkey, "Reference Fiscal Year
awkey4 TYPE bkpf-awkey, "Reference Facture
usnam  TYPE bkpf-usnam, "Créateur pièce réf OU VBRK-ERNAM
buzei  TYPE bseg-buzei, "Line item
bschl  TYPE bseg-bschl, "Posting key
koart  TYPE bseg-koart, "Account Type
waers  TYPE bkpf-waers, "Currency
wrbtr  TYPE bseg-wrbtr, "Amount


END OF ty_final.


TYPES: BEGIN OF ty_bkpf_key,
belnr TYPE bkpf-belnr,
bukrs TYPE bkpf-bukrs,
gjahr TYPE bkpf-gjahr,
END OF ty_bkpf_key.

TYPES: BEGIN OF ty_vbrk_key,
vbeln TYPE vbrk-vbeln,
END OF ty_vbrk_key.



DATA : gt_bkpf TYPE TABLE OF ty_bkpf,
gs_bkpf LIKE LINE OF gt_bkpf,
gt_bseg TYPE TABLE OF ty_bseg,
gs_bseg LIKE LINE OF gt_bseg.


DATA : gt_bkpf_key TYPE TABLE OF ty_bkpf_key,
gs_bkpf_key LIKE LINE OF gt_bkpf_key,
gt_vbrk_key TYPE TABLE OF ty_vbrk_key,
gs_vbrk_key LIKE LINE OF gt_vbrk_key.


DATA : gt_final TYPE TABLE OF ty_final,
gs_final LIKE LINE OF gt_final.