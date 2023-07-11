*&---------------------------------------------------------------------*
*& Report  Z_MAIL_LBA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_email_lba.

INCLUDE z_email_lba_top.
INCLUDE z_email_lba_scr.
INCLUDE z_email_lba_f01.


START-OF-SELECTION.

  PERFORM retrieve_file.

  IF sy-subrc = 0.
    PERFORM control_email.

    IF gv_receiv_email = abap_true.
      PERFORM send_email.
    ENDIF.

  ENDIF.