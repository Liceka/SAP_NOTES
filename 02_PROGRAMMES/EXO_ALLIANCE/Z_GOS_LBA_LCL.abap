*&---------------------------------------------------------------------*
*&  Include           Z_GOS_LBA_LCL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include
*&---------------------------------------------------------------------*

CLASS lcl_commit_handler DEFINITION .
    PUBLIC SECTION.
      DATA: gp_commit_required.
      METHODS: on_commit_required FOR EVENT commit_required OF cl_gos_service.
  ENDCLASS.                    "lcl_commit_handler DEFINITION
  
  
  CLASS lcl_commit_handler IMPLEMENTATION.
    METHOD on_commit_required.
      gp_commit_required = 'X'.
    ENDMETHOD.                    "lcl_commit_handler
  ENDCLASS.