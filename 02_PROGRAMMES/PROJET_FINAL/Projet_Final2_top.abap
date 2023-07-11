*&---------------------------------------------------------------------*
*& Include          Z_POEC_LBA_TOP
*&---------------------------------------------------------------------*

TABLES : zekko_lba, zekpo_lba.

TYPES: BEGIN OF ty_final_ekko,

         ebeln TYPE ebeln,
         bstyp TYPE bstyp,
         aedat TYPE aedat,
         ernam TYPE ernam,
         waers TYPE waers,

       END OF ty_final_ekko.

TYPES: BEGIN OF ty_final_ekpo,

         ebeln TYPE ebeln,
         ebelp TYPE ebelp,
         matnr TYPE matnr,
         werks TYPE werks_d,
         menge TYPE bstmg,
         netpr TYPE bprei,
         netwr TYPE bwert,
         meins TYPE bstme,

       END OF ty_final_ekpo.


DATA: gt_final_ekko TYPE TABLE OF ty_final_ekko,
      gt_final_ekpo TYPE TABLE OF ty_final_ekpo.

DATA : go_alv_grid         TYPE REF TO cl_gui_alv_grid,
       gt_fieldcat_grid    TYPE lvc_t_fcat,
       go_custom_container TYPE REF TO cl_gui_custom_container.

DATA: go_container2 TYPE REF TO cl_gui_container,
      go_salv2      TYPE REF TO cl_salv_table,
      go_message2   TYPE REF TO cx_salv_msg.


DATA: go_container1 TYPE REF TO cl_gui_container,
      go_salv1      TYPE REF TO cl_salv_table,
      go_message1   TYPE REF TO cx_salv_msg,
      go_events     TYPE REF TO cl_salv_events_table.
