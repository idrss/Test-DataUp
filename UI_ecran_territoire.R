fluidPage(
  column(width = 3, 
         box(
           title = "L'année d'exercice comptable et la population de référence",
           status = "success",
           width = 12, 
           textOutput("reminderTerritoire") %>% tags$i()
         ),
         box(
           title = "1. Le territoire",
           status = "primary",
           width = 12, 
           helpText("Pour sélectionner une région ou un département, cliquer sur le menu déroulant correspondant, effacer le texte et saisir le nom du territoire souhaité."),
           selectizeInput(
             "select_geo",
             label = h4("niveau géographique"),
             choices = list(
               "Région" = "reg",
               "Département" = "dep"
               # ,
               # "Métropole" = "metro", "DROM" = "drom",
               # "EPCI" = "epci",
               # "Commune" = "com"
             ),
             selected = "reg",
           ),
           withSpinner(uiOutput("ui_geo"), color = "#1484b1", type = "7"),# UI réactive en fonction de la sélection
         ),
         box(
           title = "La fiche du territoire",
           status = "primary",
           width = 12, 
           infoBoxOutput("territoire_infoNBailleur", width = 12),
           infoBoxOutput("territoire_infoLls", width = 12)
         ),
         box(
           title = "Les indicateurs clés",
           status = "primary",
           width = 12, 
           tableOutput("territoire_TableauSyntheseType"),
           tableOutput("territoire_TableauSyntheseDep")
         ),
         box(
           title = "2. Les indicateurs financiers disponibles",
           status = "warning",
           width = 12, 
           selectizeInput(
             "territoire_select_indicateur",
             label = h4(" "),
             choices = dico %>% 
               select(indicateur) %>% 
               pull(), 
             selected = " "
           ),
           
           helpText("Pour ajouter un indicateur, le selectionner dans le menu déroulant puis appuyer sur 'ajouter'."),
           helpText("Pour le supprimer de l'affichage, appuyer sur 'Suppr'."),
           
           actionButton(inputId = "ajouter2",
                        label = "ajouter",
                        width = '100%',
                        style= "color: #fff; background-color: #F39C12; border-color: #F39C12"
           ),
           
           br(),
           tags$br("définition métier :"),
           helpText(textOutput(outputId = "territoire_dico"))
         )
  ),
  column(width = 9, 
         fixedRow(box(
           status="primary",
           width = 12,
           title = "Les détails des organismes du territoire",
           collapsible = T,
           dataTableOutput("territoire_TableauBailleur", width = '100%')),
           box(
             status="primary",
             width = 6,
             title = "Les caractéristiques nationales (population de référence : OPH + SA-HLM)",
             collapsible = T,
             tableOutput("territoire_TableauSyntheseIndicateurN")),
           box(
             status="primary",
             width = 6,
             title = "Les caractéristiques du territoire (population de référence : celle choisie)",
             collapsible = T,
             tableOutput("territoire_TableauSyntheseIndicateur")),
           box(
             title = "Les indicateurs financiers retenus", 
             status = "warning",
             width = 12,
             tags$div(id = 'placeholder2')
           )
           )
  )
)
  
