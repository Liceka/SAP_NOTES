# Les dynpros : *Exercice power point*


```ABAP
REPORT zz_dynpro_lba_4

INCLUDE ZZ_DYNPRO_LBA_4_TOP.
INCLUDE ZZ_DYNPRO_LBA_4_F01.

START-OF-SELECTION.

  CALL SCREEN 9001.
```

> Dans **TOP** :
___

```ABAP
DATA : gv_vbeln TYPE vbak-vbeln.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          ernam TYPE vbak-ernam,
          erdat TYPE vbak-erdat,
          erzet TYPE vbak-erzet,
          auart TYPE vbak-auart,
        END OF ty_vbak,
        BEGIN OF ty_mara,
          matnr TYPE mara-matnr,
          maktx TYPE makt-maktx,
        END OF ty_mara.

DATA : gs_vbak         TYPE ty_vbak,
       gv_matnr        TYPE matnr,
       gv_matnr3       TYPE matnr,
       gv_matnr_intern TYPE boolean,
       gv_matnr_extern TYPE boolean,
       gv_list_matnr   TYPE matnr,
       gv_matnr_select TYPE matnr,
       gv_maktx_select TYPE makt-maktx,
       gt_mara         TYPE TABLE OF ty_mara,
       gv_modif        TYPE boolean.

DATA : gt_mara2            TYPE STANDARD TABLE OF mara,
       go_alv_grid         TYPE REF TO cl_gui_alv_grid,
       gt_fieldcat_grid    TYPE lvc_t_fcat,
       go_custom_container TYPE REF TO cl_gui_custom_container.
```

> Dans **Dynpros 9001** :
___

```ABAP
PROCESS BEFORE OUTPUT.
 MODULE STATUS_9001.
   MODULE init_screen.
     MODULE change_screen.

PROCESS AFTER INPUT.
 MODULE USER_COMMAND_9001.
```

> Dans **F01** :
___

```ABAP
MODULE status_9001 OUTPUT.
  SET PF-STATUS 'STATUT_GUI_9001'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
```


```ABAP
MODULE init_screen OUTPUT.

DATA : lt_valeur_list TYPE STANDARD TABLE OF vrm_value,
         ls_list        LIKE LINE OF lt_valeur_list.

  SELECT mara~matnr, makt~maktx
    FROM mara
    INNER JOIN makt ON makt~matnr = mara~matnr
    WHERE makt~spras = @sy-langu
    INTO TABLE @gt_mara
    UP TO 10 ROWS. #Pour afficher 10 lignes dans la liste déroulante
  IF sy-subrc = 0.
    LOOP AT gt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>).
*      APPEND VALUE vrm_value( key = <fs_mara>-matnr text = |{ <fs_mara>-matnr }/{ <fs_mara>-maktx }| ) TO lt_valeur_list.
      ls_list-key = <fs_mara>-matnr.
      ls_list-text = |{ <fs_mara>-matnr }/{ <fs_mara>-maktx }|.
      APPEND ls_list TO lt_valeur_list. #Pour afficher la sélection de la liste déroulante dans les 2 zones de saisies non étidatble créées en dessous
    ENDLOOP.
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'GV_LIST_MATNR'
      values          = lt_valeur_list
    EXCEPTIONS
      id_illegal_name = 1.
ENDMODULE.
```


```ABAP
MODULE change_screen OUTPUT.

*  LOOP AT SCREEN.
*    IF screen-name = 'GV_MATNR' OR screen-name = 'GV_LIST_MATNR'.
*      CASE gv_modif.
*        WHEN 'X'.
*          screen-input = 0.
*          screen-color = 6.
*        WHEN OTHERS.
*          screen-input = 1.
*          screen-color = 5.
*      ENDCASE.
*    ENDIF.
*    MODIFY SCREEN.
*  ENDLOOP.

  LOOP AT SCREEN.
    CASE gv_modif.
      WHEN 'X'.
        IF screen-name = 'GV_MATNR' OR screen-name = 'GV_LIST_MATNR'.
          screen-input = 0.
        ENDIF.
      WHEN OTHERS.
        IF screen-name = 'GV_MATNR' OR screen-name = 'GV_LIST_MATNR'.
          screen-input = 1.
        ENDIF.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.


ENDMODULE.
```

```ABAP
MODULE user_command_9001 INPUT.

  PERFORM user_command.

ENDMODULE.
```

```ABAP
FORM user_command .

** Prise en compte de l'action utilisateur
  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'FIND'.
* Méthode 1
*      IF gv_matnr_extern = 'X'.
*        SELECT COUNT( * ) FROM mara WHERE matnr = gv_matnr.
*        IF sy-subrc = 0.  "L'article existe.
*          MESSAGE TEXT-001 TYPE 'S'.
*        ELSE. "L'article n'existe pas dans la BDD
*          MESSAGE TEXT-002 TYPE 'W'.
*        ENDIF.
*      ELSE.
*        CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
*          EXPORTING
*            input        = gv_matnr
*          IMPORTING
*            output       = gv_matnr
*          EXCEPTIONS
*            length_error = 1
*            OTHERS       = 2.
*        SELECT COUNT( * ) FROM mara WHERE matnr = gv_matnr.
*        IF sy-subrc = 0.  "L'article existe.
*          MESSAGE TEXT-001 TYPE 'S'.
*        ELSE. "L'article n'existe pas dans la BDD
*          MESSAGE TEXT-002 TYPE 'W'.
*        ENDIF.
*      ENDIF.

* Méthode 2
      IF gv_matnr_intern = 'X'.
        CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
          EXPORTING
            input        = gv_matnr
          IMPORTING
            output       = gv_matnr
          EXCEPTIONS
            length_error = 1
            OTHERS       = 2.
      ENDIF.

      SELECT COUNT( * ) FROM mara WHERE matnr = gv_matnr.
      IF sy-subrc = 0.  "L'article existe.
        MESSAGE TEXT-001 TYPE 'S'.
      ELSE. "L'article n'existe pas dans la BDD
        MESSAGE TEXT-002 TYPE 'W'.
      ENDIF.

    WHEN 'LIST'.
* on affiche le matnr sélectionné dans le texte à coté
      gv_matnr_select = gv_list_matnr.

* on va rechercher la désignation dans la table globale
      READ TABLE gt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>)
        WITH KEY matnr = gv_list_matnr.
      IF sy-subrc IS INITIAL.
*   et on affecte la désignation trouvée dans la variable du dynpro
        gv_maktx_select = <fs_mara>-maktx.
      ENDIF.

    WHEN 'ALV'.
      CALL SCREEN 9002.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.
```

> Dans **Dynpros 9002** :
___

```ABAP
PROCESS BEFORE OUTPUT.
  MODULE status_9002.
  MODULE display_alv.
*
PROCESS AFTER INPUT.
  MODULE user_command_9002.
```

> Dans **F01** :
___

```ABAP
MODULE status_9002 OUTPUT.
  SET PF-STATUS 'STATUT_GUI_9002'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
```

```ABAP
MODULE display_alv OUTPUT.

  IF gv_matnr IS INITIAL. " Si l'article du Dynpro 9001 n'a pas été renseigné

* Sélection des données relatives aux 100 premiers articles de la table MARA
    SELECT *
      FROM mara
      INTO TABLE gt_mara2 UP TO 100 ROWS.
    IF sy-subrc IS NOT INITIAL.
      FREE gt_mara2.
      RETURN.
    ENDIF.

  ELSE. " Sinon

* Sélection des données relatives à l'article saisi dans le Dynpro 9001
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = gv_matnr
      IMPORTING
        output       = gv_matnr
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.

    SELECT *
    FROM mara
    INTO TABLE gt_mara2 WHERE matnr = gv_matnr.
    IF sy-subrc IS NOT INITIAL.
      FREE gt_mara2.
      RETURN.
    ENDIF.
  ENDIF.

* Création du Custom container en fonction de l'élement (du nom) dans mon Dynpro
  go_custom_container = NEW cl_gui_custom_container( container_name = 'CONTAINER' ).

* Création du Field Catalog
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'MARA'
    CHANGING
      ct_fieldcat            = gt_fieldcat_grid
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    FREE gt_fieldcat_grid.
    RETURN.
  ENDIF.

* Création de l'objet ALV GRID avec pour Custom Container l'objet créé juste avant
  go_alv_grid = NEW cl_gui_alv_grid( i_parent = go_custom_container ).

* Affichage de l'ALV dans le Custom Container
  go_alv_grid->set_table_for_first_display(
    CHANGING
      it_outtab           =  gt_mara2            " Table à afficher
      it_fieldcatalog     =  gt_fieldcat_grid   " Field catalogue
   EXCEPTIONS
     invalid_parameter_combination = 1
     program_error                 = 2
     too_many_lines                = 3
     OTHERS                        = 4 ).
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.


ENDMODULE.
```

```ABAP
MODULE user_command_9002 INPUT.

  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 9001.
    WHEN 'DISP'.
* Sélection des données relatives à l'article saisi dans le Dynpro 9002

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
        EXPORTING
          input        = gv_matnr3
        IMPORTING
          output       = gv_matnr3
        EXCEPTIONS
          length_error = 1
          OTHERS       = 2.

      SELECT *
      FROM mara
      INTO TABLE gt_mara2 WHERE matnr = gv_matnr3.
      IF sy-subrc IS NOT INITIAL.
        FREE gt_mara2.
        RETURN.
      ENDIF.

* Je refresh l'ALV pour qu'il prenne en compte les nouvelles données de la table GT_MARA2
      CALL METHOD Go_alv_grid->refresh_table_display.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
```