
*&---------------------------------------------------------------------*
*&      Form  POPUP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM popup .

    *Pour afficher l''ALV avec la fenetre de ME23N
    
    *DATA : go_gos_manager TYPE REF TO cl_gos_manager,
    *       gw_borident    TYPE borident.
    *
    *
    *gw_borident-objtype = 'BUS2012'. "- (check ME23N)
    *gw_borident-objkey = p_ebeln. "- Numéro PO dans parameter
    *
    *CREATE OBJECT go_gos_manager
    *  EXPORTING
    *    is_object      = gw_borident
    *    ip_no_commit   = ' '
    *  EXCEPTIONS
    *    object_invalid = 1.
    *
    *WRITE: / 'Hello world - of GOS'.
    
    *cl_gos_manager is very useful to manage attachments on a report. It lets you upload and download files related any object inside your report. You can also take notes. Simple to use ;
    
    
    
    
    
      DATA : go_manager   TYPE REF TO cl_gos_manager,
             lp_no_commit TYPE        sgs_cmode,
             gp_service   TYPE        sgs_srvnam,
             gs_object    TYPE        borident.
    
      DATA  gs_bc_object TYPE sibflpor.
      DATA: gs_service_selection TYPE sgos_sels,
            gt_service_selection TYPE tgos_sels.
    
    *** go_manager related bor object and key
     " key field for ex. document no
     gs_object-objkey  = p_ebeln.
     " bor object that you created at swo1
      gs_object-objtype = 'BUS2012'.
    
      CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
        IMPORTING
          own_logical_system             = gs_object-logsys
        EXCEPTIONS
          own_logical_system_not_defined = 1
          OTHERS                         = 2.
    
    *** Which service we''re gonna use
    
    "" For Attaching Document
    *  gp_service = 'PCATTA_CREA'.
    "" Display and change documents
      gp_service = 'VIEW_ATTA'.
    
    *** Create Instance
      CREATE OBJECT go_manager
        EXPORTING
          ip_no_commit = lp_no_commit
          is_object    = gs_object.
    
    *** Start Service
      CALL METHOD go_manager->start_service_direct
        EXPORTING
          ip_service       = gp_service
          is_object        = gs_object
        EXCEPTIONS
          no_object        = 1
          object_invalid   = 2
          execution_failed = 3
          OTHERS           = 4.
    ENDFORM.
    
    
    
      FORM assign_object.
    *    gs_bc_object-catid = gs_lporb-catid = 'BO'.
        gs_object-objtype = gs_lporb-typeid.
        gs_object-objkey  = gs_lporb-instid.
    
    ENDFORM.                    "assign_object
    
    FORM open_archive_for_read .
    * data declaration
      CONSTANTS: archive_object LIKE arch_obj-object VALUE 'SOBL'.
    
      DATA: read_handle  LIKE sy-tabix,
            write_handle LIKE sy-tabix,
            l_errmsg TYPE string,
            lx_obl TYPE REF TO cx_obl,
            commit_cnt   LIKE sy-tabix,
            object_cnt   LIKE sy-tabix,
            buffer       TYPE arc_buffer,
            buffer_ref   TYPE REF TO data.
      DATA: lt_links TYPE obl_t_link,
            ls_lporb TYPE sibflporb.
    
      TRY.
          MOVE-CORRESPONDING gs_bc_object TO ls_lporb.
    
    
    * open a new archiving session to reload data
          CALL FUNCTION 'ARCHIVE_OPEN_FOR_READ'
            EXPORTING
    *   ARCHIVE_DOCUMENT         = '000000'
    *   ARCHIVE_NAME             = ' '
              object                   = archive_object
    *   MAINTAIN_INDEX           = ' '
            IMPORTING
              archive_handle           = read_handle
    * TABLES
    *   ARCHIVE_FILES            =
    *   SELECTED_FILES           =
            EXCEPTIONS
              file_already_open        = 1
              file_io_error            = 2
              internal_error           = 3
              no_files_available       = 4
              object_not_found         = 5
              open_error               = 6
              not_authorized           = 7
              OTHERS                   = 8
                    .
          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE 'A' NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
    
    * loop to get the next data object from the archive file(s)
          DO.
            CALL FUNCTION 'ARCHIVE_GET_NEXT_OBJECT'
              EXPORTING
                archive_handle          = read_handle
              EXCEPTIONS
                end_of_file             = 1
                file_io_error           = 2
                internal_error          = 3
                open_error              = 4
                wrong_access_to_archive = 5
                OTHERS                  = 6.
            CASE sy-subrc.
              WHEN 0.
    * do nothing
              WHEN 1.
    * reached end of file
                EXIT.
              WHEN OTHERS.
                MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
                        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
                EXIT.
            ENDCASE.
            CALL FUNCTION 'SOBL_ARCHIVE_READ_LINKS'
              EXPORTING
                archive_handle = read_handle
                is_object      = ls_lporb
              IMPORTING
                et_links       = lt_links.
            IF NOT lt_links[] IS INITIAL.
              EXIT.
            ENDIF.
          ENDDO.                                 "object loop
    
    ** close the archiving session
    *  CALL FUNCTION 'ARCHIVE_CLOSE_FILE'
    *    EXPORTING
    *      archive_handle          = read_handle
    *    EXCEPTIONS
    *      internal_error          = 1
    *      wrong_access_to_archive = 2
    *      OTHERS                  = 3.
    *  IF sy-subrc <> 0.
    *    MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
    *            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    *    EXIT.
    *  ENDIF.
        CATCH cx_obl INTO lx_obl.
          MESSAGE l_errmsg TYPE 'I'.
      ENDTRY.
    ENDFORM.
    *&---------------------------------------------------------------------*
    *&      Form  ALV
    *&---------------------------------------------------------------------*
    *       text
    *----------------------------------------------------------------------*
    *  -->  p1        text
    *  <--  p2        text
    *----------------------------------------------------------------------*
    
    
    FORM alv .
    
    
    
    DATA: go_handler TYPE REF TO lcl_commit_handler.
    
    
      gs_lporb-typeid = 'BUS2012'.
      gs_lporb-instid  = p_ebeln.
    *  gs_lporb-catid  = p_catid.
      PERFORM assign_object.
      CREATE OBJECT go_handler.
      SET HANDLER go_handler->on_commit_required FOR ALL INSTANCES.
      REFRESH gt_service_selection.
    *  LOOP AT p_ebeln.
    *    CLEAR gs_service_selection.
    *    MOVE-CORRESPONDING p_serv TO gs_service_selection.
    *    APPEND gs_service_selection TO gt_service_selection.
    *  ENDLOOP.
      gp_republish = 'X'.
    *  IF p_arch = 'X'.
    *    PERFORM open_archive_for_read.
    *  ENDIF.
    *  IF p_none = 'X'.
    *    CALL SCREEN 200.
    *  ELSE.
    *    CALL SCREEN 100.
    *  ENDIF.
    
    ENDFORM.
    
    
    
    
    *&---------------------------------------------------------------------*
    *&      Form  ALV2
    *&---------------------------------------------------------------------*
    *       text
    *----------------------------------------------------------------------*
    *  -->  p1        text
    *  <--  p2        text
    *----------------------------------------------------------------------*
    FORM alv2 .
    
    *  TRY.
    *CALL METHOD cl_binary_relation=>read_links
    *  EXPORTING
    *    is_object           =
    **    ip_logsys           =
    **    it_role_options     =
    **    it_relation_options =
    **    ip_no_buffer        = SPACE
    **  IMPORTING
    **    et_links            =
    **    et_roles            =
    *    .
    * CATCH cx_obl_parameter_error .
    * CATCH cx_obl_internal_error .
    * CATCH cx_obl_model_error .
    *ENDTRY.
    
    ENDFORM.