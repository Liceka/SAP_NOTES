# Dictionnaire SAP: 

### 1.  Transactions :
___

***Remplacer les … par N ou O***

SU01 : Débloquer utilisateur (mettre le nom + cadenas)

SM12 : Entrée de bloquage

/N : remplace la fenêtre existante 

/O : ouvrir une autre fenêtre (on peut aller jusqu'à 6 fenêtres)  

/NEX : fermer toutes les fenêtres  

/H : débugage sur des transactions standards 

SLG0 : Pour consulter les logs (résultats du programme) 

SM36 : Pour créer des jobs. On peut utiliser l'assistant de JOB qui aide à créer le job. 

SM37 : Consulter les jobs. 

SE24 : Créer / afficher / modifier des classes 

SE37 : Pour créer des modules fonctions 

[se14] : Pour changer la structure d'une table.  
Après avoir changé le champs dans [se16n], aller dans la transcation et [traiter] [activer et adapter à la BDD]

[se63] TRADUCTION OBJET ABAP, autre texte, SAPscript, smartform
mettre le nom du smartform

[SE10] TEXTE STANDARD

/...SE38 : modification directe du code standard (attention, c'est le code de base donc il faut faire très attention) et s'il y a des mises à jour de SAP, ça peut se supprimer 

/…SE80 : pour coder en ABAP  

[SU53] : check des autorisations qui ont échoué

[Se78] : Gestion des graphiques des formulaires

[SMARTFORMS] : Création de formulaires

/…SE10 : organisation des transports  (ou SE01) (fermer la porte du camion) 

/...STMS : pour gérer le transport 

/…SE11 : dictionnaires de format (récipient) 

/…SE16N : consulter les données d'une table (valeur) 

/…ST22 : Consulter les beugs 

/....SE91 : Pour créer un message sur la base de donnée 

/....SE93 : Gestion des transactions (pour afficher le programme qu'utilise la transaction)

/...STVARV : pour avoir les options de sélection sans passer par l'écran de sélection 
(pour qu'une seule personne ait accès à l'option de sélection) 

/....VA01 : Transaction commande de vente

/....ME21N: Transaction commande d'achat

/....SM35: Transaction pour batchinput

SHDB : Transaction qui permet de faire des enregistrement des simulations des mainpulations


MARA : Table des articles 

HAWA : Article commercialisable 

POSTE : détails pour chaque article (EKPO) 

STRING : autant de caractère qu'on veut 

CONCATENATE : pour fusionner 

FLOAT : decimal 

CONSTANTS : constante  

WRITE : écrire le code  

DATA : variante  

TYPE : modèle de ligne  

VALUE : valeur  

*: pour insérer un commentaire en début de ligne, sinon "  

": pour insérer un commentaire n'importe où  

 

BO : Business Objets : OBJETS 


DOMAINE : Le domaine est le supérieur hiérarchique de l'élément de donné (ex: CHAR 10), l'élément de donné utilise le domaine pour lui donner une forme, l'élément de donné peut avoir un autre nom mais avoir le domaine CHAR10 


Lo = Local Objet 

Message i006 WITH text-003 

Le i pour information (ca affiche une pop up avec l'information mais ça stoppe pas le programme) Le E pour Erreur (ca stoppe le programme) 

Le W : warning avec indication rouge (E), jaune (W) ou vert (S) , (ex : MESSAGE TEXT-001 TYPE 'S'. ) 

Le A pour abandon (mais pas utilisé dans SAP) 

Objet métier : ce que l'utilisateur va manipuler : ex facture, commande, article.... tous ces objets sont reliés entre eux 

PBO : ce qui se passe avant que ce charge l'écran, avant l'affichage. Process Before Output 

PAI : ce qui se passe une fois la valeur saisie, Process After Imput. 

STANDARD : déjà existant dans SAP

OBJET SPECIFIQUE (ou dit "SPE") : faut rajouter du code qui n'existait pas avant, ça commence forcément par Z ou Y

Commande de vente = commande client

Sinon il y a des user-exists, qui sont des brèches laissées volontairement par SAP afin d'y insérer des spécificités sans casser ce qu'il y a de déjà existant Ne peut pas être supprimé lors de mise à jour.

SE38 : modification directe du code standard (attention, c'est le code de base donc il faut faire très attention) et s'il y a des mises à jour de SAP, ça peut ce supprimer

CONSTANTS : Qqch de constant, qui ne change pas

CUSTO : Les données que les fonctionnels font

INTER-MANDANTS : Mêmes données dans le système sur chaque mandant

MANDANT INDEPENDANT : Différentes données dans chaque mandant

MANDANTS : Sous divisions dans un système

- MM : Gestion matière
- OT : Ordre de transport, demande de transport
- PM : Gestion de maintenance
- PP : Gestion de prod
- QM : Gestion de qualité
- SD : Vente et distribution

SPEC : Documentation spécifique que le fonctionnel a fait en décrivant le besoin du client

Systèmes : Environnements

TABLE : On peut voir ça comme un livre, avec des pages et des lignes, un ensemble de lignes/structures

Transporter : Passer un programme d'un système à un autre (on peut aussi dire "livré")

TYPES : Modèle de ligne (template)

VARIABLE : Contenant qui reçoit des valeurs (des valeurs qui changent Ex : un champs ou une table), inverse : CONSTANTE

WORKBENCH : Tous les objets créés par les devs (programmes, fonctions, classes, formulaires…) Le workbench est inter-mandant
 

 
 