*&---------------------------------------------------------------------*
*&  Include           Z_SMART_LBA_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.


SELECTION-SCREEN SKIP. "Pour sauter une ligne

PARAMETERS  p_vbeln TYPE vbak-vbeln DEFAULT '17789' OBLIGATORY.

SELECTION-SCREEN SKIP 2. "Pour sauter une ligne

SELECTION-SCREEN PUSHBUTTON 33(10) lb1 USER-COMMAND pb1.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN : END OF BLOCK b1.


AT SELECTION-SCREEN.

  CASE sscrfields.
    WHEN 'PB1'.
      PERFORM select_data.
    WHEN OTHERS.
  ENDCASE.