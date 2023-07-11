const voiture = {
  kilometrage: 0,
  marque: "",
  maxReservoir: 50,
  reservoir: 18,
  consommation: 4.5,
  nombre_trajet: 0,
  prix_esssence: 0,
  roule: function (kilometre) {
    const conso = (this.consommation / 100) * kilometre;

    const niveau = this.reservoir;

    if (niveau - conso <= 0) {
      // Quand je ne peux pas rouler sur cette distance
      return (
        "Le niveau de carburant ne permet pas de parcourir : " +
        kilometre +
        " km."
      );
    } else {
      // Quand je peux rouler sur cette distance

      this.nombre_trajet++; // Ajoute 1 au nombre de trajet
      this.kilometrage += kilometre; // J'ajoute le kilometrage
      this.reservoir -= conso; // je réduis le réservoir

      return this.kilometrage; // je renvois le nombre de km qu'à parcouru ma voiture
    }
  },

  // Voir consigne exercie 2 en dessous
  plein: function (litre) {
    console.log(this.nombre_trajet);
    this.nombre_trajet = 0;

    if (this.maxReservoir >= this.reservoir + litre) {
      this.reservoir += litre;

      return this;
    } else {
      const surplus = this.reservoir + litre - this.maxReservoir;

      return "Le nombre de litre dépasse la capacité max de : " + surplus;
    }
  },
};

voiture.roule(40);
voiture.plein(0);

