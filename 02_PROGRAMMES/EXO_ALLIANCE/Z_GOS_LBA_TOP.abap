*&---------------------------------------------------------------------*
*&  Include           Z_GOS_LBA_TOP
*&---------------------------------------------------------------------*

DATA : go_gos               TYPE REF TO cl_gos_manager,
       go_publication       TYPE REF TO cl_gos_manager,
       gs_object            TYPE borident,
       gs_bc_object         TYPE sibflpor,
       gs_lporb             TYPE sibflporb,
       gs_old               TYPE sibflporb,
       ok_code              LIKE sy-ucomm,
       gp_control_init,
       gp_republish         TYPE c,
       gt_objects           TYPE TABLE OF sibflporbt,
       go_container         TYPE REF TO cl_gui_custom_container,
       go_manager           TYPE REF TO cl_gos_manager,
       gp_service           LIKE sgosattr-name,
       gs_service_selection TYPE sgos_sels,
       gt_service_selection TYPE tgos_sels,
       go_history           TYPE REF TO cl_gos_object_history.




TYPES: BEGIN OF ty_final,
         title   TYPE string,
         creator TYPE string,
         date    TYPE datum,
       END OF ty_final.

DATA gt_final TYPE STANDARD TABLE OF ty_final.