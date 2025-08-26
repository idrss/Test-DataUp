Rédigée par Idrissa NDIAYE

1. Accès et organisation

Profil : Idrissa NDIAYE – Responsable de projet

Coordonnées : LinkedIn

Adresse professionnelle : idrissa.ndiaye@developpement-durable.gouv.fr

Accès projet

Portail Redmine : hébergement sec Rshiny

Connexions techniques via Bastion0 (SSH) avec authentification Carte Agent.

2. Déploiement de l’application

La branche main contient l’application Idrissa TEST.

La branche docker-compose inclut les procédures de déploiement via Docker.

La documentation technique et les instructions sont disponibles dans le fichier README.md.

Rôles et étapes de déploiement :

Mise à disposition des fichiers par la maîtrise d’ouvrage.

Déploiement par la maîtrise d’œuvre serveur sur l’instance de préproduction.

Recette par la maîtrise d’ouvrage.

Passage en production validé et déployé.

3. Maintenance et évolutions
Mise à jour des contenus

Les pages de l’application utilisent des fichiers UI et peuvent faire appel à des .Rmd.

Les textes sont modifiables directement via la forge GitLab (fonction edit + commit).

Données bailleurs (Boléro)

Chaque année, mise à jour du fichier référentiel bailleurs.

L’ETL (bolero_data_transformation.R) génère les jeux de données nécessaires (rb, b, dico).

Vérifications : formats, compatibilité des colonnes, absence de valeurs vides.

Référentiels géographiques

Actualisation des fichiers dataSpatial (communes, départements, régions).

Adaptation des scripts pour garantir la cohérence entre référentiels et jeux de données.

4. Gouvernance et bonnes pratiques

Gestion en deux environnements :

Dev (développement)

Main (production)

Déploiement automatisé via Docker et reverse-proxy sur le RIE.

5. Vigilance

Cohérence des intitulés d’indicateurs entre Boléro et l’application Idrissa TEST.

Vérification des critères de qualité (encodage, formats, homogénéité).

Suivi des dépendances logicielles via {renv} et images Docker pour reproductibilité.

6. Synthèse

Idrissa TEST est une application développée en R / Shiny, permettant le suivi et l’analyse des données issues de Boléro.
La maîtrise d’ouvrage est assurée par Idrissa NDIAYE, en lien avec les équipes techniques pour le déploiement et la maintenance.

Le projet repose sur :

Une infrastructure sécurisée (Bastion0, Docker, reverse-proxy RIE).

Un workflow clair (préproduction → recette → production).

Une démarche de reproductibilité (renv, ETL, dictionnaires de données).
