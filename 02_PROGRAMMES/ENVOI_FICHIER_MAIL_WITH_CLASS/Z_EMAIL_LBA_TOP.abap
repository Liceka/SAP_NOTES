*&---------------------------------------------------------------------*
*&  Include           Z_MAIL_LBA_TOP
*&---------------------------------------------------------------------*

DATA:    BEGIN OF gt_tab OCCURS 0,
rec(1000) TYPE c,
END OF gt_tab.


DATA :   gs_tab(1000) TYPE c.


DATA: go_regex     TYPE REF TO cl_abap_regex,
go_matcher   TYPE REF TO cl_abap_matcher,
go_exception TYPE REF TO cx_bcs,
go_match     TYPE c LENGTH 1,
gv_msg       TYPE string.


* Pour passer en mode binaire qui permet de convertir le fichier en pls lignes.
DATA :   gv_xstring   TYPE xstring,
contents_bin TYPE solix_tab.

* Après le contrôle de l'adresse mail, permet de ne pas faire l'envoi du mail si abap_false.
DATA :   gv_receiv_email  TYPE abap_bool.