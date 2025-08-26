# écran accueil et définition version ----------------------------------------------------------

showModal(
  modalDialog(
    title = paste(
      "ERICOLS - Exploration de la remontée des informations comptables des organismes de logement social"
    ),
    footer = modalButton("J'accepte les conditions générales d'utilisation"),
    size = "l",
    fade = T,
    easyClose = F, # maintenir "false" pour forcer le lecteur à lire le texte 
    tags$div(column(
      width = 12,
      img(
        src = 'logo_MTES_MCT2.png',
        align = "left",
        height = "50%",
        width = "50%"
      ),
      img(
        src = 'identite.png',
        align = "right",
        height = "40%",
        width = "40%"
      )
    ),
    
    tags$div(
      column(width = 4,
             tags$h2(tags$code(
               stringr::str_glue("ERICOLS"," ", {versionApp}) #valeur à changer pour chaque nouvelle année 
             )),
             tags$h3(
               tags$code(
                 "image DIAGFIN du",
                 file.info(file = "data/dataBolero/bolero_2021.csv")$ctime #valeur à changer pour chaque nouvelle année 
               )
             )),
      
      column(
        width = 8,
        includeMarkdown("UI_page_accueil_droite.Rmd")
      )
    ))
  )
)