*&---------------------------------------------------------------------*
*& Report  Z_EXO_LBA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT Z_EXO_LBA.

INCLUDE z_exo_lba_lcl.
INCLUDE Z_EXO_LBA_TOP.
INCLUDE Z_EXO_LBA_SCR.
INCLUDE Z_EXO_LBA_F01.

START-OF-SELECTION.

PERFORM select_data.
PERFORM display_data.


*Pour voir la performance du programme
*  GET RUN TIME FIELD DATA(wvl_t0).
*PERFORM select_data. "25000
*  GET RUN TIME FIELD DATA(wvl_t1).
*  DATA(wvl_tot) = wvl_t1 - wvl_t0.
*  WRITE wvl_tot.

END-OF-SELECTION.