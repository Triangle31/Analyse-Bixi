###
### getStations(data, pattern)
###
##  Cette fonction extrait les numéros de stations BIXI dont le nom correspond
##  à un ou plusieurs expressions régulières.
##
##  Arguments
##
##  data: Tableau de données contenant au moins deux colonnes :
##          - pk : code de la station
##          - name : nom complet de la station
##  pattern: Vecteur de chaines de caractères représentant des expressions
##              régulières permettant de rechercher des stations dans la colonne
##              name.
##
##  Valeur
##
##  Une liste nommée des numéros de stations (pk) qui correspondent aux patterns.
##
##  Exemples
##
##  getStations(BIXI_STATIONS, "Bordeaux")
##  getStations(pattern = c("Bordeaux", "[0-9]+e"), data = BIXI_STATIONS)
##


getStations <- function(data, pattern) {

  resultats <- list()

  for (i in pattern) {
    stations <- grepl(i, data$name, ignore.case = TRUE)
    resultats[[i]] <- data$pk[stations]
  }
  resultats
}