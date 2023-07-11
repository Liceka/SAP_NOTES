*&---------------------------------------------------------------------*
*&  Include           Z_SMART_LBA_TOP
*&---------------------------------------------------------------------*

TABLES sscrfields.



DATA :

  gt_info    TYPE zt_lba,

  lv_fname   TYPE rs38l_fnam,         "Code du module fonction associé au smartform
  lv_sf_name TYPE tdsfname,           "Nom smartform

  ls_control TYPE ssfctrlop,
  ls_output  TYPE ssfcompop,
  getotf     TYPE tdgetotf,

  "FOR READ TEXT
  gv_vbeln   LIKE  thead-tdname,
  language   LIKE  thead-tdspras VALUE 'P',
  id         LIKE  thead-tdid VALUE '0002',
  object     LIKE  thead-tdobject VALUE 'VBBK',
  lines      TYPE TABLE OF tline.

 DATA gt_pdf_data TYPE solix_tab.

*TYPES: BEGIN OF zst_lba,
*        vbeln TYPE zst_lba-vbeln,
*        kunnr TYPE zst_lba-kunnr,
*        name1 TYPE zst_lba-name1,
*        stras TYPE zst_lba-stras,
*        pstlz TYPE zst_lba-pstlz,
*        ort01 TYPE zst_lba-ort01,
*        land1 TYPE zst_lba-land1,
*        landx TYPE zst_lba-landx,
*        posnr TYPE zst_lba-posnr,
*        arktx TYPE zst_lba-arktx,
*        kwmeng TYPE zst_lba-kwmeng,
*        netwr TYPE zst_lba-netwr,
*        cmwae TYPE zst_lba-cmwae,
*        total_netwr TYPE zst_lba-total_netwr,
*      END OF zst_lba.