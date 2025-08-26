Script Rshiny=ERICOLS

########################### PACKAGES ############################
library(shiny)
library(shinydashboard)
library(tidyverse)
library(readxl)
library(janitor)
library(DT)
library(shinyWidgets)
library(shinycssloaders)
library(ggplot2)

########################### UI ############################
ui <- dashboardPage(
  dashboardHeader(title = "Visualisation BOLERO"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Chargement des données", tabName = "load_data", icon = icon("upload")),
      menuItem("Exploration graphique", tabName = "visualisation", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "load_data",
              fluidRow(
                box(title = "Charger le fichier Excel", status = "primary", solidHeader = TRUE,
                    fileInput("file", "Fichier Excel", accept = ".xlsx"), width = 6)
              )
      ),
      tabItem(tabName = "visualisation",
              fluidRow(
                box(title = "Filtres", status = "primary", solidHeader = TRUE, width = 4,
                    pickerInput("indicateur", "Indicateur :", choices = NULL, multiple = FALSE, options = list(`live-search` = TRUE)),
                    pickerInput("siren", "SIREN :", choices = NULL, multiple = TRUE, options = list(`live-search` = TRUE)),
                    pickerInput("annee", "Année :", choices = NULL, multiple = TRUE),
                    radioButtons("type_plot", "Type de graphique :",
                                 choices = c("Lignes" = "line", "Barres" = "bar",
                                             "Secteurs" = "pie", "Boite à moustaches" = "box",
                                             "Heatmap" = "heatmap"),
                                 selected = "line")
                ),
                box(title = "Graphique", status = "primary", solidHeader = TRUE, width = 8,
                    withSpinner(plotOutput("plot_indicateur")))
              ),
              fluidRow(
                box(title = "Tableau des données", status = "primary", solidHeader = TRUE,
                    DTOutput("table_indicateur"), width = 12)
              )
      )
    )
  )
)

########################### SERVER ############################
server <- function(input, output, session) {
  
  data_all <- reactive({
    req(input$file)
    sheets <- excel_sheets(input$file$datapath)
    data_list <- lapply(sheets, function(sh) {
      read_excel(input$file$datapath, sheet = sh) %>%
        mutate(`Siren Entite` = as.character(`Siren Entite`),
               Exercice = as.numeric(str_extract(sh, "\\d{4}")))
    })
    df <- bind_rows(data_list)
    df <- clean_names(df)
    return(df)
  })
  
  observeEvent(data_all(), {
    df <- data_all()
    updatePickerInput(session, "indicateur",
                      choices = names(df)[grepl("^d|^a", names(df))])
    updatePickerInput(session, "siren",
                      choices = unique(df$siren_entite))
    updatePickerInput(session, "annee",
                      choices = sort(unique(df$exercice)))
  })
  
  data_filtered <- reactive({
    req(input$indicateur, input$siren, input$annee)
    df <- data_all()
    df %>%
      filter(siren_entite %in% input$siren,
             exercice %in% input$annee) %>%
      select(siren_entite, exercice, libelle_famille, all_of(input$indicateur))
  })
  
  output$plot_indicateur <- renderPlot({
    df <- data_filtered()
    req(nrow(df) > 0)
    ind <- input$indicateur
    
    gg <- ggplot(df, aes(x = as.factor(exercice), y = .data[[ind]], fill = siren_entite, color = siren_entite))
    
    if (input$type_plot == "line") {
      gg <- gg + geom_line(aes(group = siren_entite)) + geom_point()
    } else if (input$type_plot == "bar") {
      gg <- gg + geom_col(position = position_dodge())
    } else if (input$type_plot == "box") {
      gg <- gg + geom_boxplot(aes(group = exercice))
    } else if (input$type_plot == "pie") {
      gg <- ggplot(df, aes(x = "", y = .data[[ind]], fill = siren_entite)) +
        geom_bar(stat = "identity", width = 1) +
        coord_polar("y") + theme_void()
    } else if (input$type_plot == "heatmap") {
      gg <- gg + geom_tile(aes(fill = .data[[ind]])) +
        scale_fill_viridis_c()
    }
    
    gg + labs(title = paste("Graphique de", ind), x = "Année", y = "Valeur") +
      theme_minimal()
  })
  
  output$table_indicateur <- renderDT({
    datatable(data_filtered(), options = list(pageLength = 10))
  })
}

########################### RUN APP ############################
shinyApp(ui = ui, server = server)
