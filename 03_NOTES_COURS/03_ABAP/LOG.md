# Affichage via une LOG
  
Affichage d’un compte rendu des opérations via un ALV ou une LOG (voir SLG0 / SLG1 http://quelquepart.free.fr/?tag=slg1         https://blogs.sap.com/2012/04/18/create-and-view-log-using-slg0-and-slg1-transaction/ )  




  ```ABAP

DATA:   ls_log        TYPE bal_s_log,
        ls_msg        TYPE bal_s_msg,
        ls_log_handle TYPE balloghndl,
        lt_log_handle TYPE bal_t_logh.
  
  ls_log-object = 'ZLOG_PROJ'.          "Object name
  ls_log-aluser = sy-uname.        "Username
  ls_log-alprog = sy-repid.          "report name


  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = ls_log
    IMPORTING
      e_log_handle            = ls_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
    EXIT.
  ENDIF.

  ```
  ........

  
  ```ABAP

LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) WHERE type = 'E' OR type = 'A'.
        EXIT.
      ENDLOOP.

      IF sy-subrc = 0. "si c'est égal à 0, ERREUR!
        ls_msg-msgty = 'E'.
        ls_msg-msgid = 'ZKDE_MESS'.
        ls_msg-msgno = 012.
        ls_msg-msgv1 = <fs_data>-id_com.
        ROLLBACK WORK.
      ELSE.          "sinon si diffent de 0 alors succès.
        ls_msg-msgty = 'S'.
        ls_msg-msgid = 'ZKDE_MESS'.
        ls_msg-msgno = 013.
        ls_msg-msgv1 = lv_vbeln.
        ls_msg-msgv2 = <fs_data>-id_com.
        COMMIT WORK AND WAIT.
      ENDIF.

  CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = ls_log_handle
          i_s_msg          = ls_msg
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.
      IF sy-subrc = 0.
        INSERT ls_log_handle INTO TABLE lt_log_handle.
* Implement suitable error handling here
      ENDIF.

ENDLOOP.


    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_client         = sy-mandt
        i_save_all       = 'X'
        i_t_log_handle   = lt_log_handle
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

 ```
