FUNCTION zdriver_create.
*"----------------------------------------------------------------------
*"*"Interface locale :
*"  IMPORTING
*"     VALUE(IS_DRIVER) TYPE  ZDRIVER_CAR
*"  EXPORTING
*"     VALUE(EV_ID_DRIVER) TYPE  ZDRIVER_ID
*"  EXCEPTIONS
*"      ERROR_ALREADYEXIST
*"      ERROR_INFO_DRIVER
*"      ERROR_INFO_CAR
*"----------------------------------------------------------------------

  DATA: wa_driver_car TYPE zdriver_car,
        v_num(4)      TYPE n.


  IF is_driver-surname    IS INITIAL OR
     is_driver-name       IS INITIAL OR
     is_driver-date_birth IS INITIAL OR
     is_driver-city       IS INITIAL OR
     is_driver-country    IS INITIAL.
    RAISE error_info_driver.
  ENDIF.


  IF is_driver-car_brand IS INITIAL OR
     is_driver-car_model IS INITIAL OR
     is_driver-car_year  IS INITIAL OR
     is_driver-car_color IS INITIAL OR
     is_driver-car_id    IS INITIAL.
    RAISE error_info_car.
  ENDIF.


  SELECT SINGLE id_driver FROM zdriver_car
    INTO @DATA(v_id_driver)
    WHERE surname = @is_driver-surname
      AND name    = @is_driver-name.
  IF sy-subrc = 0.
    RAISE error_alreadyexist.
  ELSE.
    MOVE-CORRESPONDING is_driver TO wa_driver_car.
  ENDIF.


  SELECT MAX( id_driver ) FROM zdriver_car
    INTO @v_id_driver.

  v_num       = v_id_driver+1(4) + 1.
  CONCATENATE 'C' v_num INTO v_id_driver.
  CONDENSE v_id_driver NO-GAPS.


  wa_driver_car-id_driver = v_id_driver.

  INSERT zdriver_car FROM wa_driver_car.
  IF sy-subrc = 0.
    ev_id_driver = v_id_driver.
  ENDIF.

ENDFUNCTION.