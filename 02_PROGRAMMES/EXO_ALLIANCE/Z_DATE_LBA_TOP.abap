*&---------------------------------------------------------------------*
*&  Include           Z_DATE_LBA_TOP
*&---------------------------------------------------------------------*

TYPES : BEGIN OF ty_type,
          vbeln TYPE vbak-vbeln,
          posnr TYPE vbap-posnr,
          edatu TYPE vbep-edatu,
          etenr TYPE vbep-etenr,
          tddat TYPE vbep-tddat,
          mbdat TYPE vbep-mbdat,
          lddat TYPE vbep-lddat,
          wadat TYPE vbep-wadat,

        END OF ty_type.

DATA :gt_type TYPE TABLE OF ty_type,
      gt_new TYPE TABLE OF ty_type,
      gs_type LIKE LINE OF gt_type,
      gs_new LIKE LINE OF gt_new.

DATA : gv_date TYPE vbep-edatu.