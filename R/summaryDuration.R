###
### summaryDuration(x, per.status = FALSE)
###
##  Cette fonction calcule  les statistiques produites par la fonction summary
##  (minimum, premier quartile, médiane, moyenne, troisième quartile et maximum)
##  et peuvent être séparées par type d'usager ou non.
##
##  Arguments
##
##  x: Tableau de données de déplacements BIXI incluant au minimum les colonnes:
##      - duration_sec: durée d'un déplacement en secondes.
##      - is_member: valeur booléenne si l'utilisateur est un membre  (TRUE)
##                       ou non (FALSE).
##  per.status: Valeur booléenne pour savoir si les statistiques doivent être
##                séparées par catégorie d'utilisateur (TRUE) ou non
##                (FALSE, par défault).
##
##  Valeur
##
##  Une liste de vecteurs étiquetés de statistiques (minimum, premier quartile,
##    médiane, moyenne, troisième quartile et maximum).
##

##
##  Exemples
##
##  summaryDuration(BIXI_DATASET)
##  summaryDuration(per.status = TRUE, x = BIXI_DATASET)
##


summaryDuration <- function(x, per.status = FALSE)
{
  ## Avec le per.status FALSE
  if (!per.status) {
    return(summary(x$duration_sec))
  }

  ## Avec le per.status TRUE
  split_data <- split(x$duration_sec, x$is_member)
  lapply(split_data, summary)
}