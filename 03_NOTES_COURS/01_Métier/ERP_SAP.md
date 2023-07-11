# LOGICIEL: *ERP_SAP*


Les ERP sont des progiciels de gestion d'entreprise  


SAP : Progiciel de + utilisé au monde, en 2019 : 43% des utilisateurs de progicels utilisent SAP  

SAP Fiori : c'est la partie WEB (portail d'application)  

ECC : version la plus utilisée aujourd'hui  

S/4 HANA : Dernière version, plus intuitive, plus rapide, plus fluide. En 2027, les anciennes versions deviendront obsolètes  


SAP est divisé en plusieurs catégories, et dans chaque catégorie on a des modules.  

Par exemple dans la catégorie logistique on peut trouver les modules :  

- SD : vente et distribution  
- MM : Gestion matière  
- PP : Gestion de prod  
- QM : Gestion de qualité  
- PM : Gestion de maintenance  


Dans la catégorie finance : FI / CO / AM / PS / EIS  


On a d'abord une **Entête** qui est ensuite divisé en plusieurs **POSTS** (POSTS = ITEMS) , ENTETES (=HEADER) 


On travaille sur différents systèmes/environnements :   

Pour les développeurs il y a l'environnement **DEVELOPPEMENT** (pour faire le code mais sans toucher à celui en cours chez le client)  

Le système **INTEGRATION / RECETTE / QUALIFICATION**: c'est là où va travailler le fonctionnel, il va "organiser" le progiciel avec les options fournies par le logiciel (comme pour les paramètres d'une application de téléphone) (si besoin du code : besoin du développeur) et va ensuite tester sur son système le code du développeur et ses modifications à lui  

L'environnement **PRODUCTION** : le système final chez le client  

Pour passer d'un système à l'autre on dit "livré" ou "transporté"  

  

1 VARIABLE = 1 CHAMPS  

1 ensemble de CHAMPS = 1 LIGNE / STRUCTURE  

1 ensemble de LIGNE / STRUCTURE = 1 TABLE  

 

Tcode : transaction code : (sinon chercher sur Google en tapant SAP Tcode) 

01 : pour créer 

02 : modifier 

03 : afficher 

 

A chaque objet SAP correspond des transactions et des tables (base de données) 

SE16N : Transaction qui permet de d'afficher les données  

Les champs colorés dans indique la clé primaire (donc une seule ligne) 

SE11 : pour voir comment c'est structuré (on peut voir les types, description par exemple) (dictionnaire) 