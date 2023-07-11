
* Affichage de L'ALV

DATA :  lo_alv                  TYPE REF TO cl_salv_table,
        lo_alv_functions        TYPE REF TO cl_salv_functions.

cl_salv_table=>factory(
IMPORTING
r_salv_table = lo_alv
CHANGING
t_table      = lt_covoit ).

lo_alv_functions = lo_alv->get_functions( ).
lo_alv_functions->set_all( abap_true ).


lo_alv->display( ).

----------------------------------------------------------------------------------------------------------------------------------------

TRY.
  
    ********** Affichage du container 1 de l écran 9001 après le select data **********
    
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