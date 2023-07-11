// EXERCICE BIBLIOTHEQUE :


const bibliotheque = [
    {
        nom: "À la recherche du Boson de Higgs",
        auteur: "Laurent Vacavant",
        lu: false,
    },
    {
        nom: "La couleur tombée du ciel",
        auteur: "Howard Phillips Lovecraft",
        lu: true,
        score: 9,
    },
    {
        nom: "Le mythe de Cthulhu",
        auteur: "Howard Phillips Lovecraft",
        lu: true,
        score: 8,
    },
    {
        nom: "La dramaturgie",
        auteur: "Yves Lavandier",
        lu: false,
    },
    {
        nom: "Le Hobbit",
        auteur: "John Ronald Reuel Tolkien",
        lu: false,
    },
    {
        nom: "Tintin et le Lotus Bleu",
        auteur: "Hergé",
        lu: true,
        score: 8
    }
  ];

  const librairie = {
    "À la recherche du Boson de Higgs": {
        prix: 19.99,
        score: 8.6
    },
    "La couleur tombée du ciel": {
        prix: 10.59,
        score: 9.1
    },
    "Le mythe de Cthulhu": {
        prix: 10.59,
        score: 9.3
    },
    "La dramaturgie": {
        prix: 52.94,
        score: 8.4
    },
    "Le Hobbit": {
        prix: 12.69,
        score: 9
    },
    "Tintin et le Lotus Bleu": {
        prix: 12.71,
        score: 9.3
    }
};

const livreslu = filter(bibliotheque); 
console.log("Livre non lu : " + livreslu);
  

//Filtre les livres non lu et affiche les noms : 1ere option
function filtre_livres(bibliotheque)
{
    let tableau = [];
    bibliotheque.forEach(function(livre) {
        if(!livre.lu)
        {
            tableau.push(livre.nom);
        }
    });
 
    return tableau;
}

//Filtre les livres non lu et affiche les noms : 2eme option

function filtre_livres(bibliotheque)
{
    for(let i = 0; i < bibliotheque.length; i++)
	{
		const livre = bibliotheque[i];

		if(!livre.lu) // Dans le cas où je n'ai PAS lu le livre (avec le !)
			{
						tableau.push(livre.nom);

			}
	}

						return tableau;
}


//Filtre les livres non lu et affiche les noms : 2eme option
bibliotheque
    .filter(livre => !livre.lu) // Filtre (ne pas mettre de ; car toujours la même instruction)
    .map(livre => livre.nom) // Renvois les noms 
    .join(", "); // Sépare les noms par des ,


//Avec ma liste de livre, j’ai réussi a obtenir la liste des livres disponible à ma librairie.    
//J’aimerais savoir combien j’ai payé l’ensemble des bouquins de ma bibliothèque.   

    function prix_bouquins(bibliotheque, librairie)
{
    let somme = 0;
    bibliotheque.forEach(function(livre) {
        const donnee_livre = librairie[livre.nom];
        somme += donnee_livre.prix;
    });
 
    return somme.toFixed(2);
}

// Pour calculer la somme totale des livres

bibliotheque
    .map(livre => librairie[livre.nom].prix)
    .reduce((somme, prix) => somme + prix, 0)

// Pour calculer la somme totale des livres que je n'ai pas lu

bibliotheque
    .filter(livre => !livre.lu)
    .map(livre => librairie[livre.nom].prix)
    .reduce((somme, prix) => somme + prix, 0)


// Pour calculer le score moyen des bouquins que j'ai acheté. Je me base sur le score de ma librairie.

function moyenne_bouquins(bibliotheque, librairie)
{
    let somme = 0;
    bibliotheque.forEach(function(livre) {
        const donnee_livre = librairie[livre.nom];
        somme += donnee_livre.score;
    });

        const moyenne = somme / bibliotheque.length
 
    return moyenne;toFixed(2);
}

// Si je l'ai lu, je prends mon score, si je ne l'ai pas le, je prends le score de la libraire

function moyenne_bouquins(bibliotheque, librairie)
{
    let somme = 0;
    bibliotheque.forEach(function(livre) {
        const donnee_livre = librairie[livre.nom];
        if(livre.lu) // si livre non lu, je prends le score de la librairie
        {
             somme += livre.score;   
        }
        else // si livre lu, je prends le score de ma bibliotheque
        somme += donnee_livre.score;
    });

        const moyenne = somme / bibliotheque.length;
        return moyenne;toFixed(2);
}

// En réduisant le code pour afficher le score que des livres dans la bibliotheque:

(bibliotheque

    .map(livre => livre.score ?? 0 ) // le ?? pour remplacer les cases vides par 0
    .reduce((somme, score) => (somme + score), 0)/bibliotheque.length).toFixed(2)


// En réduisant le code pour afficher  :je prends mon score, si je ne l'ai pas le, je prends le score de la libraire  
( bibliotheque 
        .map((livre) => livre.score ?? librairie[livre.nom].score) 
        .reduce((somme, score) => somme + score, 0) / bibliotheque.length ).toFixed(2);

