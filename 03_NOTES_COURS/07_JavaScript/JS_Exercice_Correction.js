let num1 = 5;
let num2 = 2;
const persons = [
    "Fred",
    "Lisa",
    "JP",
    "Guillaume",
    "Maxime",
    "Jiyeong",
  ];

  const notes = [12, 16, 19, 15, 14, 13, 17, 18];
  const valeurAbsolue = absoluteValue(num1);
  const anneeBisextile = biWeekly(num1);
  const conversionCelcius = fahrenheitToCelsius(num1);
  const pairImpair = randomNumber(num1, num2);
  const prenomAleatoire = getRandomName(persons);

  console.log("Valeur absolue : " + valeurAbsolue);
  console.log("Année bisextile : " + anneeBisextile);
  console.log("Celcius : " + conversionCelcius);
  console.log("Type de nombre : " + pairImpair);
  console.log("Prénom aléatoire : " + prenomAleatoire);
  

//Je souhaites savoir la valeur absolue du nombre que je saisie.
//La valeur absolue d’un nombre est sa valeur positive.
function absoluteValue(num1) {
  if (num1 < 0) {
    return -num1;
  } else {
    return num1;
  }
}

//En donnant une année à l’ordinateur, je voudrais qu’il me dise si elle est bissextile ou non.
//Je sais qu’une année bissextile est une année divisible par 4
//si c’est une année de centenaire (comme 1800, 1900, etc.), elle doit en complément être divisible par 400.
function biWeekly(num1) {
  if ((num1 % 4 == 0 && num1 % 100 != 0) || num1 % 400 == 0) {
    return num1 + " est une année bissextile";
  } else {
    return num1 + " n'est pas une année bissextile";
  }
}

//J’ai l’habitude de travailler avec des américains, et il a tendance a me donner les températures en Fahrenheit.
//Comme j’y comprends rien, je voudrais faire une fonction qui me permet de convertir 
//des degrés Fahrenheit en degré Celsius.
//Après quelques recherches, j’ai trouvé ceci :
  //(°F − 32) ÷ 1.8 = °C

function fahrenheitToCelsius(num1) {
  let degre = (num1 - 32) % 1.8;
  return degre;
}
//Pour me faciliter la vie, j’aimerais avoir une fonction qui me renvoie un nombre aléatoire.
//Avec cette fonction, je pourrais rentrer un minimum et un maximum. 
//A partir de ça, je voudrais que mon nombre aléatoire soit compris entre le minimum et le maximum.

function randomNumber(min, max) {
  return Math.random() * (max - min) + min;
}

//J’aimerais tirer une personne aléatoirement parmi une liste de participants.

function getRandomName(Persons) {
  const randomIndex = Math.round(Math.random() * Persons.length);
  return Persons[randomIndex];
}


//J’ai reçu mes notes de semestre, mais personne ne me donne ma moyenne générale.
// J’aimerais calculer ma moyenne a partir d’un tableau de notes

function getRandomName(notes) {
  const randomIndex = Math.round(Math.random() * notes.length);
  return notes[randomIndex];
}

function generateRandomSum(notes) { 
  let sum = 0; 
  for (let i = 0; i < notes.length; i++) { 
    const note = notes[i]; 
    const random = Math.floor(Math.random() * (Math.abs(note) + 1)); 
    sum += note < 0 ? -random : random; 
  } 
  return sum; 
}