##
## Ce script R importe et filtre les données des déplacements BIXI et calcule
## des statistiques sur la durée des déplacements, sur le nombre de
## déplacements et calcule aussi le revenue total avant taxes.
##

# Avant d'exécuter ce script assurez-vous que les données sont dans le dossier
# data du répertoire de travail.

# On met la date de début et de fin de l'intervalle qui nous intéresse
# dans start et end. L'année doit être la même pour les 2 dates et on
# l'initialise dans annee. Le pattern sert à ciblé les stations qui nous
# intéressent. On met une expression régulière pour rechercher les stations
# que l'on veut dans pattern.

# Dans notre cas, on veut les trajets entre le 18 juin 2020 et le 11 octobre
# 2020. On veut le modèle de tarification de 2020 et on veut toutes les
# stations sur la rue St-Denis.

start <- "2020-06-18"
end <- "2020-10-11"
annee <- "2020"
pattern <- "St-Denis"


# On importe les fonctions du dossier R
source("R/importStations.R")
source("R/filename.R")
source("R/importData.R")
source("R/getStations.R")
source("R/summaryDuration.R")
source("R/summaryRentals.R")
source("R/revenues.R")
source("R/cost.R")


# Dans un objet stations, on importe toutes les stations du fichier
# "stations_...u.csv". On initialise fichier_stations  selon l'annee.

fichier_stations <- paste0("data/stations_", annee, "u.csv")
stations <- importStations(fichier_stations)


# On extrait les stations qui nous intéresse selon le pattern dans un objet
# stations_cible.

stations_cible <- getStations(stations, pattern)


# On importe les données des trajets avec la fonction ImportData dans un objet
# bixi. Les arguments start et end nous donne la date de début et de fin.

bixi <- importData(start, end, path = "data")


# On garde seulement les trajets qui commencent ou terminent sur une station de
# station_cible dans un objet bixi_cible.

bixi_cible <- 
  bixi[as.numeric(as.character(bixi$emplacement_pk_start)) %in% 
         unlist(stations_cible) | 
         as.numeric(as.character(bixi$emplacement_pk_end)) %in% 
         unlist(stations_cible), ]


# On fait summaryDuration sur notre bixi_cible. Cette fonction retourne le 
# minimum, le maximum, la moyenne, la médiane et les quartiles de la durée des
# déplacements. On le fait sur toutes les données de bixi_cible une fois et sur
# les membres et non-membres séparément une fois. 

summaryDuration(bixi_cible, FALSE)
summaryDuration(bixi_cible, TRUE)


# On fait summaryRentals sur notre bixi_cible. Cette fonction retourne le
# nombre de déplacements, le nombre de déplacements effectuées par des membres, 
# ainsi que la proportion de déplacements effectuées par des membres.

summaryRentals(bixi_cible)


# On calcule le revenu total de notre bixi_cible avec la fonction revenues en 
# utilisant la fonction cost. L'argument tariff peut être 2020 ou 2024 et on 
# le choisi selon l'année.

annee_tarif <- ifelse(annee > 2020, "2024", "2020")
revenues(bixi_cible, cost, tariff = annee_tarif)