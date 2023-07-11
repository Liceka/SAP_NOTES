*&---------------------------------------------------------------------*
*&  Include           Z_PALINDROME_LBA_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  PALINDROME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM palindrome .

    g_input = p_input .
    CONDENSE g_input NO-GAPS.
    
    *IF p_palin IS NOT INITIAL.
    
    CALL FUNCTION 'STRING_REVERSE'
    EXPORTING
    string = g_input
    lang = sy-langu
    IMPORTING
    RSTRING = g_rev
     EXCEPTIONS
     TOO_SMALL = 1
     OTHERS = 2
    .
    
    IF g_input EQ g_rev.
    
    WRITE : g_input, 'est un palindrome'.
    
    ELSE .
    
    WRITE : g_input, 'n''est pas un palindrome'.
    
    ENDIF.
    
    ENDFORM.
    *&---------------------------------------------------------------------*
    *&      Form  REGEX
    *&---------------------------------------------------------------------*
    *       text
    *----------------------------------------------------------------------*
    *  -->  p1        text
    *  <--  p2        text
    *----------------------------------------------------------------------*
    FORM regex .
    
      g_input = p_input .
    CONDENSE g_input NO-GAPS.
    
    
    *The predicate function matches compares a search range of the argument text,
    *defined using off and len, with the regular expression specified in regex.
    
      IF matches( val = g_input regex = g_compare ).
        WRITE 'Good name'.
      ELSE.
        WRITE 'Not good name, try again !'.
      ENDIF.
    
    
    
    ENDFORM.