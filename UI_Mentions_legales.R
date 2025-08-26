fluidPage(
  column(width = 6,
         includeMarkdown("UI_mentions_legales_gauche.Rmd") %>% box(
                     status = "success",
                     width = 12
                 )),
  column(width = 6,
         includeMarkdown("UI_mentions_legales_droite.Rmd") %>% box(
                     status = "success",
                     width = 12
                 ))
  )
