*----------------------------------------------------------------------*
***INCLUDE Z_EXO_LBA_LCL.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&       Class LCL_CLASS_HANDLER
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*

*Classes utilisées pour le cliq sur le bouton EXPORT

CLASS lcl_class_handler DEFINITION.

    public section.
      methods:
        on_user_command for event added_function of cl_salv_events
          importing e_salv_function.
  
  ENDCLASS.
  *&---------------------------------------------------------------------*
  *&       Class (Implementation)  LCL_CLASS_HANDLER
  *&---------------------------------------------------------------------*
  *        Text
  *----------------------------------------------------------------------*
  CLASS lcl_class_handler IMPLEMENTATION.
    method on_user_command.
      perform export_alv using e_salv_function text-i08.
    endmethod.
  ENDCLASS.               "LCL_CLASS_HANDLER