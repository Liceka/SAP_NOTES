*A ecrire dans [initialisation du code] de l'interface de l'adobe 
*pour faire afficher l'image sur le formulaire

data iv_image_name TYPE TDOBNAME VALUE 'ALLIANCE'.

 CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
    EXPORTING
      p_object       = 'GRAPHICS' ##NOTEXT
      p_name         = iv_image_name
      p_id           = 'BMAP' ##NOTEXT
      p_btype        = 'BCOL' ##NOTEXT                          " ‘BCOL’ for color, ‘BMON’ for Black & White
    RECEIVING
      p_bmp          = gv_logo
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.

  IF sy-subrc <> 0.
*     Si logo non trouvé en couleur, recherche en noir et blanc
    CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
      EXPORTING
        p_object       = 'GRAPHICS' ##NOTEXT
        p_name         = iv_image_name
        p_id           = 'BMAP' ##NOTEXT
        p_btype        = 'BMON' ##NOTEXT
      RECEIVING
        p_bmp          = gv_logo
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
  ENDIF.