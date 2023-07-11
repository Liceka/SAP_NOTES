 
* Exemple de chargement d'une listbox (liste déroulante)
   
DATA lt_values TYPE vrm_values.
DATA ls_value LIKE LINE OF lt_values.

    CLEAR ls_value.
    ls_value-key = '1'.
    ls_value-text = 'Toulouse'.
    APPEND ls_value TO lt_values.

    CLEAR ls_value.
    ls_value-key = '2'.
    ls_value-text = 'paris'.
    APPEND ls_value TO lt_values.

    CLEAR ls_value.
    ls_value-key = '3'.
    ls_value-text = 'marseille'.
    APPEND ls_value TO lt_values.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_list1'
        values = lt_values.

    CLEAR ls_value.
    ls_value-key = '1'.
    ls_value-text = 'Toulouse'.
    APPEND ls_value TO lt_values.
    
    CLEAR ls_value.
    ls_value-key = '2'.
    ls_value-text = 'paris'.
    APPEND ls_value TO lt_values.

    CLEAR ls_value.
    ls_value-key = '3'.
    ls_value-text = 'marseille'.
    APPEND ls_value TO lt_values.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_list2'
        values = lt_values.