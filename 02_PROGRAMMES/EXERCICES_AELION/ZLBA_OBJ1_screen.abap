*&---------------------------------------------------------------------*
*& Include          ZLBA_OBJ1_SCR
*&---------------------------------------------------------------------*

PARAMETERS : p_driver    TYPE zdriver_car_kde-ID_driver MATCHCODE OBJECT Z_id_driver_prog_07,
             p_city_f TYPE ztravel-city_from MATCHCODE OBJECT Z_city_from_prog_07,
             p_city_t   TYPE ztravel-city_to MATCHCODE OBJECT Z_city_to_prog_07,
             p_date TYPE ztravel-DATE_TRAVEL.