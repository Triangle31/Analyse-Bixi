###
### revenues(x, FUN, ...)
###
##  Cette fonction calcule  le revenu avant taxes généré par des déplacements
##  pour une structure de tarif donnée.
##
##  Arguments
##
##  x: Tableau de données de déplacements BIXI ayant le même format que celui
##         produit par importData().
##  FUN: Une fonction qui calcule le revenu associé aux durées de déplacements
##          en secondes (la fonction cost()).
##
##  Valeur
##
##  Une valeur numérique qui représente la somme en revenue généré par
##      des déplacements ($).
##
##  Exemples
##
##  revenues(FUN = cost, "2024", x = BIXI_DATASET)
##  revenues(BIXI_DATASET, cost, "2020")
##


revenues <- function(x, FUN, ...)
{
  sum(FUN(x$duration_sec, ...))
}