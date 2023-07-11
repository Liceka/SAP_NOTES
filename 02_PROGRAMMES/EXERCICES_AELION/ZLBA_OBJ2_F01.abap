*&---------------------------------------------------------------------*
*& Include          ZLBA_OBJ2_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form create_personne
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_personne .

    DATA : lo_personne TYPE REF TO zcl_personne_lba,
           lv_identite TYPE string.
  
    CREATE OBJECT lo_personne.
    lo_personne->nom = 'BIMBAM'.
    lo_personne->prenom = 'BOUM'.
  
    lv_identite = lo_personne->nom && | | && lo_personne->prenom.
  
    WRITE : / lv_identite.
  
  
  
  ENDFORM.
  
  
*&---------------------------------------------------------------------*
*& Form create_personne2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
  FORM create_personne2 .
  
    DATA : lo_personne TYPE REF TO zcl_personne_lba,
           lv_identite TYPE string.
  
    CREATE OBJECT lo_personne.
  *  lo_personne->nom = 'BIMBAM'.
  *  lo_personne->prenom = 'BOUM'.
  
    lv_identite = lo_personne->get_identite( ).
  
    WRITE : / lv_identite.
  
  
  
  
  
  
  
  ENDFORM.
  
  
  *&---------------------------------------------------------------------*
  *& Form create_personne3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM create_personne3 .
  
    DATA : lo_personne  TYPE REF TO zcl_personne_lba,
           lo_employee  TYPE REF TO zcl_personne_lba,
           lv_identite  TYPE string,
           lv_identite2 TYPE string.
  
  
  *Création de l objet personne
    CREATE OBJECT lo_personne.
  *  lo_personne->nom = 'BIMBAM'.
  *  lo_personne->prenom = 'BOUM'.
  
    lv_identite = lo_personne->get_identite( ).
  
  
  
  *Création de l objet employée
    CREATE OBJECT lo_employee.
  
    lv_identite2 = lo_employee->get_identite( ).
  
    WRITE : lv_identite.
    WRITE : lv_identite2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form create_personne4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM create_personne4 .
  
  *  DATA : lo_consultant TYPE REF TO zcl_employee_consultant_lba,
  *         lo_manager    TYPE REF TO zcl_employee_manager_lba,
  *         lv_intitule   TYPE string,
  *         lv_intitule2  TYPE string.
  *
  **Création de l objet employée consultant
  *  CREATE OBJECT lo_consultant.
  *
  *  lo_consultant->nom = 'TACO'.
  *  lo_consultant->prenom = 'TAC'.
  *
  **  lv_intitule = lo_consultant->get_identite( )  && | : | &&  lo_consultant->get_nom_metier( ).
  * lv_intitule  = lo_consultant->get_intitule( ).
  *
  *
  *
  **Création de l objet employée manager
  *  CREATE OBJECT lo_manager.
  *
  *  lo_manager->nom = 'BLABLI'.
  *  lo_manager->prenom = 'BLABLA'.
  *
  **  lv_intitule2 = lo_manager->get_identite( )  && | : | &&  lo_manager->get_nom_metier( ).
  *    lv_intitule2  = lo_manager->get_intitule( ).
  *
  *  WRITE : lv_intitule.
  *  SKIP.
  *  WRITE : lv_intitule2.
  
  
  
  
  * TYPAGE DYNAMIQUE : On déclara lo_employéé TYPE REF TO la classe mère et quand on crée l objet, on TYPE de la classe fille.
  * Cette méthode évite de déclarer 2 objets.
  
    DATA : lo_employee  TYPE REF TO zcl_employee_lba,
           lv_intitule  TYPE string,
           lv_intitule2 TYPE string.
  
  *Création de l objet employée consultant
    CREATE OBJECT lo_employee TYPE zcl_employee_consultant_lba.
  
    lo_employee->nom = 'TACO'.
    lo_employee->prenom = 'TAC'.
  
  *  lv_intitule = lo_consultant->get_identite( )  && | : | &&  lo_consultant->get_nom_metier( ).
    lv_intitule  = lo_employee->get_intitule( ).
  
  
  
  *Création de l objet employée manager
    CREATE OBJECT lo_employee TYPE zcl_employee_manager_lba.
  
    lo_employee->nom = 'BLABLI'.
    lo_employee->prenom = 'BLABLA'.
  
  *  lv_intitule2 = lo_manager->get_identite( )  && | : | &&  lo_manager->get_nom_metier( ).
    lv_intitule2  = lo_employee->get_intitule( ).
  
    WRITE : lv_intitule.
    SKIP.
    WRITE : lv_intitule2.
  
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form event
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM event .
  
    DATA : lo_employee  TYPE REF TO zcl_employee_lba,
           lv_intitule  TYPE string,
           lv_intitule2 TYPE string.
  
  *Création de l objet employée consultant
    CREATE OBJECT lo_employee TYPE zcl_employee_consultant_lba.
  
    lo_employee->nom = 'TACO'.
    lo_employee->prenom = 'TAC'.
  
    SET HANDLER lo_employee->handle_employee_hired FOR lo_employee.
  
  *  lv_intitule = lo_consultant->get_identite( )  && | : | &&  lo_consultant->get_nom_metier( ).
    lv_intitule  = lo_employee->get_intitule( ).
    WRITE : lv_intitule.
  
  **Création de l objet employée manager
  *  CREATE OBJECT lo_employee TYPE zcl_employee_manager_lba.
  *
  *  lo_employee->nom = 'BLABLI'.
  *  lo_employee->prenom = 'BLABLA'.
  *
  **  lv_intitule2 = lo_manager->get_identite( )  && | : | &&  lo_manager->get_nom_metier( ).
  *    lv_intitule2  = lo_employee->get_intitule( ).
  *
  *  WRITE : lv_intitule.
  *  SKIP.
  *  WRITE : lv_intitule2.
  *
  **  RAISE EVENT employee_hired.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form create_mammifere
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM create_mammifere .
  
    DATA : lo_mammifere TYPE REF TO zcl_mammifere_lba.
  
    CREATE OBJECT lo_mammifere.
    lo_mammifere->zif_action_animal_lba~manger( ).
    lo_mammifere->av_qte_nourriture = p_qte.
  
    lo_mammifere->zif_action_animal_lba~manger( ).
  
  
  
    lo_mammifere->ZIF_ACTION_ANIMAL_LBA~SE_REPRODUIRE( ).
  
    WRITE : lo_mammifere->AV_ENFANT->get_poids( ).
  
  
    IF 1 = 1.
    ENDIF.
  
  ENDFORM.