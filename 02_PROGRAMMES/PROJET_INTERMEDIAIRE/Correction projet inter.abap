*&---------------------------------------------------------------------*
*& Report ZPROJ_INTER_2023
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zproj_inter_2023.

INCLUDE zproj_inter_2023_top.
INCLUDE zkde_alv_proj.
INCLUDE zproj_inter_2023_scr.
INCLUDE zproj_inter_2023_f01.



INITIALIZATION.

  PERFORM init_data.

START-OF-SELECTION.

  IF p_crea = 'X'.

    PERFORM get_data_from_file.

    PERFORM prepare_data.

    PERFORM check_data.

    PERFORM create_sales_order.

  ENDIF.

  IF p_alv = 'X'.

    PERFORM select_data.

    PERFORM display_data.

  ENDIF.