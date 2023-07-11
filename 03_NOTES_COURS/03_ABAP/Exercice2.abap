*EXO No2
*
*Besoin exprimé par le Client
*Le client souhaite disposer d'un report lui permettant
*d'afficher certaines informations concernant les articles
*
*1/ Lise des informations à afficher : (table article : MARA)
*- le numéro d'article
*- la description (table MAKT)
*- le type d'article
*- son poids net
*- unité de poids
*
*2/ L'utilisateur souhaite pouvoir afficher ces informations
*en fonction du type d'article et du numéro d'article




* methode 1 Déclaration statique :
TABLES : mara.
SELECT-OPTIONS : s_matnr FOR mara-matnr.
SELECT-OPTIONS : s_mtart FOR mara-mtart.

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


* methode 2 Déclaration dynamique:
TABLES : mara.
SELECT-OPTIONS : s_matnr FOR mara-matnr.
SELECT-OPTIONS : s_mtart FOR mara-mtart.

SELECT matnr, mtart, ntgew, gewei
FROM mara
INTO TABLE  @DATA(lt_mara)
  WHERE matnr IN @s_matnr
AND mtart IN @s_mtart.


* Affichage ALV
DATA : lo_alv TYPE REF TO cl_salv_table.

CALL METHOD cl_salv_table=>factory
  IMPORTING
    r_salv_table = lo_alv
  CHANGING
    t_table      = lt_mara.

CALL METHOD lo_alv->display.

*L'utilisateur souhaite qu'on affiche également la description
*de l'article se trouvant dans la table MAKT

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
       " ls_final type ty_modele         on peut aussi faire comme ça pour déclarer la structure
       ls_final LIKE LINE OF lt_final,
       ls_mara  LIKE LINE OF lt_mara,
       ls_makt  LIKE LINE OF lt_makt.

LOOP AT lt_mara INTO ls_mara.
  clear ls_final.
  ls_final-matnr = ls_mara-matnr.
  ls_final-mtart = ls_mara-mtart.
  ls_final-ntgew = ls_mara-ntgew.
  ls_final-gewei = ls_mara-gewei.

READ TABLE lt_makt INTO ls_makt
WITH KEY matnr = ls_mara-matnr.
  
    IF sy-subrc = 0. " veut dire s'il a trouvé le champs
        ls_final-maktx = ls_makt-maktx.
    ENDIF.
APPEND ls_final TO lt_final.
ENDLOOP.

DATA : lo_alv TYPE REF TO cl_salv_table.

CALL METHOD cl_salv_table=>factory
  IMPORTING
    r_salv_table = lo_alv
  CHANGING
    t_table      = lt_final.

CALL METHOD lo_alv->display.

*SOLUTION 3 : En faisant un INNER JOIN (qui lie 2 tables entre elles):

TABLES : mara.
SELECT-OPTIONS : s_matnr FOR mara-matnr.
SELECT-OPTIONS : s_mtart FOR mara-mtart OBLIGATORY.
PARAMETERS : p_trait AS CHECKBOX.

IF p_trait IS NOT INITIAL. "is not initial veut dire que c'est coché

  SELECT mara~matnr, mara~mtart, mara~ntgew, mara~gewei, makt~maktx
* avec Inner join, on met ~ , ça sert à préciser  dans quel table il doit prendre les infos quand on sélectionne dans plusieurs tables
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

