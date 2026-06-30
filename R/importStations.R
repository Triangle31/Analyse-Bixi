###
### importStations(file)
###
##  Cette fonction isole le numéro et le nom des stations BIXI depuis le
##  fichier csv entré en argument et retire les doublons.
##
##  Arguments
##
##  file: le chemin d'accès qui mène au fichier csv de données BIXI que
##        l'on souhaite utiliser.
##
##  Valeur
##
##  Un data frame des numéros des stations (pk) avec leur nom (name).
##
##  Exemples
##
##  importStations("data/fichier1.csv")
##  importStations("../../desktop/fichier2.csv")
##


importStations <- function(file){
  df_complet <- read.csv(file, stringsAsFactors = FALSE)
  unique(df_complet[, c("pk", "name")])
}