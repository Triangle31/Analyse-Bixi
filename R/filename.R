###
### filename(date, path = getwd())
###
##
##
##  Cette fonction construit les chemins d’accès vers des fichiers contenant
##  des données sur l’utilisation des vélos BIXI à Montréal, correspondant
##  aux dates fournies.
##
##
##  Arguments
##
##  date: vecteur de chaines de caractères contenant des dates dans le format ISO 8601 (AAAA-MM-JJ).
##
##  path: chaine de caractères contenant  le chemin d’accès vers le répertoire contenant 
##        les fichiers de données, par défaut le répertoire courant. 
##
##
##  Valeur
##
##  retourne un vecteur de chaines de caractères contenant les chemins d’accès complets vers les fichiers 
##    correspondants aux dates fournies.
##
##
##  Exemples
##
##  filename(c("2021-06-24", "2021-07-26"))
##
##  filename("2020-10-12", path = "data/")
##


filename <- function(date, path = getwd()){
  
  annee_mois <- substr(date, 1, 7)
  
  fichiers <- paste0("OD_", annee_mois, "u.csv")
  
  file.path(path, fichiers)
}


