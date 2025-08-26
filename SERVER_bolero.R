######################## TOUTES LES PAGES ###########################

# générique : dico  --------------------------------------------------------------------

output$territoire_dico <- renderText({
  
  getDefinitionMetier(x = input$territoire_select_indicateur)
  
})

# générique : rappel des paramètres choisis  ------------------------------

output$reminderBailleur <- renderText({
  
  a <- paste(input$select_annee)
  
  b <- paste(input$select_pop_etude) 
  
  c(a, b)
  
  
})

output$reminderTerritoire <- renderText({
  
  a <- paste(input$select_annee)
  
  b <- paste(input$select_pop_etude) 
  
  c(a, b)
  
  
})

output$reminderRatios <- renderText({
  
  a <- paste(input$select_annee)
  
  b <- paste(input$select_pop_etude) 
  
  c(a, b)
  
  
})

######################## PAGE ACCUEIL ############################### 

source(
  "UI_page_accueil_gauche.R", encoding = "UTF-8", local = TRUE
)$value

######################## PAGE BAILLEUR ############################### 

# écran bailleur : renderTier1result------------------------------------------------------------------


#' Afficher la valeur d'un indicateur pour un couple 'bailleur, indicateur, année'
#'
#' @param x un indicateur 
#'
#' @return
#' @export 
#'
#' @examples 
#'   result <- b %>%
#'filter(indicateur == x,
#'       id == input$select_id,
#'       annee == input$select_annee) %>%
#'  pull(indicateur_value) 

getIndicateurValue <- function(x){
  
  result <- b %>%
    filter(indicateur == x,
           id == input$select_id,
           annee == input$select_annee) %>%
    pull(indicateur_value) 
  
  paste(result)
  
}

#' Afficher le positionnement d'un indicateur pour un couple 'bailleur, indicateur, année, pop d'étude'. 
#' La fonction repose sur 'getIndicateurValue'
#'
#' @param x un indicateur 
#'
#' @return le décile d'appartenance de l'indicateur 
#' @export
#'
#' @examples
getIndicateurPosition <- function(x){
  
  getValueFromIdPop <- b %>%
    filter(indicateur == x,
           annee == input$select_annee,
           famille == input$select_pop_etude) %>%
    select(indicateur_value)%>%
    pull()
  
  ecdfFromIDPop <- ecdf(getValueFromIdPop)
  
  paste(
    ecdfFromIDPop(getIndicateurValue(x)) %>% ecdfText()
  )
  
}


# écran bailleur : indicateurs financiers reactive --------------------------------------------------

### plusieurs variables reactives car elles sont appelées à plusieurs reprises ; chaque élément réactif fait référence à un indicateur financier. 

llsTotal <- reactive({
  
  a <- b %>%
    filter(id == input$select_id,
           indicateur_code %in% c("A2", "A3"), #en 2024, BLOGTGERE est nommé A2, BLFGERE est nommé A3
           annee == input$select_annee) %>% 
    select(indicateur_value) %>% 
    sum()
})


frng <- reactive({

    b %>%
      filter(id == input$select_id,
             indicateur_code == "D2", # en 2024, B2 est devenu D2 qq soit la famille de l'organisme
             annee == input$select_annee) %>%
      pull(indicateur_value)

})



cafca <- reactive({
  
  b %>%
    filter(id == input$select_id,
           indicateur_code == "D20", # en 2024, B20 est devenu D20
           annee == input$select_annee) %>%
    pull(indicateur_value)
  
  
})


tresorie <- reactive({
  
  a <- b %>%
    filter(id == input$select_id,
           indicateur_code == "D4", 
           annee == input$select_annee) %>%
    pull(indicateur_value)
  
})


depreciation <- reactive({ 
  
  a <- b %>%
    filter(id == input$select_id,
           indicateur_code %in% c("D35"), #en 2024, C5 est devenu D35
           annee == input$select_annee) %>% 
    select(indicateur_value) %>% 
    pull(indicateur_value)
})



# écran bailleur : tableau des bailleurs indicateurs à ajouter et supprimer ----------------------

### résultat fonction des inputs suivants : "input$page_bailleur_select_indicateur" 
### il permet de présenter selon les éléments choisis par l'opérateur : la valeur de l'indicateur coché, sa définition et son positionnement

output$bailleur_indicateur_ajoute <- renderDataTable({
  
  req(input$page_bailleur_select_indicateur)
  
  indicateur <- c(input$page_bailleur_select_indicateur)
  
  df1 <- sapply(indicateur, getIndicateurValue) %>% 
    as_tibble()
  
  df1$id <- indicateur
  
  df1 <- df1 %>%
    select(id, value)
  
  df1 <- df1 %>% 
    rename(`nom de l'indicateur` = id,
           indicateur = value) 
  
  df2 <- sapply(indicateur, getIndicateurPosition) %>% 
    as_tibble()
  
  df2$id <- indicateur
  
  df2 <- df2 %>%
    select(value)
  
  df2 <- df2 %>% 
    select(value) %>% 
    rename(`décile d'appartenance` = value) 
  
  df3 <- sapply(indicateur, getDefinitionMetier) %>% 
    as_tibble()
  
  df3$id <- indicateur
  
  df3 <- df3 %>%
    rename(indicateur1 = id,
           `définition de l'indicateur` = value) %>% 
    select(`définition de l'indicateur`)
  
  df <- cbind(df1, df2, df3)
  
  df 
  
  
  
  
},
server = T,
filter =  'top',
rownames = F,
extensions = c('Buttons', 'ColReorder'),
options = list(
  autoWidth = T,
  colReorder= T,
  dom = 'Bfrtip',
  pageLength = 10,
  buttons = 
    list(list(extend = 'copy'),
         list(extend = 'excel', filename = paste0(Sys.Date(), " export ERICOLS"), header = "ERICOLS"),
         list(extend = 'colvis'))
) 
)







# écran bailleur : fiche bailleur ----------------------------------------------------------------------

### tableau affiché pour définir les principales caractéristiques de l'organisme choisi 

output$bailleurFicheId <- renderTable({
  
  df1 <- rb %>% 
    filter(id == input$select_id) %>% 
    select(nom, siren, famille, dep, reg) %>% 

    rename(
      `Nom` = nom,
      `Numéro de SIREN` = siren,
      `Famille` = famille, 
      `Département du siège de l'organisme` = dep,
      `DREAL gestionnaire` = reg
    )
  
  df1 <- as_tibble(cbind(nms = names(df1), t(df1)))
  
  if(!is.na(df1$V2[4]) & !is.na(df1$V2[5])){
    df1$V2[4] <- df1$V2[4] %>% getDep
    df1$V2[5] <- df1$V2[5] %>% getRegion
  }
  
  
  df1

}
,
colnames = F,
hover = TRUE,
align = 'l', 
digits = 2,
spacing = "xs",
width = '100%'
)


# écran bailleur : infobox bailleur --------------------------------------------------------

### plusieurs infobox pour une meilleure prise de connaissance côté opérateur 
### ces infobox sont conditionnés en fonction de l'organisme interrogé 

output$bailleur_infoLls <- renderInfoBox({
  
  
  subtitle <- if_else(getFamille(input$select_id) != "COOP", 
                      "somme des logements ordinaires et foyers gérés",
                      "lorsque la somme des logements ordinaires et foyers gérés est nul, les ratios financiers sont à prendre avec précaution")
  
  a <- llsTotal()
  
  infoBox(
    title = "Total Logements gérés",
    color = "blue",
    subtitle = subtitle, 
    icon = icon("building"), 
    value = paste(a %>% prettyNum(big.mark  = " "), "logements")
  )
  
})

# output$bailleur_infoIndicateurFrng <- renderInfoBox({
#   
#   a <- if_else(getFamille(input$select_id) != "SEM", 
#                frng() %>% round(2), 
#                frng() %>% round(2))
#   
#   b <- if_else(getFamille(input$select_id) != "SEM",
#                "eq. mois de dépense",
#                "€/logement")
#   
#   
#   c <- if (getFamille(input$select_id) != "SEM") {
#     if_else(a > 2, "risque de cessation de paiement faible", "donc risque de cessation de paiement élevé")
#   } else if (getFamille(input$select_id) == "SEM") {
#     if_else(a > 750, "risque de cessation de paiement faible", "donc risque de cessation de paiement élevé")
#   }
#   
#   subtitle <- if_else(getFamille(input$select_id) != "SEM", 
#                       "pour les OHLM la valeur doit être supérieure à 2 mois de dépenses",
#                       "pour les SEM la valeur doit être supérieure à 750€/logement géré")
#   
#   infoBox(
#     title = "FRNGT au logement",
#     color = "blue",
#     subtitle = subtitle, 
#     icon = icon("piggy-bank"), 
#     value = paste(a, b, c), 
#   )
#   
# })

output$bailleur_infoIndicateurFrng <- renderInfoBox({
  
  a <- frng()
  
  
  b <- if_else(
    a > 750,
    "organisme au-dessus du seuil d’alerte",
    "donc un risque de cessation de paiement existe"
  )
  
  infoBox(
    title = "FRNGT au logement",
    color = "blue",
    subtitle = "pour les OHLM la valeur doit être supérieure à 750€", 
    icon = icon("piggy-bank"), 
    value = paste(a %>% sprintf("%.1f",.) %>% prettyNum(big.mark  = " "), "€ par logement", b) 
  )
  
})



output$bailleur_infoIndicateurCafca <- renderInfoBox({
  
  a <- cafca()
  
  b <-
    if_else(
      a > 35,
      "donc les ressources avant remboursement des emprunts sont suffisantes",
      "donc les ressources avant remboursement des emprunts sont insuffisantes"
    )
  
  infoBox(
    title = "CAF Brute / C.A. locatif (%)",
    color = "blue",
    subtitle = "le seuil plancher est de 35%", 
    icon = icon("wallet"), 
    value = paste(a %>% sprintf("%.0f%%",.), b), 
  )
  
})

output$bailleur_infoIndicateurTresorie <- renderInfoBox({
  
  a <- tresorie()
  
  b <- if_else(
    a > 1000, 
    "organisme au dessus du seuil d'alerte", 
    "donc un risque de cessation de paiement existe")
  
  infoBox(
    title = "Trésorerie par logement",
    color = "blue",
    subtitle = "le seuil plancher est de 1 000€", 
    icon = icon("coins"), 
    value = paste(a %>% sprintf("%.1f",.) %>% prettyNum(big.mark  = " "), "€ par logement", b) 
  )
  
})


output$bailleur_depreciation <- renderInfoBox({
  
  a <- depreciation()
  
  infoBox(
    title = "Dépréciation",
    color = "blue",
    subtitle = "le seuil plancher est de 0", 
    icon = icon("business-time"),
    value = paste(a %>% sprintf("%.1f",.) %>% prettyNum(big.mark  = " "), "année(s)") 
  )
  
})



######################## PAGE TERRITOIRE ############################### 

# ecran territoire : choix des territoires ui reactive pour selection région ou département  -------------------------------------------------------

### variable d'environnement pour notamment switcher entre le niveau département et le niveau régional sans conditionner chaque fonction sur la page territoire 
### la fonction jongle sur le niveau départemental et le niveau régional. 
### appeler "input$select_geo" à partir de maintenant 
### possible de continuer sur le niveau epci, communal etc. 

output$ui_geo <- renderUI({
  if (is.null(input$select_geo)) {
    return()
  }
  
  switch(
    input$select_geo,
    "reg" =  selectInput(
      "select_mod",
      label = h4("sélection de la région"),
      choices = sort(ref_reg$libreg), 
      multiple = FALSE, 
      selected= "Bretagne"
    ),
    "dep" =  selectInput(
      "select_mod",
      label = h4("sélection du département"),
      choices = sort(ref_dep$libdep)
    )
  )
  
})

#value identifiant de la région ou de l'identifiant 
id_select_mod <- reactive({
  switch(
    input$select_geo,
    "reg"  = return(ref_reg[ref_reg$libreg %in% input$select_mod,]$reg),
    "dep"  = return(ref_dep[ref_dep$libdep %in% input$select_mod,]$dep)
    # ,
    # "epci" = return(ref_epci()[ref_epci()$LIBEPCI %in% input$select_mod,]$SIREN),
    # "com"  = return(ref_com()[ref_com()$LIBCOM %in% input$select_mod,]$DEPCOM)
  )
  
})

# ecran territoire : variable reactive territoire  -------------------------------------------------------

### variable réactive utilisée pour les prochains calculs 
### il se repose sur le territoire choisi et plusieurs indicateurs clefs 
### il est à conditionner en fonction du niveau territorial car on ne filtre pas sur la même variable 

territoire <- reactive({
  
  if(input$select_geo == "reg"){
    
    b %>%
      filter(
        annee == input$select_annee,
        indicateur_code %in% c(
          "D4", 
          "D21", #B21 est remplacé par D21
          "D20", #B20 est remplacé par D20
          "D35", #C5 est remplacé par D35
          "A2", #BLOGTGERE est remplacé par A2
          "A3", #BLFGERE est remplacé par A3
          "D2"), #B2 est remplacé par D2
          # "B2SEM"), #B2SEM est supprimé par D2 
        reg == id_select_mod()) %>%
      pivot_wider(id_cols = c("siren", "nom", "famille", "dep", "reg"),
                  names_from = "indicateur_code",
                  values_from = "indicateur_value") %>%
      left_join(ref_dep, by = "dep") %>% 
      left_join(ref_reg, by = "reg") %>% 
      mutate(`département` = paste(libdep, "-", dep)) %>% 
      as_tibble() 
    
  }
  
  else{
    b %>%
      filter(
        annee == input$select_annee,
        indicateur_code %in% c(
          "D4",
          "D21", #B21 est remplacé par D21
          "D20", #B20 est remplacé par D20
          "D35", #C5 est remplacé par D35
          "A2", #BLOGTGERE est remplacé par A2
          "A3", #BLFGERE est remplacé par A3
          "D2"), #B2 est remplacé par D2
        # "B2SEM"), #B2SEM est supprimé par D2 
        dep == id_select_mod()) %>%
      pivot_wider(id_cols = c("siren", "nom", "famille", "dep", "reg"),
                  names_from = "indicateur_code",
                  values_from = "indicateur_value") %>%
      left_join(ref_dep, by = "dep") %>% 
      left_join(ref_reg, by = "reg") %>% 
      mutate(`département` = paste(libdep, "-", dep)) %>% 
      as_tibble() }
})



# écran territoire : les indicateurs clefs, tableau synthèse famille --------------------------------

### tableau pour illustrer la composition du territoire par famille d'organisme
### le résultat se repose sur la variable 'territoire()' 

output$territoire_TableauSyntheseType <- renderTable({
  
  req(territoire())
  
  if(nrow(territoire())>2){
    
    territoire() %>%
      group_by(famille) %>%
      summarise(
        nombre = n(),
        `logements + foyers gérés` = sum(A2, A3, na.rm = T)) %>%
      mutate(
        '%' = (`logements + foyers gérés`/sum(`logements + foyers gérés`, na.rm = T)) %>% percent(digits = 0),
        `logements + foyers gérés` = prettyNum(`logements + foyers gérés`, big.mark = " ")) %>% 
      adorn_totals("row") 
    
    
  }
  
  else{print("Nombre insuffisant de bailleurs pour présenter un résultat interprétable. ")}
  
}
,
hover = TRUE,
align = 'r',
digits = 0,
spacing = "xs",
width = '100%'
)


# écran territoire : les indicateurs clefs, tableau synthèse département -------------------------

### tableau pour illustrer la composition du territoire par département 
### le résultat se repose sur la variable 'territoire()' 

output$territoire_TableauSyntheseDep <- renderTable({
  
  if(nrow(territoire())>2){
    
    territoire() %>% 
      group_by(`département`) %>% 
      summarise(
        nombre = n(),
        `logements + foyers gérés` = sum(A2, A3, na.rm = T)) %>% 
      mutate(
        '%' = (`logements + foyers gérés`/sum(`logements + foyers gérés`, na.rm = T)) %>% percent(digits = 0),
        `logements + foyers gérés` = `logements + foyers gérés` %>% prettyNum(big.mark = " "))
      
    
  }else{print("Nombre insuffisant de bailleurs pour présenter un résultat interprétable. ")}
  
}
,
hover = TRUE,
align = 'r', 
digits = 0,
spacing = "xs",
width = '100%')


# écran territoire : "Les caractéristiques nationales (population de référence : OPH + SA-HLM)" -----------------

### tableau pour illustrer l'échelle national par rapport aux indicateurs présentés 
### le résultat se repose sur la variable 'territoire()' 

output$territoire_TableauSyntheseIndicateurN <- renderTable({
  
  temp <- b %>%
    filter(
      famille %in% c("SA-HLM", "OFFICE"),
      annee == input$select_annee,
      indicateur_code %in% c(
        "D2",
        "D4",
        "D20",
        "D35", 
        "A2")) %>%
    pivot_wider(id_cols = c("siren", "nom", "famille", "dep", "reg"),
                names_from = "indicateur_code",
                values_from = "indicateur_value") %>%
    as_tibble()
  
  resultat <- sapply(
    temp %>% 
      select(-c(siren, reg)) %>% 
      select_if(is.numeric), multi.fun) %>% 
    round(digits = 2) %>% 
    as_tibble() %>% 
    rename(
      `trésorie par logement` = D4,
      `CAF brute/C.A locatif` = D20,
      `dépréciation` = D35,
      `total logements gérés` = A2,
      `FRNGT par logement` = D2
    ) %>%
    select(
      `total logements gérés`,
      `trésorie par logement`,
      `CAF brute/C.A locatif`,
      `FRNGT par logement`,
      `dépréciation`
    ) %>% 
    mutate(
      `total logements gérés` = `total logements gérés` %>% sprintf("%.0f",.) %>% prettyNum(big.mark  = " "),
      `trésorie par logement` = `trésorie par logement` %>% sprintf("%.0f",.) %>% prettyNum(big.mark  = " "),
      `CAF brute/C.A locatif` = `CAF brute/C.A locatif` %>% sprintf("%.1f%%",.),
      `FRNGT par logement` = `FRNGT par logement` %>% sprintf("%.0f",.) %>% prettyNum(big.mark  = " "), 
      `dépréciation` = `dépréciation` %>% sprintf("%.1f%%",.)
    ) %>% 
    rowid_to_column()
  
  resultat[,1] <- c("mediane", "moyenne", "min.", "max.", "somme")
  
  resultat <- resultat %>% rename(' '= rowid)
  
  
  # pour cleaner les valeurs somme de % qui ne veut rien dire 
  
  resultat[5,4] <- NA
  resultat[5,5] <- NA
  resultat[5,6] <- NA
  
  # pour exposer le résultat
  
  resultat

  
}
,
hover = TRUE,
align = 'r', 
digits = 2,
spacing = "xs",
width = '100%'
)



# écran territoire : "Les caractéristiques du territoire (population de référence : celle choisie)" --------------------------

### tableau pour illustrer l'échelle national par rapport aux indicateurs présentés puis le comparer au territoire choisi 
### le résultat se repose sur la variable 'territoire()' 

output$territoire_TableauSyntheseIndicateur <- renderTable({
  
  if(nrow(
    territoire() %>% filter(famille %in% input$select_pop_etude)
  ) > 3){
    
    resultat <- sapply(territoire() %>% 
                         filter(famille %in% input$select_pop_etude) %>% 
                         select(-c(siren, reg)) %>% 
                         mutate(
                           `logements + foyers` = A2 + A3,
                           `FRNGT par logement` = D2) %>%
                         select_if(is.numeric), multi.fun) %>%       
      as_tibble() %>% 
      rename(
        `trésorie par logement` = D4,
        `CAF brute/C.A locatif` = D20,
        `dépréciation` = D35,
        `total logements gérés` = A2) %>%
      select(
        `total logements gérés`,
        `trésorie par logement`,
        `CAF brute/C.A locatif`,
        `FRNGT par logement`,
        `dépréciation`
      ) %>% 
      mutate(
        `total logements gérés` = `total logements gérés` %>% sprintf("%.0f",.) %>% prettyNum(big.mark  = " "),
        `trésorie par logement` = `trésorie par logement` %>% sprintf("%.0f",.) %>% prettyNum(big.mark  = " "),
        `CAF brute/C.A locatif` = `CAF brute/C.A locatif` %>% sprintf("%.1f%%",.),
        `FRNGT par logement` = `FRNGT par logement` %>% sprintf("%.0f",.) %>% prettyNum(big.mark  = " "), 
        `dépréciation` = `dépréciation` %>% sprintf("%.1f%%",.)
      ) %>%
      rowid_to_column()
    
    resultat[,1] <- c("mediane", "moyenne", "min.", "max.", "somme")
    
    resultat <- resultat %>% rename(' '= rowid)
    
    # pour cleaner les valeurs somme de % qui ne veut rien dire 
    
    resultat[5,4] <- NA
    resultat[5,5] <- NA
    resultat[5,6] <- NA
    
    # pour exposer le résultat

    resultat }else{
      tibble(' ' = "Nombre insuffisant de bailleurs pour présenter un résultat interprétable.")}
  
  
}
,  
align = 'r', 
digits = 2,
spacing = "xs",
width = '100%',
hover = TRUE
)


# écran territoire : Les détails des organismes du territoire -------------------------------------

### tableau pour détailler les bailleurs qui composent le territoire choisi 

output$territoire_TableauBailleur <- renderDataTable({
  
  if(nrow(
    territoire() %>% filter(famille %in% input$select_pop_etude)
  ) > 3){
  
  req(
    territoire()$D4, territoire()$D20, territoire()$D35, territoire()$A2, territoire()$A3, territoire()$D2, cancelOutput = F)
    
    territoire() %>% 
    mutate_if(is.character, as.factor) %>% 
    mutate(`FRNGT par logement` = D2) %>% 
    select(-c(reg, dep, libreg, libdep)) %>% 
    rename(
      `trésorie par logement` = D4,
      `CAF brute/C.A locatif ` = D20,
      `dépréciation` = D35,
      `logements ordinaires gérés` = A2,
      `logements foyers gérés` = A3,
    ) %>%
      select(
        `département`,
        siren,
        nom,
        famille,
        `logements ordinaires gérés`,
        `logements foyers gérés`,
        `trésorie par logement`,
        `CAF brute/C.A locatif `, 
        `FRNGT par logement`,
        `dépréciation`
      ) %>%
      mutate(
      `logements ordinaires gérés` = `logements ordinaires gérés` %>% prettyNum(big.mark = " "),
      `logements foyers gérés` = `logements foyers gérés` %>% prettyNum(big.mark = " "),
      `trésorie par logement` = `trésorie par logement` %>% round(2) %>% prettyNum(big.mark = " "),
      `CAF brute/C.A locatif ` = `CAF brute/C.A locatif ` %>% round(2) %>% prettyNum(big.mark = " "),
      `FRNGT par logement` = `FRNGT par logement` %>% round(0),
      `dépréciation` = `dépréciation` %>% round(2))}
  else{
    tibble(' ' = "Nombre insuffisant de bailleurs pour présenter un résultat interprétable. ")}
  
 
}
,
server = T,
filter =  'top',
rownames = F,
extensions = c('Buttons', 'ColReorder'),
options = list(
  autoWidth = T,
  colReorder= T,
  dom = 'Bfrtip',
  pageLength = 10,
  buttons = 
    list(list(extend = 'copy'),
         list(extend = 'excel', filename = paste0(Sys.Date(), " export ERICOLS"), title = "ERICOLS"),
         list(extend = 'colvis'))
  )
)

# écran territoire : indicateur ajouter/supprimer -------------------------------------------------------

### élément qui évolue en fonction de l'évènement "ajouter un indicateur" (bouton)
### cet élément est à relier avec l'élément qui suit 
### l'output se nomme "#placeholder2" 

# var pour supprimer un indicateur 
rv <- reactiveValues()

# ajouter un indicateur selon les évènements 
observeEvent({input$ajouter2}, {
  
  # calculs de la valeur à afficher si
  if(input$select_geo == "reg"){
    temp <- b %>%
      filter(
        reg == id_select_mod(),
        annee == input$select_annee,
        indicateur == input$territoire_select_indicateur) %>%
      select(indicateur_value) %>%
      lapply(multi.fun) %>% 
      as_tibble() %>% 
      rowid_to_column() %>% 
      rename(' ' = rowid, valeur = indicateur_value)
    
    temp[,1] <- c("mediane", "moyenne", "min.", "max.", "somme")
  }
  
  # calculs de la valeur à afficher sinon
  else{
    temp <- b %>%
      filter(
        dep == id_select_mod(),
        annee == input$select_annee,
        indicateur == input$territoire_select_indicateur) %>%
      select(indicateur_value) %>%
      lapply(multi.fun) %>% 
      as_tibble() %>% 
      rowid_to_column() %>% 
      rename(' ' = rowid, valeur = indicateur_value)
    
    
    temp[,1] <- c("mediane", "moyenne", "min.", "max.", "somme")
  }
  
  # résultat 
  resultatAafficher <- renderTable(
    temp, # résultat à afficher 
    align = 'r', 
    digits = 1,
    spacing = "xs"
  )
  
  # var environnement 
  ajouter <- input$ajouter2 
  id <- paste0('txt', ajouter) # var environnement du résultat 
  btnID <- paste0(id, "rmv")
  
  # insertUI 
  insertUI(
    selector = '#placeholder2', # ui name 
    where = "beforeBegin", # règle de comment l'ui ajouté se positionne
    ui = tags$div( # ensemble de l'ui 
      id = id,
      class="col-sm-3",
      tags$div(
        actionButton(
          inputId = btnID, 
          label = "Suppr",
          style= "color: #fff; background-color: #F39C12; border-color: #F39C12", 
          width = "80px"),
        br(),
        br(),
        tags$b(input$territoire_select_indicateur),
        br(),
        br(),
        resultatAafficher,
        br()

     )
    )
   )
  
  
  # inserted1 <<- c(id, inserted1)
  
  # make a note of the ID of this section, so that it is not repeated accidentally
  rv[[id]] <- TRUE
  print("created")
  
  #résultat selon les évènements passés
  observeEvent(input[[btnID]], {
    removeUI(selector = paste0("#", id))
    
    rv[[id]] <- NULL
    print("destroyed")
    
  }, ignoreInit = TRUE, once = TRUE)
  
}
)


# écran territoire : infobox territoire -----------------------------------------------------------------

### ensemble de calculs pour afficher les résultats dans des infobox 

output$territoire_infoNBailleur <- renderInfoBox({
  
  n <- territoire() %>%  
    nrow()
  
  ohlm <- territoire() %>%  
    filter(famille %in% c("OPH", "COOP", "SA-HLM")) %>% 
    nrow()
  
  tot <- b %>% pull(siren) %>% unique() %>% length()
  
  infoBox(
    title = "",
    color = "blue",
    subtitle = "",
    value = paste(n, "(dont",ohlm,"OHLM", ")", "sur un total de ", tot, "OLS au niveau national"), 
    icon = icon("users")
  )
  
  
})



output$territoire_infoLls <- renderInfoBox({
  
  lls <- territoire() %>%  
    select(A2, A3) %>%
    mutate(total = A2 + A3) %>% 
    summarise(total) %>% 
    sum(na.rm = T)
  
  
  total <- b %>% 
    filter(
      annee == "2020",
      indicateur_code %in% c("A2", "A3")) %>% 
    select(indicateur_value) %>% 
    sum(na.rm = T)
  
  total <- (lls/total)
  
  infoBox(
    title = "", 
    color = "blue",
    subtitle = "somme des logements ordinaires et foyers gérés",
    value = paste(lls %>% prettyNum(big.mark = " "), "logements locatifs sociaux représentant", total %>% percent(digits = 0), "du parc national"), 
    icon = icon("building"),
  )
  
})

######################## PAGE RESSOURCES ############################### 


# écran ressources : download (service offline ) ---------------------------------------------------------------

### ensemble de fonctions pour créer les actions "je télécharge le fichier" 

# output$dlBolero2021 <- downloadHandler(
#   
#   filename = function() {
#     paste("bolero_2021.xlsx", sep="")
#   },
#   content = function(file) {
#     file.copy("data/dataBolero/bolero_2021.xlsx", file)
#   }
# )  
# 
# output$dlBolero2020 <- downloadHandler(
#   
#   filename = function() {
#     paste("bolero_2020.xlsx", sep="")
#   },
#   content = function(file) {
#     file.copy("data/dataBolero/bolero_2020.xlsx", file)
#   }
# )  
# 
# output$dlBolero2019 <- downloadHandler(
#   
#   filename = function() {
#     paste("bolero_2019.xlsx", sep="")
#   },
#   content = function(file) {
#     file.copy("data/dataBolero/bolero_2019.xlsx", file)
#   }
# )  
# 
# output$dlBolero2018 <- downloadHandler(
#   
#   filename = function() {
#     paste("bolero_2018.xlsx", sep="")
#   },
#   content = function(file) {
#     file.copy("data/dataBolero/bolero_2018.xlsx", file)
#   }
# )  
# 
# output$dlBolero2017 <- downloadHandler(
#   
#   filename = function() {
#     paste("bolero_2017.xlsx", sep="")
#   },
#   content = function(file) {
#     file.copy("data/dataBolero/bolero_2017.xlsx", file)
#   }
# )    
# 
# output$dlBolero2016 <- downloadHandler(
#   
#   filename = function() {
#     paste("bolero_2016.xlsx", sep="")
#   },
#   content = function(file) {
#     file.copy("data/dataBolero/bolero_2016.xlsx", file)
#   }
# )    
# 
# output$dlGuide <- downloadHandler(
#   
#   filename = function() {
#     paste("guide_restructuration_2019.pdf", sep="")
#   },
#   content = function(file){
#     file.copy("data/dataPdf/guide_restructuration.pdf", file)
#   }
# )

# écran ressources : tableau dictionnaire ----------------------------------------------------

### récupère la variable d'environnement DICO pour ensuite le rendre disponible côté opérateur 
### attention, les inputs sont sur DICO, mais la donnée attaquée est B. Il peut y avoir une certaine différence entre les deux ensembles 

output$ressources_tableaudictionnaire <- renderTable({
  
  dico %>%
    rename(
      "libellé court" = indicateur_code,
      # "libellé long" = indicateur_lib,
      "définition métier" = definition_metier
    ) %>% 
    select(-indicateur_order)
  
}
,
hover = TRUE,
striped = TRUE,
spacing = 'xs'
)

######################## PAGE RATIOS (déciles des indicateurs) ############################### 

# écran ratio : tableau  --------------------------------------------------

### variable réactif pour la fonction qui suit 

ratiosTableauData <- reactive({
  
  ratiosTableauData <- b %>%
    filter(
      famille %in% input$select_pop_etude,
      annee == input$select_annee,
      indicateur %in% input$ratios_select_indicateur_ratios) %>% 
    select(indicateur, indicateur_value) %>% 
    # pivot_wider(names_from = "indicateur", values_from = "indicateur_value", values_fn = "list") %>% 
    pivot_wider(names_from = "indicateur", values_from = "indicateur_value") %>% 
    sapply(., c) %>% 
    as_tibble()
  
})

### fonction pour rendre sous forme de tableau, les indicateurs choisis 

# condition de fonctionnement : il faut que la table possède le même nb de valeur pour chaque indicateur choisi 
# dans le scrip bolero_data_transformation, ajout de mutate à la fin de l'import pour changer tous les na en 0
# pour tester 
# temp <- b %>%
#   filter(
#     famille %in% "SA-HLM",
#     annee == "2022",
#     indicateur %in% c(
#       "D14D- Loyers et charges",
#       "D11- Taux de vacance (%)"
#     )) %>%
#   select(indicateur, indicateur_value) 
# 
# 
# temp %>%  
#   pivot_wider(names_from = "indicateur", values_from = "indicateur_value") %>% 
#   sapply(., c) %>% 
#   as_tibble()
# 
# temp %>% 
#   dplyr::group_by(indicateur) %>%
#   dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
#   dplyr::filter(n > 1L)




output$ratiosTableau <- renderDataTable({
  
  req(input$ratios_select_indicateur_ratios)
  
  localQuantile <- function(x) {
    quantile(x, probs = seq(.1, 1, by = .1), na.rm = T, names = F, digits = 2) 
  } 
  
  ratiosTableauDataTransformed <- sapply(ratiosTableauData(), localQuantile)
  
  ratiosTableauDataTransformedBis <- ratiosTableauDataTransformed %>% 
    t() 
  
  indicateur <- ratiosTableauDataTransformedBis %>%
    row.names()
  
  colnames(ratiosTableauDataTransformedBis) <- c(
    "D1",
    "D2",
    "D3",
    "D4",
    "D5",
    "D6",
    "D7",
    "D8",
    "D9",
    "D10"
  )
  
  
  ratiosTableauDataTransformedBis <- ratiosTableauDataTransformedBis %>% as_tibble()
  
  indicateur <- indicateur %>% as_tibble()
  
  f <- cbind(indicateur, ratiosTableauDataTransformedBis)
  
  f <- f %>% 
    rename(indicateur = value) %>% 
    mutate(`D1` = `D1` %>% round(2) %>% prettyNum(big.mark = " ")) %>% 
    mutate(`D2` = `D2` %>% round(2) %>% prettyNum(big.mark = " ")) %>% 
    mutate(`D3` = `D3` %>% round(2) %>% prettyNum(big.mark = " ")) %>% 
    mutate(`D4` = `D4` %>% round(2) %>% prettyNum(big.mark = " ")) %>% 
    mutate(`D5` = `D5` %>% round(2) %>% prettyNum(big.mark = " ")) %>% 
    mutate(`D6` = `D6` %>% round(2) %>% prettyNum(big.mark = " ")) %>% 
    mutate(`D7` = `D7` %>% round(2) %>% prettyNum(big.mark = " ")) %>% 
    mutate(`D8` = `D8` %>% round(2) %>% prettyNum(big.mark = " ")) %>% 
    mutate(`D9` = `D9` %>% round(2) %>% prettyNum(big.mark = " ")) %>% 
    mutate(`D10` = `D10` %>% round(2) %>% prettyNum(big.mark = " "))
  
},
server = T,
rownames = F,
filter =  'top',
extensions = c('Buttons', 'ColReorder'),
options = list(
  digits = 2, 
  autoWidth = F,
  colReorder= T,
  dom = 'Bfrtip',
  pageLength = 10,
  buttons = 
    list(list(extend = 'copy'),
         list(extend = 'excel', filename = paste0(Sys.Date(), " export ERICOLS"), title = "ERICOLS"),
         list(extend = 'colvis'))
  ) 
)


