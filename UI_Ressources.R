fluidPage(column(
  width = 3,
  box(
    status = "success",
    title = "Les raccourcis du web",
    width = 12, 
    tags$p(
      "rechercher",
      tags$code("Ctrl"), tags$code("+"), tags$code("F")
    ),
    tags$p(
      "sauvegarder",
      tags$code("Ctrl"), tags$code("+"), tags$code("S")
    ),
    tags$p(
      "imprimer",
      tags$code("Ctrl"), tags$code("+"), tags$code("P")
    ),
    tags$p(
      "doubler",
      tags$code("Ctrl"), tags$code("+"), tags$code("N")
    ),
    tags$p(
      "zoomer",
      tags$code("Ctrl"), tags$code("molette"), "ou", tags$code("Ctrl"), tags$code("+")
    )
  ),
  box(
    status = "primary",
    width = 12,
    title = "Les données brutes",
    tags$p("Pour tout besoin de données spécifiques, veuillez effectuer une demande à l'", tags$a(href = "mailto:lo4.lo.dhup.dgaln@developpement-durable.gouv.fr", "adresse suivante : lo4.lo.dhup.dgaln@developpement-durable.gouv.fr"), ", en précisant :"),
    br(),
    # tags$li(tags$a(href = "mailto:lo4.lo.dhup.dgaln@developpement-durable.gouv.fr", "l'email : lo4.lo.dhup.dgaln@developpement-durable.gouv.fr")),
    tags$li("l'objet 'ERICOLS données complémentaires'."),
    tags$li("l’usage que vous souhaitez en faire"),
    tags$li("le territoire"),
    tags$li("l’exercice ou les exercices (années)"),
    tags$li("les indicateurs"),
    tags$li("les organismes (touts ceux du territoires, les représentants d'une famille..."),
  ),
  box(
    status = "primary",
    title = "Le guide de la restructuration",
    width = 12,
    tags$div("Guide à destination des services déconcentrés pour le suivi de la restructuration des OLS (loi Elan)."),
    br(),
    DL_button_data("dlGuide", "guide restructuration")
  ),
  box(
    status = "primary",
    title = "Les liens utiles",
    width = 12,
    tags$a(href = "https://www.financement-logement-social.logement.gouv.fr/", "SITE : les informations règlementaires du logement social"), 
    hr(),
    tags$a(href = "https://www.financement-logement-social.logement.gouv.fr/les-organismes-de-logement-social-chiffres-cles-r696.html", "BROCHURE : les chiffres clefs du logement social"),
    hr(),
    tags$a(href = "https://ssm-ecologie.shinyapps.io/RPLS/", "APPLICATION : Répertoire des logements locatifs des bailleurs sociaux (RPLS)")
  )
),
column(
  width = 9,
  box(
    status = "primary",
    title = "Le dictionnaire des indicateurs",
    width = 12,
    tableOutput("ressources_tableaudictionnaire")
  )
))
