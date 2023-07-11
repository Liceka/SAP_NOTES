*&---------------------------------------------------------------------*
*& Include          ZJLMF_PROJECT_01_TOP
*&---------------------------------------------------------------------*

TABLES: vbak, vbap.

TYPES: BEGIN OF ty_fileline,
         fileline TYPE string,
       END OF ty_fileline.

DATA: gt_line   TYPE TABLE OF ty_fileline,
      gt_file   TYPE TABLE OF zsjlmf_file_01,
      gt_return TYPE TABLE OF bapiret2.


TYPES : BEGIN OF ty_final,
          vbeln    TYPE vbak-vbeln,      " Numéro de la commande de vente
          auart    TYPE vbak-auart,      " Type de doc. De vente
          erdat    TYPE vbak-erdat,      " Date de création de la commande
          erzet    TYPE vbak-erzet,      " Heure de création
          vdatu    TYPE vbak-vdatu,      " Date de livraison souhaitée
          vkorg    TYPE vbak-vkorg,      " Organisation commerciale
          vtweg    TYPE vbak-vtweg,      " Canal de distribution
          spart    TYPE vbak-spart,      " Secteur d’activité
          kunnr    TYPE vbap-kunnr_ana,  " Client donneur d’ordre
          name1    TYPE kna1-name1,      " Nom du donneur d’ordre
          kunwe    TYPE vbap-kunwe_ana,  " Client réceptionnaire
          name2    TYPE kna1-name2,      " Nom du client réceptionnaire
          address  TYPE String,          " KNA1 - Adresse du client réceptionnaire (Code postal + Ville + Pays)
          posnr    TYPE vbap-posnr,      " Numéro de poste Com.
          matnr    TYPE vbap-matnr,      " Article
          maktx    TYPE makt-maktx,      " Désignation article
          werks    TYPE vbap-werks,      " Division
          po_quant TYPE vbap-zmeng,      " Quantité commandée
          po_unit  TYPE vbap-zieme,      " Unité de quantité
          ntgew    TYPE mara-ntgew,      " Poids net de l’article
          gewei    TYPE mara-gewei,      " Unité de poids
          pt_post  TYPE vbap-zmeng,      " Poids total du poste
          pt_comm  TYPE vbap-zmeng,      " Poids total de la commande
          check    TYPE xfeld,           " Case pour pouvoir cliquer dans l'ALV pour sélectionner la ligne à imprimer
        END OF ty_final.

DATA : t_ty_final TYPE TABLE OF ty_final.

DATA: number1(4) TYPE n VALUE '9001',
      number2(4) TYPE n VALUE '9002'.

DATA : bdctab TYPE STANDARD TABLE OF bdcdata WITH HEADER LINE.

DATA : go_custom_container TYPE REF TO cl_gui_custom_container,
       go_alv_functions    TYPE REF TO cl_salv_functions,
       gt_alv              TYPE STANDARD TABLE OF vbap,
       go_alv_grid         TYPE REF TO cl_gui_alv_grid,
       go_message          TYPE REF TO cx_salv_msg,
       go_columns       TYPE REF TO cl_salv_columns_table,
       go_column       TYPE REF TO cl_salv_column_table,
       gr_events        TYPE REF TO cl_salv_events_table,
       go_events      TYPE REF TO ycl_event.