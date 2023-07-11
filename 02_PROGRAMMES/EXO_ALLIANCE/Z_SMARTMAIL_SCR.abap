*&---------------------------------------------------------------------*
*&  Include           Z_SMART_LBA_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN : BEGIN OF BLOCK b.


SELECTION-SCREEN SKIP. "Pour sauter une ligne

PARAMETERS  p_vbeln TYPE vbak-vbeln DEFAULT '17789' OBLIGATORY.

PARAMETERS: p_radio1 RADIOBUTTON GROUP rb USER-COMMAND fcode DEFAULT 'X'.
PARAMETERS: p_radio2 RADIOBUTTON GROUP rb.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN : END OF BLOCK b.




SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.


SELECTION-SCREEN SKIP 2. "Pour sauter une ligne

SELECTION-SCREEN PUSHBUTTON 33(10) lb1 USER-COMMAND pb1 MODIF ID sc2.


SELECTION-SCREEN : END OF BLOCK b1.



SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(17) text-003 FOR FIELD p_rad1 MODIF ID sc1.
PARAMETERS: p_rad1 RADIOBUTTON GROUP rb1 USER-COMMAND fcode DEFAULT 'X' MODIF ID sc1.
PARAMETERS: p_file TYPE vbak-vbeln DEFAULT '17789' MODIF ID sc1.
SELECTION-SCREEN PUSHBUTTON 66(9) lb2 USER-COMMAND pb2 MODIF ID sc1.
SELECTION-SCREEN END OF LINE.


SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(17) text-004 FOR FIELD p_rad2 MODIF ID sc1.
PARAMETERS: p_rad2 RADIOBUTTON GROUP rb1 MODIF ID sc1.
PARAMETERS: p_recevr TYPE so_recname      OBLIGATORY DEFAULT 'lisa.bagues@alliance4u.fr' MODIF ID sc1.
SELECTION-SCREEN PUSHBUTTON 66(9) lb3 USER-COMMAND pb3 MODIF ID sc1.
SELECTION-SCREEN END OF LINE.


SELECTION-SCREEN END OF BLOCK b2.


AT SELECTION-SCREEN.

  CASE sscrfields.
    WHEN 'PB1'.
      PERFORM select_data.

      IF gt_info IS NOT INITIAL.
        PERFORM call_smartform.
        PERFORM preview_smartform.
      ELSE.
        MESSAGE : 'No data found' TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.

    WHEN 'PB2'.
      IF p_rad1 = 'X'.
        PERFORM select_data.
           IF gt_info IS NOT INITIAL.
              PERFORM call_smartform.
*              PERFORM add_attachments.
              PERFORM add_attachment.
           ELSE.
              MESSAGE : 'No data found' TYPE 'I' DISPLAY LIKE 'E'.
           ENDIF.

      ENDIF.


    WHEN 'PB3'.
      IF p_rad2 = 'X'.
        PERFORM select_data.

       IF gt_info IS NOT INITIAL.
         PERFORM call_smartform.
         PERFORM send_email.
       ELSE.
         MESSAGE : 'No data found' TYPE 'I' DISPLAY LIKE 'E'.
        ENDIF.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.

    IF p_radio1 = 'X' AND screen-group1 = 'SC1'.
      screen-active = 0.
      MODIFY SCREEN.
    ELSEIF p_radio2 = 'X' AND screen-group1 = 'SC2'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.

  ENDLOOP.

  LOOP AT SCREEN.

    IF screen-name = 'P_FILE'.
      IF p_rad1 IS NOT INITIAL.
        screen-input  = 1.
      ELSE.
        screen-input  = 0.
      ENDIF.
      MODIFY SCREEN.

    ELSEIF screen-name = 'P_RECEVR'.
      IF p_rad2 IS NOT INITIAL.
        screen-input = 1.
      ELSE.
        screen-input  = 0.
      ENDIF.
      MODIFY SCREEN.

    ENDIF.

  ENDLOOP.