*&---------------------------------------------------------------------*
*& Report  Z_PALINDROME_LBA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

*1er exercice vérifier si le texte rentré dans le paramètre est un palindrome.


*2eme exercice (evolution du premier programe).
*
*ajouter un radio bouton sur le programme :
*o palindrome
*o verif chaine
*
*un seul parameter de saisie de chaine de caractère.
*
*Si c'est "vérif chaîne" qui est sélectionné,
*vérifier que la chaine de caractères est de ce type :
*"AIRCRAFT-XXXYY" avec XXX (3 à 5 chiffres quelconques et YY 2 Lettres quelconques)
*
*"AIRCRAFT-123AB" est correct
*"AIRCRAFT-1234AB" est correct
*"AIRCRAFT-12345AB" est correct

REPORT z_palindrome_lba.

INCLUDE z_palindrome_lba_top.
INCLUDE z_palindrome_lba_scr.
INCLUDE z_palindrome_lba_f01.

START-OF-SELECTION.

  IF p_palin IS NOT INITIAL.

    PERFORM palindrome.

  ELSE.

    PERFORM regex.

  ENDIF.