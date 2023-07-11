*&---------------------------------------------------------------------*
*&  Include           Z_004_UWU_TOP
*&---------------------------------------------------------------------*


*Pour le SELECTION-SCREEN PUSHBUTTON on doit ajouter la TABLE :
TABLES sscrfields.


DATA: lta_sood  TYPE STANDARD TABLE OF sood,
      lwa_sood  TYPE sood,
      str_write TYPE string,
      ls_lporb  TYPE sibflporb.


DATA: ta_srgbtbrel TYPE STANDARD TABLE OF srgbtbrel, wa_srgbtbrel TYPE srgbtbrel.
DATA: t_receivers TYPE somlreci1 OCCURS 0 WITH HEADER LINE.



DATA: lo_bitem     TYPE REF TO cl_sobl_bor_item,
      lo_container TYPE REF TO cl_gui_container.



DATA: go_regex     TYPE REF TO cl_abap_regex,
      go_matcher   TYPE REF TO cl_abap_matcher,
      go_exception TYPE REF TO cx_bcs,
      go_match     TYPE c LENGTH 1,
      gv_msg       TYPE string.

* Après le contrôle de l'adresse mail, permet de ne pas faire l'envoi du mail si abap_false.
DATA :   gv_receiv_email  TYPE abap_bool.