*&---------------------------------------------------------------------*
*& Include          ZZ_DYNPRO_KDE_2_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_9001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  SET PF-STATUS 'STATUT_GUI_9001'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  PERFORM user_command.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_9002 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_9002 OUTPUT.
  SET PF-STATUS 'STATUT_GUI_9002'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9002 INPUT.

  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 9001.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form user_command
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
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


    WHEN OTHERS.
  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Module INIT_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_screen OUTPUT.

  DATA: BEGIN OF i_alv OCCURS 0,
          matnr TYPE mara-matnr,
          maktx TYPE makt-maktx,
        END OF i_alv.

  DATA: alv_container  TYPE REF TO cl_gui_custom_container,
        site_container TYPE REF TO cl_gui_custom_container,
        html           TYPE REF TO cl_gui_html_viewer,
        alv_grid       TYPE REF TO cl_gui_alv_grid,
        layout         TYPE lvc_s_layo,
        fieldcat       TYPE lvc_t_fcat,
        variant        TYPE disvariant.

  variant-report = sy-repid.
  variant-username = sy-uname.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE i_alv
    FROM mara
    INNER JOIN makt ON mara~matnr = makt~matnr AND makt~spras = sy-langu.
  SORT i_alv ASCENDING BY matnr.

  CREATE OBJECT alv_container
    EXPORTING
      container_name = 'ALV_CONTAINER'.

  CREATE OBJECT alv_grid
    EXPORTING
      i_parent = alv_container.

  CREATE OBJECT site_container
    EXPORTING
      container_name = 'CUSTOM_AREA'.

  CREATE OBJECT html
    EXPORTING
      parent = site_container.

  CALL METHOD html->show_url
    EXPORTING
    url = 'https://answers.sap.com/questions/1089696/alv-on-dynpro.html'.

  PERFORM get_fieldcatalog.

  CALL METHOD alv_grid->set_table_for_first_display
    EXPORTING
      is_layout        = layout
      is_variant       = variant
      i_save           = 'U'
      i_structure_name = 'i_alv'
    CHANGING
      it_outtab        = i_alv[]
      it_fieldcatalog  = fieldcat[].

*
*
*
** Création de l'objet ALV GRIS avec pour Custom Container l'objet créé juste avant
*  go_alv_grid = NEW cl_gui_alv_gris( i_parent = go_custom_container ).
*
** Affichage de l'ALV dans le Custom Container
*  go_alv_grid->set_table_for_first_display(
*  CHANGING
*    it_outtab = gt_mara "Table à afficher
*    it_fieldcatalog = gt_fieldcat_grid "Field catalogue
*    EXCEPTIONS
*      invalid_parameter_combination = 1
*      program_error = 2
*      too_many_lines = 3
*      OTHERS = 4 ).
*
*  IF sy-subrc <> 0.
*    RETURN.
*  ENDIF.

*  DATA : lt_valeur_list TYPE STANDARD TABLE OF vrm_value,
*         ls_list        LIKE LINE OF lt_valeur_list.
*
*  SELECT mara~matnr, makt~maktx
*    FROM mara
*    INNER JOIN makt ON makt~matnr = mara~matnr
*    WHERE makt~spras = @sy-langu
*    INTO TABLE @gt_mara
*    UP TO 10 ROWS.
*  IF sy-subrc = 0.
*    LOOP AT gt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>).
**      APPEND VALUE vrm_value( key = <fs_mara>-matnr text = |{ <fs_mara>-matnr }/{ <fs_mara>-maktx }| ) TO lt_valeur_list.
*      ls_list-key = <fs_mara>-matnr.
*      ls_list-text = |{ <fs_mara>-matnr }/{ <fs_mara>-maktx }|.
*      APPEND ls_list TO lt_valeur_list.
*    ENDLOOP.
*  ENDIF.
*
*  CALL FUNCTION 'VRM_SET_VALUES'
*    EXPORTING
*      id              = 'GV_LIST_MATNR'
*      values          = lt_valeur_list
*    EXCEPTIONS
*      id_illegal_name = 1.





ENDMODULE.

*&---------------------------------------------------------------------*
*& Form get_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_fieldcatalog .

  DATA: ls_fcat TYPE lvc_s_fcat.
  REFRESH: fieldcat.
  CLEAR: ls_fcat.

  ls_fcat-reptext = 'Material Number'.
  ls_fcat-coltext = 'Material Number'.
  ls_fcat-fieldname = 'MATNR'.
  ls_fcat-ref_table = 'I_ALV'.
  ls_fcat-outputlen = '18'.
  ls_fcat-col_pos = 1.

  APPEND ls_fcat TO fieldcat.
  CLEAR: ls_fcat.

  ls_fcat-reptext = 'Material Description'.
  ls_fcat-coltext = 'Material Description'.
  ls_fcat-fieldname = 'MAKTX'.
  ls_fcat-ref_table = 'I_ALV'.
  ls_fcat-outputlen = '40'.
  ls_fcat-col_pos = 2.

  APPEND ls_fcat TO fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module CHANGE_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
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