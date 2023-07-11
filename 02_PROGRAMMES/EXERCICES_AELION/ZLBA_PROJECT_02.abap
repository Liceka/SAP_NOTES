*&---------------------------------------------------------------------*
*& Report ZMDA_PROJECT_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLBA_PROJECT_02.

INCLUDE zlba_alv.

INCLUDE ZLBA_PROJECT_02_TOP.
*INCLUDE ZLBA_PROJECT_1_TOP.
INCLUDE ZLBA_PROJECT_02_SCR.
*INCLUDE ZLBA_PROJECT_1_SCR.
INCLUDE ZLBA_PROJECT_02_F01.
*INCLUDE ZLBA_PROJECT_1_F01.


START-OF-SELECTION.



IF p_create = 'X'.
  PERFORM data_extraction.
  PERFORM data_preparation.
  PERFORM data_verification.
*  PERFORM client_order_creation.
  PERFORM batch_input.

ELSE.

  PERFORM display_client_order.

ENDIF.