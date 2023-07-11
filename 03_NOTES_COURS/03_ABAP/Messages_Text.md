 ```ABAP
  IF sy-subrc = 0. "j'ai trouvé les articles
    MESSAGE TEXT-001 TYPE 'S'. " le S veut dire Succes
  ELSE.
    MESSAGE TEXT-002 TYPE 'I'. 
"je n'ai pas trouvé les articles type 'E' veut dire Erreur donc le programme s'arrête
  ENDIF.  



IF sy-subrc <> 0. "je n'ai pas trouvé les numéro de livraison
    MESSAGE TEXT-001 TYPE 'E'. " type 'E' veut dire Erreur donc le programme s'arrête
  ENDIF.

  "ou en utilisant check (qui sert de if et exit en meme temps) le check quitte le tiroir et non le programme. 
  "Du coup il va continuer les autres tiroirs.
  check sy-subrc = 0.
```

On peut aussi faire des messageS dans la base de donnée dans [SE91] pour que ce soit utilisé dans plusieurs programmes.

Il faut rentrer une classe de messages (en commençant par Z) (ici ZKDE_MESS)
[Créer]
Puis [désignation] 
Puis [enregistrer] en objet local

On peut aussi faire la traduction dans "[saut]" pour l'écrire en plusieurs langues.

 ```ABAP
IF sy-subrc <> 0. "je n'ai pas trouvé les numéro de livraison
    MESSAGE e000 (ZKDE_MESS). "(le e pour erreur, i pour information, s pour succes)
ENDIF.
 ```

On peut aussi mettre & dans le message et le & va être remplacé par le nom de la variable :

 ```ABAP
Ex : MESSAGE e000 (ZKDE_MESS) with lv_liv.
 ```

Ce qui est dans le with va remplacer le & dans le message

On peut aussi mettre &1 &2 &3... SI on veut remplacer plusieurs mots. Les mettre dans l'ordre dans le WITH

Pour créer une fenêtre pop-up avec un message créé dans SE91 :

```ABAP
SELECT COUNT(*) FROM zdriver_car_kde  INTO lv_count.

  IF sy-subrc = 0.
    MESSAGE i002(zkde_mess) WITH lv_count.
    endif.
```   
