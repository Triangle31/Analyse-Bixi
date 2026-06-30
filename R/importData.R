###
### importData(start, end, path = getwd())
###
##  Cette fonction importe l'historique des déplacements BIXI entre 2 dates
##  d'une même année entre avril et novembre inclusivement.
##
##  Arguments
##
##  start: Chaine de caractères contenant la date de début de l'intervalle voulu.
##  end: Chaine de caractères contenant la date de fin de l'intervalle voulu.
##  path: Chaine de caractères contenant le répertoire désiré ou bien le
##        répertoire courant par défault.
##
##  Valeur
##
##  Un tableau de données de l'historique des déplacements BIXI entre les 2 dates
##    sélectionnées d'une même année entre avril et novembre inclusivement.
##
##  Exemples
##
##  importData("2042-05-09", "2042-05-27")
##  importData("2022-07-01", "2022-07-31", "data/fichier.csv")
##




importData <- function(start, end, path = getwd())
{
    ## Définir des nombres magiques: numéro des mois (après le premier).
    APR <- 3L
    NOV <- 10L

    ## Convertir les deux premiers arguments en dates.
    start <- as.Date(start)
    end <- as.Date(end)

    ## Extraire les numéros des mois des dates de début et de fin (ces
    ## données servent souvent).

    start.mon <- as.POSIXlt(start)$mon
    end.mon <- as.POSIXlt(end)$mon

    # Valider les arguments

    if (is.na(start) || is.na(end))
      stop("Dates invalides")

    if (start > end)
      stop("La date de début doit être antérieur à que la date de fin")

    if (format(start, "%Y") != format(end, "%Y"))
      stop("Les dates doivent être dans la même année")

    if (start.mon < APR || end.mon > NOV)
      stop("Les dates doivent être entre avril et novembre")

    ## Générer les dates

    dates <- seq(start + 1, by = "+1 month",
                 length.out = end.mon - start.mon + 1L) - 1

    ## Importer les données

    all_data <- list()

    ## Cas 1
    if (start.mon == end.mon) {

      files <- filename(dates[1], path)
      all_data[[1]] <- read.bixi(files)
    }

    ## Cas 2
    else if (end.mon - start.mon == 1L) {

      files <- filename(dates, path)

      all_data[[1]] <- read.bixi(files[1])
      all_data[[2]] <- read.bixi(files[2])
    }
    ## Cas 3
    else {
      files <- filename(dates, path)
      for (i in seq_along(files)) {
        all_data[[i]] <- read.bixi(files[i])
      }
    }

    ## Combiner et filtrer
    df <- do.call(rbind, all_data)
    df <- df[df$start_date >= start & df$start_date <= end, ]
    df
}

###
### read.bixi(filename)
###
##  Importe un fichier de données BIXI uniformes d'historique des
##  déplacements.
##
##  Arguments
##
##  filename: chemin d'accès complet vers un fichier de données.
##
##  Valeur
##
##  Tableau de données de six colonnes:
##
##  start_date: date de début du déplacement ("Date");
##  emplacement_pk_start: code d'emplacement de départ ("factor");
##  end_date: date de fin du déplacement ("Date");
##  emplacement_pk_end: code d'emplacement d'arrivée ("factor");
##  duration_sec: durée du déplacement en secondes ("numeric");
##  is_member: membre BIXI ou utilisateur occasionnel ("factor").
##
##  Exemples
##
##  read.bixi("OD_2016-05u.csv")
##  read.bixi("data/OD_2016-05u.csv")
##

read.bixi <- function(filename)
{
  ## Terminer avec une erreur si le fichier n'existe pas.
  if (!file.exists(filename))
    stop(paste("file", filename, "does not exist"))

  ## Importer les données avec les bons types de colonnes.
  read.csv(filename,
           colClasses = c(start_date           = "Date",
                          emplacement_pk_start = "factor",
                          end_date             = "Date",
                          emplacement_pk_end   = "factor",
                          duration_sec         = "numeric",
                          is_member            = "factor"),
           comment.char = "")
}
