*&---------------------------------------------------------------------*
*& Include          Z_POEC_LBA_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_events DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS on_double_click
      FOR EVENT if_salv_events_actions_table~double_click
      OF cl_salv_events_table
      IMPORTING row
                column.

ENDCLASS.

CLASS lcl_events IMPLEMENTATION.

  METHOD on_double_click.



    PERFORM double_click_event IN PROGRAM (sy-repid) IF FOUND USING row column.



  ENDMETHOD.

ENDCLASS.
