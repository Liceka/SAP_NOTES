FUNCTION Z_CART_LBA_EDITOR_EXIT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      BUFFER TYPE  RSWSOURCET
*"----------------------------------------------------------------------

  DATA: L_FIRSTNAME  LIKE ADRP-NAME_FIRST,
        L_LASTNAME   LIKE ADRP-NAME_LAST,
        L_FUNCTION   LIKE ADCP-FUNCTION,
        L_DEPARTMENT LIKE ADCP-DEPARTMENT,
        L_DATUM(10).

  DATA: LT_SVAL      TYPE STANDARD TABLE OF SVAL,
        LS_SVAL      TYPE SVAL,
        LS_DD02L     TYPE DD02L,
        LS_DD03L     TYPE DD03L,
        LT_DD03L     TYPE STANDARD TABLE OF DD03L,
        LV_STRUCNAME LIKE RSRD1-DDTYPE_VAL,
        LV_REPORT    TYPE STRING,
        LV_TOP       TYPE string,
        LV_SCR       TYPE string,
        LV_F01       TYPE string.

  TABLES: USR21, " Assign user name address key
          ADRP,  " Persons (central address administration)
          ADCP.  " Person/Address assignment (central address administration)

* Initialize first and last name, if not found in database l_firstname = 'first name'.
  L_LASTNAME = 'last name'.
  WRITE SY-DATUM DD/MM/YYYY TO L_DATUM.

* Retrieval of first and last name in database
  SELECT SINGLE * FROM USR21 WHERE BNAME = SY-UNAME.

  IF SY-SUBRC = 0.
    SELECT SINGLE *
      FROM ADRP
      WHERE PERSNUMBER = USR21-PERSNUMBER.

    IF SY-SUBRC = 0.
      L_FIRSTNAME = ADRP-NAME_FIRST.
      L_LASTNAME = ADRP-NAME_LAST.
* Retrtieval of function and department of user
      SELECT SINGLE *
        FROM ADCP
        WHERE PERSNUMBER = USR21-PERSNUMBER.

      IF SY-SUBRC = 0.
        L_FUNCTION = ADCP-FUNCTION.
        L_DEPARTMENT = ADCP-DEPARTMENT.
      ENDIF.
    ENDIF.
  ENDIF.

* Get name of structure from user
  LS_SVAL-TABNAME = 'RSRD1'.
  LS_SVAL-FIELDNAME = 'DDTYPE_VAL'.
  LS_SVAL-FIELD_ATTR  = '00'.
  APPEND LS_SVAL TO LT_SVAL.

  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      POPUP_TITLE     = 'Enter Report Name'
    TABLES
      FIELDS          = LT_SVAL
    EXCEPTIONS
      ERROR_IN_FIELDS = 1
      OTHERS          = 2.

  READ TABLE LT_SVAL INTO LS_SVAL INDEX 1.
  LV_STRUCNAME = LS_SVAL-VALUE.

  CONCATENATE LV_STRUCNAME '.' INTO LV_REPORT.
  CONCATENATE LV_STRUCNAME '_TOP.' INTO LV_TOP.
  CONCATENATE LV_STRUCNAME '_SCR.' INTO LV_SCR.
  CONCATENATE LV_STRUCNAME '_F01.' INTO LV_F01.

  BUFFER =      '*&---------------------------------------------------------------------*'.
  APPEND BUFFER.
  BUFFER =      '*                               .,,,,,,,,,,,,                           '.
  APPEND BUFFER.
  BUFFER =      '*                        ,;%%%%uuuuuuuuuuuuu%%%\                        '.
  APPEND BUFFER.
  BUFFER =      '*                     /%%%%%uuuu====####uuuuuu%%%%                      '.
  APPEND BUFFER.
  BUFFER =      '*                   /%%%%%uuuu.....===###uuuuu%%%%%%                    '.
  APPEND BUFFER.
  BUFFER =      '*            , `````\%%%%%uuu....##.===##uuuu%%%%%%%%                   '.
  APPEND BUFFER.
  BUFFER =      '*           ,````````)####\%u....../==#/uuu%%%%%%%%%%%                  '.
  APPEND BUFFER.
  BUFFER =      '*           ,`````/#########\%mmmmmmmmmmmmm%%%%%%%%%%%;                 '.
  APPEND BUFFER.
  BUFFER =      '*           #\``/##########(mmmmmmmmmmmmmmmmnu%%`%%%%%%%                '.
  APPEND BUFFER.
  BUFFER =      '*           ###############(mmmmmmmmmmmmmmmmmnuu%%`%%%%%%;              '.
  APPEND BUFFER.
  BUFFER =      '*           u\###########/ (mmmmmmmmmmmmmmmmmmnuu%%`%%%%%%%%            '.
  APPEND BUFFER.
  BUFFER =      '*          uuuuuEEE         \mmmmmmmmmmmmmmmmmnuuu%%`%%%%%%%%%          '.
  APPEND BUFFER.
  BUFFER =      '*          uuuuuEEE    .:::,#u,mmmmnnmmmmmmmmmnuuu%%;; %%%%%%%%%        '.
  APPEND BUFFER.
  BUFFER =      '*           uuuuuu\##\:::::##uuummmmmmmmmmmmmmnuu%%;;;; :...%%%%%%      '.
  APPEND BUFFER.
  BUFFER =      '*              uuuuu\#######/uuuuuuuuuu,mmmmmmnu%%...;;;  ::...%%%%     '.
  APPEND BUFFER.
  BUFFER =      '*                 \uuuuuuuuuuuuuuuuuuuuuuuu,mmnu/ \...;;;   ::...%%%    '.
  APPEND BUFFER.
  BUFFER =      '*                   >####&&################<%%%%    \;;;/    ::...%%%   '.
  APPEND BUFFER.
  BUFFER =      '*               (#####&&&################%%%%%%%              ::..%%%   '.
  APPEND BUFFER.
  BUFFER =      '*           (######&&&&##############(%%%%%%%%%%                ::%/    '.
  APPEND BUFFER.
  BUFFER =      '*          (####&&&&&&#############(%%%%%%%%%%%%%                       '.
  APPEND BUFFER.
  BUFFER =      '*        (#######&&&&&############(%%%%%%%%%%%%%%%%                     '.
  APPEND BUFFER.
  BUFFER =      '*       (#########################(%%%%%%%%%%%%%%%%%%                   '.
  APPEND BUFFER.
  BUFFER =      '*       (# (######################(%%%%%%%%%%%%%%%%%%%%                 '.
  APPEND BUFFER.
  BUFFER =      '*          (#######################(%%%%%%%%%%%%%%%%%%%%%               '.
  APPEND BUFFER.
  BUFFER =      '*         %%%(#####################(%%%%%%%%%%%%%%%%%%%%%%%             '.
  APPEND BUFFER.
  BUFFER =      '*        %%%%%%(####################(%%%%%%%%%%%%%%%%%%%%%%%            '.
  APPEND BUFFER.
  BUFFER =      '*       ;%%%%%%; (#################n`%%%%%%%%`%%%%%%%%%%%%%%%           '.
  APPEND BUFFER.
  BUFFER =      '*      (%%%%%%%(  ;%nn############nn`%%%%%%%%`%%%%%%%%%%%%%%%%          '.
  APPEND BUFFER.
  BUFFER =      '*       ;%%%%%%%  %%%nnnnnnnnnnnnn`%%%%%%%%%`%%%%%%%%%%%%%%%%%%(@@@)    '.
  APPEND BUFFER.
  BUFFER =      '*        \%%%%%;  %%%%nnnnnnnn`%%%%%%%%%`%%`n%%%%%%%%%%%%%%%%%(@@@@@)   '.
  APPEND BUFFER.
  BUFFER =      '*         (%(%/   %%%%%nnnnnn`%%%%%%%%%%%`nnnn%%%%%%%%%%%%%%%%(@@@@@@   '.
  APPEND BUFFER.
  BUFFER =      '*                %%%%%%nnnnnn`%%%%%%%%`nnnnnnnn%%%%%%%%%%%%%%(@@@@@@@   '.
  APPEND BUFFER.
  BUFFER =      '*               %%%%%%%nnnnnnn(%(%)nnnnnnnnnnnn%%%%%%%%%%%%%(@@@@@@@)   '.
  APPEND BUFFER.
  BUFFER =      '*           .,;%%%%%%%%nnnnnnnnnnnnnnnnnnnnnnn%%%%%%%%%%%%%(@@@@@@@@    '.
  APPEND BUFFER.
  BUFFER =      '*    ,nnnnnnn%%%%%%%%%nnnnnn)nnnnnnnnnnnnnnn%%%%%%%%%%%%%%(@@@@@@@)     '.
  APPEND BUFFER.
  BUFFER =      '* /nnnnnnnnnnn%%%%%%nnnnnnnnnnn)nnnnnnnnn%%%%%%%%%%%%%%%/  (@@@@)       '.
  APPEND BUFFER.
  BUFFER =      '*(uu(uuuuuuuuuuuuuuuuuuuuuuuuuuu/   (uu;;;;;;;;;;;uu)                   '.
  APPEND BUFFER.
  BUFFER =      '*                                    (uu;;;;;;;;;;uu)                   '.
  APPEND BUFFER.
  BUFFER =      '*                                     (uuuuuuuuuuuuu)                   '.
  APPEND BUFFER.
  BUFFER =      '*                                       (uu)(uu)(uu)                    '.
  APPEND BUFFER.
  BUFFER =      '*                                                                       '.
  APPEND BUFFER.
  BUFFER =      '*&---------------------------------------------------------------------*'.
  APPEND BUFFER.
  CONCATENATE   '*& REPORT                :' LV_STRUCNAME INTO BUFFER SEPARATED BY SPACE.
  APPEND BUFFER.
  BUFFER =      '*& VERSION               : 1.00'.
  APPEND BUFFER.
  CONCATENATE   '*& AUTHOR                : ' SY-UNAME' -' L_FIRSTNAME L_LASTNAME INTO BUFFER SEPARATED BY SPACE.
  APPEND BUFFER.
  CONCATENATE   '*& FUNCTION / DEPARTMENT : ' L_FUNCTION '/' L_DEPARTMENT INTO BUFFER SEPARATED BY SPACE.
  APPEND BUFFER.
  BUFFER =      '*&---------------------------------------------------------------------*'.
  APPEND BUFFER.
  CONCATENATE   '*& CREATION DATE         : ' L_DATUM INTO BUFFER SEPARATED BY SPACE.
  APPEND BUFFER.
  BUFFER =      '*& PURPOSE               : '.
  APPEND BUFFER.
  BUFFER =      '*&---------------------------------------------------------------------*'.
  APPEND BUFFER.
  BUFFER =      '*& CORRECTION ON VERSION : 1.00'.
  APPEND BUFFER.
  BUFFER =      '*& NEW VERSION           : 1.01'.
  APPEND BUFFER.
  BUFFER =      '*& AUTHOR                : '.
  APPEND BUFFER.
  BUFFER =      '*& DATE                  : '.
  APPEND BUFFER.
  BUFFER =      '*& REASON                : '.
  APPEND BUFFER.
  BUFFER =      '*& CHANGE                : '.
  APPEND BUFFER.
  BUFFER =      '*&---------------------------------------------------------------------*'.
  APPEND BUFFER.
  BUFFER =      '*& HISTORY'.
  APPEND BUFFER.
  BUFFER =      '*&---------------------------------------------------------------------*'.
  APPEND BUFFER.
  BUFFER =      '                                                                       '.
  APPEND BUFFER.
  CONCATENATE   'REPORT' LV_REPORT INTO BUFFER SEPARATED BY SPACE.
  APPEND BUFFER.
  BUFFER =      '                                                                       '.
  APPEND BUFFER.
  CONCATENATE   'INCLUDE' LV_TOP INTO BUFFER SEPARATED BY SPACE.
  APPEND BUFFER.
  CONCATENATE   'INCLUDE' LV_SCR INTO BUFFER SEPARATED BY SPACE.
  APPEND BUFFER.
  CONCATENATE   'INCLUDE' LV_F01 INTO BUFFER SEPARATED BY SPACE.
  APPEND BUFFER.
  BUFFER =      '                                                                       '.
  APPEND BUFFER.
  BUFFER =      'INITIALIZATION.'.
  APPEND BUFFER.
  BUFFER =      '                                                                       '.
  APPEND BUFFER.
  BUFFER =      'PERFORM DATA_INITIALIZATION.'.
  APPEND BUFFER.
  BUFFER =      '                                                                       '.
  APPEND BUFFER.
  BUFFER =      'START-OF-SELECTION.'.
  APPEND BUFFER.
  BUFFER =      '                                                                       '.
  APPEND BUFFER.
  BUFFER =      'END-OF-SELECTION.'.
  APPEND BUFFER.

ENDFUNCTION.