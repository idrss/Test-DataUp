# ref bailleur ------------------------------------------------------------

options(readr.show_col_types = FALSE)

# rb nouvelle version -----------------------------------------------------


rb <- rio::import(file = "data/dataBolero/rb_caroline_aout22_v5.xlsx", sheet = "liste_orga_ERIC_OLS_16_21_v0809")

rb <- rb %>%
  mutate(id = paste(nom,"-",siren))

rb <- rb %>% 
  distinct(id, .keep_all = T) %>% 
  select(-annee)



# load boléro -------------------------------------------------------------

b18 <- read_delim("data/dataBolero/bolero_2018.csv", 
                  delim = ",", escape_double = FALSE, locale = locale(decimal_mark = ","), 
                  trim_ws = TRUE) %>% 
  mutate_all(~replace_na(., 0)) # pour l'écran ration, il  faut que tous les indicateurs choisis possèdent le m nb d'observation

b18 <- b18 %>% 
  rename("siren" = `Siren Entite`,
         "annee" = `Exercice`) %>% 
  select(-c(`Code famille`, `Libelle Famille`)) %>% 
  inner_join(rb, by = "siren")


b19 <- read_delim("data/dataBolero/bolero_2019.csv", 
                  delim = ",", escape_double = FALSE, locale = locale(decimal_mark = ","), 
                  trim_ws = TRUE) %>% 
  mutate_all(~replace_na(., 0)) # pour l'écran ration, il  faut que tous les indicateurs choisis possèdent le m nb d'observation

b19 <- b19 %>% 
  rename("siren" = `Siren Entite`,
         "annee" = `Exercice`) %>% 
  select(-c(`Code famille`, `Libelle Famille`)) %>% 
  inner_join(rb, by = "siren")

b20 <- read_delim("data/dataBolero/bolero_2020.csv", 
                  delim = ",", escape_double = FALSE, locale = locale(decimal_mark = ","), 
                  trim_ws = TRUE) %>% 
  mutate_all(~replace_na(., 0)) # pour l'écran ration, il  faut que tous les indicateurs choisis possèdent le m nb d'observation

b20 <- b20 %>% 
  rename("siren" = `Siren Entite`,
         "annee" = `Exercice`) %>% 
  select(-c(`Code famille`, `Libelle Famille`)) %>% 
  inner_join(rb, by = "siren")

b21 <- read_delim("data/dataBolero/bolero_2021.csv", 
                  delim = ",", escape_double = FALSE, locale = locale(decimal_mark = ","), 
                  trim_ws = TRUE) %>% 
  mutate_all(~replace_na(., 0)) # pour l'écran ration, il  faut que tous les indicateurs choisis possèdent le m nb d'observation

b21 <- b21 %>% 
  rename("siren" = `Siren Entite`,
         "annee" = `Exercice`) %>% 
  select(-c(`Code famille`, `Libelle Famille`)) %>% 
  inner_join(rb, by = "siren")

b22 <- read_delim("data/dataBolero/bolero_2022.csv", 
                  delim = ",", escape_double = FALSE, locale = locale(decimal_mark = ","), 
                  trim_ws = TRUE) %>% 
  mutate_all(~replace_na(., 0)) # pour l'écran ration, il  faut que tous les indicateurs choisis possèdent le m nb d'observation

b22 <- b22 %>% 
  rename("siren" = `Siren Entite`,
         "annee" = `Exercice`) %>% 
  select(-c(`Code famille`, `Libelle Famille`)) %>% 
  inner_join(rb, by = "siren")



# transformer csv en xlsx pour le téléchargement --------------------------
# à lancer pour chaque nouveaux fichiers bolero 

# rio::export(b18, file = "data/dataBolero/bolero_2018.xlsx")
# rio::export(b19, file = "data/dataBolero/bolero_2019.xlsx")
# rio::export(b20, file = "data/dataBolero/bolero_2020.xlsx")
# rio::export(b21, file = "data/dataBolero/bolero_2021.xlsx")


# assemblage des différentes années  --------------------------------------

b <- rbind(b22, b21, b20, b19, b18)

# éléments géographiques

ref_com <- read_excel("data/dataSpatial/ref_com.xlsx",
                      sheet = "2019")

ref_reg <- read_excel("data/dataSpatial/ref_reg_dep_epci.xlsx",
                      sheet = "reg")

ref_dep <- read_excel("data/dataSpatial/ref_reg_dep_epci.xlsx",
                      sheet = "dep")

ref_reg_dep <- rio::import("data/dataSpatial/ref_reg_dep.xls")

ref_reg_dep <- ref_reg_dep %>% 
  mutate(reg = as.character(REG),
         dep = as.character(DEP)) %>% 
  select(reg,dep)

ref_com_dep_reg <- rio::import("data/dataSpatial/ref_com_dep_reg_2022.xlsx")

# affectation du territoire aux bailleurs à partir du "codeCommuneEtablissement"

b <- b %>% 
  left_join(ref_com_dep_reg, by = c("codeCommuneEtablissement" = "CODGEO")) %>% 
  rename(dep = DEP,
         reg = REG)

# test : vérifier que chaque siren est unique par année 

# autres traitements création de la variable d'environnement maîtresse 

b <- b %>% 
  pivot_longer(-c(annee, siren, dep, reg, id, famille, nom, codeCommuneEtablissement, dep, reg), 
               names_to = "indicateur", values_to = "indicateur_value", values_drop_na = T)


#autres traitements création de la variable d'environnement maîtresse et optimisation 
b <- b %>%
  select(-c(codeCommuneEtablissement))


# creation d'une autre colonne pour un autre libellé indicateur 
b <- b %>% separate(indicateur, c("indicateur_code", "indicateur_lib"), sep = "- ", remove = F)

b <- b %>%
  mutate(
    siren = str_pad(siren, 9, pad = "0"),
    id = paste(nom,"-",siren)
         ) %>% 
  select(-indicateur_lib)


# dico --------------------------------------------------------------------

# dico <- b %>% 
#   select(indicateur, indicateur_code) %>% 
#   unique

#ajouter les nouveaux dicos dans des onglets et choisir l'onglet souhaité
dico <- 
  readxl::read_excel("data/dico/dico_indicateurs_financiers_new.xlsx", sheet = "DICO_2024") %>% 
  arrange(indicateur_code) #tri par ordre alphabétique lors du choix des indicateurs

# temp <- temp %>%
#   select(indicateur_code, indicateur_lib, definition_metier, indicateur_order)
# 
# dico <- dico %>% 
#   left_join(temp, by = "indicateur_code")

# l'application n'affichage pas tous les indicateurs 

# dico <- dico %>%
  # filter(!indicateur_order %in% c(100:107))
  


# rb avec les informations géographiques ----------------------------------

rb <- rb %>% 
  left_join(ref_com_dep_reg, by = c("codeCommuneEtablissement" = "CODGEO")) %>% 
  rename(dep = DEP,
         reg = REG) %>% 
  mutate(siren = str_pad(siren, 9, pad = "0"),
         id = paste(nom,"-",siren))

# multiplication par 100 lorsque l'indicateur est indiqué "%"


motif <- "%"

b <- b %>% 
  mutate(indicateur_value = ifelse(grepl(motif, indicateur),
                                   indicateur_value * 100,
                                   indicateur_value))

# nettoyage des variables d'environnement pour améliorer la performance du système 

rm(motif, b18, b19, b20, b21, b22, ref_com_dep_reg, ref_reg_dep)


