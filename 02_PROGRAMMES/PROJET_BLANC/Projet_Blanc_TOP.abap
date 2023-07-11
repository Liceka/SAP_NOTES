*&---------------------------------------------------------------------*
*& Include          ZLBA_PROJECT_BLANC_TOP
*&---------------------------------------------------------------------*
*& Date Création / Auteur / Motif
*& 24.04.2023 / LBA (Aelion) / Création progamme PROJET ABAP
*&---------------------------------------------------------------------*


* On déclare le type de table pour pouvoir récupérer les informations du fichier dans la table
TYPES: BEGIN OF ts_line,
         line TYPE string,
       END OF ts_line.

TYPES: BEGIN OF ty_data,
         id_com        TYPE zid_com_po,
         doc_type      TYPE vbak-auart,
         sales_org     TYPE  vbak-vkorg,
         distr_chan    TYPE vbak-vtweg,
         sect_act      TYPE  vbak-spart,
         partn_role_ag TYPE parvw,
         partn_numb_ag TYPE vbak-kunnr,
         partn_role_we TYPE  parvw,
         partn_numb_we TYPE vbak-kunnr,
         itm_numb      TYPE  vbap-posnr,
         material      TYPE  vbap-matnr,
         plant         TYPE  vbap-werks,
         quantity      TYPE  vbap-zmeng,
         quantity_unit TYPE  vbap-zieme,

       END OF ty_data.


DATA : gt_file TYPE STANDARD TABLE OF ts_line,
       gt_data TYPE TABLE OF ty_data.