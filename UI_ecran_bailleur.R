fluidPage(column(
  width = 3,
  box(
    status = "success",
    width = 12,
    title = "L'année d'exercice comptable et la population de référence",
    textOutput("reminderBailleur") %>% tags$i(),
  )
  ,
  
  box(
    title = "1. L'organisme", 
    status = "primary",
    width = 12,
    tags$i(
      "Le menu déroulant est également une barre de recherche (avec fonction d'autocomplétion). Pour rechercher un organisme, cliquer sur le menu déroulant, effacer le texte et saisir son nom ou son numéro siren."
    ),
    br(),
    selectizeInput(
      label = h4(" "),
      inputId = "select_id",
      choices = b %>% pull(id) %>% unique(),
      multiple = FALSE,
      selected = "OFFICE PUBLIC DE L'HABITAT DE LA VILLE DE BOBIGNY - 279300149"
    )
    
  )
  ,
  
  box(
    status = "primary",
    width = 12,
    title = "La fiche de l'organisme",
    tableOutput("bailleurFicheId")
  )
  ,
  
  box(
    status = "primary",
    width = 12,
    title = "Les indicateurs clés",
    infoBoxOutput("bailleur_infoLls", width = 12),
    infoBoxOutput("bailleur_infoIndicateurFrng", width = 12),
    infoBoxOutput("bailleur_infoIndicateurCafca", width = 12),
    infoBoxOutput("bailleur_infoIndicateurTresorie", width = 12),
    infoBoxOutput("bailleur_depreciation", width = 12)
  )
),
column(
  width = 9,
  box(
    status = "warning",
    width = 12,
    title = "2. Les indicateurs financiers disponibles",
    collapsible = T,
    tags$i("
      Pour ajouter un indicateur dans le tableau de droite, cliquer sur un indicateur de la liste ci-dessous. 
      Pour effacer un indicateur, cliquer de nouveau dessus. 
             "),
    br(),
  multiInput(
    label = NULL,
    "page_bailleur_select_indicateur",
    choices = dico %>% 
      select(indicateur) %>% 
      pull(), 
    selected = " "
  )
  ),
  box(
    status = "warning",
    width = 12,
    title = "Les indicateurs financiers retenus",
    dataTableOutput("bailleur_indicateur_ajoute")
  )
))
