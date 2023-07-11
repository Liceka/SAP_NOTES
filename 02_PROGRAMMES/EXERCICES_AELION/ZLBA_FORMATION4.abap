*&---------------------------------------------------------------------*
*& Report ZLBA_FORMATION4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlba_formation4.

INCLUDE zlba_formation4_top. "Déclaration de mes variables globales
INCLUDE zlba_formation4_scr. "SCREEN Déclaration de notre écran de sélection
INCLUDE zlba_formation4_f01. "Traitements effectués sur les données (sélection de données, affichage des données...)
*
*START-OF-SELECTION.
*
*  PERFORM select_data.
*
*  PERFORM display_data.
*
*end-OF-SELECTION.

"Introduction de la notion d'OFFSET (pour prélever des morceaux de valeur de la variable)

* 1/ Rajouter une colonne date du jour dans votre table

*  DATA : lv_date  TYPE dats,
*         lv_date2 TYPE STRING.
*
*  lv_date = sy-datum. "AAAAMMJJ  20230302
*
*
*  CONCATENATE lv_date+6(2) lv_date+4(2) lv_date(4) INTO lv_date2 SEPARATED BY '.'.
*
*  write : lv_date2.


*    Extraire le jour le mois et l'année de la variable système SY-DATUM
*    et l'afficher au format DD/MM/AAAA dans cette colonne pour chaque ligne de votre table finale

* 2/ Ajouter un message d'information / d'erreur / de succès après chaque instruction décisive
*     en utilisant les éléments de texte de votre programme

* 3/ Remplacer vos messages d'erreur par des messages provenant de la classe de message ZKDE_MESS

* 4/ Déconnectez vous de SAP puis reconnectez vous en anglais
*    Que constatez-vous lorsque vous lancez votre programme?

* 5/ Corrigez le problème constaté à la question 4

* 6/ Commentez tout votre code et déclarez un modèle permettant de récupérer dans la même table interne
*    le numéro de facture
*    la date de création de la facture
*    + la totalité des champs de la VBRP

*
TYPES :      BEGIN OF ty_fac,
               fkart TYPE vbrk-fkart,
               fkdat TYPE vbrk-fkdat.
               INCLUDE STRUCTURE vbrp.
TYPES :                END OF ty_fac.

DATA : lt_fac TYPE TABLE OF ty_fac.
DATA : lo_alv TYPE REF TO cl_salv_table.

*lt_fac2 type table of ty_fac.

*TABLES : vbrk, vbrp.

*SELECT SINGLE vbeln FROM vbak INTO @DATA(lv_vbeln) WHERE vbeln IN @s_vbeln.
*
*DATA : LR_FKART type RANGE OF fkart.
*
*
**SELECT vbrk~fkart, vbrk~fkdat, vbrp~*
**    FROM vbrk
**    INNER JOIN VBrp ON vbrp~vbeln = vbrk~vbeln
**  INTO TABLE @lt_fAC
**  WHERE fkart IN @lr_fkart.
*
*  select sign, opti, low, high
*  from tvarvc
*  into table LR_FKART
*where name = 'ztype_facture'.
*
*
*
*  SELECT vbrk~fkart, vbrk~fkdat, vbrp~*
*    FROM vbrk
*    INNER JOIN VBrp ON vbrp~vbeln = vbrk~vbeln
*  INTO TABLE @lt_fAC
*   WHERE fkart in @LR_FKART.
*
*
*SELECT max( netwr ) FROM vbrk
*  INTO @DATA(lv_max).
*
*  SELECT min( netwr ) FROM vbrk
*  INTO @DATA(lv_min).
*
*   SELECT avg( netwr ) FROM vbrk
*  INTO @DATA(lv_avg).
*
*  WRITE : 'Montant maximum :', lv_max, 'EUR'.
*  SKIP.
*   WRITE : 'Montant minimum :', lv_min, 'EUR'.
*   SKIP.
*  WRITE : 'Montant moyen des factures :', lv_avg, 'EUR'.




*  SELECT vbrk~fkart, vbrk~fkdat, vbrp~*
*    FROM vbrk
*    INNER JOIN VBrp ON vbrp~vbeln = vbrk~vbeln
*     APPENDING TABLE @lt_FAC
*   WHERE fkart = 'S1'.

*
*    CALL METHOD cl_salv_table=>factory
*      IMPORTING
*        r_salv_table = lo_alv
*      CHANGING
*        t_table      = lt_FAC.
*
*CALL METHOD lo_alv->display.
**
*   INTO TABLE lt_fac
*  WHERE fkart = 'F2'.
*
*SELECT vbeln
*  FROM vbrp
*  INTO TABLE lt_fac
*  FOR ALL ENTRIES IN lt_fac
*  WHERE lt_fac-fkart <> '0'.
**  WHERE vbeln = vbrk-vbeln.
*
*SELECT ekpo~ebeln, ekpo~ebelp, ekpo~bukrs, ekpo~bstyp, ekpo~matnr, ekpo~menge, ekpo~meins, ekpo~volum, ekpo~voleh, ekko~bsart, ekko~lifnr, ekko~ekorg
*      FROM ekpo
*      INNER JOIN ekko ON ekko~ebeln = ekpo~ebeln
*      INTO TABLE @DATA(lt_final)
*      WHERE ekpo~ebeln IN @s_ebeln
*      AND ekpo~matnr IN @s_matnr
*      AND ekpo~bukrs IN @s_bukrs.

* 7/ Récupérez les données évoquées à la question 6 à l'aide d'UN SELECT en ne prenant QUE
*    les factures de type F2 (Un champ de la VBRK vous donnera cette information)

* 8/ Effectuez un deuxième select en ne prenant cette fois que les factures de type S1
*    Et stockez les dans la même table que celle utilisée pour le 1er select
*    Débuggez le résultat de votre sélection.  Que constatez-vous?

* 9/ Répetez les opérations 7 et 8 en prenant soin cette fois de ne pas effacer les données
*    résultant du 1er select

* 10/ Créer une table de type RANGE correspondant au type de facture et ajoutez y les valeurs F2 et S1
*    afin de constistuer une liste de valeurs
*    Utilisez ce range pour refaire le même select qu'à l'étape 7

* 11/ Rajouter une autre colonne dans votre table finale nommée "Montant de la facture la plus élevéé"
*    et utilisez le sélect adéquat pour récupérer le montant de la facture la plus élevée dans la VBRK

* 12/ TVARVC : Créer une variable dans la table TVARVC en utilisant la transaction TVARVC
*              Alimentez cette variable avec les types de facture évoqués précédemment

* 13/ Notion de rupture (At NEW, At first,...exemple : at first vbeln, on alimente la date de création)
* car pas besoin de remplir à nouveau ce champ si la ligne suivante correspondant au même numéro de facture
*