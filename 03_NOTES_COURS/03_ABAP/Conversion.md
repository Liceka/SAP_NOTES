# Pour que SAP reconnaisse l'unité qui n'est pas universelle
Car l'unité du fichier n'est pas au même format que l'unité dans SAP donc il faut la convertir au bon format

Aller dans SE16N, sur la bonne table, Activer la vue technique dans onglets "autres fonctions"
Dans la colonne "EXIT DE CONVERTION", s'il y a un champs, double cliquer dessu pour regarder le nom des modules fonctions. 

On peut tester/exécuter le module foncion dans SE37 pour vérifier ce qui marche ou pas.

Ensuite, on appele le module fonction dans le programme avec l'onglet "modèle"

Exemple dans le projet intermédiaire :

```ABAP
LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<fs_data2>)
      WHERE id_com = <fs_data>-id_com.
      ls_item-itm_number = <fs_data2>-itm_numb.
      ls_item-material = <fs_data2>-material.
      ls_item-plant = <fs_data2>-plant.
      ls_item-target_qty =  <fs_data2>-quantity.

      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
        EXPORTING
          input          = <fs_data2>-quantity_unit
          language       = sy-langu
        IMPORTING
          output         = <fs_data2>-quantity_unit
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.

        ls_item-target_qu = <fs_data2>-quantity_unit.

        APPEND ls_item TO lt_item.

        ls_itemx-itm_number = 'X'.
        ls_itemx-material = 'X'.
        ls_itemx-plant = 'X'.
        ls_itemx-target_qty =  'X'.
        ls_itemx-target_qu = 'X'.
        ls_itemx-updateflag = 'I'.

        APPEND ls_itemx TO lt_itemx.

      ENDLOOP.
```
