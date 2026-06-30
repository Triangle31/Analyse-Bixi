###
### summaryRentals(x)
###
##  Cette fonction calcule et renvoit sous forme de vecteur nommée les
##  statistiques suivantes:
##      Le nombre total d'utilisateur, le nombre total d'utilisateurs qui sont
##      membres et la proportion d'utilisateurs qui sont membres.
##
##
##  Arguments
##
##  x: Tableau de données de déplacements BIXI incluant au minimum la colonne
##        duration_sec (durée d'un déplacement en secondes).
##
##  Valeur
##
##  Un vecteur nommée contenant le nombre total d'utilisateur, le nombre total
##      d'utilisateurs qui sont membres et la proportion d'utilisateurs qui sont
##      membres dans le tableau de données fournie en argument.
##
##  Exemple
##
##  summaryRentals(BIXI_DATASET)
##


summaryRentals <- function(x) {
  total <- nrow(x)
  members <- sum(x$is_member == 1)
  proportion <- members / total
  c(total = total, members = members, proportion = proportion)
}