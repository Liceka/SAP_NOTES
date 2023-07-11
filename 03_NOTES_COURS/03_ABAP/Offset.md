LV_NAME = 'KEVIN'

LV_NAME +2(3)     (va afficher VIN)
LV_NAME (3)         (va afficher KEV)

Exemple pour mettre la date du jour dans le bon ordre :

```ABAP
DATA : lv_date  TYPE string,

  lv_date = sy-datum. "AAAAMMJJ  20230302

 CONCATENATE sy_datum+6(2) sy_datum+4(2) sy_datum(4) INTO lv_date SEPARATED BY '.'.

  write : lv_date.
```