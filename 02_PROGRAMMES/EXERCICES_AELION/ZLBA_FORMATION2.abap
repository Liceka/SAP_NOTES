*&---------------------------------------------------------------------*
*& Report ZLBA_FORMATION1
*&---------------------------------------------------------------------*
*& Date Création / Auteur / Motif
*& 22.02.2023 / LBA / Exercice ABAP
*&---------------------------------------------------------------------*
REPORT zlba_formation2.

*------------Révision de toutes les notions abordées------------

*1/ L'Utilisateur final souhaite disposer d'un report lui permettant
* d'afficher les informations des commandes d'achats
* Ci-dessous, la liste des champs à afficher :
* EBELN  : EKPO Document achat
* EBELP  : EKPO Poste
* BUKRS  : EKPO Société
* BSTYP  : EKPO Catégorie doc.
* MATNR : EKPO numéro article
* MENGE : EKPO Quantité de commande
* MEINS : EKPO Unité d'achat
* VOLUM : EKPO Volume
* VOLEH : EKPO Unité de volume
* BSART : EKKO Type document
* LIFNR : EKKO Fournisseur
* EKORG : EKKO Organis. achats


*2/ L'utilisateur souhaite pouvoir "filtrer" cette sélection de données
* en fonction du n° commande d'achat / de l'article / de la société
* Il indique que le critère "société" doit être un critère obligatoire
* et que sa valeur par défaut sera "0001'.

*3/ L'utilisateur souhaite également disposer d'une case à cocher lui
* permettant d'afficher ou non le volume de l'article

*4/ L'utilisateur précise enfin qu'il a besoin de messages d'information
* dans l'éventualité où il renseignerait une société qui n'existe pas.
* et dans l'éventualité où aucune information ne serait récupérée.

TABLES : ekpo, ekko.
SELECT-OPTIONS : s_ebeln FOR ekpo-ebeln.
SELECT-OPTIONS : s_matnr FOR ekpo-matnr.
SELECT-OPTIONS : s_bukrs FOR ekpo-bukrs. "OBLIGATORY.
PARAMETERS : p_vol AS CHECKBOX.
PARAMETERS : p_prog1 RADIOBUTTON GROUP b1,
             p_prog2 RADIOBUTTON GROUP b1.

DATA : lo_alv TYPE REF TO cl_salv_table.

IF p_prog1 IS NOT INITIAL. "on peut aussi mettres is p_prog1 = abap_true
  IF p_vol IS NOT INITIAL. "is not initial veut dire que c'est coché

    SELECT ekpo~ebeln, ekpo~ebelp, ekpo~bukrs, ekpo~bstyp, ekpo~matnr, ekpo~menge, ekpo~meins, ekpo~volum, ekpo~voleh, ekko~bsart, ekko~lifnr, ekko~ekorg
      FROM ekpo
      INNER JOIN ekko ON ekko~ebeln = ekpo~ebeln
      INTO TABLE @DATA(lt_final)
      WHERE ekpo~ebeln IN @s_ebeln
      AND ekpo~matnr IN @s_matnr
      AND ekpo~bukrs IN @s_bukrs.

  ELSE.
    SELECT ekpo~ebeln, ekpo~ebelp, ekpo~bukrs, ekpo~bstyp, ekpo~matnr, ekpo~menge, ekpo~meins, ekpo~voleh, ekko~bsart, ekko~lifnr, ekko~ekorg
  FROM ekpo
  INNER JOIN ekko ON ekko~ebeln = ekpo~ebeln
  INTO TABLE @DATA(lt_final2)
  WHERE ekpo~ebeln IN @s_ebeln
  AND ekpo~matnr IN @s_matnr
  AND ekpo~bukrs IN @s_bukrs.

  ENDIF.

  IF sy-subrc = 0. "j'ai trouvé les articles
    MESSAGE TEXT-001 TYPE 'S'. " le S veut dire Succes
  ELSE.
    MESSAGE TEXT-002 TYPE 'I'. "je n'ai pas trouvé les articles type 'E' veut dire Erreur donc le programme s'arrête
  ENDIF.




  IF p_vol IS NOT INITIAL.
    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = lt_final.

    CALL METHOD lo_alv->display.

  ELSE.

    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = lt_final2.

    CALL METHOD lo_alv->display.

  ENDIF.

ELSE.
*information de livraison (numéro de livraison) suite à la commande d'achat

  IF p_vol IS NOT INITIAL. "is not initial veut dire que c'est coché

    SELECT ekpo~ebeln, ekpo~ebelp, ekpo~bukrs, ekpo~bstyp, ekpo~matnr, ekpo~menge, ekpo~meins, ekpo~volum, ekpo~voleh, ekko~bsart, ekko~lifnr, ekko~ekorg, ekes~vbeln
      FROM ekpo
      INNER JOIN ekko ON ekko~ebeln = ekpo~ebeln
      INNER JOIN ekes ON ekpo~ebelp = ekes~ebelp
      INTO TABLE @DATA(lt_final3)
      WHERE ekpo~ebeln IN @s_ebeln
      AND ekpo~matnr IN @s_matnr
      AND ekpo~bukrs IN @s_bukrs.

    DATA : ls_commande LIKE LINE OF lt_final3.
    ls_commande-ebeln = '45000000501'.
    ls_commande-ebelp = '00041'.
    ls_commande-bukrs = '1010'.
    ls_commande-bstyp = 'F'.
    ls_commande-matnr = 'TROTINETTE'.
    ls_commande-menge = '1000'.
    ls_commande-meins = 'ST'.
    ls_commande-volum = '0.000'.
    ls_commande-voleh = 'G'.
    ls_commande-bsart = 'NB'.
    ls_commande-lifnr = '0000100110'.
    ls_commande-ekorg = '2020'.
    ls_commande-vbeln = '0180000003'.
    APPEND ls_commande TO lt_final3.

    ls_commande-ebeln = '45000000501'.
    ls_commande-ebelp = '00041'.
    ls_commande-bukrs = '1010'.
    ls_commande-bstyp = 'F'.
    ls_commande-matnr = 'DRAISIENNE'.
    ls_commande-menge = '1000'.
    ls_commande-meins = 'ST'.
    ls_commande-volum = '0.000'.
    ls_commande-voleh = 'G'.
    ls_commande-bsart = 'NB'.
    ls_commande-lifnr = '0000100110'.
    ls_commande-ekorg = '2020'.
    ls_commande-vbeln = '0180000003'.
    MODIFY lt_final3 FROM ls_commande TRANSPORTING matnr WHERE ebeln = '4500000501'.


  ELSE.
    SELECT ekpo~ebeln, ekpo~ebelp, ekpo~bukrs, ekpo~bstyp, ekpo~matnr, ekpo~menge, ekpo~meins, ekpo~voleh, ekko~bsart, ekko~lifnr, ekko~ekorg, ekes~vbeln
  FROM ekpo
  INNER JOIN ekko ON ekko~ebeln = ekpo~ebeln
  INNER JOIN ekes ON ekpo~ebelp = ekes~ebelp
  INTO TABLE @DATA(lt_final4)
  WHERE ekpo~ebeln IN @s_ebeln
  AND ekpo~matnr IN @s_matnr
  AND ekpo~bukrs IN @s_bukrs.

  ENDIF.

  IF sy-subrc = 0. "j'ai trouvé les articles
    MESSAGE TEXT-001 TYPE 'S'. " le S veut dire Succes
  ELSE.
    MESSAGE TEXT-002 TYPE 'I'. "je n'ai pas trouvé les articles type 'E' veut dire Erreur donc le programme s'arrête
  ENDIF.



  IF p_vol IS NOT INITIAL.
    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = lt_final3.

    CALL METHOD lo_alv->display.

  ELSE.

    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = lt_final4.

    CALL METHOD lo_alv->display.

  ENDIF.


ENDIF.
*
*LOOP AT lt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>).
*  <fs_mara>-ntgew = '200'.
* ENDLOOP.

*INSERT
*APPEND
*MODIFY
*DELETE