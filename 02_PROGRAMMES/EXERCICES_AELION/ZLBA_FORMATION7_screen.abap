*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION7_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK block
WITH FRAME TITLE title.

PARAMETERS : p_radio3 RADIOBUTTON GROUP rad2 USER-COMMAND frad1 DEFAULT 'X'.

PARAMETERS : p_radio RADIOBUTTON GROUP rad1 DEFAULT 'X'.



SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002. " Si on ne veut pas de texte, il faut écrire juste TITLE.
  PARAMETERS : p_PASSE  TYPE zpassenger-id_passenger MODIF ID sc2 MATCHCODE OBJECT Z_PASSENGER_ID,
               p_SURNAM TYPE zpassenger-surname MODIF ID sc2,
               p_NAME   TYPE zpassenger-name MODIF ID sc2,
               p_DATBRH TYPE zpassenger-date_birth MODIF ID sc2,
               p_CITY   TYPE zpassenger-city MODIF ID sc2,
               p_CNTRY  TYPE zpassenger-country MODIF ID sc2,
               p_LANG   TYPE zpassenger-lang MODIF ID sc2.

SELECTION-SCREEN : END OF BLOCK b2.

PARAMETERS : p_radio2 RADIOBUTTON GROUP rad1.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : p_DATE_T TYPE ztravel-date_travel MODIF ID sc2,
               p_HOUR_T TYPE ztravel-hour_travel MODIF ID sc2,
               p_DRIVER TYPE ztravel-id_driver MODIF ID sc2,
               p_PASS1  TYPE ztravel-id_passenger1 MODIF ID sc2,
               p_PASS2  TYPE ztravel-id_passenger2 MODIF ID sc2,
               p_PASS3  TYPE ztravel-id_passenger3 MODIF ID sc2,
               p_CTYFR  TYPE ztravel-city_from MODIF ID sc2,
               p_CTRYFR TYPE ztravel-country_from MODIF ID sc2,
               p_CITYTO TYPE ztravel-city_to MODIF ID sc2,
               p_CTRYTO TYPE ztravel-country_to MODIF ID sc2,
               p_KMS    TYPE ztravel-kms MODIF ID sc2,
               p_KMSUNI TYPE ztravel-kms_unit MODIF ID sc2,
               p_DURATI TYPE ztravel-duration MODIF ID sc2,
               p_TOLL   TYPE ztravel-toll MODIF ID sc2,
               p_GASOL  TYPE ztravel-gasol MODIF ID sc2,
               p_UNIT   TYPE ztravel-unit MODIF ID sc2.
SELECTION-SCREEN : END OF BLOCK b1.

PARAMETERS : p_radio4 RADIOBUTTON GROUP rad2.
SELECTION-SCREEN : BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECT-OPTIONS : s_DATE_T FOR ztravel-date_travel MODIF ID sc3,
                   s_CTRYFR FOR ztravel-country_from MODIF ID sc3,
                   s_CTRYTO FOR ztravel-country_to MODIF ID sc3.
SELECTION-SCREEN : END OF BLOCK b3.

SELECTION-SCREEN END OF BLOCK block.


AT SELECTION-SCREEN OUTPUT.
LOOP AT SCREEN.
  IF P_radio3 = 'X'  AND ( P_radio = 'X' OR P_radio2 = 'X' )  AND screen-group1 = 'SC3'.
    screen-active = 0.
    MODIFY SCREEN.
  ELSEIF P_radio4 = 'X' AND screen-group1 = 'SC2'.
    screen-active = 0.
    MODIFY SCREEN.
  ENDIF.
ENDLOOP.