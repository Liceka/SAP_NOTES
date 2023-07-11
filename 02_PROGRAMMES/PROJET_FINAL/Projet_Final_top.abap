*&---------------------------------------------------------------------*
*& Include          Z_POEC_INTEG_LBA_TOP
*&---------------------------------------------------------------------*

TYPES: BEGIN OF ts_line,
         line TYPE string,
       END OF ts_line.


TYPES: BEGIN OF ty_data,

  EBELN TYPE EBELN,
  BSTYP TYPE BSTYP,
  AEDAT TYPE AEDAT,
  ERNAM TYPE ERNAM,
  WAERS TYPE WAERS,
  EBELP TYPE EBELP,
  MATNR TYPE MATNR,
  WERKS TYPE WERKS_D,
  MENGE TYPE BSTMG,
  NETPR TYPE BPREI,
  NETWR TYPE BWERT,
  MEINS TYPE BSTME,

       END OF ty_data.

DATA : gt_file TYPE STANDARD TABLE OF ts_line,
       gt_data TYPE TABLE OF ty_data.