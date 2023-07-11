&---------------------------------------------------------------------*
& Report ZLBA_FORMATION1
&---------------------------------------------------------------------*
& Date Création / Auteur / Motif
& 21.02.2023 / LBA (Aelion) / Création 1er progamme ABAP
&---------------------------------------------------------------------*
REPORT zlba_formation1.

DATA : lv_name  TYPE srmfname,
       première manière de déclarer
       lv_name2 TYPE zdriver_car_kde-name,
       autre manière de déclarer
       lv_name3 TYPE char25.
moins utilisé car il met moins d'informations que les autres

SELECT : SINGLE name
FROM zdriver_car_kde
INTO lv_name
WHERE id_driver = 'LISA_BA'.

WRITE : lv_name.


DATA : ls_zdriver  TYPE zdriver_car_kde.

SELECT : SINGLE *
FROM zdriver_car_kde
INTO ls_zdriver
WHERE id_driver = 'LISA_BA'.

WRITE : ls_zdriver.

 Récupération de l'ensemble des données de la table :

DATA : lt_zdriver  TYPE TABLE OF zdriver_car_kde,
       lv_fusion TYPE string.

SELECT *
FROM zdriver_car_kde
INTO TABLE lt_zdriver.

SORT lt_zdriver BY name ASCENDING.


LOOP AT lt_zdriver INTO ls_zdriver
  WHERE car_brand = 'Peugeot' and ( name = 'OSCAR' or name = 'MAGALI' ).
  WRITE : ls_zdriver.
ENDLOOP.

LOOP AT lt_zdriver INTO ls_zdriver where car_brand =  'Peugeot'.
  WHERE car_brand = 'Peugeot'.
  IF ls_zdriver-name = 'OSCAR'.
    EXIT.
    ELSEIF ls_zdriver-name = 'MAGALI'.
      WRITE : ls_zdriver.
    ELSE.
       WRITE : 'Heureusement je n''ai pas de peugeot'.
  ENDIF.

  CHECK ls_zdriver-name <> 'OSCAR'.
  CASE ls_zdriver-name.
    WHEN 'OSCAR'.
      CONTINUE.
    WHEN 'MAGALI'.
      WRITE : ls_zdriver.
    WHEN OTHERS.
      WRITE : 'Je roule en Allemande'.
  ENDCASE.

  WRITE ls_zdriver.

CONCATENATE lv_fusion ls_zdriver-name into lv_fusion SEPARATED BY space.
lv_fusion = |{ lv_fusion }{ ls_zdriver-name }|.


ENDLOOP.
WRITE lv_fusion.

TYPES : BEGIN OF ty_zdriver,
        id_driver TYPE Z_DRIVER_ID_KDE,
        surname TYPE NAMEF,
        name TYPE SRMFNAME,
        date_birth TYPE P06_DATENAISS,
        END OF ty_zdriver.

DATA : lt_driver  TABLE OF ty_zdriver.

SELECT id_driver surname name date_birth
  FROM zdriver_car_kde
  INTO TABLE  lt_driver.
TABLES : zdriver_car_kde.

PARAMETERS : p_id  z_driver_id_kde.
SELECT-OPTIONS : s_id FOR zdriver_car_kde-id_driver.


SELECT id_driver, surname, name, date_birth
FROM zdriver_car_kde
  INTO TABLE @DATA(lt_driver)
  WHERE id_driver = @p_id.
  WHERE id_driver IN @s_id.
IF 1 = 1.
ENDIF.

DATA : lo_alv TYPE REF TO cl_salv_table.

CALL METHOD cl_salv_table=>factory
  IMPORTING
    r_salv_table = lo_alv
  CHANGING
    t_table      = lt_driver.

CALL METHOD lo_alv->display.

EXO No2

Besoin exprimé par le Client
Le client souhaite disposer d'un report lui permettant
d'afficher certaines informations concernant les articles

1/ Lise des informations à afficher : (table article : MARA)
- le numéro d'aricle
- la description
- le type d'article
- son poids net
- unité de poids

2/ L'utilisateur souhaite pouvoir afficher ces informations
en fonction du type d'article et du numéro d'article

 methode 1 :
TABLES : mara.
SELECT-OPTIONS : s_matnr FOR mara-matnr.
SELECT-OPTIONS : s_mtart FOR mara-mtart OBLIGATORY.
PARAMETERS : p_trait AS CHECKBOX.

TYPES : BEGIN OF ty_modele,
          matnr TYPE matnr, "numéro article
          mtart TYPE mtart, "TYPE Article
          ntgew TYPE ntgew, "POIDS NET
          gewei TYPE gewei, "unité poids
        END OF ty_modele.

DATA : lt_mara  TYPE TABLE OF ty_modele.

SELECT matnr mtart ntgew gewei
  FROM mara
  INTO TABLE  lt_mara
WHERE matnr IN s_matnr
AND mtart IN s_mtart.

 methode 2 :

SELECT matnr, mtart, ntgew, gewei
FROM mara
INTO TABLE  @DATA(lt_mara)
  WHERE matnr IN @s_matnr
AND mtart IN @s_mtart.



DATA : lo_alv TYPE REF TO cl_salv_table.

CALL METHOD cl_salv_table=>factory
  IMPORTING
    r_salv_table = lo_alv
  CHANGING
    t_table      = lt_mara.

CALL METHOD lo_alv->display.

L'utilisateur souhaite qu'on affiche également la description
de l'article se trouvant dans la table MAKT

SELECT matnr, maktx
  FROM makt
  INTO TABLE @DATA(lt_makt)
  FOR ALL ENTRIES IN @lt_mara
  WHERE matnr = @lt_mara-matnr
  AND spras = 'F'.

TYPES : BEGIN OF ty_modele,
          matnr TYPE mara-matnr, "numéro article
          maktx TYPE makt-maktx, "description
          mtart TYPE mara-mtart, "TYPE Article
          ntgew TYPE ntgew, "POIDS NET
          gewei TYPE mara-gewei, "unité poids
        END OF ty_modele.

DATA : lt_final TYPE TABLE OF ty_modele,
        ls_final type ty_modele         on peut aussi faire comme ça pour déclarer la structure
       ls_final LIKE LINE OF lt_final,
       ls_mara  LIKE LINE OF lt_mara,
       ls_makt  LIKE LINE OF lt_makt.

LOOP AT lt_mara INTO ls_mara.
  clear ls_final.
  ls_final-matnr = ls_mara-matnr.
  ls_final-mtart = ls_mara-mtart.
  ls_final-ntgew = ls_mara-ntgew.
  ls_final-gewei = ls_mara-gewei.
  READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_mara-matnr.
  IF sy-subrc = 0. " veut dire s'il a trouvé le champs
    ls_final-maktx = ls_makt-maktx.
  ENDIF.
    APPEND ls_final TO lt_final.
 ENDLOOP.



SOLUTION 3 : En faisant un INNER JOIN (qui lie 2 tables entre elles):
IF p_trait IS NOT INITIAL. "is not initial veut dire que c'est coché

  SELECT mara~matnr, mara~mtart, mara~ntgew, mara~gewei, makt~maktx
 avec Inner join, on met ~ , ça sert à préciser  dans quel table il doit prendre les infos quand on sélectionne dans plusieurs tables
    FROM mara
    INNER JOIN makt ON makt~matnr = mara~matnr
    INTO TABLE @DATA(lt_final)
    WHERE mara~matnr IN @s_matnr
    AND mara~mtart IN @s_mtart
    AND makt~spras = 'F'.

  IF sy-subrc = 0. "j'ai trouvé les articles
    MESSAGE TEXT-002 TYPE 'I'. " le S veut dire Succes
  ELSE.
    MESSAGE TEXT-001 TYPE 'E'. "je n'ai pas trouvé les articles type 'E' veut dire Erreur donc le programme s'arrête
  ENDIF.

ELSE.

  SELECT matnr, mtart, ntgew, gewei
  FROM mara
  INTO TABLE @DATA(lt_final2)
  WHERE matnr IN @s_matnr
  AND mtart IN @s_mtart.
ENDIF.

DATA : lo_alv TYPE REF TO cl_salv_table.

IF p_trait IS NOT INITIAL.
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