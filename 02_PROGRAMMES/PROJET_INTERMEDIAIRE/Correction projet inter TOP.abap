
*&---------------------------------------------------------------------*
*& Include          ZPROJ_INTER_2023_TOP
*&---------------------------------------------------------------------*

TABLES : vbak, vbap.

* Typage de la table interne qui va servir à récupérer le contenu du fichier CSV
TYPES:
  BEGIN OF ts_line,
    line TYPE string,
  END OF ts_line,
  tt_line TYPE STANDARD TABLE OF ts_line.

* Typage de la table interne qui servira à stocker les données des Commandes de vente à créer
TYPES : BEGIN OF ty_data,
          id_com        TYPE zid_com_po,
          doc_type      TYPE vbak-auart,
          sales_org     TYPE vbak-vkorg,
          distr_chan    TYPE vbak-vtweg,
          sect_act      TYPE vbak-spart,
          partn_role_ag TYPE parvw,
          partn_numb_ag TYPE vbak-kunnr,
          partn_role_we TYPE parvw,
          partn_numb_we TYPE vbak-kunnr,
          itm_numb      TYPE vbap-posnr,
          material      TYPE vbap-matnr,
          plant         TYPE vbap-werks,
          quantity      TYPE vbap-zmeng,
          quantity_unit TYPE vbap-zieme,
        END OF ty_data.

* Typage de la table qui servira à afficher les commandes de vente créées
TYPES : BEGIN OF ty_cv,
          vbeln     TYPE vbak-vbeln,       " N° de commande de vente
          auart     TYPE vbak-auart,       " Type de commande
          erdat     TYPE vbak-erdat,       " Date de création de la commande
          erzet     TYPE vbak-erzet,       " Heure de création de la commande
          vdatu     TYPE vbak-vdatu,       " Date de livraison souhaitée
          vkorg     TYPE vbak-vkorg,       " Organisation commerciale
          vtweg     TYPE vbak-vtweg,       " Canal de distribution
          spart     TYPE vbak-spart,       " Secteur d'activité
          kunnr_ana TYPE vbap-kunnr_ana,   " N°Client donneur d'ordre
          name1     TYPE kna1-name1,       " Nom du donneur d'ordre
          kunwe_ana TYPE vbap-kunwe_ana,   " N° Client réceptionnaire
          name2     TYPE kna1-name1,       " Nom du réceptionnaire
          adress    TYPE string,           " Adresse du réceptionnaire : Code postal + Ville + Pays
          posnr     TYPE vbap-posnr,       " N° de Poste de la commande
          matnr     TYPE vbap-matnr,       " N° Article
          maktx     TYPE makt-maktx,       " Description de l'article (Dans la langue de connexion du client)
          werks     TYPE vbap-werks,       " Division
          zmeng     TYPE vbap-zmeng,       " Quantité commande de vente
          zieme     TYPE vbap-zieme,       " unité de quantité
          ntgew     TYPE mara-ntgew,       " poids net de l'article
          gewei     TYPE mara-gewei,       " unité de poids
          pds_post  TYPE mara-ntgew,       " poids total du poste
          pds_tot   TYPE mara-ntgew,       " poids total de la commande
        END OF ty_cv.

* Déclaration des tables internes

DATA : gt_file TYPE tt_line,
       gt_data TYPE STANDARD TABLE OF ty_data,
       gt_cv   TYPE STANDARD TABLE OF ty_cv,
       gt_alv  TYPE STANDARD TABLE OF vbap.
