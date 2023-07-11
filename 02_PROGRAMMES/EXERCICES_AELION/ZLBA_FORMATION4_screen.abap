*&---------------------------------------------------------------------*
*& Include          ZLBA_FORMATION4_SCR
*&---------------------------------------------------------------------*

*L’utilisateur souhaite disposer des critères de sélection suivants :
*-  Le numéro de livraison avec possibilité de saisir plusieurs numéros (critère obligatoire)
*-  Le numéro d’article avec possibilité de saisir plusieurs numéros
*-  La division de l’article avec possibilité de saisir plusieurs numéros
*-  Le numéro de facture avec possibilité de saisir plusieurs numéros
*-  Une case à cocher lui permettant d’afficher ou non les articles supprimés (un des champs de la table MARA vous donnera cette information)

select-options : s_vbeln for likp-vbeln obligatory.
select-options : s_matnr for lips-matnr.
select-options : s_werks for lips-werks.
select-options : s_vbelnf for vbrk-vbeln.

PARAMETERS : p_suppr  AS CHECKBOX.