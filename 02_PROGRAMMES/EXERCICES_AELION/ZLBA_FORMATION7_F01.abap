*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION7_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form insert_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
* IF p_radio3 IS NOT INITIAL.

FORM insert_data .


    DATA : lt_mess  TYPE bapiret2_tt,
           lt_mess1 TYPE bapiret2_tt.
 
 
    IF p_radio IS NOT INITIAL.
 
      CALL FUNCTION 'ZMDA_AJOUT'
        EXPORTING
          i_passe    = p_PASSE
          i_surnam   = p_SURNAM
          i_name     = p_NAME
          i_datbrh   = p_DATBRH
          i_city     = p_CITY
          i_cntry    = p_CNTRY
          i_lang     = p_LANG
        IMPORTING
          et_message = lt_mess.
 
 
      LOOP AT lt_mess INTO DATA(ls_mess) WHERE type = 'E'.
        EXIT.
      ENDLOOP.
      IF sy-subrc = 0.
        MESSAGE s009(ZKDE_mess).
      ELSE.
        MESSAGE s000(ZKDE_mess).
 
      ENDIF.
    ELSE.
      CALL FUNCTION 'ZMDA_AJOUT_TRAJET'
        EXPORTING
          i_date_t    = p_DATE_T
          i_hour_t    = p_HOUR_T
          i_driver    = p_DRIVER
          i_pass1     = p_PASS1
          i_pass2     = p_PASS2
          i_pass3     = p_PASS3
          i_ctyfr     = p_CTYFR
          i_ctryfr    = p_CTRYFR
          i_cityto    = p_CITYTO
          i_ctryto    = p_CTRYTO
          i_kms       = p_KMS
          i_kmsuni    = p_kmsuni
          i_durati    = p_DURATI
          i_toll      = p_TOLL
          i_gasol     = p_GASOL
          i_unit      = p_UNIT
        IMPORTING
          et_message1 = lt_mess1.
      LOOP AT lt_mess1 INTO DATA(ls_mess1) WHERE type = 'E'.
        EXIT.
      ENDLOOP.
      IF sy-subrc = 0.
        MESSAGE s010(ZKDE_mess).
      ELSE.
        MESSAGE s000(ZKDE_mess).
 
      ENDIF.
    ENDIF.
 
 
  ENDFORM.
 
 *ELSE.
 *&---------------------------------------------------------------------*
 *& Form display_data
 *&---------------------------------------------------------------------*
 *& text
 *&---------------------------------------------------------------------*
 *& -->  p1        text
 *& <--  p2        text
 *&---------------------------------------------------------------------*
  FORM display_data .
 
 
 
 
    SELECT ztravel~date_travel, ztravel~city_from, ztravel~country_from,
      ztravel~city_to, ztravel~country_to,
      zdriver_car_kde~surname && @space && zdriver_car_kde~name AS driver_n,
      zdriver_car_kde~car_brand, zdriver_car_kde~car_model,
      ZTravel~id_passenger1, ZTravel~id_passenger2, ZTravel~id_passenger3,
      ztravel~kms, ztravel~kms_unit, ztravel~toll, ztravel~gasol, ztravel~unit
      FROM ztravel
      INNER JOIN zdriver_car_kde ON zdriver_car_kde~id_driver = ztravel~id_driver
      INTO TABLE @DATA(lt_final)
      WHERE ztravel~date_travel IN @s_DATE_T
         AND   ztravel~country_from IN @s_CTRYFR
         AND   ztravel~country_to IN @s_CTRYTO
      ORDER BY date_travel.
 
 
 
 * Affichage de L ALV
   DATA : lo_alv           TYPE REF TO cl_salv_table,
          lo_alv_functions TYPE REF TO cl_salv_functions.
 
   cl_salv_table=>factory(
   IMPORTING
     r_salv_table = lo_alv
   CHANGING
     t_table      = lt_final ).
 
   lo_alv_functions = lo_alv->get_functions( ).
   lo_alv_functions->set_all( abap_true ).
 
 
   lo_alv->display( ).
 
 
 
 
 
  ENDFORM.
 
 *ENDIF.