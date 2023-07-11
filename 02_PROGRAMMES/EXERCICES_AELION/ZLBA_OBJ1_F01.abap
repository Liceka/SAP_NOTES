*&---------------------------------------------------------------------*
*& Include          ZLBA_OBJ1_F01
*&---------------------------------------------------------------------*






*&---------------------------------------------------------------------*
*& Form create_objet
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_objet .

*CREATE OBJECT go_travel
*  EXPORTING
*    iv_driver_id = p_driver
*    iv_city_from = p_city_f
*    iv_city_to   = p_city_t.
*
*
*
*CALL METHOD go_travel->get_travel
*  IMPORTING
*    et_travel     = DATA(lt_travel)
*  EXCEPTIONS
*    no_data_found = 1
*    OTHERS        = 2.
*
**IF sy-subrc <> 0.
*** Implement suitable error handling here
**ENDIF.
*
*CALL METHOD go_travel->display_travel.

CREATE OBJECT go_covoit
  EXPORTING
    iv_driver_id = p_driver
    iv_city_from = p_city_f
    iv_city_to   = p_city_t
    iv_date = p_date.


CALL METHOD go_covoit->get_covoit
  EXCEPTIONS
    no_data_found = 1
    others        = 2
        .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

CALL METHOD go_covoit->display_covoit.

ENDFORM.