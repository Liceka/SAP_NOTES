# User Exit : *Ajouter du code dans le code standard*

Le code dans les user-exit restent lors de mises à jour de SAP, quels que soit le type des user_exit. 


## - User Exit :
Aller dans la transaction et trouver le nom du programme en bas à droite.

Ouvrir le programme en se80.

 Exercice :
 Vérifier le montant de la commande au moment où elle est sauvegardée, contrôler que le montant ne dépasse pas 10000e, si plus de 10000; mettre un message.

 Trouver le user exit correspondant sur le programme dans les objets puis [userexit...] [modif] [insérer]

## - Exits de fonction :

Sans le code, les brèches laissées par SAP s'appellent les "Call customer-fonction"

Le code est rangé dans des modules fonction

Transaction CMOD pour créer projet d extensions et pouvoir faire des exits fonctions

Transaction SMOD : gestion des extensions

On peut désactiver l'extension sans devoir désactiver le code pour résoudre un prb par ex.

 

 Dans le débeug, créer point d'arret intruction ABAP "call customer-fonction" et il va s'arreter à chaque fois qu'il rencontre l'exit fonction.

## - Exits de MENU

## - Exits d'ECRAN

## - Exits de TABLE

## - Point d'extension *Point Enhancement*

Disponible à partir de la version ECC6

Endroit pour incruster une logique de code, explicites ou implicites

Dans programme :
[Traiter]

[Opération d'extension]

[afficher]

Se mettre fans la zone Enhancement puis cliq sur Etendre (spirale)
Puis créer une implémentation sur le point d'extension


## - BADI *Businnes Add-in*

Visibles en SE18

Exemple de badi : ME_PROCESS_PO_CUST

Une BADI est une autre version du user-exit, c'est la vesion OBJET du user-exit. 

Créer différentes implémentations.

SE18

Afficher la badi
[Implémentation]
[Créer]
[ZLBA...]
[Donner une désignation]
[Sauvegarder]
[Petite feuille blanche]
[Donner un nom Z...]
[Désignation]
[Valider]

SE19 pour voir les implémentations.