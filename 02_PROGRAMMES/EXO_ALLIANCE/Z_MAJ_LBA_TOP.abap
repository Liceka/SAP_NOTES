*&---------------------------------------------------------------------*
*&  Include           Z_MAJ_LBA_TOP
*&---------------------------------------------------------------------*

*TABLES : vbak.

TYPES : BEGIN OF ty_init,
          vbeln TYPE vbak-vbeln,
          posnr TYPE vbap-posnr,
          abgru TYPE vbap-abgru,
        END OF ty_init.

DATA: gt_outtab TYPE TABLE OF ty_init,
      gt_old TYPE SORTED TABLE OF ty_init WITH NON-UNIQUE KEY vbeln posnr abgru.



DATA: ok_code            LIKE sy-ucomm,
      save_ok            LIKE sy-ucomm,
      g_container        TYPE scrfname VALUE 'BCALV_GRID_0100_CONT1',
      g_grid             TYPE REF TO cl_gui_alv_grid,
      g_custom_container TYPE REF TO cl_gui_custom_container,
      gt_fieldcat        TYPE lvc_t_fcat,
      gs_layout          TYPE lvc_s_layo,
      g_max              TYPE i VALUE 100.

* local class to handle semantic checks
CLASS lcl_event_receiver DEFINITION DEFERRED.

DATA: g_event_receiver TYPE REF TO lcl_event_receiver.

TYPES : BEGIN OF ty_rapport,
          vbeln TYPE vbak-vbeln,
          posnr TYPE vbap-posnr,
          abgru TYPE vbap-abgru,
          mess TYPE string,
        END OF ty_rapport.

DATA : gt_rapport TYPE TABLE OF ty_rapport,
      gs_rapport LIKE LINE OF gt_rapport.