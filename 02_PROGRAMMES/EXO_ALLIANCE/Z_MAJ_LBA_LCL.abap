*&---------------------------------------------------------------------*
*&  Include           Z_MAJ_LBA_LCL
*&---------------------------------------------------------------------*
**************************************************************
* LOCAL CLASS Definition
**************************************************************
*§4.Define and implement event handler to handle event DATA_CHANGED.
*
CLASS lcl_event_receiver DEFINITION.

    PUBLIC SECTION.
      METHODS:
        handle_data_changed
                      FOR EVENT data_changed OF cl_gui_alv_grid
          IMPORTING er_data_changed.
  
    PRIVATE SECTION.
  
  * This flag is set if any error occured in one of the
  * following methods:
      DATA: error_in_data TYPE c.
  
  * Methods to modularize event handler method HANDLE_DATA_CHANGED:
      METHODS: check_abgru
        IMPORTING
          ps_good_abgru   TYPE lvc_s_modi
          pr_data_changed TYPE REF TO cl_alv_changed_data_protocol.
  
  
  
  *....................................................................
  * This is a suggestion how you could comment your checks in each method:
  *.....
  * CHECK: fieldname(old/new value) !<comp> fieldname(old/new value)
  * IF NOT: (What to tell the user is wrong about the input)
  *......
  * Remarks:
  *  fieldname:       fieldname of table for the corresponding column
  *  (old/new value): ckeck with value of GT_OUTTAB or MT_GOOD_CELLS.
  *  !<comp>        : the value is valid if the condition <comp> holds.
  *
  * Example:
  *  CHECK ABGRU(new) !>= ABGRU(old)
  *  IF NOT: There are not enough number of seats according to this
  *          planetype.
  *.......................................................................
  
  ENDCLASS.
  
  CLASS lcl_event_receiver IMPLEMENTATION.
    METHOD handle_data_changed.
  
      DATA: ls_good TYPE lvc_s_modi.
  
      error_in_data = space.
  * semantic checks
  
  * Identify columns which were changed and check input
  * against output table gt_outtab or other new input values of one row.
  
  * Table er_data_changed->mt_good_cells holds all cells that
  * are valid according to checks against their DDIC data.
  * No matter in which order the input was made this table is
  * ordered by rows (row_id). For each row, the entries are
  * sorted by columns according to their order in the fieldcatalog
  * (not the defined order using field COL_POS but the order
  * given by the position of the record in the fieldcatalog).
  
  * The order is relevant if new inputs in several columns of
  * the same row are dependent.
  
  *§5.Loop over table MT_GOOD_CELLS to check all values that are
  *   valid due to checks according to information of the DDIC.
  
      LOOP AT er_data_changed->mt_good_cells INTO ls_good.
        CASE ls_good-fieldname.
  * check if column ABGRU of this row was changed
          WHEN 'ABGRU'.
            CALL METHOD check_abgru
              EXPORTING
                ps_good_abgru   = ls_good
                pr_data_changed = er_data_changed.
  
        ENDCASE.
      ENDLOOP.
  
  *§7.Display application log if an error has occured.
      IF error_in_data EQ 'X'.
        CALL METHOD er_data_changed->display_protocol.
      ENDIF.
  
    ENDMETHOD.
  *--------------------------------------------------------------------
    METHOD check_abgru.
  
  *..................................................
  * Overview of checks according to field ABGRU
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  * a) Does the Planetype exists? (check against check table VBAP)
  *
  
      DATA: l_abgru TYPE vbap-abgru,
            ls_vbap TYPE vbap.
  
  * Get new cell value to check it.
  * (In this case: ABGRU).
      CALL METHOD pr_data_changed->get_cell_value
        EXPORTING
          i_row_id    = ps_good_abgru-row_id
          i_fieldname = ps_good_abgru-fieldname
        IMPORTING
          e_value     = l_abgru.
  * existence check: Does the plane exists?
      SELECT SINGLE * FROM vbap INTO ls_vbap WHERE
                                      abgru = l_abgru.
      IF sy-subrc NE 0.
  * In case of error, create a protocol entry in the application log.
  * Possible values for message type ('i_msgty'):
  *
  *    'A': Abort (Stop sign)
  *    'E': Error (red LED)
  *    'W': Warning (yellow LED)
  *    'I': Information (green LED)
  *
        CALL METHOD pr_data_changed->add_protocol_entry
          EXPORTING
            i_msgid     = '0K'
            i_msgno     = '000'
            i_msgty     = 'E'
            i_msgv1     = text-m03           "Flugzeugtyp
            i_msgv2     = l_abgru && ' don''t exist on DB'
            i_msgv3     = text-m05           "exitstiert nicht
            i_fieldname = ps_good_abgru-fieldname
            i_row_id    = ps_good_abgru-row_id.
  
        error_in_data = 'X'.
        EXIT. "ABGRU does not exit, so we're finished here!
      ENDIF.
  
  
    ENDMETHOD.                           " CHECK_ABGRU
  
  ENDCLASS.