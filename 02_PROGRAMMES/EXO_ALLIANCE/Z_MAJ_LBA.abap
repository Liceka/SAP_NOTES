*&---------------------------------------------------------------------*
*& Report  Z_MAJ_LBA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*


*Programme qui permet de mettre à jour un champ spécifique dans une commande client (VA02).
*Dans un rapport ALV, l'utilisateur pourra modifier la valeur du champ "Order Reason".
*Le bouton SAVE permettra de mettre à jour la SO
* Après l'exécution du programme, afficher les valeurs mises à jour dans un rapport ALV.
*Dans ce rapport ALV, ajouter un champ "Message" pour indiquer que le Sales Order (SO) a été mis à jour.

REPORT Z_MAJ_LBA NO STANDARD PAGE HEADING..


INCLUDE Z_MAJ_LBA_TOP.
INCLUDE Z_MAJ_LBA_LCL.
INCLUDE Z_MAJ_LBA_SCR.
INCLUDE Z_MAJ_LBA_F01.

INITIALIZATION.

  PERFORM data_initialization.

START-OF-SELECTION.


*PERFORM select_data.
call screen 100.




END-OF-SELECTION.