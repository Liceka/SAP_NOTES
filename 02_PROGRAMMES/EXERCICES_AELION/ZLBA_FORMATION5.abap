*&---------------------------------------------------------------------*
*& Report ZLBA_FORMATION5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlba_formation5.

*TABLES : zdriver_car_kde.
*
**TYPES :      BEGIN OF ty_car.
**               INCLUDE STRUCTURE zdriver_car_kde.
**TYPES :                END OF ty_car.
**             ty_t_car TYPE TABLE OF ty_car.
*
**DATA : lt_car TYPE TABLE OF ty_car,
*DATA : lo_alv   TYPE REF TO cl_salv_table,
*       lv_count TYPE i.


*
*SELECT * FROM zdriver_car_kde INTO TABLE lt_car.
*
* OU
SELECT *
  FROM zdriver_car_kde
  INTO TABLE @DATA(lt_car).
*
* IF sy-subrc = 0.
*  LOOP AT lt_car ASSIGNING FIELD-SYMBOL(<fs_disp>).
*    IF <fs_disp>-car_color = 'NOIR'.
*            lv_count = lv_count + 1.
*   endif.
*      ENDLOOP.
*      endif.

*SELECT MAX( car_year ) FROM zdriver_car_kde INTO @DATA(lv_count2).
*
*IF sy-subrc = 0.
*  MESSAGE i004(zkde_mess) WITH lv_count2. "Pour écrire dans un message pop up créé dans se91
*ENDIF.
*
*SELECT SINGLE name FROM zdriver_car_kde INTO @DATA(lv_name)
*  WHERE car_year = @lv_count2.
*
*
*IF sy-subrc = 0.
*  MESSAGE i005(zkde_mess) WITH lv_name. "Pour écrire dans un message pop up créé dans se91
*ENDIF.
*
*
*
*READ TABLE lt_car TRANSPORTING NO FIELDS WITH KEY car_brand = 'AUDI'.
*
*IF sy-subrc = 0.
*  MESSAGE i006(zkde_mess).
*ELSE.
*  MESSAGE i007(zkde_mess).
*ENDIF.

DATA : lt_ville TYPE SORTED TABLE OF zdriver_car_kde WITH NON-UNIQUE KEY ID_driver,
       ls_ville LIKE LINE OF lt_ville,
       lo_alv   TYPE REF TO cl_salv_table.

*CLEAR lt_ville.
*
* LOOP AT lt_car INTO ls_ville WHERE city = 'Toulouse' or city = 'TOULOUSE'.
*
*   IF sy-subrc = 0.
*          APPEND ls_ville TO lt_ville .
*          ENDIF.
*ENDLOOP.



*7/  Videz la 2ème table puis renouvellez la même opération que pour la question 7
*    mais cette fois ci ne transférez dans la 2ème table que la ligne correspondant
*    à la première voiture grise que vous trouverez

**CLEAR lt_ville.

*  DATA : lt_display2 TYPE TABLE OF zdriver_car_kde,
*         ls_display2 LIKE LINE OF lt_display2.
*
*  LOOP AT gt_display ASSIGNING FIELD-SYMBOL(<fs_display>) WHERE city = 'Toulouse' OR city = 'TOULOUSE'.
*    MOVE <fs_display> TO ls_display2.
*    APPEND ls_display2 TO lt_display2.
*  ENDLOOP.
*
*  LOOP AT gt_display ASSIGNING <fs_display>.
*    IF <fs_display>-city = 'Toulouse' OR <fs_display>-city = 'TOULOUSE'.
*      MOVE <fs_display> TO ls_display2.
*      APPEND ls_display2 TO lt_display2.
*    ENDIF.
*  ENDLOOP.
*
*  LOOP AT gt_display ASSIGNING <fs_display>.
*    CHECK <fs_display>-city = 'Toulouse' OR <fs_display>-city = 'TOULOUSE'.
*    MOVE <fs_display> TO ls_display2.
*    APPEND ls_display2 TO lt_display2.

*CLEAR lt_ville.
*
*LOOP AT lt_car INTO ls_ville WHERE car_color = 'Gris' OR car_color = 'Grise' OR car_color = 'GRIS' OR car_color = 'GRISE'.
*  IF sy-subrc = 0.
*    APPEND ls_ville TO lt_ville.
*    EXIT.
*  ENDIF.
*ENDLOOP.




*8/ Ensuite Effacez de nouveau le contenu de la 2ème table et copier l'intégralité
* de la 1ère table dans la 2ème table
* Triez la 2ème table par ID_DRIVER
* puis ajoutez une ligne dans votre 2ème table interne avec de nouvelles informations
* qui n'existent pas encore dans cette table (Attention à ne pas remettre un ID_DRIVER
* déjà présent dans la table car pour rappel l'ID_DRIVER est la clé de la table ZDRIVER_CAR_KDE)

CLEAR lt_ville.

lt_ville = lt_car.


    DATA : ls_add LIKE LINE OF lt_ville.
ls_add-ID_DRIVER = 'ZzzAhah'.
ls_add-SURNAME = 'Hihi'.
ls_add-NAME = 'Hiha'.
ls_add-DATE_BIRTH = '20230502'.
ls_add-CITY = 'TOULOUSE'.
ls_add-REGION = 'OCC'.
ls_add-COUNTRY = 'FRANCE'.
ls_add-CAR_BRAND = 'TOYOTA'.
ls_add-CAR_MODEL = 'VERSO'.
ls_add-CAR_YEAR = '2012'.
ls_add-CAR_COLOR = 'VERT'.
ls_add-CAR_ID = '1536897'.
ls_add-LANG = 'F'.

    APPEND ls_add TO lt_ville.

*9/ Utilisez la 1ère table pour supprimer de la 2ème table toutes les lignes qui se trouvent
* aussi dans la première table

lOOP AT lt_car ASSIGNING FIELD-SYMBOL(<fs_display>).
  DELETE lt_ville WHERE id_driver = <fs_display>.
ENDLOOP.

*ls_add-SURNAME = 'Hiho'.
*ls_add-NAME = 'Hoha'.
*MODIFY ls_add FROM TABLE lt_ville.

*10/ Modifier la seule ligne qui existe encore dans la 2ème table en changeant la valeur d'un
* des champs de cette ligne

  CLEAR ls_add.
  ls_add-name = 'HAMI'.
  MODIFY lt_ville FROM ls_add TRANSPORTING name WHERE ID_DRIVER = 'ZzzAhah'.

*LOOP AT lt_ville ASSIGNING FIELD-SYMBOL(<fs_display2>) WHERE id_driver = 'ZAhah'.
*      <fs_display2>-SURNAME = 'toto'.
*    ENDLOOP.
INSERT zdriver_car_kde from table lt_ville.

ls_add-ID_DRIVER = 'ZzzAhah'.
ls_add-SURNAME = 'Hihi'.
ls_add-NAME = 'Hiha'.
ls_add-DATE_BIRTH = '20230502'.
ls_add-CITY = 'TOULOUSE'.
ls_add-REGION = 'OCC'.
ls_add-COUNTRY = 'FRANCE'.
ls_add-CAR_BRAND = 'TOYOTA'.
ls_add-CAR_MODEL = 'VERSO'.
ls_add-CAR_YEAR = '2012'.
ls_add-CAR_COLOR = 'VERT'.
ls_add-CAR_ID = '1536897'.
ls_add-LANG = 'F'.

    APPEND ls_add TO lt_ville.
    INSERT zdriver_car_kde from table lt_ville.


IF 1 = 1.
  ENDIF.

*10/ Modifier la seule ligne qui existe encore dans la 2ème table en changeant la valeur d'un
* des champs de cette ligne

*SELECT COUNT(*) FROM zdriver_car_kde  INTO lv_count.
*
*  IF sy-subrc = 0.
*    MESSAGE i002(zkde_mess) WITH lv_count. "Pour écrire dans un message pop up créé dans se91
*    endif.

*SELECT COUNT(*) FROM zdriver_car_kde  INTO lv_count WHERE CAR_color = 'NOIR'.
*  IF sy-subrc = 0.
*   MESSAGE i003(zkde_mess) WITH lv_count.
*   endif.





*
*DATA : ls_color TYPE table of lt_car.
*
*LOOP AT lt_car
*
*


*WRITE : 'Nombre total d''élèves : ', lv_count.


*
*CALL METHOD cl_salv_table=>factory
*  IMPORTING
*    r_salv_table = lo_alv
*  CHANGING
*    t_table      = lt_car.
*
*CALL METHOD lo_alv->display.

*ORM merge_data  USING    ut_vbak TYPE ty_t_vbak
*                          ut_vbap TYPE ty_t_vbap
*                          ut_makt TYPE ty_t_makt
*                          ut_kna1 TYPE ty_t_kna1.
*
*  DATA : ls_final LIKE LINE OF gt_final,
*         ls_vbak  TYPE ty_vbak,
*         ls_vbap  TYPE ty_vbap,
*         ls_makt  TYPE ty_makt,
*         ls_kna1  TYPE ty_kna1.
*
*  LOOP AT ut_vbak INTO ls_vbak.
*    CLEAR ls_final.

*CALL METHOD cl_salv_table=>factory
*  IMPORTING
*    r_salv_table = lo_alv
*  CHANGING
*    t_table      = lt_ville.
*
*CALL METHOD lo_alv->display.