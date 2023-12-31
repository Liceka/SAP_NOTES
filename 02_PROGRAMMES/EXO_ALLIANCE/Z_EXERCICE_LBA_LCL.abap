class ZCL_GOS_LBA definition
  public
  final
  create public .

public section.

  constants C_YES type CHAR1 value 'Y' ##NO_TEXT.
  constants C_NO type CHAR1 value 'N' ##NO_TEXT.
  constants C_INFINITY type DATS value '99991231' ##NO_TEXT.
  constants C_INITIAL_DATE type DATUM value '00000000' ##NO_TEXT.
  constants C_TRUE type XFELD value 'X' ##NO_TEXT.
  constants C_FALSE type XFELD value ' ' ##NO_TEXT.
  constants GC_TYPE_FILE type SO_OBJ_TP value 'EXT' ##NO_TEXT.
  constants GC_TYPE_ARL type SO_OBJ_TP value 'ARC' ##NO_TEXT.
  constants GC_TYPE_URL type SO_OBJ_TP value 'URL' ##NO_TEXT.
  constants GC_TYPE_NOTE type SO_OBJ_TP value 'RAW' ##NO_TEXT.
  class-data GS_LPORB type SIBFLPORB .

  class-methods GOS_GET_FILE_LIST
    importing
      !IS_LPORB type SIBFLPORB
    exporting
      !RT_MESSAGES type BAPIRETTAB
      !T_ATTACHMENTS type Z_TT_SOOD .
  class-methods GOS_DOWNLOAD_FILE_TO_GUI
    importing
      !FILE_PATH type CHAR100
      !ATTACHMENT type SOOD
    exporting
      !RT_MESSAGES type BAPIRETTAB .
  class-methods GOS_ATTACH_FILE_SOLITAB
    importing
      !IV_NAME type STRING
      !IV_CONTENT type STRING optional
      !IV_CONTENT_SOLITAB type SOLI_TAB optional
      !IS_LPORB type SIBFLPORB
      !IV_OBJTP type SO_OBJ_TP optional
      !IV_FILELENGTH type I
      !IV_OBJNAME type STRING
      !IV_EXT type STRING
    returning
      value(RT_MESSAGES) type BAPIRETTAB .
  class-methods GOS_EMAIL_ATTACHED_FILE
    importing
      !FOLDER_REGION type SO_FOL_RG
      !DOCTP type SO_OBJ_TP
      !DOCYR type SO_OBJ_YR
      !DOCNO type SO_OBJ_NO
      !T_RECEIVERS type Z_TT_SOMLRECI1
      !SEND_NOW type CHAR1 optional
    exporting
      value(RT_MESSAGES) type BAPIRETTAB .
  class-methods GOS_DELETE_FILE
    importing
      !FOLDER_REGION type SO_FOL_RG
      !DOCTP type SO_OBJ_TP
      !DOCYR type SO_OBJ_YR
      !DOCNO type SO_OBJ_NO
      !IS_LPORB type SIBFLPORB
    exporting
      !RT_MESSAGES type BAPIRETTAB .
  class-methods DISPLAY_ATTACHMENTS
    importing
      !IO_CONTAINER type ref to CL_GUI_CONTAINER .
  class-methods GET_BITEM
    importing
      value(IS_LPORB) type SIBFLPORB optional
    returning
      value(RO_BITEM) type ref to CL_SOBL_BOR_ITEM .
  class-methods SET_OBJECT
    importing
      !IS_LPORB type SIBFLPORB .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GOS_LBA IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_GOS_LBA=>DISPLAY_ATTACHMENTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_CONTAINER                   TYPE REF TO CL_GUI_CONTAINER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method DISPLAY_ATTACHMENTS.

        DATA:
      lo_bitem  TYPE REF TO CL_BROWSER_ITEM,
      ls_layout TYPE sgs_s_allo,
      go_attachments TYPE REF TO cl_gos_attachments,
      gp_mode TYPE sgs_rwmod VALUE 'D',
      gp_init_al TYPE c.

    ls_layout-no_title = 'X'.

    lo_bitem = get_bitem( ).
    TRY.
        IF gp_init_al = space.
          IF go_attachments IS INITIAL.
            CREATE OBJECT go_attachments
              EXPORTING
                io_object      = lo_bitem
                ip_check_arl   = 'X'
                ip_check_bds   = 'X'
                io_container   = io_container
                is_layout      = ls_layout
                ip_mode        = gp_mode
                ip_notes       = 'X'
                ip_attachments = 'X'
                ip_urls        = 'X'.
          ELSE.
            go_attachments->set_container( io_container ).
          ENDIF.
          go_attachments->display( ).
        ELSE.
          go_attachments->refresh( ).
        ENDIF.
        gp_init_al = 'X'.
      CATCH cx_gos_al_error cx_sobl_browser .
    ENDTRY.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_GOS_LBA=>GET_BITEM
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_LPORB                       TYPE        SIBFLPORB(optional)
* | [<-()] RO_BITEM                       TYPE REF TO CL_SOBL_BOR_ITEM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_BITEM.

        DATA:
      ls_borident TYPE borident,
      ls_lpor     TYPE sibflpor.

    IF is_lporb IS INITIAL.
      is_lporb = gs_lporb.
      CLEAR gs_lporb.
    ENDIF.

    CASE is_lporb-catid.
      WHEN 'BO'.
        ls_borident-objkey = is_lporb-instid.
        ls_borident-objtype = is_lporb-typeid.

        CREATE OBJECT ro_bitem TYPE cl_sobl_bor_item
          EXPORTING
            is_bor = ls_borident.
*      WHEN 'BC' OR 'CL'.
*        MOVE-CORRESPONDING is_lporb TO ls_lpor.
*        CREATE OBJECT ro_bitem TYPE cl_obl_bc_item
*          EXPORTING
*            is_lpor = ls_lpor.
    ENDCASE.

    IF gs_lporb IS INITIAL.
      gs_lporb = is_lporb.
    ENDIF.


  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_GOS_LBA=>GOS_ATTACH_FILE_SOLITAB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_NAME                        TYPE        STRING
* | [--->] IV_CONTENT                     TYPE        STRING(optional)
* | [--->] IV_CONTENT_SOLITAB             TYPE        SOLI_TAB(optional)
* | [--->] IS_LPORB                       TYPE        SIBFLPORB
* | [--->] IV_OBJTP                       TYPE        SO_OBJ_TP(optional)
* | [--->] IV_FILELENGTH                  TYPE        I
* | [--->] IV_OBJNAME                     TYPE        STRING
* | [--->] IV_EXT                         TYPE        STRING
* | [<-()] RT_MESSAGES                    TYPE        BAPIRETTAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GOS_ATTACH_FILE_SOLITAB.

    data: ls_message type bapiret2,
        filename type string,
        filefullname type string,
        mime_type type string,
        size type i,
        offset type i,
        offset_old type i,
        temp_len type i,
        objname type string,
        l_obj_type type so_obj_tp,
        hex_null type x length 1 value '20',
        l_document_title type so_text255,
        file_ext type string,
        lt_objcont type standard table of solisti1 initial size 6,
        objcont like line of lt_objcont,
        lt_ls_doc_change type standard table of sodocchgi1,
        ls_doc_change like line of lt_ls_doc_change,
        lt_data type soli_tab,
        ls_data type soli,
        lt_xdata type solix_tab,
        ls_xdata type solix,
        l_folder_id type sofdk,
        ls_object_id type soodk,
        l_object_id_fol type so_obj_id,
        l_object_id type so_obj_id,
        l_object_hd_change type sood1,
        l_tab_size type int4,
        l_retype type breltyp-reltype,
        lt_urltab type standard table of sood-objdes.

  call function 'SO_FOLDER_ROOT_ID_GET'
    exporting
      region    = 'B'
    importing
      folder_id = l_folder_id.

  if iv_objtp = gc_type_file.
    size = iv_filelength.

*    call method split_path
*      exporting
*        iv_path     = iv_name
*      importing
*        ev_filename = filename.
*
*    call method split_file_extension
*      exporting
*        iv_filename_with_ext = filename
*      importing
*        ev_filename          = objname
*        ev_extension         = file_ext.

    filename = iv_objname.
    objname = iv_objname.
    file_ext = iv_ext.

    ls_doc_change-obj_name = objname.
    ls_doc_change-obj_descr = objname.
    ls_doc_change-obj_langu = sy-langu.
    ls_doc_change-sensitivty = 'F'.
    ls_doc_change-doc_size = size.

    l_retype = 'ATTA'.
    l_obj_type = 'EXT'.

    l_object_hd_change-objnam = ls_doc_change-obj_name.
    l_object_hd_change-objdes = ls_doc_change-obj_descr.
    l_object_hd_change-objsns = ls_doc_change-sensitivty.
    l_object_hd_change-objla  = ls_doc_change-obj_langu.
    l_object_hd_change-objlen = ls_doc_change-doc_size.
    l_object_hd_change-file_ext = file_ext.

    data lt_obj_header type standard table of solisti1.
    data ls_header type solisti1.
    concatenate '&SO_FILENAME=' filename into ls_header.
    append ls_header to lt_obj_header.
    clear ls_header.
    ls_header = '&SO_FORMAT=BIN'.
    append ls_header to lt_obj_header.

    lt_data[] = iv_content_solitab[].
  else.
    size = strlen( iv_content ).
    objname = iv_name.

    ls_doc_change-obj_descr = objname.
    ls_doc_change-sensitivty = 'O'.
    ls_doc_change-obj_langu  = sy-langu.

    offset = 0.

    if iv_objtp = gc_type_note.
      l_retype = 'NOTE'.
      l_obj_type = 'RAW'.
      l_object_hd_change-file_ext = 'TXT'.

      while offset <= size.
        offset_old = offset.
        offset = offset + 255.
        if offset > size.
          temp_len = strlen( iv_content+offset_old ).
          clear ls_data-line.
          ls_data-line = iv_content+offset_old(temp_len).
        else.
          ls_data-line = iv_content+offset_old(255).
        endif.
        append ls_data to lt_data.
      endwhile.

      if objname is initial.
        read table lt_data index 1 into l_document_title.
        while l_document_title+49 <> ' '.
          shift l_document_title right.
        endwhile.
        shift l_document_title left deleting leading ' '.
        ls_doc_change-obj_descr = l_document_title.
      endif.
    else.
*     it's url (not note)
      l_retype = 'URL'.
      l_obj_type = 'URL'.

      if objname is initial.
        split iv_content at '/' into table lt_urltab.
        describe table lt_urltab lines l_tab_size.
        read table lt_urltab index l_tab_size into ls_doc_change-obj_descr.
      endif.

      while offset <= size.
        offset_old = offset.
        offset = offset + 250.
        if offset > size.
          temp_len = strlen( iv_content+offset_old ).
          clear ls_data-line.
          ls_data-line = iv_content+offset_old(temp_len).
        else.
          ls_data-line = iv_content+offset_old(250).
        endif.
        concatenate '&KEY&' ls_data-line into ls_data-line.
        append ls_data to lt_data.
      endwhile.
    endif.

    ls_doc_change-doc_size = size.

    l_object_hd_change-objdes = ls_doc_change-obj_descr.
    l_object_hd_change-objsns = ls_doc_change-sensitivty.
    l_object_hd_change-objla  = ls_doc_change-obj_langu.
    l_object_hd_change-objlen = ls_doc_change-doc_size.
  endif.

* save object
  call function 'SO_OBJECT_INSERT'
    exporting
      folder_id                  = l_folder_id
      object_hd_change           = l_object_hd_change
      object_type                = l_obj_type
    importing
      object_id                  = ls_object_id
    tables
      objcont                    = lt_data
      objhead                    = lt_obj_header
    exceptions
      component_not_available    = 01
      folder_not_exist           = 06
      folder_no_authorization    = 05
      object_type_not_exist      = 17
      operation_no_authorization = 21
      parameter_error            = 23
      others                     = 1000.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
    ls_message-type = sy-msgty.
    ls_message-id = sy-msgid.
    ls_message-number = sy-msgno.
    ls_message-message_v1 = sy-msgv1.
    ls_message-message_v2 = sy-msgv2.
    ls_message-message_v3 = sy-msgv3.
    ls_message-message_v4 = sy-msgv4.
    append ls_message to rt_messages.
    return.
  endif.

* create relation
  data l_obj_rolea type borident.
  data l_obj_roleb type borident.
  l_obj_rolea-objkey = is_lporb-instid.
  l_obj_rolea-objtype = is_lporb-typeid.
  l_obj_rolea-logsys = is_lporb-catid.

  l_object_id_fol  = l_folder_id.
  l_object_id = ls_object_id.
  concatenate l_object_id_fol l_object_id into l_obj_roleb-objkey respecting blanks.
  l_obj_roleb-objtype = 'MESSAGE'.
  clear l_obj_roleb-logsys.

  call function 'BINARY_RELATION_CREATE'
    exporting
      obj_rolea    = l_obj_rolea
      obj_roleb    = l_obj_roleb
      relationtype = l_retype
    exceptions
      others       = 1.
  if sy-subrc = 0.
    commit work and wait.
  else.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
    ls_message-type = sy-msgty.
    ls_message-id = sy-msgid.
    ls_message-number = sy-msgno.
    ls_message-message_v1 = sy-msgv1.
    ls_message-message_v2 = sy-msgv2.
    ls_message-message_v3 = sy-msgv3.
    ls_message-message_v4 = sy-msgv4.
    append ls_message to rt_messages.
    return.
  endif.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_GOS_LBA=>GOS_DELETE_FILE
* +-------------------------------------------------------------------------------------------------+
* | [--->] FOLDER_REGION                  TYPE        SO_FOL_RG
* | [--->] DOCTP                          TYPE        SO_OBJ_TP
* | [--->] DOCYR                          TYPE        SO_OBJ_YR
* | [--->] DOCNO                          TYPE        SO_OBJ_NO
* | [--->] IS_LPORB                       TYPE        SIBFLPORB
* | [<---] RT_MESSAGES                    TYPE        BAPIRETTAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GOS_DELETE_FILE.

    data: ex type ref to cx_root,
        text type string,
        l_folder_id type soodk,
        l_object_id type soodk,
        document_id type sofmk,
        lo_root type ref to cx_root,
        ls_fol_id type soodk,
        lwa_document_data type sofolenti1,
        document_content type standard table of soli,
        lwa_object_header type standard table of solisti1,
        l_document_id type swo_typeid,
        l_document_data type sofolenti1,
        lt_header type soli_tab,
        lv_message type bapiret2,
        lo_docsrv type ref to cl_gos_document_service.

  try.
      call function 'SO_FOLDER_ROOT_ID_GET'
        exporting
          region    = folder_region
        importing
          folder_id = ls_fol_id
        exceptions
          others    = 1.

      if sy-subrc eq 0.
        l_folder_id-objtp = ls_fol_id-objtp.
        l_folder_id-objyr = ls_fol_id-objyr.
        l_folder_id-objno = ls_fol_id-objno.

        l_object_id-objtp = doctp.
        l_object_id-objyr = docyr.
        l_object_id-objno = docno.

        call function 'SO_OBJECT_READ'
          exporting
            folder_id                  = l_folder_id
            object_id                  = l_object_id
          tables
            objcont                    = document_content
          exceptions
            active_user_not_exist      = 1
            communication_failure      = 2
            component_not_available    = 3
            folder_not_exist           = 4
            folder_no_authorization    = 5
            object_not_exist           = 6
            object_no_authorization    = 7
            operation_no_authorization = 8
            owner_not_exist            = 9
            parameter_error            = 10
            substitute_not_active      = 11
            substitute_not_defined     = 12
            system_failure             = 13
            x_error                    = 14
            others                     = 15.

        if sy-subrc eq 0.
          document_id-foltp = l_folder_id-objtp.
          document_id-folyr = l_folder_id-objyr.
          document_id-folno = l_folder_id-objno.
          document_id-doctp = l_object_id-objtp.
          document_id-docyr = l_object_id-objyr.
          document_id-docno = l_object_id-objno.

          l_document_id = document_id.

          create object lo_docsrv.
          case doctp.
            when gc_type_file.
              call method lo_docsrv->delete_attachment
                exporting
                  is_lporb      = is_lporb
                  ip_attachment = l_document_id.
            when gc_type_note.
              call method lo_docsrv->delete_note
                exporting
                  is_lporb = is_lporb
                  ip_note  = l_document_id.
            when gc_type_url.
              call method lo_docsrv->delete_url
                exporting
                  is_lporb = is_lporb
                  ip_url   = l_document_id.
          endcase.

          if sy-subrc = 0.
            commit work and wait.
          else.
            lv_message-id = sy-msgid.
            lv_message-number = sy-msgno.
            lv_message-message_v1 = sy-msgv1.
            lv_message-message_v2 = sy-msgv2.
            lv_message-message_v3 = sy-msgv3.
            lv_message-message_v4 = sy-msgv4.
            append lv_message to rt_messages.
            return.
          endif.
        endif.
      endif.
    catch cx_root into ex.
      lv_message-id = sy-msgid.
      lv_message-number = sy-msgno.
      lv_message-message_v1 = sy-msgv1.
      lv_message-message_v2 = sy-msgv2.
      lv_message-message_v3 = sy-msgv3.
      lv_message-message_v4 = sy-msgv4.
      append lv_message to rt_messages.
  endtry.


  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_GOS_LBA=>GOS_DOWNLOAD_FILE_TO_GUI
* +-------------------------------------------------------------------------------------------------+
* | [--->] FILE_PATH                      TYPE        CHAR100
* | [--->] ATTACHMENT                     TYPE        SOOD
* | [<---] RT_MESSAGES                    TYPE        BAPIRETTAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GOS_DOWNLOAD_FILE_TO_GUI.

 data: ex type ref to cx_root,
        text type string,
        ltp_sortfield type char30,
        lta_objcont type soli_tab,
        ltp_pathfile(1000) type c,
        ltp_filename type string,
        ltp_binfilesize type so_doc_len,
        ls_message type bapiret2.

  try .
      concatenate attachment-objtp attachment-objyr attachment-objno into ltp_sortfield.
      import objcont_tab to lta_objcont from database soc3(dt) id ltp_sortfield.

      if sy-subrc = 0.
        if not attachment-acnam is initial.
          concatenate file_path '\' attachment-objdes '.' attachment-acnam into ltp_pathfile.
        else.
          concatenate file_path '\' attachment-objdes '.' attachment-file_ext into ltp_pathfile.
        endif.

        replace '\\' with '\' into ltp_pathfile+2.
        translate ltp_pathfile using '/  '.

        ltp_binfilesize = attachment-objlen.

        call function 'SO_OBJECT_DOWNLOAD'
          exporting
            bin_filesize     = ltp_binfilesize
            filetype         = 'BIN'
            path_and_file    = ltp_pathfile
            extct            = attachment-extct
            no_dialog        = 'X'
          importing
            act_filename     = ltp_filename
          tables
            objcont          = lta_objcont
          exceptions
            file_write_error = 1
            invalid_type     = 2
            x_error          = 3
            kpro_error       = 4
            others           = 5.

        if sy-subrc <> 0.
          message id sy-msgid type sy-msgty number sy-msgno
                  with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
          ls_message-type = sy-msgty.
          ls_message-id = sy-msgid.
          ls_message-number = sy-msgno.
          ls_message-message_v1 = sy-msgv1.
          ls_message-message_v2 = sy-msgv2.
          ls_message-message_v3 = sy-msgv3.
          ls_message-message_v4 = sy-msgv4.
          append ls_message to rt_messages.
          return.
        endif.
      else.
        message id sy-msgid type sy-msgty number sy-msgno
                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
        ls_message-type = sy-msgty.
        ls_message-id = sy-msgid.
        ls_message-number = sy-msgno.
        ls_message-message_v1 = sy-msgv1.
        ls_message-message_v2 = sy-msgv2.
        ls_message-message_v3 = sy-msgv3.
        ls_message-message_v4 = sy-msgv4.
        append ls_message to rt_messages.
        return.
      endif.
    catch cx_root into ex.
      text = ex->get_text( ).

      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
      ls_message-type = sy-msgty.
      ls_message-id = sy-msgid.
      ls_message-number = sy-msgno.
      ls_message-message_v1 = sy-msgv1.
      ls_message-message_v2 = sy-msgv2.
      ls_message-message_v3 = sy-msgv3.
      ls_message-message_v4 = sy-msgv4.
      append ls_message to rt_messages.
      return.
  endtry.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_GOS_LBA=>GOS_EMAIL_ATTACHED_FILE
* +-------------------------------------------------------------------------------------------------+
* | [--->] FOLDER_REGION                  TYPE        SO_FOL_RG
* | [--->] DOCTP                          TYPE        SO_OBJ_TP
* | [--->] DOCYR                          TYPE        SO_OBJ_YR
* | [--->] DOCNO                          TYPE        SO_OBJ_NO
* | [--->] T_RECEIVERS                    TYPE        Z_TT_SOMLRECI1
* | [--->] SEND_NOW                       TYPE        CHAR1(optional)
* | [<---] RT_MESSAGES                    TYPE        BAPIRETTAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GOS_EMAIL_ATTACHED_FILE.

    data: ex type ref to cx_root,
        text type string,
        l_folder_id type soodk,
        l_object_id type soodk,
        document_id type sofmk,
        lo_root type ref to cx_root,
        ls_fol_id type soodk,
        l_document_id type so_entryid,
        lwa_document_data type sofolenti1,
        document_content type standard table of soli,
        lwa_object_header type standard table of solisti1,
        lwa_object_content type standard table of solisti1,
        lwa_object_content_1 type standard table of solisti1,
        lwa_contents_hex type standard table of solix,
        lt_plist type standard table of sopcklsti1,
        wa_lt_plist type sopcklsti1,
        wa_lwa_object_content_1 type solisti1,
        mailto type ad_smtpadr,
        document_content_solix type solix_tab,
        wa_object_header like line of lwa_object_header,
        send_request  type ref to cl_bcs,
        sent_to_all type os_boolean,
        document type ref to cl_document_bcs,
        doc_size type so_obj_len,
        recipient type ref to if_recipient_bcs,
        bcs_exception type ref to cx_bcs,
        ttext type bcsy_text,
        wa_t_receivers like line of t_receivers,
        moff type i,
        lt_url_tab type table of so_url,
        ld_url_tab_size type sytabix,
        fil_nm(50) type c,
        file_ext(3) type c,
        fil_nm_txt type so_obj_des,
        ls_message type bapiret2.

  try .
      call function 'SO_FOLDER_ROOT_ID_GET'
        exporting
          region    = folder_region
        importing
          folder_id = ls_fol_id
        exceptions
          others    = 1.

      if sy-subrc eq 0.
        l_folder_id-objtp = ls_fol_id-objtp.
        l_folder_id-objyr = ls_fol_id-objyr.
        l_folder_id-objno = ls_fol_id-objno.

        l_object_id-objtp = doctp.
        l_object_id-objyr = docyr.
        l_object_id-objno = docno.

        call function 'SO_OBJECT_READ'
          exporting
            folder_id                  = l_folder_id
            object_id                  = l_object_id
          tables
            objcont                    = document_content
          exceptions
            active_user_not_exist      = 1
            communication_failure      = 2
            component_not_available    = 3
            folder_not_exist           = 4
            folder_no_authorization    = 5
            object_not_exist           = 6
            object_no_authorization    = 7
            operation_no_authorization = 8
            owner_not_exist            = 9
            parameter_error            = 10
            substitute_not_active      = 11
            substitute_not_defined     = 12
            system_failure             = 13
            x_error                    = 14
            others                     = 15.

        if sy-subrc eq 0.
          document_id-foltp = l_folder_id-objtp.
          document_id-folyr = l_folder_id-objyr.
          document_id-folno = l_folder_id-objno.
          document_id-doctp = l_object_id-objtp.
          document_id-docyr = l_object_id-objyr.
          document_id-docno = l_object_id-objno.

          l_document_id = document_id.

          call function 'SO_DOCUMENT_READ_API1'
            exporting
              document_id                = l_document_id
            importing
              document_data              = lwa_document_data
            tables
              object_header              = lwa_object_header
              object_content             = lwa_object_content_1
              contents_hex               = lwa_contents_hex
            exceptions
              document_id_not_exist      = 1
              operation_no_authorization = 2
              x_error                    = 3
              others                     = 4.

          if sy-subrc eq 0.
            clear: send_request, document, recipient, sent_to_all, fil_nm_txt.

            try.
                read table t_receivers into wa_t_receivers index 1.

                mailto = wa_t_receivers-receiver.
                send_request = cl_bcs=>create_persistent( ).

                read table lwa_object_header into wa_object_header index 1.
                if sy-subrc eq 0.
                  find '=' in wa_object_header-line match offset moff.
                  add 1 to moff.
                  fil_nm = wa_object_header-line+moff.

                  split fil_nm at '.' into table lt_url_tab.
                  describe table lt_url_tab lines ld_url_tab_size.
                  if ld_url_tab_size gt 1.
                    read table lt_url_tab index ld_url_tab_size into file_ext.
                  else.
                    clear file_ext.
                  endif.
                endif.

                fil_nm_txt = fil_nm.

                if fil_nm_txt is initial.
                  fil_nm_txt = 'Requested File is Attached'.
                endif.

                append 'The file you requested file is attached.' to ttext.

                document = cl_document_bcs=>create_document(
                                i_type    = 'RAW'
                                i_text    = ttext
                                i_subject = fil_nm_txt ).

                call method document->add_attachment
                  exporting
                    i_attachment_type    = file_ext
                    i_attachment_subject = fil_nm
                    i_att_content_hex    = lwa_contents_hex
                    i_attachment_header  = lwa_object_header
                    i_attachment_size    = lwa_document_data-doc_size.

                send_request->set_document( document ).
                recipient = cl_cam_address_bcs=>create_internet_address( mailto ).
                send_request->add_recipient( recipient ).
                sent_to_all = send_request->send( i_with_error_screen = 'X' ).
              catch cx_bcs into bcs_exception.
                message i865(so) with bcs_exception->error_type.
            endtry.

            if sy-subrc eq 0.
              if send_now eq 'X'.
                submit rsconn01 with mode = 'INT' and return.
              endif.
            else.
              message id sy-msgid type sy-msgty number sy-msgno
                      with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
              ls_message-type = sy-msgty.
              ls_message-id = sy-msgid.
              ls_message-number = sy-msgno.
              ls_message-message_v1 = sy-msgv1.
              ls_message-message_v2 = sy-msgv2.
              ls_message-message_v3 = sy-msgv3.
              ls_message-message_v4 = sy-msgv4.
              append ls_message to rt_messages.
              return.
            endif.
            commit work.
          else.
            message id sy-msgid type sy-msgty number sy-msgno
                    with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
            ls_message-type = sy-msgty.
            ls_message-id = sy-msgid.
            ls_message-number = sy-msgno.
            ls_message-message_v1 = sy-msgv1.
            ls_message-message_v2 = sy-msgv2.
            ls_message-message_v3 = sy-msgv3.
            ls_message-message_v4 = sy-msgv4.
            append ls_message to rt_messages.
            return.
          endif.
        else.
          message id sy-msgid type sy-msgty number sy-msgno
                  with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
          ls_message-type = sy-msgty.
          ls_message-id = sy-msgid.
          ls_message-number = sy-msgno.
          ls_message-message_v1 = sy-msgv1.
          ls_message-message_v2 = sy-msgv2.
          ls_message-message_v3 = sy-msgv3.
          ls_message-message_v4 = sy-msgv4.
          append ls_message to rt_messages.
          return.
        endif.
      else.
        message id sy-msgid type sy-msgty number sy-msgno
                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
        ls_message-type = sy-msgty.
        ls_message-id = sy-msgid.
        ls_message-number = sy-msgno.
        ls_message-message_v1 = sy-msgv1.
        ls_message-message_v2 = sy-msgv2.
        ls_message-message_v3 = sy-msgv3.
        ls_message-message_v4 = sy-msgv4.
        append ls_message to rt_messages.
        return.
      endif.
    catch cx_root into ex.
      text = ex->get_text( ).

      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
      ls_message-type = sy-msgty.
      ls_message-id = sy-msgid.
      ls_message-number = sy-msgno.
      ls_message-message_v1 = sy-msgv1.
      ls_message-message_v2 = sy-msgv2.
      ls_message-message_v3 = sy-msgv3.
      ls_message-message_v4 = sy-msgv4.
      append ls_message to rt_messages.
      return.
  endtry.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_GOS_LBA=>GOS_GET_FILE_LIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_LPORB                       TYPE        SIBFLPORB
* | [<---] RT_MESSAGES                    TYPE        BAPIRETTAB
* | [<---] T_ATTACHMENTS                  TYPE        Z_TT_SOOD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GOS_GET_FILE_LIST.

     types: begin of ts_key,
           foltp type so_fol_tp,
           folyr type so_fol_yr,
           folno type so_fol_no,
           objtp type so_obj_tp,
           objyr type so_obj_yr,
           objno type so_obj_no,
           forwarder type so_usr_nam,
         end of ts_key,

         begin of ts_attachment,
          foltp type so_fol_tp,
          folyr type so_fol_yr,
          folno type so_fol_no,
          objtp type so_obj_tp,
          objyr type so_obj_yr,
          objno type so_obj_no,
          brelguid type oblguid32,
          roletype type oblroltype,
         end of ts_attachment,

         tt_attachment type table of ts_attachment.
  data: ta_srgbtbrel type standard table of srgbtbrel,
        wa_srgbtbrel type srgbtbrel,
        lta_sood type standard table of sood,
        lwa_sood type sood, ltp_pathin(1000) type c,
        ltp_filename type string,
        ltp_sortfield type char30,
        lta_objcont type soli_tab,
        lta_attachments type tt_attachment,
        lwa_attachments like line of lta_attachments,
        lo_boritem type ref to cl_sobl_bor_item,
        lo_al_item type ref to cl_gos_al_item,
        li_link type ref to if_browser_link,
        ls_option type obl_s_relt,
        lt_options type obl_t_relt,
        ls_key type ts_key,
        ls_attachment type ts_attachment,
        lt_attachment type tt_attachment,
        lt_links type obl_t_link,
        ls_link  type obl_s_link,
        lp_linkid type blnk_inst,
        gs_lpor type sibflporb,
        ls_message type bapiret2.

  if not is_lporb-typeid is initial and not is_lporb-instid is initial.
    select * from srgbtbrel into table ta_srgbtbrel
      where instid_a eq is_lporb-instid
       and typeid_a eq is_lporb-typeid
       and catid_a  eq 'BO'.

    if sy-subrc eq 0.
      sort ta_srgbtbrel by instid_a typeid_a catid_a.
      delete adjacent duplicates from ta_srgbtbrel comparing instid_a typeid_a catid_a.

      loop at ta_srgbtbrel into wa_srgbtbrel.
        clear: lt_attachment[], lta_attachments[].

        gs_lpor-instid = wa_srgbtbrel-instid_a.
        gs_lpor-typeid = wa_srgbtbrel-typeid_a.
        gs_lpor-catid  = wa_srgbtbrel-catid_a.

        ls_option-sign = 'I'.
        ls_option-option = 'EQ'.

        ls_option-low = 'ATTA'.
        append ls_option to lt_options.
        ls_option-low = 'NOTE'.
        append ls_option to lt_options.
        ls_option-low = 'URL'.
        append ls_option to lt_options.

        try.
            call method cl_binary_relation=>read_links_of_binrels
              exporting
                is_object           = gs_lpor
                it_relation_options = lt_options
                ip_role             = 'GOSAPPLOBJ'
              importing
                et_links            = lt_links.

            loop at lt_links into ls_link.
              case ls_link-typeid_b .
                when 'MESSAGE'.
                  ls_key = ls_link-instid_b.
                  move-corresponding ls_key to ls_attachment.
                  ls_attachment-roletype = ls_link-roletype_b.
                  if ls_link-brelguid is initial.
                    ls_attachment-brelguid = ls_link-relguidold.
                  else.
                    ls_attachment-brelguid = ls_link-brelguid.
                  endif.
                  append ls_attachment to lt_attachment.
                when others.
                  continue.
              endcase.
            endloop.
          catch cx_obl_parameter_error .
          catch cx_obl_internal_error .
          catch cx_obl_model_error .
          catch cx_root.
        endtry.
      endloop.

      lta_attachments[] = lt_attachment[].
      check lines( lta_attachments ) > 0.

      select * from sood into table lta_sood
        for all entries in lta_attachments
        where
          objtp = lta_attachments-objtp  and
          objyr = lta_attachments-objyr  and
          objno = lta_attachments-objno.
      if sy-subrc eq 0.
        t_attachments[] = lta_sood.
      endif.

      data rcode type i.
      data objhead_tab type table of soli.
      data objcont_tab type table of soli.
      data objpara_tab type table of selc.
      data objparb_tab type table of soop1.
      data sood_key type soodk.
      data hex_mode type sonv-flag.
      field-symbols <fs> type line of z_tt_sood.

      loop at t_attachments assigning <fs>.
        if not ( <fs>-objtp is initial or <fs>-objyr is initial or <fs>-objno is initial ).
          concatenate <fs>-objtp <fs>-objyr <fs>-objno into sood_key.

          perform socx_select in program sapfsso0
                              tables objhead_tab objcont_tab
                                     objpara_tab objparb_tab
                              using  sood_key
                                     hex_mode
                                     rcode.
          if rcode eq 0.
            data moff type i.
            data l_param_search type soli-line.
            data l_param_head type soli-line.
            data value type soli-line.
            data wa_objhead_tab like line of objhead_tab.
            data lt_url_tab type table of so_url.
            data ld_url_tab_size type sytabix.
            l_param_search = '&SO_FILENAME'.
            translate l_param_search to upper case.
            loop at objhead_tab into wa_objhead_tab.
              clear moff.
              find '=' in wa_objhead_tab-line match offset moff.
              check sy-subrc = 0.
              l_param_head = wa_objhead_tab-line(moff).
              translate l_param_head to upper case.
              if l_param_head = l_param_search.
                add 1 to moff.
                value = wa_objhead_tab-line+moff.
                if not ( value is initial ).
                  split value at '.' into table lt_url_tab.
                  describe table lt_url_tab lines ld_url_tab_size.
                  if ld_url_tab_size gt 1.
                    read table lt_url_tab index ld_url_tab_size into <fs>-acnam.
                  endif.
                endif.
              endif.
            endloop.
          endif.
        endif.
      endloop.
    else.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
      ls_message-type = sy-msgty.
      ls_message-id = sy-msgid.
      ls_message-number = sy-msgno.
      ls_message-message_v1 = sy-msgv1.
      ls_message-message_v2 = sy-msgv2.
      ls_message-message_v3 = sy-msgv3.
      ls_message-message_v4 = sy-msgv4.
      append ls_message to rt_messages.
      return.
    endif.
  else.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 into ls_message-message.
    ls_message-type = sy-msgty.
    ls_message-id = sy-msgid.
    ls_message-number = sy-msgno.
    ls_message-message_v1 = sy-msgv1.
    ls_message-message_v2 = sy-msgv2.
    ls_message-message_v3 = sy-msgv3.
    ls_message-message_v4 = sy-msgv4.
    append ls_message to rt_messages.
    return.
  endif.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_GOS_LBA=>SET_OBJECT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_LPORB                       TYPE        SIBFLPORB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method SET_OBJECT.

        DATA:
      go_attachments TYPE REF TO cl_gos_attachments,
      go_outbox TYPE REF TO cl_gos_outbox,
      go_relations  TYPE REF TO cl_gos_relations,
      lo_bitem TYPE REF TO cl_browser_item.

    IF is_lporb = gs_lporb.
      RETURN.
    ELSE.
      gs_lporb = is_lporb.
      lo_bitem = get_bitem( ).

      TRY.
          IF NOT go_attachments IS INITIAL.
            CALL METHOD go_attachments->refresh( lo_bitem ).
          ENDIF.
          IF NOT go_relations IS INITIAL.
            CALL METHOD go_relations->refresh( lo_bitem ).
          ENDIF.
          IF NOT go_outbox IS INITIAL.
            CALL METHOD go_outbox->refresh( lo_bitem ).
          ENDIF.
        CATCH cx_gos_al_error cx_sobl_browser.
      ENDTRY.
    ENDIF.

    gs_lporb = is_lporb.

  endmethod.
ENDCLASS.