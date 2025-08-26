######################## PACKAGE ###########################

library(tidyverse) #package essentiel pour la data science
library(tidyr) #package nécessaire pour la transformation des données
library(dplyr) #package nécessaire pour la transformation des données
library(shiny) #package pour le rendu intéractif web
library(shinydashboard) #package ui pour le rendu intéractif web
library(rio) #package nécessaire pour l'import et l'export des données
library(readxl) #package nécessaire pour l'import des fichiers .xlsx
library(shinycssloaders) #package nécessaire pour le volet serveur et le choix des départements
library(shinyEffects) #package nécessaire pour l'ui du choix des départements
library(DT) #package nécessaire pour l'affichage des données sous forme de tableau intéractif
library(janitor) #package nécessaire pour des statstiques descriptives
library(shinyWidgets) #package nécessaire pour l'ui shiny
library(htmltools) #package nécessaire pour l'ui shiny
library(renv) #package nécessaire pour figer les packages
library(markdown) #package pour lire les markdown 
library(shinyWidgets)#package pour multicol choix des indicateurs page bailleur et choix des indicateurs page ratios 

######################## PARAMETRES ###########################

versionApp <- "v1.3.6" # à changer pour afficher la version partout sur l'ensemble des fichiers 


######################## FONCTIONS ###########################

`%not_in%` <- Negate(`%in%`)

percent <- function(x,
                    digits = digits,
                    format = "f",
                    ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}



#' Avoir la définition d'un indicateur 
#'
#' @param x un indicateur  
#'
#' @return retourne la définition de cet indicateur 
#' @import magrittr
#' @export
#'
#' @examples 
#' > dico$indicateur
#' "RLS_BRUTE - Réduction du loyer solidaire brute"
#' dico$indicateur[1] %>% getDefinitionMetier()
#' "Dans le cadre de la RLS, la RLS brute représente le montant avant lissage. Il n'est pas le montant effectivement payé (se référer à la RLS nette)."
#'

getDefinitionMetier <- function(x) {
  dicoReactive <- dico %>%
    filter(indicateur == x) %>%
    pull(definition_metier)
  
  paste(dicoReactive)
  
}

#' Télécharger les fichiers bruts
#'
#' @param outputId
#' @param label 
#'
#' @return
#' @export
#'
#' @examples
DL_button_data <- function(outputId, label = "télécharger") {
  tags$a(
    id = outputId,
    class = "btn btn-primary shiny-download-link",
    href = "",
    target = "_blank",
    download = NA,
    icon("file-alt"),
    label,
    style = 'padding:8px; font-size:100%; width:100%;'
  )
}

#' Multi-fonctions 
#'
#' @param x pour un vector, déterminer la valeur, médiane, la moyenne, le minimum, le maximum et la somme 
#'
#' @return un texte 
#' importFrom stats median
#' @export
#'
#' @examples
#'  c(1:100) %>% multi.fun()
#' mean    min    max    sum 
#' 50.5   50.5    1.0  100.0 5050.0 


multi.fun <- function(x) {
  c(
    median(x, na.rm = T),
    mean = mean(x, na.rm = T),
    min = min(x, na.rm = T),
    max = max(x, na.rm = T),
    sum = sum(x, na.rm = T)
  )
}


#' Récupère le libellé d'une région à partir d'un code région 
#'
#' @param x un code région 
#'
#' @return le libellé de la région 
#' import magrittr 
#' @export
#'
#' @examples
#' b$reg[32]
#' "52"
#' b$reg[32] %>% getRegion()
#' "Pays de la Loire"

getRegion <- function(x) {
  a <- ref_reg %>%
    filter(reg == x) %>%
    pull(libreg)
  
  paste(a)
}

#' Récupère le libellé complet d'un département à partir d'un code département  
#'
#' @param x un code département
#'
#' @return le libellé du département 
#' import magrittr
#' @export
#'
#' @examples
#' b$dep[12]
#' "44"
#' b$dep[12] %>% getDep()
#' "LOIRE-ATLANTIQUE - 44"

getDep <- function(x) {
  a <- ref_dep %>%
    filter(dep == x) %>%
    pull(libdep)
  
  b <- ref_dep %>%
    filter(dep == x) %>%
    pull(dep)
  
  paste(a, "-", b)
  
}

#' Récupère la famille OHLM d'un organisme à partir de son id
#'
#' @param x un id bailleur 
#'
#' @return la famille de l'id bailleur demandé : OPH par exemple 
#' import magrittr 
#' @export
#'
#' @examples 
#' b$dep[12] %>% getDep()
#' s"LOIRE-ATLANTIQUE - 44"
#' b$id[123]
#' "SCIC VALDURANCE HABITAT - 005650148"

getFamille <- function(x) {
  b %>%
    filter(id == x) %>%
    pull(famille) %>%
    unique()
  
}
#pour un meilleur affichage checkboxGroupInput de la page accueil
page_bailleur_affichage_tableau <-
  list(tags$head(tags$style(
    HTML(
      "
                                 .multicolBailleur {
                                   height: 400px;
                                   width: 750px;
                                   font-size: 10px;
                                   column-gap: 10px;
                                   /*-webkit-column-count: 8;  Chrome, Safari, Opera */
                                   -moz-column-count: 8;    /* Firefox */
                                   -column-count: 8;
                                   -moz-column-fill: balance;
                                   -column-fill: balance;
                                 }
                                 "
    )
  )))
#pour un meilleur affichage checkboxGroupInput de la page ratios
page_ratios_affichage_tableau <-
  list(tags$head(tags$style(
    HTML(
      "
                                 .multicolRatios {
                                   height: 900px;
                                   width: 350px;
                                   font-size: 10px;
                                   -webkit-column-count: 3; /* Chrome, Safari, Opera */
                                   -moz-column-count: 3;    /* Firefox */
                                   -column-count: 3;
                                   -moz-column-fill: balance;
                                   -column-fill: balance;
                                 }
                                 "
    )
  )))


#' Génère pour un vector, l'affichage texte D1,D2, etc. 
#'
#' @param x un integer
#'
#' @return un texte 
#' @export
#'
#' @
#' .2 %>% ecdfText()
#' "entre D2 et D3"

ecdfText <- function(x) {
  if (x < .1) {
    result <- "inférieur 1D"
  }
  else if (x >= .1 & x < .2) {
    result <- "entre D1 - D2"
  }
  else if (x >= .2 & x < .3) {
    result <- "entre D2 - D3"
  }
  else if (x >= .3 & x < .4) {
    result <- "entre D3 - D4"
  }
  else if (x >= .4 & x < .5) {
    result <- "entre D4 - D5"
  }
  else if (x >= .5 & x < .6) {
    result <- "entre D5 - D6"
  }
  else if (x >= .6 & x < .7) {
    result <- "entre D6 - D7"
  }
  else if (x >= .7 & x < .8) {
    result <- "entre D7 - D8"
  }
  else if (x >= .8 & x < .9) {
    result <- "entre D8 - D9"
  }
  else {
    result <- "supérieur 9D"
  }
  return(result)
}



######################## DATA ###########################

source("bolero_data_transformation.R",
       encoding = "UTF-8",
       local = TRUE)$value

######################## UI ###########################

ui <-
  dashboardPage(
    dashboardHeader(title = "ERICOLS", disable = T),
    
    dashboardSidebar(disable = TRUE),
    
    dashboardBody(
      navbarPage(
        title = paste("ERICOLS"),
        collapsible = TRUE,
        fluid = TRUE,
        # responsive = TRUE,
        selected = "paramètres",
        
        tabPanel("paramètres",
                 source(
                   "UI_ecran_parametres.R",
                   encoding = "UTF-8",
                   local = TRUE
                 )$value
                 , icon = icon("calendar"))
        ,
        tabPanel("organisme",
                 source(
                   "UI_ecran_bailleur.R", encoding = "UTF-8", local = TRUE
                 )$value
                 , icon = icon("address-card"))
        ,
        tabPanel("territoire",
                 source(
                   "UI_ecran_territoire.R",
                   encoding = "UTF-8",
                   local = TRUE
                 )$value
                 , icon = icon("buromobelexperte"))
        ,
        tabPanel("déciles des indicateurs",
                 source(
                   "UI_Ratios.R", encoding = "UTF-8", local = TRUE
                 )$value,
                 icon = icon("table"))
        ,
        tabPanel("ressources",
                 source(
                   "UI_Ressources.R", encoding = "UTF-8", local = TRUE
                 )$value,
                 icon = icon("info-circle"))
        ,
        tabPanel("mentions légales",
                 source(
                   "UI_Mentions_legales.R",
                   encoding = "UTF-8",
                   local = TRUE
                 )$value,
                 icon = icon("university"))
      ),
      
    ),
    
  )

######################## SERVER ###########################

server <- function(input, output, session) {
  source("SERVER_bolero.R", encoding = "UTF-8", local = TRUE)$value
  
}

######################## RUN THE APP ###########################

shinyApp(ui = ui, server = server)
