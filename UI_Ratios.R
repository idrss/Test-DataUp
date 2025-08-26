fluidPage(
  column(
    width = 4,
    box(
      status = "success",
      width = 12,
      title = "L'année d'exercice comptable et la population de référence",
      textOutput("reminderRatios") %>% tags$i(),
    ),
    box(
      status = "warning",
      width = 12, 
      title = "1. Les indicateurs financiers disponibles",
      tags$i("
      Pour ajouter un indicateur dans le tableau de droite, cliquer sur un indicateur de la liste ci-dessous. 
      Pour effacer un indicateur, cliquer de nouveau dessus. 
             "),
      br(),
      multiInput(
        label = NULL,
        "ratios_select_indicateur_ratios",
        choices = dico %>% 
          select(indicateur) %>% 
          pull(), 
        selected = " "
      )  
    )
  ),
  column(
    width = 8,
    box(
      title = "Les indicateurs financiers retenus",
      status = "warning",
      width = 12,
      collapsible = F,
      dataTableOutput("ratiosTableau")
    )
    
  )
)