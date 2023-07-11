PROGRAMME : ZKDE_CORR_EXO3

Pour prendre la liste de tous les champs d'une structure déjà existante "INCLUDE STRUCTURE"

```ABAP
TYPES :      BEGIN OF ty_fac,
               fkart TYPE vbrk-fkart,
               fkdat TYPE vbrk-fkdat.
               INCLUDE STRUCTURE vbrp.
TYPES :                END OF ty_fac.
```

Pour compter le nombre de ligne :

```ABAP
* 1/ Combien de lignes comptent actuellement notre table ?
  DATA : lv_count TYPE i.
    SELECT COUNT( * ) FROM zdriver_car_kde INTO lv_count.
* OU
*   SELECT COUNT( * ) FROM zdriver_car_kde INTO @DATA(lv_count).
```

Pour afficher dans une POP up à l'aide d'un message créé en SE91 (qui peut être utilisé par pls personnes) (voir onglet MESSAGES TEXT)

```ABAP
* 1bis/ Affichez le nombre de lignes dans une pop up d'information avant
* d'afficher la table

*  IF sy-subrc = 0.
*    MESSAGE i002(zkde_mess) WITH lv_count.
*  ENDIF.
```

Pour sélectionner une partie de la table

```ABAP
 2/ Combien de voitures 'NOIR' dans cette table?

  SELECT COUNT( * ) FROM zdriver_car_kde INTO lv_count WHERE CAR_color = 'NOIR'.
    IF sy-subrc = 0.
    MESSAGE i003(zkde_mess) WITH lv_count.
    ENDIF.

* OU on crée une variable qu'on incrémente :
  SELECT * FROM zdriver_car_kde INTO TABLE gt_display.
  IF sy-subrc = 0.
    LOOP AT gt_display ASSIGNING FIELD-SYMBOL(<fs_disp>).
      IF <fs_disp>-car_color = 'NOIR'.
        lv_count = lv_count + 1.
      ENDIF.
    ENDLOOP.
  ENDIF.
```

Sélectionner la valeur maximum (minimum MIN, moyenne AVG...)

```ABAP
* 3/ Sélectionnez l'année de fabrication de la voiture la plus récente

  SELECT MAX( car_year ) FROM zdriver_car_kde INTO @DATA(lv_date).
  IF sy-subrc = 0.
    MESSAGE i004(zkde_mess) WITH lv_date.
  ENDIF.

SELECT SINGLE 

* 4/ Récupérez le prénom du propriétaire de cette voiture

*  SELECT SINGLE name FROM zdriver_car_kde INTO @DATA(lv_name)
*    WHERE car_year = @lv_date.
*    IF sy-subrc = 0.
*      MESSAGE i005(zkde_mess) WITH lv_name.
*    ENDIF.
```

Lecture directe : READ TABLE, ça va lire qu'une ligne qu'on va mettre dans une structure ou pour vérifier si une valeur existe "TRANSPORTING NO FIELDS" pour qu'il ne copie pas les valeurs

```ABAP
* 5/ Vérifiez à l'aide d'une lecture directe s'il existe une voiture de la marque "AUDI" dans notre table
  READ TABLE gt_display TRANSPORTING NO FIELDS WITH KEY car_brand = 'AUDI'.
  IF sy-subrc = 0.
    MESSAGE i006(zkde_mess).
  ELSE.
    MESSAGE i007(zkde_mess).
  ENDIF.
```

Lecture séquentielle = LOOP
CHECK pour une condition

```ABAP
*6 / Créer une autre table interne au même format que votre 1 ère table
*    puis Effectuez une lecture séquentielle sur votre 1ère table et ajoutez dans votre 2ème table
*    uniquement les lignes de la 1ère table pour lesquelles le propriètaire vit à 'Toulouse'
*    Affichez la 2ème table

  DATA : lt_display2 TYPE SORTED TABLE OF zdriver_car_kde WITH NON-UNIQUE KEY ID_driver,
         ls_display2 LIKE LINE OF lt_display2.

* 3 façons de faire, avec WHERE, IF ou CHECK
  LOOP AT gt_display ASSIGNING FIELD-SYMBOL(<fs_display>) 
    WHERE city = 'Toulouse' OR city = 'TOULOUSE'.
        MOVE <fs_display> TO ls_display2.
        APPEND ls_display2 TO lt_display2.
  ENDLOOP.

  LOOP AT gt_display ASSIGNING <fs_display>.
    IF <fs_display>-city = 'Toulouse' OR <fs_display>-city = 'TOULOUSE'.
      MOVE <fs_display> TO ls_display2.
      APPEND ls_display2 TO lt_display2.
    ENDIF.
  ENDLOOP.

  LOOP AT gt_display ASSIGNING <fs_display>.
    CHECK <fs_display>-city = 'Toulouse' OR <fs_display>-city = 'TOULOUSE'.
    MOVE <fs_display> TO ls_display2.
    APPEND ls_display2 TO lt_display2.
  ENDLOOP.
```

Exit pour sortir de la boucle une fois qu'il a récupéré la 1ere valeur.

```ABAP
*7/  Videz la 2ème table puis renouvellez la même opération que pour la question 7
*    mais cette fois ci ne transférez dans la 2ème table que la ligne correspondant
*    à la première voiture grise que vous trouverez

  CLEAR lt_display2.

  LOOP AT gt_display ASSIGNING <fs_display>.
    CHECK <fs_display>-car_color = 'GRISE'.
    ls_display2 = <fs_display>. 
*OU MOVE <fs_display> TO ls_display2.

    APPEND ls_display2 TO lt_display2.
    EXIT.
  ENDLOOP.

  LOOP AT gt_display ASSIGNING <fs_display> 
    WHERE car_color = 'GRISE'.
    ls_display2 = <fs_display>.
* ou MOVE <fs_display> TO ls_display2.

    APPEND ls_display2 TO lt_display2.
    EXIT.
  ENDLOOP.
```

OU EN LECTURE DIRECTE : 

```ABAP
*  READ TABLE gt_display ASSIGNING <fs_display> WITH KEY car_color = 'GRISE'.
*  IF sy-subrc = 0.
*    ls_display2 = <fs_display>.
*    APPEND ls_display2 TO lt_display2.
*  ENDIF.
```

APPEND ajoute en dernière position
On avait trié la table bar ordre alphabétique dans le data :

```ABAP
DATA : lt_display2 TYPE SORTED TABLE OF zdriver_car_kde WITH NON-UNIQUE KEY ID_driver,
```

```ABAP
*8/ Ensuite Effacez de nouveau le contenu de la 2ème table et copier l'intégralité
* de la 1ère table dans la 2ème table
* puis ajoutez une ligne dans votre 2ème table interne avec de nouvelles informations
* qui n'existent pas encore dans cette table (Attention à ne pas remettre un ID_DRIVER
* déjà présent dans la table car pour rappel l'ID_DRIVER est la clé de la table ZDRIVER_CAR_KDE)
* ajoutez une deuxième fois la même ligne ds la 2ème table

  CLEAR lT_display2.
  lt_display2 = gt_display.

  DATA : ls_display3 LIKE LINE OF lt_display2.

  ls_display3-mandt = sy-mandt.
  ls_display3-id_driver = 'ZDEVKEV'.
  ls_display3-surname  = 'KEKE'.
  ls_display3-name = 'DEV'.
  ls_display3-date_birth = '19901206'.
  ls_display3-city = 'ARRAS'.
  ls_display3-region = 'NORD'.
  ls_display3-country = 'FRANCE'.
  ls_display3-car_brand = 'FERRARI'.
  ls_display3-car_model = 'F40'.
  ls_display3-car_year  = '2002'.
  ls_display3-car_color = 'ROUGE'.
  ls_display3-car_id  = ''.
  ls_display3-lang = 'F'.

  APPEND ls_display3 TO lt_display2.

*(sinon faire un insert avec un index pour lui donner la position exacte)

  DELETE ADJACENT DUPLICATES FROM lt_display2 COMPARING ID_driver. (ça va supprimer les doublons en regardant les ID driver)
```

```ABAP
*9/ Utilisez la 1ère table pour supprimer de la 2ème table toutes les lignes qui se trouvent
* aussi dans la première table

  LOOP AT gt_display ASSIGNING FIELD-SYMBOL(<fs_display>).
    DELETE lt_display2 WHERE id_driver = <fs_display>-id_driver.
* OU
*    DELETE lt_display2 FROM <fs_display>.
  ENDLOOP.

*10/ Modifier la seule ligne qui existe encore dans la 2ème table en changeant la valeur d'un
* des champs de cette ligne

  CLEAR ls_display3.
  ls_display3-name = 'HAMILTON'.
  MODIFY lt_display2 FROM ls_display3 TRANSPORTING name WHERE id_driver = 'ZDEVKEV'.
```

Pour ajouter une ligne dans la table de la base de données :
On a été obligé d'ajouter : ACCEPTING DUPLICATE KEYS.
Car on avait 2 fois le même id driver.


```
**-------------Attention, ci-dessous, on va modifier la table de la Base de données ZDRIVER_CAR_KDE
* 11/ Ajoutez le contenu de votre 2ème table interne à la table ZDRIVER_CAR_KDE
  
  INSERT zdriver_car_kde FROM TABLE lt_display2.

* 12/ Contrôlez le résultat de votre instruction sans aller consulter la table en BDD
* puis vérifiez la Base de données

  IF sy-subrc = 0.
    " La ligne a bien été ajoutée dans la BDD
  ELSE.
    " L'insertion dans la BDD a échoué
  ENDIF.

* 13/ Ajoutez exactement la même ligne de nouveau dans votre table interne
*    et utilisez de nouveau cette table interne pour ajouter les deux lignes de votre table dans la table ZDRIVER_CAR_KDE
*     et contrôler de nouveau : que s'est t-il passé?

  ls_display3-mandt = sy-mandt.
  ls_display3-id_driver = 'ZDEVKEV'.
  ls_display3-surname  = 'KEKE'.
  ls_display3-name = 'DEV'.
  ls_display3-date_birth = '19901206'.
  ls_display3-city = 'ARRAS'.
  ls_display3-region = 'NORD'.
  ls_display3-country = 'FRANCE'.
  ls_display3-car_brand = 'FERRARI'.
  ls_display3-car_model = 'F40'.
  ls_display3-car_year  = '2002'.
  ls_display3-car_color = 'ROUGE'.
  ls_display3-car_id  = ''.
  ls_display3-lang = 'F'.
  
  APPEND ls_display3 TO lT_display2.
  INSERT zdriver_car_kde FROM TABLE lt_display2 ACCEPTING DUPLICATE KEYS.
  IF sy-subrc = 0.
    " La ligne a bien été ajoutée dans la BDD
  ELSE.
    " L'insertion dans la BDD a échoué
  ENDIF.
```