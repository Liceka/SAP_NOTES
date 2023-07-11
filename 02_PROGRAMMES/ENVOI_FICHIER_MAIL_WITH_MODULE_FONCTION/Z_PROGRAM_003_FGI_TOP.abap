*&---------------------------------------------------------------------*
*&  Include           Z_PROGRAM_003_FGI_TOP
*&---------------------------------------------------------------------*

" DATA_RETRIEVE PERFORM
DATA: BEGIN OF gt_file_d OCCURS 0,
        rec(1000) TYPE c,
      END OF gt_file_d.

DATA:
  gv_file_d            LIKE LINE OF gt_file_d,
  v_excel_string(2000) TYPE c,
  gv_file_p            LIKE v_excel_string.

" DATA_CHECK PERFOM
DATA:
  gv_regex_pattern TYPE string VALUE '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  gv_receiv_email  TYPE abap_bool,
  gv_sender_email  TYPE abap_bool.

" DATA_SEND_API PERFORM
DATA:
  document_data LIKE sodocchgi1,
  packing_list  LIKE sopcklsti1 OCCURS 1 WITH HEADER LINE,
  receivers     LIKE somlreci1 OCCURS 1 WITH HEADER LINE,
  object_header LIKE solisti1 OCCURS 1 WITH HEADER LINE,
  contents_bin  LIKE solisti1 OCCURS 10 WITH HEADER LINE,
  contents_txt  LIKE solisti1 OCCURS 10 WITH HEADER LINE,
  txt_lines     TYPE i.

" DATA_SEND_BCS PERFORM
CONSTANTS:
  gc_subject     TYPE so_obj_des VALUE 'ABAP Email (attachment) with CL_BCS', " Email subject
  gc_email_to    TYPE adr6-smtp_addr VALUE 'frederic.giustini@alliance4u.fr', " Valid email
  gc_text        TYPE soli VALUE 'ABAP email with attachment with CL_BCS!', " Text used into the email body
  gc_type_raw    TYPE so_obj_tp VALUE 'RAW', " Email type
  gc_att_type    TYPE soodk-objtp VALUE 'PDF', " Attachment type
  gc_att_subject TYPE sood-objdes VALUE 'Document in PDF'. " Attachment title

DATA:
  gt_text           TYPE soli_tab, " Table which contains email body text
  gt_attachment_hex TYPE solix_tab, " Table which contains the attached file
  gv_sent_to_all    TYPE os_boolean, " Receive the information if email was sent
  gv_error_message  TYPE string, " Used to get the error message
  go_send_request   TYPE REF TO cl_bcs, " Email object
  go_recipient      TYPE REF TO if_recipient_bcs, " Who will receive the email
  go_sender         TYPE REF TO cl_sapuser_bcs, " Who is sending the email
  go_document       TYPE REF TO cl_document_bcs, " Email body
  gx_bcs_exception  TYPE REF TO cx_bcs,
  gt_binary_table   TYPE TABLE OF xstring,
  gv_string         TYPE string,
  gv_binary         TYPE solix_tab,
  gv_xstring        TYPE xstring.