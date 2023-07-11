class Utilisateur
{
nom;
prenom;
email;
pseudo;
mdp;
connecté = false;
constructor(email, mdp)
  {
      this.email = email;
      this.mdp = mdp;

  }
connexion()
{

  for (let i = 0; i < 3; i++)
  {
    const mdp_saisi = prompt ("Veuillez saisire votre mot de passe");
    
          if(this.mdp === mdp_saisi)
            {
                this.connecté = true;
                return; //mdp ok, arrête le traitement
            }
          else
            {
            throw new Error("Le mot de passe est invalide !")
            }
  
  }
}
}

const moi = new Utilisateur("lisa.bagues@blabla.com", "blabla")
moi.connexion()

function inscrption()
{
aler ("je m'inscris")
}