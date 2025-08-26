# 1 Accès

## Adresses

<https://rshiny.cgdd.e2.rie.gouv.fr/traefik/dashboard/#/http/routers>

<https://rshiny.preprod.cgdd.e2.rie.gouv.fr/traefik/dashboard/#/>

<https://connect1.cgdd.e2.rie.gouv.fr/ericols/>

## Principales informations

L'application r-shiny est déployée dans un conteneur Docker sur des
machines Debian en hébergement-sec. - instance de preproduction
10.167.71.43 - instance de production 10.167.71.42

| service        | statut             | utilisateur                                                                                                      | compte   | droit                    |
|-------------|-------------|--------------------|-------------|-------------|
| DGALN/DHUL/LO4 | maitrise d'ouvrage | [fanch.kerguelen\@developpement-durable.gouv.fr](mailto:fanch.kerguelen@developpement-durable.gouv.fr){.email}   | néant    | néant                    |
| DGALN/DHUL/LO4 | maitrise d'ouvrage | [caroline.regnard\@developpement-durable.gouv.fr](mailto:caroline.regnard@developpement-durable.gouv.fr){.email} | néant    | néant                    |
| DGALN/DHUP/PH4 | maitrise d'oeuvre  | [eric.wang\@developpement-durable.gouv.fr](mailto:eric.wang@developpement-durable.gouv.fr){.email}               | néant    | néant                    |
| CGDD/SDSED/BUN | maitrise d'oeuvre  | [rachid.moughaoui\@developpement-durable.gouv.fr](mailto:rachid.moughaoui@developpement-durable.gouv.fr){.email} | adminrmo | administrateur acces ssh |
| CGDD/SDSED/BUN | maitrise d'oeuvre  | [nicolas.sephane\@developpement-durable.gouv.fr](mailto:nicolas.sephane@developpement-durable.gouv.fr){.email}   | adminnse | administrateur acces ssh |

## Projet Redmine

<https://portail-support.din.developpement-durable.gouv.fr/projects/hebergement-sec-rshiny?jump=welcome>

### Accès au projet

-   demander l'autorisation au bureau métier : *DGALN/DHUP/LO4*
    [lo4.lo.dhup.dgaln\@developpement-durable.gouv.fr](mailto:lo4.lo.dhup.dgaln@developpement-durable.gouv.fr)

-   demander l'accès au bureau technique : *CGDD/SDSED/BUN*

-   accéder à la [forge
    ministérielle](https://gitlab-forge.din.developpement-durable.gouv.fr/cgdd/sdsed-bun/r-et-rshiny/ericols)

-   générer à partir de la forge, son token d'accès

-   utiliser la branche `dev` pour le développement

-   utiliser la branche `main` pour la production

-   `merge request` est sous l'autorité CGDD/BUN

## Accès aux machines

Les machines seront accessibles à terme uniquement à travers le
**Bastion0** (SSH jump proxy). Il est nécessaire d'avoir la clef
publique de sa Carte Agent sur les machines. (vérifier si nos clefs ont
été déployées automatiquement par la DNUM).

```         
/home/adminnse/.ssh/authorized_keys
```

```         
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFpS/T2Tf9aZSsrdKVdDaPSsC7Dbq1xQ37XXbMhrWbt0ShQbQoG4hZgh062hY9iqNdDmpxkZZRY1S7Q9Ib5XZfyHGM87PqgXQwS4xdFgFdZ2r9/ZtHzbyoEyazvZ6MOs5+f0N5BKO6bkDX6eeLuzIl9rbh4SPmrVWyxC9PxxXDyR554gauB721HJTwoXcGLaKKKHJhZQRtccQRMRpckXnAvo5DQMYd63sh1s3oUmQ4tBAR4W4OK0Mf75R86p7Dc0weuORxN7yOh7+hckHmpzvFI3iW9noj3YM8RXpBfcCIkBgfdyiD41ICi7EqR1b7JkObV8Ia72Y7Vy1uySo+vOMT  CAPI:f23ddedcbed7c942fe12331825003ad9e4760c8a SN=SEPHANE, G=Nicolas, CN=Nicolas SEPHANE nicolas.sephane, OU=0002 130019540, O=Secteur public Developpement durable Logement et Transports, C=FR
```

Les comptes administrateurs pour déployer des application rshiny sont :

```         
id adminnse
uid=1000(adminnse) gid=1000(adminnse) groupes=1000(adminnse),27(sudo),998(docker)

id adminrmo
uid=1001(adminrmo) gid=1001(adminrmo) groupes=1001(adminrmo),27(sudo),998(docker)
```

## Déploiement

La branche `main` contient l'application **ERICOLS**. Se référer à la
branche `docker-compose` pour déployer **ERICOLS**, les explications
sont dans le fichier `README.md`.

# 2 FAQ

## Comment s'organiser pour travailler sur ERICOLS

En résumé : - Disposer du go MOA, LO4 - Disposer du go MOE serveur,
BNU - Disposer du GO MOE applicatif, PH4

En détails :

1.  DGALN/DHUP/LO4 informe le CGDD/SDSED/BUN
2.  DGALN/DHUP/LO4 met à disposition les fichiers sur le présent dépôt
    dans la branche `main`
3.  CGDD/SDSED/BUN récupère et **déploie** sur l'instance de
    **préproduction**
4.  DGALN/DHUP/LO4 **recette** sur la **préproduction** et demande la
    mise en production
5.  CGDD/SDSED/BUN **déploie** sur l'instance de **production**
6.  DGALN/DHUP/LO4 **recette** sur la **production**

## Comment actualiser le texte de l'application

Il est possible pour certaines pages de changer le texte facilement. Au
niveau de l'architecture, le rendu est dans les fichiers avec le tag
"UI". Néanmoins, depuis la version 1.1.1, chaque fichier avec un tag
"UI" peut faire appel à un fichier avec l'extension `.Rmd`. Ces fichiers
peuvent être modifiés directement à partir de la forge en appuyant sur
`edit` puis à la fin de la modification, `commit changes` et enfin
communiquer le changement au BUN pour prise en compte sur la production

*eg.*

![](images/paste-504937BA.png)

![](images/paste-CEF6FEE7.png)

## Comment actualiser la liste des bailleurs

Pour localiser les organismes sur les territoires (région/département),
il est important de donner une localisation. Cette localisation est
effectuée sur la base du siège social de l'organisme. Pour le
déterminer, nous prenons l'output du référentiel bailleur. A chaque
nouvel exerice, il est important de mettre à jour aussi la variable
*rb*.

La mise à jour de la variable *rb* permet notamment d'avoir le correct
nombre d'organismes par département et donc par région et d'exclure les
organismes déclarés céssés.

Voici les étapes à réaliser pour mettre à jour la variable *rb* :

1.  ouvrir le fichier scrip *bolero_data_transformation.R*

2.  mettre à jour le fichier
    *ericols/data/dataBolero/rb_caroline_aout_v5.xlsx*

3.  lancer le script et attention aux formats des variables et le
    libellé des colonnes

```{r}
# 'data.frame':	813 obs. of  11 variables:
#  $ siren                   : chr  "005580113" "005650148" "005720610" "006380158" ...
#  $ nom                     : chr  "CISN COOPERATIVE" "SCIC VALDURANCE HABITAT" "PICARDIE MARITIME HABITAT FONDATION PAUL DUCLERCQ" "CISN RESIDENCES LOCATIVES" ...
#  $ famille                 : chr  "COOP" "COOP" "COOP" "SA-HLM" ...
#  $ juridique               : chr  "juridique autre" "juridique autre" "juridique autre" "SA à conseil d'administration (s.a.i.)" ...
#  $ naf                     : chr  "juridique autre" "juridique autre" "juridique autre" "SA à conseil d'administration (s.a.i.)" ...
#  $ nic                     : num  40 33 12 45 37 67 46 1 69 1 ...
#  $ siret                   : num  5.58e+11 5.65e+11 5.72e+11 6.38e+11 6.65e+11 ...
#  $ codeCommuneEtablissement: chr  "44210" "04070" "80001" "44210" ...
#  $ id                      : chr  "CISN COOPERATIVE - 005580113" "SCIC VALDURANCE HABITAT - 005650148" "PICARDIE MARITIME HABITAT FONDATION PAUL DUCLERCQ - 005720610" "CISN RESIDENCES LOCATIVES - 006380158" ...
#  $ dep                     : chr  "44" "04" "80" "44" ...
#  $ reg                     : chr  "52" "93" "32" "52" ...


```

1.  lancer le script *bolero_data_transformation.R* et vérifier le
    résultat de l'output `rb`

```{r}

# rb nouvelle version -----------------------------------------------------


rb <- rio::import(file = "data/dataBolero/rb_caroline_aout22_v5.xlsx")

rb <- rb %>%
  mutate(id = paste(nom,"-",siren))

rb <- rb %>% 
  distinct(id, .keep_all = T) %>% 
  select(-annee)

```

## Comment actualiser le référentiel géographique

1.  actualiser les fichiers utilisés dans le dossier dataSpaital

2.  actualiser le script de transformation des données
    *bolero_data_transformation.R*

```{r}
# éléments géographiques

ref_com <- read_excel("data/dataSpatial/ref_com.xlsx",
                      sheet = "2019")

ref_reg <- read_excel("data/dataSpatial/ref_reg_dep_epci.xlsx",
                      sheet = "reg")

ref_dep <- read_excel("data/dataSpatial/ref_reg_dep_epci.xlsx",
                      sheet = "dep")

ref_reg_dep <- rio::import("data/dataSpatial/ref_reg_dep.xls")

ref_reg_dep <- ref_reg_dep %>% 
  mutate(reg = as.character(REG),
         dep = as.character(DEP)) %>% 
  select(reg,dep)

ref_com_dep_reg <- rio::import("data/dataSpatial/ref_com_dep_reg_2022.xlsx")

# éléments siège social

b <- b %>% 
  left_join(ref_com_dep_reg, by = c("codeCommuneEtablissement" = "CODGEO")) %>% 
  rename(dep = DEP,
         reg = REG)
```

## Comment actualiser ajouter une nouvelle année

1.  exporter tous les indicateurs pour tous les organismes pour la
    nouvelle année dans nouveau boléro
    (<https://bodhup.ancols.fr/BOE/BI>) Ne pas avoir de valeur vide,
    préférer la valeur 0.

2.  vérifier la compatibilité des colonnes entre la nouvelle année et
    des anciennes années et le format des colonnes. Idem pour le libellé
    des indicateurs.

    1.  si compatible aller à 3

    2.  si non compatible faire 1 pour toutes les années (possible si
        présence de nouveaux indicateurs)

3.  ouvrir le fichier *bolero_data_transformation.R*

4.  ajouter une nouvelle variable en suivant l'exemple suivant :

```{r}
b19 <- b19 %>% 
  rename("siren" = `Siren Entite`,
         "annee" = `Exercice`) %>% 
  select(-c(`Raison Sociale Entite`, `Code Famille`, `Libelle Famille`)) %>% 
  inner_join(rb, by = "siren")

b20 <- read_delim("data/dataBolero/bolero_2020.csv", 
                  delim = ";", escape_double = FALSE, locale = locale(decimal_mark = ","), 
                  trim_ws = TRUE)

b20 <- b20 %>% 
  rename("siren" = `Siren Entite`,
         "annee" = `Exercice`) %>% 
  select(-c(`Raison Sociale Entite`, `Code Famille`, `Libelle Famille`)) %>% 
  inner_join(rb, by = "siren")

b21 <- b21 %>% 
  rename("siren" = `Siren Entite`,
         "annee" = `Exercice`) %>% 
  select(-c(`Raison Sociale Entite`, `Code Famille`, `Libelle Famille`)) %>% 
  inner_join(rb, by = "siren")



# transformer csv en xlsx pour le téléchargement --------------------------
# à lancer pour chaque nouveaux fichiers bolero 

# rio::export(b16, file = "data/dataBolero/bolero_2016.xlsx")
# rio::export(b17, file = "data/dataBolero/bolero_2017.xlsx")
# rio::export(b18, file = "data/dataBolero/bolero_2018.xlsx")
# rio::export(b19, file = "data/dataBolero/bolero_2019.xlsx")
# rio::export(b20, file = "data/dataBolero/bolero_2020.xlsx")
# rio::export(b20, file = "data/dataBolero/bolero_2020.xlsx")
# rio::export(b21, file = "data/dataBolero/bolero_2021.xlsx")


# assemblage des différentes années  --------------------------------------

# b <- rbind(b19, b18, b17, b16)
b <- rbind(b21, b20, b19, b18, b17, b16)
```

5.  ajouter une nouvelle année de la manière suivante, sinon dans
    l'écran paramétrage (UI_ecran_parametres.R), l'année est absente
    puis changer la valeur par défaut\>

```{r}
# regarder ligne 14
selectInput(
      "select_annee",
      label = helpText("Choisir l'année des données :"),
      choices = list(
        "2021" = 2021, # ajouter une ligne pour la nouvelle année lors de l'actualisation 
        "2020" = 2020, 
        "2019" = 2019,
        "2018" = 2018,
        "2017" = 2017,
        "2016" = 2016
      ),
      selected = 2021 # changer la valeur par défaut pour chaque nouvelle année 
    )
```

6.  lancer le script en local et vérifier que les variables `rb` `b`
    `dico` sont valides

7.  ajouter le nouvel export pour la nouvelle année en lançant le script
    commenté, pour créer le fichier export puis re-commenter.

    ```{r}

    # transformer csv en xlsx pour le téléchargement --------------------------
    # à lancer pour chaque nouveaux fichiers bolero 

    # rio::export(b16, file = "data/dataBolero/bolero_2016.xlsx")
    # rio::export(b17, file = "data/dataBolero/bolero_2017.xlsx")
    # rio::export(b18, file = "data/dataBolero/bolero_2018.xlsx")
    # rio::export(b19, file = "data/dataBolero/bolero_2019.xlsx")
    # rio::export(b20, file = "data/dataBolero/bolero_2020.xlsx")
    # rio::export(b20, file = "data/dataBolero/bolero_2020.xlsx")
    # rio::export(b21, file = "data/dataBolero/bolero_2021.xlsx")

    ```

8.  dans le fichier UI_Ressources.R (lignes 28 à 42), ajouter une
    nouvelle ligne

    ```{r}
      box(
        status = "primary",
        title = "Les fichiers disponibles en téléchargement",
        width = 12,
        tags$div("Guide à destination des services déconcentrés pour le suivi de la restructuration des OLS (loi Elan)."),
        DL_button_data("dlGuide", "guide restructuration"),
        hr(),
        tags$div("Tableau de l'ensemble des indicateurs pour tous les organismes de logement social."),
        # ajouter ici la nouvelle ligne pour la nouvelle année 
        DL_button_data("dlBolero2020", "boléro 2020"),
        DL_button_data("dlBolero2019", "boléro 2019"),
        DL_button_data("dlBolero2018", "boléro 2018"),
        DL_button_data("dlBolero2017", "boléro 2017"),
        DL_button_data("dlBolero2016", "bolero 2016"),
        
      )
    ```

9.  puis ajouter dans le fichier SERVER_bolero.R (lignes 955) la
    fonction de téléchargement, à partir de l'exemple suivant

    ```{r}

    output$dlBolero2021 <- downloadHandler(
      
      filename = function() {
        paste("bolero_2021.xlsx", sep="")
      },
      content = function(file) {
        file.copy("data/dataBolero/bolero_2021.xlsx", file)
      }
    )  

    output$dlBolero2020 <- downloadHandler(
      
      filename = function() {
        paste("bolero_2020.xlsx", sep="")
      },
      content = function(file) {
        file.copy("data/dataBolero/bolero_2020.xlsx", file)
      }
    )  

    ```

10. changer la valeur de la version de l'application dans le fichier
    app.R (ligne 22)

```{r}

versionApp <- "v1.3.4" # à changer pour afficher la version partout sur l'ensemble des fichiers 

```

11. ajouter les modification dans le changelog dans le fichier
    UI_mentions_legales_droite.Rmd

Attention :

-   vérifier que l'export `nouveau boléro` est bien :

    -   format utf-8 csv

    -   séparateur ';'

    -   et séparateur décimale ','

-   lors du `git push`

    -   activer les fonctions d'exports pour rendre disponible les
        fichiers au format `.xlsx`

    -   en ajouter une ligne pour la nouvelle année

    -   puis commenter lors du `git push`

## Comment savoir si je peux ajouter une nouvelle année comptable

-   [ ] Disponibilité dev, infra, métier

-   [ ] Liste des organismes qui sera utilisée pour toutes les années et
    pour l'onglet par territoire

-   [ ] Exports des données `BOLERO`

-   [ ] Export de tous les indicateurs pour tous les organismes

    [ ] Dictionnaire des indicateurs dont actualisation des indicateurs

    :   définition, etc.

## Comment actualiser le dictionnaire des données

*(si je passe par le lien internet de la forge du projet)*

1.  télécharger le fichier à partir de la branche `main`

2.  récupérer le fichier
    *ericols/data/dico/dico_dincateurs_financiers.xlsx*

3.  actualiser l'onglet DICO_nouvelle_version sans modifier les libellés
    des colonnes

4.  actualiser dans SERVER_bolero.R, la référence de la version

```{r}

# extrait du code ligne 75
    tags$div(
      column(width = 4,
             tags$h2(tags$code(
               paste("ERICOLS", " v1.1.1")
             )),
             tags$h3(
               tags$code(
                 "image BOLERO du",
                 file.info(file = "data/dataBolero/bolero_2021.csv")$ctime # valeur à actualiser
               )
             ))
      
```

Attention

-   lors de l'intégration du nouveau dictionnaire des données, la
    variable dico\$indicateur_code est coeur car elle permet de faire
    les liaisons avec les fonctions dans le fichier SERVEUR_bolero.R.
    Lire *vigilance\>intitué des indicateurs (pour la maîtrise
    d'ouvrage)*

# 3 Vigilance

## Intitulé des indicateurs (pour la maîtrise d'ouvrage)

La liaison entre `ericols` et `nouveau boléro` est possible grâce au nom
de l'indicateur qui doit respecter le format suivant :
`{indicateur_code}` - `{indicateur libellé}`.

Ce format doit être respecté, car cet input (*ie. les données du*
`nouveau boléro`) en format `wide` est ensuite transformé en format
`long`.

Attention : la liaison entre les tables données et le dico, se fait avec
"indicateur_code". La valeur "indicateur_code" est écrit dans le dur
dans le code; Le changement de la valeur "indicateur_code" demande donc
des modifications dans le code.

En conclusion, tous les fichiers de toutes les années doivent avoir le
même nom des indicateurs et ces noms sont à utiliser dans le fichier
dico. Toute anomalie crée une rupture dans le système.

## Critères de qualité des indicateurs à intégrer à ERICOLS (pour la maîtrise d'ouvrage)

Il faut faire attention aux critères suivants. Toujours reprendre la
structure actuelle qui est :

-   encodage

-   pour les valeurs en pourcentage, ne pas les multiplier par 100

-   type de colonne

-   csv

## Environnements de travail : git branch : `dev` (développement) & `main` (production)

Il existe deux univers : un de développement nommé `dev` et un de
production nommé `main`.

La distinction entre les deux se fait au niveau du git via le système
des branches ou `branch`.

## Déploiement

Le déploiement est réalisé au niveau du bureau des usages numériques
(BUN) au CGDD. Il est effectué à partir de la [forge
ministérielle](https://gitlab-forge.din.developpement-durable.gouv.fr/cgdd/sdsed-bun/r-et-rshiny/ericols).

A partir de la [forge
ministérielle](https://gitlab-forge.din.developpement-durable.gouv.fr/cgdd/sdsed-bun/r-et-rshiny/ericols),
la procédure de déploiement se fait via `docker` et le fichier
`Dockerfile`.

Le `Dockerfile` permet de déployer `ericols` vers l'url exposé sur le
RIE (réseau interministériel de l'Etat).

Un url est pour la production `main`.

Un url est pour le développement `dev`.

# 4 Détails techniques du projet

## Modèle de travail : shiny

Le projet est réalisé à partir du langage de statistique et de
programmation `R` et à partir du package `Shiny`. Travailler sur le
projet demande un minimum de connaissance sur ces deux objets.

## Modèle conceptuel de données

<img src="images/paste-02498124.png" alt="illustration du modèle conceptuel de données avec notamment les fichiers UI"/>

```{mermaid}
classDiagram
   ericols <|-- ui
   ui <|-- ui_ecran_bailleur
   ui <|-- ui_ecran_territoire
   ui <|-- ui_ecran_parametres
   ui <|-- ui_ecran_mentions_llegales
   ui <|-- ui_ratios
   ui <|-- ui_ressources
   ericols <|-- server
   server <|-- dico
   server <|-- b
   server <|-- rb
       class dico{
     +indicateur
     +indicateur_code
     +indicateur_lib
     +definition_metier
   }
       class b{
     +siren
     +annee
     +nom
     +type
     +juridique
     +id
     +dep
     +reg
     +indicateur
     +indicateur_code
     +indicateur_lib
     +indicateur_value
   }
   class rb{
     +siren
     +nom
     +type
     +juridique
     +naf
     +nic
     +siret
     +codeCommuneEtablissement
     +id
     +dep
     +reg
   }
           
```

## Modèle de transformation des données : ETL

*fichier bolero_data_transformation.R*

## Modèle graphique du logo : figma

Le nécessaire lié au graphisme, c'est-à-dire le logo se trouve sur FIGMA
à travers ce lien :
<https://www.figma.com/file/JOTHifEEtw7q3hVYxWyKoW/ERICOLS?node-id=0%3A1>

## Modèle reproductible : renv & docker

### RENV (HS)

Le projet est reproductible en locale grâce au package {renv}.

`git pull` "je commence le projet"

1.  Call
    [`renv::init()`](https://rstudio.github.io/renv/reference/init.html)
    to initialize a new project-local environment with a private R
    library,

2.  Work in the project as normal, installing and removing new R
    packages as they are needed in the project,

3.  Call
    [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html)
    to save the state of the project library to the lockfile (called
    `renv.lock`),

4.  Continue working on your project, installing and updating R packages
    as needed.

5.  Call
    [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html)
    again to save the state of your project library if your attempts to
    update R packages were successful, or call
    [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html)
    to revert to the previous state as encoded in the lockfile if your
    attempts to update packages introduced some new problems.

`git commit & git pull` "je continue le projet"

-   [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html)
    to restore the state of your project from `renv.lock`.

### DOCKER

-   Récupérer le contenu du dépôt sur le serveur de préproduction

```         
cd /home/rshiny/ericols_int/
sudo git clone --branch <branche> https://gitlab-ci-token:<jeton>@gitlab-forge.din.developpement-durable.gouv.fr/cgdd/sdsed-bun/r-et-rshiny/ericols.git
```

-   Mettre à jour sur le serveur de préproduction

```         
cd /home/rshiny/ericols_int/ericols
sudo git pull
```

-   Créer le conteneur Docker

```         
sudo docker-compose build --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy
```

-   Charger le conteneur Docker et l'exposer sur le reverse-proxy

```         
docker-compose up -d
```

-   Arrêter

```         
docker-compose down
```

-   ajouter des modifications sur le dépôt

```         
sudo git add .
sudo git commit -m "update"
sudo git push
```

-   Récupérer le contenu du dépôt sur le serveur de production

```         
cd /home/rshiny/ericols/
sudo git clone --branch <branche> https://gitlab-ci-token:<jeton>@gitlab-forge.din.developpement-durable.gouv.fr/cgdd/sdsed-bun/r-et-rshiny/ericols.git
```

-   Mettre à jour sur le serveur de production

```         
cd /home/rshiny/ericols/ericols
sudo git pull
```

-   Créer le conteneur Docker

```         
sudo docker-compose build --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy
```

-   Charger le conteneur Docker et l'exposer sur le reverse-proxy

```         
docker-compose up -d
```

-   Arrêter

```         
docker-compose down
```

-   ajouter des modifications sur le dépôt

```         
sudo git add .
sudo git commit -m "update"
sudo git push
```

## Organisation des fichiers

\| .gitignore \> liste des fichiers à ignorer dans le git

\| .Rprofile \> fichier de configuration Rprofile

\| app.R \> fichier coeur qui appelle les autres fichiers

\| bolero_data_transformation.R \> ETL local pour générer les données
'b' 'rb' et 'dico'

\| Dockerfile \> fichier côté BUN pour le déploiement

\| ericols.Rproj \> fichier de projet côté Rstudio

\| README.Rmd \> fichier à lire

\| renv.lock \> fichier nécessaire pour figer les packages en local

\| SERVER_bolero.R \> fichier serveur

\| UI_ecran_bailleur.R \> fichier UI pour la page bailleur

\| UI_ecran_parametres.R \> fichier UI pour la page paramètres

\| UI_ecran_territoire.R \> fichier UI pour la page territoire

\| UI_Mentions_legales.R \> fichier UI pour la page mentions légales

\| UI_mentions_legales_droite.Rmd \> lié au fichier UI page mentions
légales

\| UI_mentions_legales_gauche.Rmd \> lié au fichier UI page mentions
légales

\| UI_page_accueil_gauche.R \> lié au fichier UI page accueil

\| UI_page_accueil_droite.Rmd \> appelé dans UI_page_accueil_gauche.R

\| UI_Ratios.R \> fichier UI pour la page ratios

\| UI_Ressources.R \> fichier UI pour la page ressources

+---data

\| +---dataBolero \> data

\| \| \| bolero_2016.csv \> data brut notamment appelé dans l'ETL

\| \| \| bolero_2016.xlsx \> data output après l'ETL, disponible en
téléchargement

\| \| \| bolero_2017.csv

\| \| \| bolero_2017.xlsx

\| \| \| bolero_2018.csv

\| \| \| bolero_2018.xlsx

\| \| \| bolero_2019.csv

\| \| \| bolero_2019.xlsx

\| \| \| bolero_2020.csv

\| \| \| bolero_2020.xlsx

\| \| \| rb_caroline_aout22_v5.xlsx \> fichier input ETL pour générer
'rb'

\| \| \|

\| \| \\---rb creation via api tentative \> fichier projet

\| \| rbCreation.R

\| \|

\| +---dataPdf \> fichiers à télécharger

\| \| guide_restructuration.pdf

\| \|

\| +---dataSpatial \> fichiers input ETL

\| \| ref_com.xlsx

\| \| ref_com_dep_reg.xlsx

\| \| ref_com_dep_reg_2022.xlsx

\| \| ref_epci.xlsx

\| \| ref_reg_dep.xls

\| \| ref_reg_dep_epci.xlsx

\| \|

\| \\---dico \> fichier input ETL

\| dico_indicateurs_financiers_new.xlsx

\|

+---images \> images appelées dans le fichier README.Rmd

\| paste-02498124.png

\| paste-504937BA.png

\| paste-CEF6FEE7.png

\|

+---renv \> dossier nécessaire au package {renv}

\| \| .gitignore

\| \| activate.R

\| \| settings.dcf
