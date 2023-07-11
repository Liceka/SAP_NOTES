*&---------------------------------------------------------------------*
*&  Include           Z_PALINDROME_LBA_TOP
*&---------------------------------------------------------------------*

DATA : g_input(50) TYPE c,
       g_rev(50) TYPE c,
       g_compare(50) TYPE c VALUE 'AIRCRAFT-\d{3,5}[A-Z]{2}'.
* variable qui compare "AIRCRAFT-" le \ veut dire "à partir de là", il faut 3 à 5 décimales \d{3,5}
* puis des lettres majuscules les 2 autres postions.