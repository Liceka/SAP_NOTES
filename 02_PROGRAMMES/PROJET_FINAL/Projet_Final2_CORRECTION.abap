*&---------------------------------------------------------------------*
*& Include          Z_POEC_LBA_F01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*

FORM select_data .

********** Sélection des données du select-option **********

  SELECT  zekko_lba~ebeln,
          zekko_lba~bstyp,
          zekko_lba~aedat,
          zekko_lba~ernam,
          zekko_lba~waers
  FROM zekko_lba
  INNER JOIN zekpo_lba ON zekpo_lba~ebeln = zekko_lba~ebeln
  WHERE zekko_lba~ebeln IN @s_ebeln
  AND zekpo_lba~matnr IN @s_matnr
  INTO TABLE @gt_final_ekko.
  DELETE ADJACENT DUPLICATES FROM gt_final_ekko COMPARING ebeln.
* On supprime les lignes avec le même EBELN


  IF sy-subrc = 0. "Les articles ont été trouvés

    CALL SCREEN 9001.


  ELSEIF s_ebeln-high IS INITIAL.

    MESSAGE e002(zlba_mess) WITH s_ebeln-low 'ZEKKO_LBA'.
* Document d'achat &1 introuvable dans la table &2

  ELSEIF s_ebeln-high IS NOT INITIAL  AND s_ebeln-low IS NOT INITIAL.

    MESSAGE e003(zlba_mess) WITH s_ebeln-low s_ebeln-high 'ZEKKO_LBA'.
* Les commandes entre &1 et &2 sont introuvables dans la table &3

  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*& Module DISPLAY_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

MODULE display_alv OUTPUT.



  TRY.

********** Affichage du container 1 de l'écran 9001 après le select data **********

      go_container1 = NEW cl_gui_custom_container( container_name = 'CONTAINER1' ).


      CALL METHOD cl_salv_table=>factory
        EXPORTING
          r_container  = go_container1
        IMPORTING
          r_salv_table = go_salv1
        CHANGING
          t_table      = gt_final_ekko.


      """"" Déclenchement de l'évènement double click """""

      go_events = go_salv1->get_event( ).
      SET HANDLER lcl_events=>on_double_click FOR go_events.

      """"" ----------------------------------------- """""

      go_salv1->get_functions( )->set_all( abap_true ). "Onglets du haut avec options
      go_salv1->get_columns( )->set_optimize( abap_true ). "Largeur colonne en fonction du texte
      go_salv1->get_display_settings( )->set_list_header('HEADER'). "titre de l'ALV
      go_salv1->get_display_settings( )->set_striped_pattern( abap_true ). "colorer 1 ligne sur 2
      go_salv1->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ). "pour sélection des lignes

      go_salv1->display( ).


********** Affichage du container 2 après le double click **********

      go_container2 = NEW cl_gui_custom_container( container_name = 'CONTAINER2' ).

      CALL METHOD cl_salv_table=>factory
        EXPORTING
          r_container  = go_container2
        IMPORTING
          r_salv_table = go_salv2
        CHANGING
          t_table      = gt_final_ekpo.

      go_salv2->get_functions( )->set_all( abap_true ). "Onglets du haut avec options
      go_salv2->get_columns( )->set_optimize( abap_true ). "Largeur colonne en fonction du texte
      go_salv2->get_display_settings( )->set_list_header('ITEM'). "titre de l'ALV
      go_salv2->get_display_settings( )->set_striped_pattern( abap_true ). "colorer 1 ligne sur 2
      go_salv2->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ). "pour sélection des lignes

    CATCH cx_salv_msg INTO go_message1.

  ENDTRY.


ENDMODULE.

FORM double_click_event USING lv_row    TYPE i
                              lv_column TYPE lvc_fname.
* On récupère la ligne et la colonne du click

  DATA : ls_ekko  LIKE LINE OF gt_final_ekKo,
         lv_vbeln TYPE vbeln.


  IF lv_column = 'EBELN'.
    "Il faut qu'on ai cliqué sur la colonne du numéro de commande


********** On récupère le VBELN par rapport à la ligne cliquée **********

    READ TABLE gt_final_ekko INTO ls_ekko INDEX lv_row. "On lit la table au niveau de la ligne cliquée

    IF sy-subrc = 0.

      lv_vbeln = ls_ekko-ebeln. "On récupère le numéro de commande pour le select suivant


********** Sélection des données du double-click par rapport au VBELN **********

      SELECT  zekpo_lba~ebeln,
              zekpo_lba~ebelp,
              zekpo_lba~matnr,
              zekpo_lba~werks,
              zekpo_lba~menge,
              zekpo_lba~netpr,
              zekpo_lba~netwr,
              zekpo_lba~meins
      FROM zekpo_lba
      WHERE zekpo_lba~ebeln = @lv_vbeln
      INTO TABLE @gt_final_ekpo.


    ENDIF.


    TRY.

********** On affiche le container 2 mais l'objet a été créé au 1er affichage**********

        go_salv2->refresh( ).
        go_salv2->display( ).

      CATCH cx_salv_msg INTO go_message2.


    ENDTRY.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

MODULE user_command_9001 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.


ENDMODULE.

*&---------------------------------------------------------------------*
*& Module STATUS_9001 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

MODULE status_9001 OUTPUT.
  SET PF-STATUS 'STATUT_GUI_9001'.
* SET TITLEBAR 'xxx'.
ENDMODULE.