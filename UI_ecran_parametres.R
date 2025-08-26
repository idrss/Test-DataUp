fluidPage(column(
  offset = 4,
  width = 6,
  box(
    status = "success",
    title = "L'année d'exercice comptable et la population de référence",
    tags$i(
      "
    Le choix de l'année et des familles d'organismes va définir la population de référence utilisée pour le calcul des moyennes, médianes et déciles. Ce choix détermine donc la population par rapport à laquelle l'organisme analysé sera positionné au regard des différents indicateurs.
           "
    ),
    br(),
    br(),
    selectInput(
      "select_annee",
      label = helpText("Choisir l'année des données :"),
      choices = list(
        "2022" = 2022, # ajouter une ligne pour la nouvelle année lors de l'actualisation 
        "2021" = 2021, 
        "2020" = 2020, 
        "2019" = 2019,
        "2018" = 2018
      ),
      selected = 2022 # changer la valeur par défaut pour chaque nouvelle année 
    ),
    
    selectInput(
      "select_pop_etude",
      label = helpText("Choisir la (les) famille(s) d'organismes :"),
      choices = rb %>% select(famille) %>% pull(),
      selected = c("OPH", "SA-HLM"),
      multiple =  T
    ),
    tags$i(
      "Les données des SA-HLM et des OPH étant les plus homogènes et les plus fiables, il est recommandé de choisir ces deux familles."
    )
  )
))