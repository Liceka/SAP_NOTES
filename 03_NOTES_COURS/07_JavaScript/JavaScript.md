# JAVASCRIPT: *.Les bases*

>"EXERCICES DANS LE FICHIER JS_Exercice_correction"
>Développeur.mozilla.org : site avec les objets standards

Comment fonctionne le web ?

Intégration du code : HTML/CSS
Interprétation du code : JAVASCRIPT

Serveur avec lien (url) et le serveur amène les données chez le client

Permet de dynamiser une page statique

alert("Hello");
Va faire apparêtre une popup avec Hello
Quand on met consol.log : affiche dans la page

Finir les instructions avec ; mais ce n'est pas obligatoire, on peut faire des espaces et des entrées pour aérer le texte
Par contre, il faut repsecter une insctruction par ligne

 ## 1. Les variables

Déclaration avec « let » ou « const »

Possibilité d’opérations sur les valeurs

Attention: JavaScript est sensible à la casse.
variable n’est pas égal à vAriAbLe.

Les variables ne sont pas typés

Possibilité d’assigner n’importe quel valeur à une variable

Les variables ne peuvent pas avoir de charactères spéciaux, il accepte les lettres et les _ 

```js
let x, y, z;
x = 1, y = 2;
z = x + y;
```

```js
let x;
x = 1; 
x = "Hello World";
```

```js
let x, y;
x = 1, y = 2;
z = x + y;
console.log(x, y, z); //Va retourner les valeurs 1 2 3
```

Types de variables :

- Nombre (number) : const x = 1.1;
- Booléen (boolean) : const x = true;
- Texte (string) : const x = "Texte";
- Objet (object) : const x = {
    					nom: "Pons",
					};
- Liste (array) : const x = [
    				0, 1, "a", null
					];

 ## 2. Les opérations :

Addition ( + )
Soustraction ( - )
Multiplication ( * )
Division ( / )
Modulo ( % )

```js
const x = 5, y = 2;
console.log(x + y); //Va retourner 7
console.log(x - y); //Va retourner 3
console.log(x * y); //Va retourner 10
console.log(x / y); //Va retourner 2.5
console.log(x % y); //Va retourner 2
```
```js
let x = 5, y = 2;
x += y; //veut dire x = x+y
x -= y;
x *= y;
x /= y;
x %= y;
x++; 
x--; 
```

## 3. Comparaisons :

Egal ( == )
Diffèrent ( != )
Inverse ( ! )
Supérieur ( > )
Inférieur ( < )
Supérieur ou égal ( >= )
Inférieur ou égal ( <= )

```js
const x = 5, y = 2;
console.log(x == y); //Va retourner false
console.log(x != y); //Va retourner true
console.log(!true); //Va retourner false
console.log(x > y); //Va retourner false
console.log(x < y); //Va retourner false
```
## 4. Conditions

if(condition), else ou else if

Si la condition renvoie « true », on exécute le bloc juste en dessous entre {}.


```js
const x = 2, y = 2;
if(x > y)
{
    console.log("X est plus grand que Y");
}
else if(x == y)
{
    console.log("X et Y sont égaux");
}
else
{
    console.log("X est plus petit que Y");
}

```


```js
const x = 1, y = 5;
				if(x < y)
				{
					alert("Bonjour")
				}
```                

S'il y a beaucoup d'options, on fait un SWITCH.
Quand on commence à accumuler beaucoup d’options pour une même condition, lire et maintenir if/else devient compliqué.
L’instruction « break » est obligatoire avant de passer à un autre « case »

```js
switch(prompt("Choisir un nombre"))
{   
	case "1":
        console.log("Option 1");
        break;
	case "4":   
	case "5":
        console.log("Option 2");
        break;
		case "8":
        console.log("Option 3");
        break;
    default:
        break;
}
``` 



## 5. BOUCLE (for LOOP) :

L’instruction « for » est composée de 3 parties, séparé par des « ; » :
	for(initialisation; condition; mise à jour)

- La première est exécutée une seule fois au début de la boucle.
- La deuxième vérifie la condition, si elle est vraie, on rentre dans le bloc de code juste en dessous.
- Une fois le bloc de code terminé, on exécute la troisième partie, puis on repart sur la deuxième partie.

```js
const x = 3;
debugger;
for(let i = 1; i <= x; i++)
{
    console.log("Itération " + i + " de la boucle.");
}
``` 

Pour visualiser une boucle, on ajoute le mot-clé « debugger; » au début de notre code.
La console de développeur s’arrête sur l’instruction « debugger ».

Boucle à l'envers :
```js
const x = 3;
for(let i = x - 1; i >= 0; i--)
{
    console.log("Itération " + i + " de la boucle.");
}
```

La boucle while est bien plus simple et également plus dangereuse.
Si la condition est mal définie, l’onglet va se bloquer.

```js
const x = 3;
let i = 0;
while(i < x)
{
    console.log("Itération " + i + " de la boucle.");    
	i++;
}
```

## 6. LES FONCTIONS :

Un bloc de code appelable n’importe quand.
Peut recevoir des arguments pour faire varier le comportement de la fonction.
peut renvoyer une valeur.

```js
function ecrisXFois(texte, qte)
{    
	for(let i = 0; i < qte; i++)
    {
        console.log(texte);
    }
}
```
ecrisXFois("Texte", 3)
RESULTAT :
Texte
Texte
Texte

```js
function demandeNombre(texte)
{    
	const valeur = prompt(texte);
    const nombre = parseFloat(valeur);
    if(isNaN(nombre))
        throw new Error("Le texte saisi n’est pas un nombre valide");
		else
        return nombre;
}
```
## 6. LES TABLEAUX :

Constitué de cases
Chaque case peut recevoir n’importe quel valeur
Accessible par son index
Un tableau commence à l’index 0
La propriété length donne la taille du tableau

```js
const x = [
	    15, 12, 8, 16, 12
		];

console.log(x[0]); //RENVOI 15
console.log(x.length); //RENVOI 5
```

Ajout d’une valeur à la fin avec la fonction push
```js
const x = [
	    15, 12, 8, 16, 12
		];
x.push(19);

```

.push() Ajoute à la fin du tableau
.pop() Supprime la dernière entrée du tableau
.sort() Trie le tableau
.map() Renvoie un tableau modifié
.forEach() Boucle sur chaque entrée du tableau


Pour parcourir chaque élément du tableau :

```js
const x = [15, 12, 8, 16, 12];
for(let i = 0; i < x.length; i++)
{
    const element = x[i];
	   console.log(element);
}
```
```js
const x = [15, 12, 8, 16, 12];
x.forEach(function(element)
		{
	    console.log(element);
		});
```

<!-- function range(min, max) p.46 
Renvoie un tableau avec tout les nombres compris entre le min et le max avec un intervalle de 1. -->

```js
function range(min,mac,step = 1)
{
		if(step <=0);
		throw new Error ("L'intervalle doit être positif");

		let tableau = [];
		for(let i = min; i <= max; i += step)

		{
			tableau.push(i);
		}
			return tableau;
		
}
```

function somme_alea(liste) p.47

## 6. LES OBJETS :

Possibilité de déclarer des « objets »
Contient des « propriétés »
Non typés

Accès via un chemin
On utilise « . » ou « [] » pour accéder aux propriétés
Un objet peut contenir un objet

```js
const x = {
	    nom: "BAGUES",
    prenom: "Lisa"
			};

console.log(x.nom); // Renvoi BAGUES
console.log(x["prenom"]); // Renvoi Lisa
console.log(x.prenom + " " + x.nom); // Renvoi Lisa BAGUES

```



VOIR EXERCICE "LIVRE LU" voir : >"EXERCICES DANS LE FICHIER JS_Exercice_Bibliotheque"
