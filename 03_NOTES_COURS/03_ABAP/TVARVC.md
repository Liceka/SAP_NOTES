# TVARVC

On a ajouté dans la table TVARVC qui se trouve dans la transaction STVARV les différentes options de sélection.

- STVARV
- Options sélection
- Gestion individuelle
- Nom de variable
- Option ( = ou > ou < ...)
- Selection multiples : mettre les valeurs concernées

[Contenu table TVARVC](https://drive.google.com/file/d/1n6wQLcOZ6t3lzjAM2vZC1jrKyEypQbQW/view?usp=share_link)

Dans le code :

1. Récupération des types de commandes autorisés pour la création des commandes de vente
  SELECT  * FROM tvarvc
  INTO TABLE lt_tvarvc
  WHERE name = 'ZPROJ_CV_AUART'
  AND   type = 'S'.
  IF sy-subrc = 0.

2. On construit un range à partir de cette liste
    LOOP AT lt_tvarvc ASSIGNING FIELD-SYMBOL(<fs_tvarvc>).
      ls_auart-sign   = <fs_tvarvc>-sign.
      ls_auart-option = <fs_tvarvc>-opti.
      ls_auart-low    = <fs_tvarvc>-low.
      APPEND ls_auart TO lr_auart.
    ENDLOOP.
  ENDIF.

3. Ensuite, dans le LOOP, on vérifie la condition :

   CHECK <fs_data>-doc_type IN lr_auart.

   

**Exemple ci-dessous dans le projet intermediaire :**

Un contrôle doit être effectué sur le contenu du fichier afin de ne créer que les commandes ayant un ‘Type de doc. Vente’ autorisés (cette liste de types de commande autorisés devra être paramétrée via une variable dans la table TVARVC créée par vos soins : ZCS, JRE, JREW, ZPSO, JOR)

```ABAP

DATA:   lr_auart      TYPE RANGE OF auart,
        ls_auart      LIKE LINE OF lr_auart,
        lt_tvarvc     TYPE STANDARD TABLE OF tvarvc.


* Récupération des types de commandes autorisés pour la création des commandes de vente
  SELECT  * FROM tvarvc
  INTO TABLE lt_tvarvc
  WHERE name = 'ZPROJ_CV_AUART'
  AND   type = 'S'.
  IF sy-subrc = 0.
* On construit un range à partir de cette liste
    LOOP AT lt_tvarvc ASSIGNING FIELD-SYMBOL(<fs_tvarvc>).
      ls_auart-sign   = <fs_tvarvc>-sign.
      ls_auart-option = <fs_tvarvc>-opti.
      ls_auart-low    = <fs_tvarvc>-low.
      APPEND ls_auart TO lr_auart.
    ENDLOOP.
  ENDIF.

  LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
    CLEAR : ls_header, ls_headerx, ls_partner, lt_partner , lt_item, lt_itemx, lt_return, lv_vbeln, ls_msg.

    IF <fs_data>-id_com = lv_id_com.
      CONTINUE.
    ENDIF.

    lv_id_com = <fs_data>-id_com.
    CHECK <fs_data>-doc_type IN lr_auart.


    ls_header-doc_type = <fs_data>-doc_type.
    ls_header-sales_org = <fs_data>-sales_org.
    ls_header-distr_chan = <fs_data>-distr_chan.
    ls_header-division = <fs_data>-sect_act.
    ls_header-req_date_h = sy-datum + 5.

    ls_headerx-doc_type = 'X'.
    ls_headerx-sales_org =  'X'.
    ls_headerx-distr_chan =  'X'.
    ls_headerx-division =  'X'.
    ls_headerx-req_date_h = 'X'.
    ls_headerx-updateflag = 'I'.

    ls_partner-partn_numb = <fs_data>-partn_numb_ag.
    ls_partner-partn_role = <fs_data>-partn_role_ag.

    APPEND ls_partner TO lt_partner.

    ls_partner-partn_numb = <fs_data>-partn_numb_we.
    ls_partner-partn_role = <fs_data>-partn_role_we.

    APPEND ls_partner TO lt_partner.

    LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data2>)
      WHERE id_com = <fs_data>-id_com.
      ls_item-itm_number = <fs_data2>-itm_numb.
      ls_item-material = <fs_data2>-material.
      ls_item-plant = <fs_data2>-plant.
      ls_item-target_qty =  <fs_data2>-quantity.

      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
        EXPORTING
          input          = <fs_data2>-quantity_unit
          language       = sy-langu
        IMPORTING
          output         = <fs_data2>-quantity_unit
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.

        ls_item-target_qu = <fs_data2>-quantity_unit.

        APPEND ls_item TO lt_item.

        ls_itemx-itm_number = 'X'.
        ls_itemx-material = 'X'.
        ls_itemx-plant = 'X'.
        ls_itemx-target_qty =  'X'.
        ls_itemx-target_qu = 'X'.
        ls_itemx-updateflag = 'I'.

        APPEND ls_itemx TO lt_itemx.

      ENDLOOP.
```