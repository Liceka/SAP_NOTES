*&---------------------------------------------------------------------*
*& Report ZLBA_FORMATION7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLBA_FORMATION7.

* Pour voir le progamme de correction de Kevin : ZKDE_EXO_COVOIT

INCLUDE zlba_formation7_top.
INCLUDE zlba_formation7_scr.
INCLUDE zlba_formation7_f01.

START-OF-SELECTION.

    IF s_date_t IS INITIAL.
        MESSAGE TEXT-004 TYPE 'E'.
      IF P_radio4 IS NOT INITIAL.
      ENDIF.
    ENDIF.

IF p_radio2 IS NOT INITIAL.

PERFORM insert_data.

ELSE.
PERFORM display_data.

ENDIF.

END-of-SELECTION.