*&---------------------------------------------------------------------*
*& Report ZLBA_BATCH_INPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLBA_BATCH_INPUT.

INCLUDE ZLBA_BATCH_INPUT_TOP.
INCLUDE ZLBA_BATCH_INPUT_SCR.
INCLUDE ZLBA_BATCH_INPUT_F01.

START-OF-SELECTION.

PERFORM batch_input.