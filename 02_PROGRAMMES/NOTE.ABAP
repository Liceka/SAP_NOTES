METHOD on_double_click.

    CALL METHOD handle_user_command( cl_browser=>gc_dblclick ).
  
  ENDMETHOD.


  METHOD handle_user_command.
    DATA:
        l_processed TYPE c,
        lt_bitem TYPE bitem_t.
  
  
    CALL METHOD get_selected_items
      IMPORTING
        et_bitem = lt_bitem
        .
  
    l_processed = process_browser_commands(
      ip_ucomm = e_ucomm
      it_selection = lt_bitem ).
  
    CHECK l_processed NE 'X' AND NOT go_cmd_handler IS INITIAL.
  
    CALL METHOD go_cmd_handler->execute_items_cmd(
            it_bitem = lt_bitem
            ip_cmd = e_ucomm ).
  
  ENDMETHOD.

  METHOD get_selected_items.

    DATA:
      ls_row TYPE lvc_s_roid,
      lt_rows TYPE lvc_t_roid,
      lo_bitem TYPE REF TO cl_browser_item.
  
    FIELD-SYMBOLS:
      <l_objref> TYPE REF TO object,
      <l_line> TYPE ANY,
      <lt_outtab> TYPE table.
  
    CALL METHOD go_alv_grid->get_selected_rows
      IMPORTING
        et_row_no = lt_rows
        .
  * remove header line:
  
    DELETE lt_rows WHERE row_id EQ 0.
    CHECK NOT lt_rows IS INITIAL.
  
  
    ASSIGN gr_outtab->* TO <lt_outtab>.
    ASSIGN gr_outtab_line->* TO <l_line>.
  
  
    ASSIGN COMPONENT cl_list_settings=>gc_objref OF STRUCTURE <l_line>
      TO <l_objref>.
  
    LOOP AT lt_rows INTO ls_row.
  
      READ TABLE <lt_outtab> INTO <l_line> INDEX ls_row-row_id
        TRANSPORTING (cl_list_settings=>gc_objref).
  
      CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
        lo_bitem ?= <l_objref>.
        APPEND lo_bitem TO et_bitem.
      ENDCATCH.
  
    ENDLOOP.
  
  ENDMETHOD.

  method IF_ALV_RM_GRID_BRIDGE~INVOKE_METHOD.
    me->r_alv_controller->dispatch( s_method_signature = value ).
  endmethod.

  method if_salv_grz_controller~dispatch.

    data: l_update           type abap_bool,
          l_exception_number type sysubrc.
    
      mac_task_begin c_task-dispatch space.
      call_level = call_level + 1.
    
    * call method / perform action
      if s_method_signature is supplied.
    *   call method
        mac_task_begin_data c_task-call_method s_method_signature-methodname s_method_signature.
        me->actual_method_signature = s_method_signature.
        l_update = abap_false.
        case s_method_signature-classname.
        when if_alv_rm_grid_bridge=>c_classname-cl_gui_alv_grid.
          call method me->(s_method_signature-methodname)
                          parameter-table s_method_signature-t_ptab
                          exception-table s_method_signature-t_etab.
          l_exception_number = sy-subrc.
          if l_exception_number <> 0 and  s_method_signature-t_etab is not initial.
            clear me->actual_method_signature.
            mac_task_end_data c_task-call_method s_method_signature.
            call_level = call_level - 1.
            mac_task_end c_task-dispatch.
            raise exception type cx_salv_grx_nc_meth_exception
                                 exporting exception_number = l_exception_number.
          endif.
          case s_method_signature-methodname.
          when if_alv_rm_grid_bridge=>c_methodname-soft_refresh_table_display or
               if_alv_rm_grid_bridge=>c_methodname-set_fixed_cols.
            l_update = me->update_immediately( ).
          when if_alv_rm_grid_bridge=>c_methodname-set_html_header or
               if_alv_rm_grid_bridge=>c_methodname-display_graphics.
            l_update = abap_true.
          endcase.
        when others.
          assert 1 = 2.
        endcase.
        clear me->actual_method_signature.
        mac_task_end_data c_task-call_method s_method_signature.
      else.
    *   action (fcode)
        me->perform_action( action ).
        l_update = me->update_immediately( ).
      endif.
    
    * update frontend if needed
      if call_level > 1 and l_update = abap_true.           "recursive call with update frontend
        l_update = abap_false.                              "delay update frontend
        update_delayed = abap_true.
      elseif call_level = 1 and update_delayed = abap_true. "after recursive call with update frontend
        l_update = abap_true.                               "call delayed update
        update_delayed = abap_false.
      endif.
      if l_update = abap_true.
        me->update_frontend( ).
      endif.
    
      call_level = call_level - 1.
      mac_task_end c_task-dispatch.
    
    endmethod.

    method log_task_begin.

        data: l_task        type salv_csqt_task,
              l_log_text    type salv_csqt_log_text,
              lr_recordable type ref to if_salv_csq_recordable.
      
        l_task = i_task.
      
        if i_text is supplied.
          l_log_text = i_text.
        endif.
      
        if i_data is supplied.
          if me->r_log->get_trace_level( ) = if_salv_csq_log=>c_trace_level-logging.
            lr_recordable = cl_salv_csq_log=>create_recordable_object( i_data ).
          endif.
        endif.
        me->r_log->log_task_begin( task       = l_task
                                   log_text   = l_log_text
                                   recordable = lr_recordable ).
      
      endmethod.

      method if_salv_csq_log~log_task_begin.

        check p_session-is_trace_active = true
            or p_break_point-is_break_point_active = true.
      
        data ls_log_record type if_salv_csq=>ys_log_data.
        ls_log_record-component = me->component.
        ls_log_record-tool = me->class.
        ls_log_record-instance = me->instance_handle.
        ls_log_record-task = task.
        ls_log_record-log_text = log_text.
        ls_log_record-record_type = if_salv_csq=>c_record_type-task_begin.
      
        if p_session-is_trace_active = true.
          p_session-r_trace_db->write_record(
              s_log_data = ls_log_record
              recordable = recordable ).
        endif.
      
        " keep call stack,
        " because correct "active task instance" is relevant for break points
        append ls_log_record to pt_call_stack.
      
        " break if relevant
        break_point( ls_log_record ).
      
      endmethod.

      method log_task_begin.

        data: l_task        type salv_csqt_task,
              l_log_text    type salv_csqt_log_text,
              lr_recordable type ref to if_salv_csq_recordable.
      
        l_task = i_task.
      
        if i_text is supplied.
          l_log_text = i_text.
        endif.
      
        if i_data is supplied.
          if me->r_log->get_trace_level( ) = if_salv_csq_log=>c_trace_level-logging.
            lr_recordable = cl_salv_csq_log=>create_recordable_object( i_data ).
          endif.
        endif.
        me->r_log->log_task_begin( task       = l_task
                                   log_text   = l_log_text
                                   recordable = lr_recordable ).
      
      endmethod.

      method if_salv_grz_controller~dispatch.

        data: l_update           type abap_bool,
              l_exception_number type sysubrc.
        
          mac_task_begin c_task-dispatch space.
          call_level = call_level + 1.
        
        * call method / perform action
          if s_method_signature is supplied.
        *   call method
            mac_task_begin_data c_task-call_method s_method_signature-methodname s_method_signature.
            me->actual_method_signature = s_method_signature.
            l_update = abap_false.
            case s_method_signature-classname.
            when if_alv_rm_grid_bridge=>c_classname-cl_gui_alv_grid.
              call method me->(s_method_signature-methodname)
                              parameter-table s_method_signature-t_ptab
                              exception-table s_method_signature-t_etab.
              l_exception_number = sy-subrc.
              if l_exception_number <> 0 and  s_method_signature-t_etab is not initial.
                clear me->actual_method_signature.
                mac_task_end_data c_task-call_method s_method_signature.
                call_level = call_level - 1.
                mac_task_end c_task-dispatch.
                raise exception type cx_salv_grx_nc_meth_exception
                                     exporting exception_number = l_exception_number.
              endif.
              case s_method_signature-methodname.
              when if_alv_rm_grid_bridge=>c_methodname-soft_refresh_table_display or
                   if_alv_rm_grid_bridge=>c_methodname-set_fixed_cols.
                l_update = me->update_immediately( ).
              when if_alv_rm_grid_bridge=>c_methodname-set_html_header or
                   if_alv_rm_grid_bridge=>c_methodname-display_graphics.
                l_update = abap_true.
              endcase.
            when others.
              assert 1 = 2.
            endcase.
            clear me->actual_method_signature.
            mac_task_end_data c_task-call_method s_method_signature.
          else.
        *   action (fcode)
            me->perform_action( action ).
            l_update = me->update_immediately( ).
          endif.
        
        * update frontend if needed
          if call_level > 1 and l_update = abap_true.           "recursive call with update frontend
            l_update = abap_false.                              "delay update frontend
            update_delayed = abap_true.
          elseif call_level = 1 and update_delayed = abap_true. "after recursive call with update frontend
            l_update = abap_true.                               "call delayed update
            update_delayed = abap_false.
          endif.
          if l_update = abap_true.
            me->update_frontend( ).
          endif.
        
          call_level = call_level - 1.
          mac_task_end c_task-dispatch.
        
        endmethod.