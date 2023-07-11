*&---------------------------------------------------------------------*
*& Include          ZLBA_BATCH_INPUT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form batch_input
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM batch_input .

    * Pour avoir les informations du champs, simuler la manip dans la transaction (ici MM01) et faire F1 sur la case,
    * puis onglet information technique.
      PERFORM BDC_dynpro  USING 'SAPLMGMM' '0060'. " using : nom du programe et nom du dynpro utilisé
      PERFORM BDC_field   USING 'BDC_CURSOR' 'RMMG1_REF-MATNR'. " On ajoute REF car c'est l'article de référence
      " Sur l'écran 0060, place le curseur sur le champs Article (pour prendre en modèlé,
      " càd qu'il va copier les infos de l'article pour éviter de remplir les infos
      PERFORM BDC_field   USING 'RMMG1_REF-MATNR' 'MZ-FG-C900'. " Dans le champs où le curseur est placé, entre la valeur MZ
      PERFORM BDC_field   USING 'BDC_CURSOR' 'RMMG1-MBRSH'. " Sur l'écran 0060, place le curseur sur le champs 'Branche'
      PERFORM BDC_field   USING 'RMMG1-MBRSH' 'M'. " Dans le champs où le curseur es placé, entre la valeur M (Construction mécanique)
      PERFORM BDC_field   USING 'BDC_CURSOR' 'RMMG1-MTART'. " Sur l'écran 0060, place le curseur sur le champs 'Type Article'
      PERFORM BDC_field   USING 'RMMG1-MTART' 'FERT'. " Dans le champs où le curseur es placé, entre la valeur FERT (Produit fini)
      PERFORM BDC_field   USING 'BDC_OKCODE' '=ENTR'. " Clique pour valider
    
    * Pour récupérer le okcode, on peut débeugger avant de simuler le cliq, si on peut pas avec /H, on drop le fichier de Kevin
    * Dans le débeugger, on écrit ok-code pour voir ce qu il affiche
    
    
      PERFORM BDC_dynpro  USING 'SAPLMGMM' '0070'. " using : nom du programe et nom du dynpro utilisé
      PERFORM BDC_field   USING 'BDC_CURSOR' 'MSICHTAUSW-DYTXT'. " Met toi sur le champs "selectionne tout"
      PERFORM BDC_field   USING 'BDC_OKCODE' '=SELA'. " Clique pour sélectionner toutes les lignes
      PERFORM BDC_dynpro  USING 'SAPLMGMM' '0070'. " using / nom du programe et nom du dynpro utilisé
      PERFORM BDC_field   USING 'BDC_OKCODE' '=ENTR'. " Clique pour valider
    
    
      PERFORM BDC_dynpro  USING 'SAPLMGMM' '0080'. " using : nom du programe et nom du dynpro utilisé
      PERFORM BDC_field   USING 'BDC_CURSOR' 'RMMG1-WERKS'. " Met toi sur le champs "Division"
      PERFORM BDC_field   USING 'BDC_OKCODE' '=ENTR'. " Clique pour valider
    
      PERFORM BDC_dynpro  USING 'SAPLMGMM' '4004'. " using : nom du programe et nom du dynpro utilisé
      PERFORM BDC_field   USING 'BDC_OKCODE' '=BU'. " Clique pour enregistrer
    
    
    
      CALL TRANSACTION 'MM01' USING bdctab MODE 'E'. "Utilise la transaction des créations des articles MM01 avec les éléments de la table BDCTAB
    *  Il montrera ce qu'il se passe que s'il y a des erreurs
    
    ENDFORM.
    *&---------------------------------------------------------------------*
    *& Form BDC_dynpro
    *&---------------------------------------------------------------------*
    *& text
    *&---------------------------------------------------------------------*
    *& -->  p1        text
    *& <--  p2        text
    *&---------------------------------------------------------------------*
    FORM BDC_dynpro USING program dynpro.
    
      CLEAR bdctab.
    
      bdctab-program = program.
      bdctab-dynpro = dynpro.
      bdctab-dynbegin = 'X'.
    
      APPEND bdctab.
    
    
    
    ENDFORM.
    *&---------------------------------------------------------------------*
    *& Form BDC_field
    *&---------------------------------------------------------------------*
    *& text
    *&---------------------------------------------------------------------*
    *& -->  p1        text
    *& <--  p2        text
    *&---------------------------------------------------------------------*
    FORM BDC_field USING fnam fval.
    
      CLEAR bdctab.
      bdctab-fnam = fnam.
      bdctab-fval = fval.
      APPEND bdctab.
    
    ENDFORM.