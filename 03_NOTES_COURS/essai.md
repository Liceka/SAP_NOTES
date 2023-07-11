  CHECK lv_ebeln = <lfs_data>-ebeln and lv-ebelp = <lfs_data>-ebelp.
  CASE sy-subrc = 0.
    WHEN 'OSCAR'.
      CONTINUE.
    WHEN 'MAGALI'.
      WRITE : ls_zdriver.
    WHEN OTHERS.
      WRITE : 'Je roule en Allemande'.
  ENDCASE.





    CHECK lv_ebeln = <lfs_data>-ebeln and lv-ebelp = <lfs_data>-ebelp.
  if sy-subrc = 0.
  WRITE : / ls_ebeln not created

  else.
    WRITE : / ls_ebeln created.
endif.




  CHECK lv_ebeln = <lfs_data>-ebeln.
  CASE sy-subrc = 0.
    WHEN ls-ebelp = <lfs_data>-ebelp.
    WRITE : / ls_ebeln not created
      CONTINUE.
    WHEN OTHERS.
    APPEND ls_ekpo into lt_ekpo
      WRITE : / ls_ebeln write created.
  ENDCASE.

CHECK lv_ebeln = <lfs_data>-ebeln and lv_ebelp = <lfs_data>-ebelp.
CASE sy-subrc.
    WHEN 0.
    WRITE : / ls_ebeln not created
      CONTINUE.
    WHEN OTHERS.
    APPEND ls_ekpo into lt_ekpo
      WRITE : / ls_ebeln write created.
  ENDCASE.


<!-- IF <fs_data>-ebeln = lv_ebeln and lv_ebelp = <lfs_data>-ebelp
      CONTINUE.
    ENDIF.

    lv_id_com = <fs_data>-id_com.
    CHECK <fs_data>-doc_type IN lr_auart. -->
