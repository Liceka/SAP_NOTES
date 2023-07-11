Permet de lire et modifier le contenu en même temps. Il n'occupe pas un espace mémoire.

ASSIGNING FIELD-SYMBOL (<fs_….>)

On utilise un field-symbol quand on est sur de récupérer des éléments car il ne marchera pas si la valeur est nulle. Le programme va planter. 

Sinon on peut changer le contenu de la structure mais en changeant la structure ça ne change pas en même temps le contenu de la table donc il faut rajouter une ligne pour changer le contenu de la table.

Ne pas utiliser un field symbol si on est pas sur qu'il est affecté à une valeur, sinon il faut soit ajouter IF SY-SUBRC = 0 
OU
IF ...ASSIGNING

Quand on déclare une table ou une structure, ca reserve automatique l'espace maximal nécessaire pour 
chacun des champs de cette table ou de cette structure (c'est pour ca que lorsqu'on ne veut récupérer que 
deux champs dans une table, on type une structure uniquement avec ces deux champs) et ca nous oblige à 
faire un append ls_structure to It_table. 

Quand on utilise un FS, non seulement ca pointe l'espace mémoire déjà réservé par la table interne sans 
réserver un nouvel espace mémoire. Ca permet donc de pointer (nom du FS dans d'autres langages 
pointeur) directement l'espace mémoire déjà occupé par la table interne donc moins d'espace occupé 
(meilleur performance) mais en plus ca permet de modifier directement les valeurs de la zone pointée 
sans faire d'append (modification à la volée). 