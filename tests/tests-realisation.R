## TRAVAIL LONGITUDINAL - TESTS UNITAIRES
##
## Copyright (C) 2025 Vincent Goulet
##
## Ce fichier fait partie du cours
## IFT-4902/7902 Programmation avec R pour l'analyse de données
##
## Cette création est mise à disposition sous licence
## Attribution-Partage dans les mêmes conditions 4.0 International de
## Creative Commons. https://creativecommons.org/licenses/by-sa/4.0/

###
### INSTRUCTIONS
###

## Les éléments suivants doivent *tous* se trouver dans le répertoire
## de travail de R [fourni par 'getwd()']:
##
## - un sous-répertoire 'data' contenant les données
##   ouvertes BIXI uniformes de 2021 en format CSV;
## - un sous-répertoire 'data' contenant les
##   données du projet 'data' en format RDS.
##
## - un sous-répertoire 'data' contenant les
##   données du projet 'bixi-donnees-uniformes-test' est hébergé dans le
##   référentiel Bitbucket de Faculté des sciences et de génie:
##
## https://projets.fsg.ulaval.ca/git/projects/VG/repos/bixi-donnees-uniformes-test/
##
## La manière la plus simple de se procurer les données du projet
## consiste à cloner le dépôt directement dans le répertoire de
## travail de R avec
##
## git clone https://projets.fsg.ulaval.ca/git/scm/vg/bixi-donnees-uniformes-test.git
##
## Cette commande crée automatiquement le répertoire
## 'bixi-donnees-uniformes-test'. Clônez-les et mettez son contenu dans votre
## dossier 'data', mais n'incluez rien de ce dépôt dans votre remise du projet.

source("R/importStations.R")
###
### Tests unitaires de la fonction 'importStations'.
###

## Nom du fichier de données «artificielles» à créer dans le
## répertoire de travail de R.
testfile <- "Stations_2042u.csv"

## Créer le fichier de données à importer.
write.csv(file = testfile, row.names = FALSE, fileEncoding = "UTF-8",
          structure(list(pk = c(7030, 6141, 6100, 6064, 6730, 6396),
                         name = c("de Bordeaux / Marie-Anne", "de Bordeaux / Rachel", "Mackay / de Maisonneuve", "Métro Peel (de Maisonneuve / Stanley)", "35e avenue / Beaubien", "Métro Pie-IX (Pierre-de-Coubertin / Pie-IX)"),
                         latitude = c(45.53341, 45.53227, 45.49659, 45.50038, 45.57008, 45.55421),
                         longitude = c(-73.57066, -73.56828, -73.57851, -73.57507, -73.57305, -73.55156)),
                    class = "data.frame", row.names = c(NA, -6L)))

## Jeu de données cible.
BIXI_STATIONS <- structure(list(pk = as.integer(c(7030, 6141, 6100, 6064, 6730, 6396)),
                                name = c("de Bordeaux / Marie-Anne", "de Bordeaux / Rachel", "Mackay / de Maisonneuve", "Métro Peel (de Maisonneuve / Stanley)", "35e avenue / Beaubien", "Métro Pie-IX (Pierre-de-Coubertin / Pie-IX)")),
                           class = "data.frame", row.names = c(NA, -6L))

## Test sur l'importation des données.
stopifnot(identical(BIXI_STATIONS,
                    try(importStations(testfile))))

## Supprimer le fichier de données.
unlink(testfile)

## Test additionnel avec les données BIXI uniformes de 2021.
##
## Le jeu de données cible est fourni dans le dépôt Git
## 'bixi-donnees-uniformes-test' en format RDS rapide à importer.
##
## Importer les données uniformes de 2021 dans l'espace de travail.
#EXPECTED_STATIONS <- readRDS("data/stations-u-test.rds")

## Test sur l'importation des données de stations de 2021.
#stopifnot(identical(EXPECTED_STATIONS,
                    #try(importStations(file = "data/Stations_2021u.csv"))))

source("R/filename.R")
###
### Tests unitaires de la fonction 'filename'.
###

## Données de test.
DATE_SINGLE <- c("2042-07-22")
DATE_VECTOR <- c("2042-08-10", "2042-09-24", "2042-10-11")
PATH <- "data"

## Valeurs cibles
EXPECTED_SINGLE_RESULT <- file.path(getwd(), "OD_2042-07u.csv")
EXPECTED_VECTOR_RESULT <- file.path(getwd(), c("OD_2042-08u.csv",
                                               "OD_2042-09u.csv",
                                               "OD_2042-10u.csv"))
EXPECTED_PATH_RESULT <- file.path("data", "OD_2042-07u.csv")

## Tests sur la création de noms de fichiers sans chemin d'accès.
stopifnot(identical(EXPECTED_SINGLE_RESULT,
                    try(filename(date = DATE_SINGLE))))
stopifnot(identical(EXPECTED_VECTOR_RESULT,
                    try(filename(date = DATE_VECTOR))))

## Test sur la création d'un nom de fichier avec chemin
## d'accès.
stopifnot(identical(EXPECTED_PATH_RESULT,
                    try(filename(path = PATH, date = DATE_SINGLE))))

source("R/importData.R")
###
### Tests unitaires de la fonction 'importData'.
###

## La conversion des dates lors de l'importation des données est
## *beaucoup* plus rapide si la variable d'environnement 'TZ' est
## "UTC" (ou "GMT"). On sauvegarde la valeur actuelle pour la
## rétablir, plus loin.
otz <- Sys.getenv("TZ")
Sys.setenv(TZ = "UTC")

## Noms des fichiers de données «artificielles» à créer dans le
## répertoire de travail de R.
testfiles <- paste0("OD_2042-0", 5:7, "u.csv")

## Créer les fichiers de données à importer.
write.csv(file = testfiles[1], row.names = FALSE, fileEncoding = "UTF-8",
          structure(list(start_date = structure(c(2282646660, 2282865120, 2283002400, 2283097080, 2283248220, 2283629340, 2284124220, 2284132380, 2284203780, 2284240980, 2284339260, 2284475580, 2284554420, 2284590660, 2284686600, 2284823340, 2284988100, 2285172000, 2285189280, 2285197080), class = c("POSIXct", "POSIXt"), tzone = "America/Montreal"),
                         emplacement_pk_start = c(6180, 6371, 6093, 6064, 6356, 6137, 6321, 6201, 6129, 6424, 6143, 6187, 6094, 6142, 6222, 6142, 6211, 6322, 6130, 6107),
                         end_date = structure(c(2282647020, 2282866080, 2283003180, 2283097440, 2283250080, 2283630480, 2284125000, 2284132920, 2284204200, 2284243320, 2284339560, 2284475880, 2284554900, 2284591260, 2284687140, 2284824000, 2284988760, 2285173260, 2285190060, 2285197500), class = c("POSIXct", "POSIXt"), tzone = "America/Montreal"),
                         emplacement_pk_end = c(6043, 6311, 6434, 6102, 6901, 6231, 6233, 6213, 6155, 6263, 6151, 6155, 6230, 6152, 6170, 6015, 6216, 6060, 6152, 6059),
                         duration_sec = c(371, 949, 750, 336, 1875, 1144, 787, 580, 462, 2322, 287, 289, 483, 597, 523, 706, 629, 1258, 746, 407),
                         is_member = c(1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1)),
                    row.names = 1:20, class = "data.frame"))

write.csv(file = testfiles[2], row.names = FALSE, fileEncoding = "UTF-8",
          structure(list(start_date = structure(c(2285408940, 2285415120, 2285450340, 2285502900, 2285632200, 2285929320, 2286133980, 2286171960, 2286206700, 2286306360, 2286382440, 2286409260, 2286558480, 2286622740, 2286671880, 2286720540, 2286720720, 2286893820, 2286988200, 2287066560, 2287162620, 2287235100, 2287259040, 2287412100, 2287734120), class = c("POSIXct", "POSIXt"), tzone = "America/Montreal"),
                         emplacement_pk_start = c(6503, 6058, 6170, 6098, 6140, 6023, 6397, 6012, 6174, 6058, 6061, 6021, 6240, 6903, 6113, 6235, 6023, 6073, 6225, 6005, 6369, 6418, 6038, 6334, 6032),
                         end_date = structure(c(2285409600, 2285415660, 2285450820, 2285503140, 2285632860, 2285931180, 2286134700, 2286172680, 2286209160, 2286306780, 2286382980, 2286409500, 2286561660, 2286624000, 2286671940, 2286721620, 2286722460, 2286894480, 2286988740, 2287066920, 2287165140, 2287235400, 2287260300, 2287412400, 2287734900), class = c("POSIXct", "POSIXt"), tzone = "America/Montreal"),
                         emplacement_pk_end = c(6243, 6729, 6146, 6064, 6196, 6711, 6396, 6111, 6735, 6097, 6013, 6220, 6044, 6327, 6112, 6266, 6050, 6729, 6165, 6413, 6413, 6402, 6748, 6338, 6117),
                         duration_sec = c(639, 562, 504, 194, 688, 1834, 695, 702, 2461, 429, 520, 256, 3205, 1232, 88, 1084, 1742, 641, 539, 346, 2538, 322, 1255, 294, 744),
                         is_member = c(1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1)),
                    row.names = 1:25, class = "data.frame"))

write.csv(file = testfiles[3], row.names = FALSE, fileEncoding = "UTF-8",
          structure(list(start_date = structure(c(2287855920, 2287945680, 2287952400, 2288022540, 2288114880, 2288205300, 2288259180, 2288816160, 2289174000, 2289474360, 2289594660, 2290180560, 2290260780, 2290407780, 2290452480), class = c("POSIXct", "POSIXt"), tzone = "America/Montreal"),
                         emplacement_pk_start = c(6201, 6214, 6159, 6026, 6143, 6086, 6362, 6107, 6260, 6204, 6012, 6248, 6107, 6004, 6154),
                         end_date = structure(c(2287856640, 2287946280, 2287954920, 2288023740, 2288115660, 2288205900, 2288260140, 2288816520, 2289174540, 2289475020, 2289594840, 2290183440, 2290262580, 2290409460, 2290452600), class = c("POSIXct", "POSIXt"), tzone = "America/Montreal"),
                         emplacement_pk_end = c(6147, 6070, 6159, 6114, 6223, 6748, 6906, 6741, 6152, 6098, 6013, 6396, 6026, 6372, 6160),
                         duration_sec = c(775, 567, 2506, 1187, 796, 604, 947, 373, 539, 624, 164, 2860, 1762, 1652, 168),
                         is_member = c(1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1)),
                    row.names = 1:15, class = "data.frame"))

## Jeux de données cibles.
EXPECTED_DATASET1 <- structure(list(start_date = structure(c(26426, 26430, 26436, 26436, 26437, 26437, 26438, 26440, 26441, 26441, 26442, 26444), class = "Date"),
                                    emplacement_pk_start = structure(c(10L, 3L, 9L, 7L, 2L, 11L, 5L, 6L, 1L, 4L, 8L, 4L), .Label = c("6094", "6129", "6137", "6142", "6143", "6187", "6201", "6222", "6321", "6356", "6424"), class = "factor"),
                                    end_date = structure(c(26426, 26430, 26436, 26436, 26437, 26437, 26438, 26440, 26441, 26441, 26442, 26444), class = "Date"),
                                    emplacement_pk_end = structure(c(11L, 8L, 9L, 6L, 4L, 10L, 2L, 4L, 7L, 3L, 5L, 1L), .Label = c("6015", "6151", "6152", "6155", "6170", "6213", "6230", "6231", "6233", "6263", "6901"), class = "factor"),
                                    duration_sec = c(1875, 1144, 787, 580, 462, 2322, 287, 289, 483, 597, 523, 706),
                                    is_member = structure(c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L), .Label = "1", class = "factor")),
                               row.names = c(NA, 12L), class = "data.frame")

EXPECTED_DATASET2 <- structure(list(start_date = structure(c(26444, 26446, 26448, 26448, 26448, 26451, 26451, 26451, 26452, 26453, 26457, 26459, 26460, 26460), class = "Date"),
                                    emplacement_pk_start = structure(c(3L, 4L, 5L, 2L, 1L, 14L, 8L, 11L, 9L, 10L, 7L, 13L, 6L, 12L), .Label = c("6107", "6130", "6142", "6211", "6322", "6012", "6023", "6058", "6098", "6140", "6170", "6174", "6397", "6503"), class = "factor"),
                                    end_date = structure(c(26444, 26446, 26448, 26448, 26448, 26451, 26451, 26451, 26452, 26453, 26457, 26459, 26460, 26460), class = "Date"),
                                    emplacement_pk_end = structure(c(1L, 5L, 3L, 4L, 2L, 10L, 13L, 8L, 6L, 9L, 12L, 11L, 7L, 14L), .Label = c("6015", "6059", "6060", "6152", "6216", "6064", "6111", "6146", "6196", "6243", "6396", "6711", "6729", "6735"), class = "factor"),
                                    duration_sec = c(706, 629, 1258, 746, 407, 639, 562, 504, 194, 688, 1834, 695, 702, 2461),
                                    is_member = structure(c(2L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 1L, 2L, 1L), .Label = c("0", "1"), class = "factor")),
                               row.names = 1:14, class = "data.frame")

EXPECTED_DATASET3 <- structure(list(start_date = structure(c(26426, 26430, 26436, 26436, 26437, 26437, 26438, 26440, 26441, 26441, 26442, 26444, 26446, 26448, 26448, 26448, 26451, 26451, 26451, 26452, 26453, 26457, 26459, 26460, 26460, 26461, 26462, 26462, 26464, 26465, 26465, 26466, 26466, 26468, 26469, 26470, 26471, 26472, 26472, 26474, 26478, 26479, 26480, 26480, 26481, 26482, 26483, 26484, 26490), class = "Date"),
                                    emplacement_pk_start = structure(c(14L, 5L, 12L, 9L, 3L, 15L, 7L, 8L, 1L, 6L, 11L, 6L, 10L, 13L, 4L, 2L, 37L, 22L, 28L, 25L, 27L, 19L, 35L, 17L, 29L, 22L, 23L, 18L, 32L, 38L, 26L, 31L, 19L, 24L, 30L, 16L, 34L, 36L, 21L, 33L, 20L, 9L, 42L, 41L, 39L, 7L, 40L, 43L, 2L), .Label = c("6094", "6107", "6129", "6130", "6137", "6142", "6143", "6187", "6201", "6211", "6222", "6321", "6322", "6356", "6424", "6005", "6012", "6021", "6023", "6032", "6038", "6058", "6061", "6073", "6098", "6113", "6140", "6170", "6174", "6225", "6235", "6240", "6334", "6369", "6397", "6418", "6503", "6903", "6026", "6086", "6159", "6214", "6362"), class = "factor"),
                                    end_date = structure(c(26426, 26430, 26436, 26436, 26437, 26437, 26438, 26440, 26441, 26441, 26442, 26444, 26446, 26448, 26448, 26448, 26451, 26451, 26451, 26452, 26453, 26457, 26459, 26460, 26460, 26461, 26462, 26462, 26464, 26465, 26465, 26466, 26466, 26468, 26469, 26470, 26471, 26472, 26472, 26474, 26478, 26479, 26480, 26480, 26481, 26482, 26483, 26484, 26490), class = "Date"),
                                    emplacement_pk_end = structure(c(14L, 11L, 12L, 8L, 6L, 13L, 4L, 6L, 10L, 5L, 7L, 1L, 9L, 3L, 5L, 2L, 27L, 35L, 23L, 18L, 25L, 34L, 31L, 20L, 36L, 19L, 15L, 26L, 16L, 29L, 21L, 28L, 17L, 35L, 24L, 33L, 33L, 32L, 37L, 30L, 22L, 40L, 38L, 41L, 39L, 42L, 37L, 44L, 43L), .Label = c("6015", "6059", "6060", "6151", "6152", "6155", "6170", "6213", "6216", "6230", "6231", "6233", "6263", "6901", "6013", "6044", "6050", "6064", "6097", "6111", "6112", "6117", "6146", "6165", "6196", "6220", "6243", "6266", "6327", "6338", "6396", "6402", "6413", "6711", "6729", "6735", "6748", "6070", "6114", "6147", "6159", "6223", "6741", "6906"), class = "factor"),
                                    duration_sec = c(1875, 1144, 787, 580, 462, 2322, 287, 289, 483, 597, 523, 706, 629, 1258, 746, 407, 639, 562, 504, 194, 688, 1834, 695, 702, 2461, 429, 520, 256, 3205, 1232, 88, 1084, 1742, 641, 539, 346, 2538, 322, 1255, 294, 744, 775, 567, 2506, 1187, 796, 604, 947, 373), is_member = structure(c(2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 1L, 2L, 1L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 1L, 2L, 2L, 2L, 2L, 2L, 1L, 2L, 2L, 2L, 1L, 2L, 1L, 1L, 2L, 2L, 2L), .Label = c("0", "1"), class = "factor")),
                               row.names = 1:49, class = "data.frame")

## Importer les données du 2042-05-09 au 2042-05-27.
DATASET1 <- try(importData("2042-05-09", "2042-05-27"))
if (!inherits(DATASET1, "try-error"))
{
    DATASET1 <- droplevels(DATASET1)
    row.names(DATASET1) <- 1:12
}

## Importer les données du 2042-05-27 au 2042-06-12.
DATASET2 <- try(importData(start = "2042-05-27", end = "2042-06-12", path = getwd()))
if (!inherits(DATASET2, "try-error"))
{
    DATASET2 <- droplevels(DATASET2)
    row.names(DATASET2) <- 1:14
}

## Importer les données du 2042-05-09 au 2042-07-12 (ordre des
## arguments inversé pour tester la validité des noms; référence au
## répertoire courant par "." plutôt qu'avec 'getwd()').
DATASET3 <- try(importData(".", end = "2042-07-12", start = "2042-05-09"))
if (!inherits(DATASET3, "try-error"))
{
    DATASET3 <- droplevels(DATASET3)
    row.names(DATASET3) <- 1:49
}

## Test sur l'importation des données du 2042-05-09 au 2042-05-27.
stopifnot(all.equal(EXPECTED_DATASET1, DATASET1))

## Test sur l'importation des données du 2042-05-27 au 2042-06-12.
stopifnot(all.equal(EXPECTED_DATASET2, DATASET2))

## Test sur l'importation des données du 2042-05-09 au 2042-07-12.
stopifnot(all.equal(EXPECTED_DATASET3, DATASET3))

## Supprimer les fichiers de données et rétablir la variable
## d'environnement 'TZ'.
unlink(testfiles)
Sys.setenv(TZ = otz)

## Tests additionnels avec des données BIXI uniformes de 2021.
##
## Les jeux de données cibles sont fournis dans le dépôt Git
## 'bixi-donnees-uniformes-test' en format RDS rapides à importer.
##
## Importer les données uniformes de 2021 dans l'espace de travail.
#EXPECTED_DATASET_SMALL  <- readRDS("data/bixi-u-test-small.rds")
#EXPECTED_DATASET_MEDIUM <- readRDS("data/bixi-u-test-medium.rds")
#EXPECTED_DATASET_LARGE  <- readRDS("data/bixi-u-test-large.rds")

## L'importation avec 'importData' prend plusieurs secondes. Pour
## accélérer les tests lorsqu'ils sont effectués à répétition, les
## données importées sont sauvegardées en format RDS dans un
## répertoire 'cache' dès que le test réussit une fois.
##
## Par mesure de «sécurité», on affiche un message lorsqu'un test
## utilise des données en cache.
##
## Pour forcer l'évaluation du test complet, supprimer le répertoire
## 'cache'.
#if (!dir.exists("cache"))
#    dir.create("cache")

## Test sur l'importation des données BIXI uniformes du 2021-05-09 au
## 2021-05-29.
##
## (La paire d'accolades additionnelles est simplement là pour placer
## la clause 'if ... else' à l'intérieur d'un groupe et ainsi
## permettre que 'else' se retrouve seul sur une ligne;
## https://cran.r-project.org/doc/manuals/R-lang.html#if)
#{
#    if (file.exists(file.path("cache", "DATASET_SMALL.rds")))
#    {
#        DATASET_SMALL <- readRDS("cache/DATASET_SMALL.rds")
#        message("NOTE: données en cache utilisées pour le test sur DATASET_SMALL")
#    }
#    else
#    {
#        otz <- Sys.getenv("TZ")
#        Sys.setenv(TZ = "UTC")
#        DATASET_SMALL <- try(importData("2021-05-09",
#                                        "2021-05-29",
#                                        "data"))
#        if (!inherits(DATASET_SMALL, "try-error"))
#        {
#            DATASET_SMALL <- droplevels(DATASET_SMALL)
#            row.names(DATASET_SMALL) <- attr(EXPECTED_DATASET_SMALL, "row.names")
#        }
#        stopifnot(all.equal(EXPECTED_DATASET_SMALL,
#                            DATASET_SMALL))
#        saveRDS(DATASET_SMALL, file.path("cache", "DATASET_SMALL.rds"))
#        Sys.setenv(TZ = otz)
#    }
#}

## Test sur l'importation des données BIXI uniformes du 2021-05-09 au
## 2021-06-18.
#{
#    if (file.exists(file.path("cache", "DATASET_MEDIUM.rds")))
#    {
#        DATASET_MEDIUM <- readRDS("cache/DATASET_MEDIUM.rds")
#        message("NOTE: données en cache utilisées pour le test sur DATASET_MEDIUM")
#    }
#    else
#    {
#        otz <- Sys.getenv("TZ")
#        Sys.setenv(TZ = "UTC")
#        DATASET_MEDIUM <- try(importData(start = "2021-05-09",
#                                         end = "2021-06-18",
#                                         path = "data"))
#        if (!inherits(DATASET_MEDIUM, "try-error"))
#        {
#            DATASET_MEDIUM <- droplevels(DATASET_MEDIUM)
#            row.names(DATASET_MEDIUM) <- attr(EXPECTED_DATASET_MEDIUM, "row.names")
#        }
#        stopifnot(all.equal(EXPECTED_DATASET_MEDIUM,
#                            DATASET_MEDIUM))
#        saveRDS(DATASET_MEDIUM, file.path("cache", "DATASET_MEDIUM.rds"))
#        Sys.setenv(TZ = otz)
#    }
#}

## Test sur l'importation des données BIXI uniformes du 2021-05-09 au
## 2021-08-10.
#{
#    if (file.exists(file.path("cache", "DATASET_LARGE.rds")))
#    {
#        DATASET_LARGE <- readRDS("cache/DATASET_LARGE.rds")
#        message("NOTE: données en cache utilisées pour le test sur DATASET_LARGE")
#    }
#    else
#    {
#        otz <- Sys.getenv("TZ")
#        Sys.setenv(TZ = "UTC")
#        DATASET_LARGE <- try(importData(path = "data",
#                                        end = "2021-08-10",
#                                        "2021-05-09"))
#        if (!inherits(DATASET_LARGE, "try-error"))
#        {
#            DATASET_LARGE <- droplevels(DATASET_LARGE)
#            row.names(DATASET_LARGE) <- attr(EXPECTED_DATASET_LARGE, "row.names")
#        }
#        stopifnot(all.equal(EXPECTED_DATASET_LARGE,
#                            DATASET_LARGE))
#        saveRDS(DATASET_LARGE, file.path("cache", "DATASET_LARGE.rds"))
#        Sys.setenv(TZ = otz)
#    }
#}

source("R/getStations.R")
###
### Tests unitaires de la fonction 'getStations'.
###

## Données de test.
BIXI_STATIONS <- structure(list(pk = as.integer(c(7030, 6141, 6100, 6064, 6730, 6396)),
                                name = c("de Bordeaux / Marie-Anne", "de Bordeaux / Rachel", "Mackay / de Maisonneuve", "Métro Peel (de Maisonneuve / Stanley)", "35e avenue / Beaubien", "Métro Pie-IX (Pierre-de-Coubertin / Pie-IX)")),
                           class = "data.frame", row.names = c(NA, -6L))

## Valeurs cibles.
EXPECTED_CODES1 <- list("Bordeaux" = as.integer(c(7030, 6141)))
EXPECTED_CODES2 <- list("Bordeaux" = as.integer(c(7030, 6141)),
                        "[0-9]+e" = as.integer(6730))

## Test sur l'extraction des numéros de stations se trouvant
## sur ou à une intersection de la rue de Bordeaux.
stopifnot(identical(EXPECTED_CODES1,
                    try(getStations(BIXI_STATIONS, "Bordeaux"))))

## Test sur l'extraction des numéros de stations se trouvant
## sur ou à une intersection de la rue de Bordeaux, ainsi que
## celles comportant un numéro de rue ou d'avenue (ordre des
## arguments inversé pour tester la validité des noms).
stopifnot(identical(EXPECTED_CODES2,
                    try(getStations(pattern = c("Bordeaux", "[0-9]+e"), data = BIXI_STATIONS))))

source("R/summaryDuration.R")
###
### Tests unitaires de la fonction 'summaryDuration'.
###

## Données de test.
BIXI_DATASET <- data.frame(start_date = as.Date("2042-05-09"),
                           emplacement_pk_start = as.factor(c(6226, 6214, 6137, 6100, 6100,
                                                              6100, 6100, 6169, 6923, 6204)),
                           end_date = as.Date("2042-05-09"),
                           emplacement_pk_end = as.factor(c(6033, 6181, 6229, 6224, 6009,
                                                            6009, 6009, 6070, 6343, 6903)),
                           duration_sec = c(904, 1404, 616, 1921, 875, 850, 2852, 3672, 253, 337),
                           is_member = as.factor(c(1, 1, 1, 1, 1, 0, 0, 0, 1, 1)))

## Valeurs cibles.
EXPECTED_STATISTICS_VECTOR <- c(Min. = 253.00, "1st Qu." = 674.50, Median = 889.50, Mean = 1368.40, "3rd Qu." = 1791.75, Max. = 3672.00)
EXPECTED_STATISTICS_LIST <- list("0" = c(Min. = 850, "1st Qu." = 1851, Median = 2852, Mean = mean(subset(BIXI_DATASET, is_member == 0)$duration_sec), "3rd Qu." = 3262, Max. = 3672), "1" = c(Min. = 253.0, "1st Qu." = 476.5, Median = 875, Mean = mean(subset(BIXI_DATASET, is_member == 1)$duration_sec), "3rd Qu." = 1154.0, Max. = 1921))

## Test sur les statistiques pour tous les déplacements.
stopifnot(identical(EXPECTED_STATISTICS_VECTOR,
                    unclass(try(summaryDuration(BIXI_DATASET)))))

## Test sur les statistiques pour les déplacements par catégorie
## d'utilisateur (ordre des arguments inversé pour tester la validité
## des noms).
stopifnot(identical(EXPECTED_STATISTICS_LIST,
                    lapply(try(summaryDuration(per.status = TRUE, x = BIXI_DATASET)), unclass)))

source("R/summaryRentals.R")
###
### Tests unitaires de la fonction 'summaryRentals'.
###

## Données de test.
BIXI_DATASET <- data.frame(start_date = as.Date("2042-05-09"),
                           emplacement_pk_start = as.factor(c(6226, 6214, 6137, 6100, 6100,
                                                              6100, 6100, 6169, 6923, 6204)),
                           end_date = as.Date("2042-05-09"),
                           emplacement_pk_end = as.factor(c(6033, 6181, 6229, 6224, 6009,
                                                            6009, 6009, 6070, 6343, 6903)),
                           duration_sec = c(904, 1404, 616, 1921, 875, 850, 2852, 3672, 253, 337),
                           is_member = as.factor(c(1, 1, 1, 1, 1, 0, 0, 0, 1, 1)))

## Valeurs cibles.
EXPECTED_RENTALS <- 10
EXPECTED_RENTALS_FROM_MEMBERS <- 7
EXPECTED_RATIO <- EXPECTED_RENTALS_FROM_MEMBERS/EXPECTED_RENTALS

## Test sur le nombre de déplacements.
##
## Utilisation de 'check.attributes = FALSE' dans 'all.equal' pour
## passer outre la vérification des étiquettes dans les résultats.
stopifnot(all.equal(EXPECTED_RENTALS,
                    try(summaryRentals(BIXI_DATASET))[1],
                    check.attributes = FALSE))

## Test sur le nombre de déplacements provenant de membres.
stopifnot(all.equal(EXPECTED_RENTALS_FROM_MEMBERS,
                    try(summaryRentals(BIXI_DATASET))[2],
                    check.attributes = FALSE))

## Test sur la proportion de déplacements provenant de membres.
stopifnot(all.equal(EXPECTED_RATIO,
                    try(summaryRentals(x = BIXI_DATASET))[3],
                    check.attributes = FALSE))

## Les noms des étiquettes ne sont pas précisés dans la spécification
## de la fonction, mais celles-ci doivent néanmoins être présentes.
EXPECTED_NAMES_LENGTH <- 3L

## Test sur le nombre d'étiquettes du résultat.
stopifnot(identical(EXPECTED_NAMES_LENGTH,
                    length(names(try(summaryRentals(BIXI_DATASET))))))

source("R/revenues.R")
source("R/cost.R")
###
### Tests unitaires de la fonction 'revenues'.
###

## Données de test.
BIXI_DATASET <- data.frame(start_date = as.Date("2042-05-09"),
                           emplacement_pk_start = as.factor(c(6226, 6214, 6137, 6100, 6100,
                                                              6100, 6100, 6169, 6923, 6204)),
                           end_date = as.Date("2042-05-09"),
                           emplacement_pk_end = as.factor(c(6033, 6181, 6229, 6224, 6009,
                                                            6009, 6009, 6070, 6343, 6903)),
                           duration_sec = c(904, 1404, 616, 1921, 875, 850, 2852, 3672, 253, 337),
                           is_member = as.factor(c(1, 1, 1, 1, 1, 0, 0, 0, 1, 1)))

## Fonction de calcul de revenus arbitraire et valeur cible.
FUNCTION <- function(x) 5 + 0.05 * pmax(0, x - 900)
EXPECTED_SUM <- 362.65

## Test sur le montant de revenu total.
stopifnot(all.equal(EXPECTED_SUM,
                    try(revenues(BIXI_DATASET, FUNCTION))))

###
### Tests unitaires de la combinaison des fonctions 'revenues' et
### 'cost' pour la structure de tarif 2020.
###

## Données de test.
BIXI_DATASET <- data.frame(start_date = as.Date("2042-05-09"),
                           emplacement_pk_start = as.factor(c(6226, 6214, 6137, 6100, 6100,
                                                              6100, 6100, 6169, 6923, 6204)),
                           end_date = as.Date("2042-05-09"),
                           emplacement_pk_end = as.factor(c(6033, 6181, 6229, 6224, 6009,
                                                            6009, 6009, 6070, 6343, 6903)),
                           duration_sec = c(904, 1404, 616, 1921, 875, 850, 2852, 3672, 253, 337),
                           is_member = as.factor(c(1, 1, 1, 1, 1, 0, 0, 0, 1, 1)))

## Valeur cible.
EXPECTED_SUM <- sum(c(2.99, 2.99, 2.99, 4.79, 2.99,
                      2.99, 7.79, 10.79, 2.99, 2.99))

## Test sur le résultat de 'revenues'.
stopifnot(all.equal(EXPECTED_SUM,
                    try(revenues(BIXI_DATASET, cost, "2020"))))

###
### Tests unitaires de la combinaison des fonctions 'revenues' et
### 'cost' pour la structure de tarif 2024.
###

## Données de test.
BIXI_DATASET <- data.frame(start_date = as.Date("2042-05-09"),
                           emplacement_pk_start = as.factor(c(6226, 6214, 6137, 6100, 6100,
                                                              6100, 6100, 6169, 6923, 6204)),
                           end_date = as.Date("2042-05-09"),
                           emplacement_pk_end = as.factor(c(6033, 6181, 6229, 6224, 6009,
                                                            6009, 6009, 6070, 6343, 6903)),
                           duration_sec = c(904, 1404, 616, 1921, 875, 850, 2852, 3672, 253, 337),
                           is_member = as.factor(c(1, 1, 1, 1, 1, 0, 0, 0, 1, 1)))

## Valeur cible.
EXPECTED_SUM <- sum(c(4.55,  6.15,  3.55, 7.95, 4.35,
                      4.35, 10.95, 13.75, 2.35, 2.55))

## Test sur le résultat de 'revenues (ordre des arguments inversé pour
## tester la validité des noms).
stopifnot(all.equal(EXPECTED_SUM,
                    try(revenues(FUN = cost, "2024", x = BIXI_DATASET))))

source("R/cost.R")
###
### Tests unitaires de la fonction 'cost'.
###


## Données de test pour la structure de tarif 2020. Nous prenons aussi
## soin de tester les cas limites:
##
## - une durée nulle;
## - une durée de moins de 30 minutes;
## - une durée de 30 minutes exactement;
## - une durée entre 30 et 31 minutes;
## - une durée de 31 minutes exactement;
## - une durée entre 31 et 45 minutes;
## - une durée de 45 minutes exactement;
## - une durée entre 45 et 46 minutes;
## - une durée de 46 minutes exactement;
## - une durée entre 46 et 60 minutes
##   (une tranche de 15 minutes additionnelles);
## - une durée entre 60 et 75 minutes
##   (deux tranches de 15 minutes additionnelles).
## - une durée entre 75 et 90 minutes
##   (trois tranches de 15 minutes additionnelles).
## - une durée entre 90 et 105 minutes
##   (quatre tranches de 15 minutes additionnelles).
ZERO_DURATION <- 0
SINGLE_DURATION <- 3 * 60
VECTOR_DURATIONS <- c(23, 30, 30, 31, 33, 45, 45, 46, 53, 73, 88, 92) * 60 +
                    c( 0,  0,  2,  0,  0,  0,  1,  0,  0,  0,  0 , 0)

## Valeurs cibles.
EXPECTED_ZERO_RESULT <-
    structure(2.99, tariff = "2020")
EXPECTED_SINGLE_RESULT <-
    structure(2.99, tariff = "2020")
EXPECTED_VECTOR_RESULTS <-
    structure(2.99 +
              c(0, 0, 1.80 + c(0, 0, 0, 0, 3.00 * c(1, 1, 1, 2, 3, 4))),
              tariff = "2020")

## Test avec une durée de 0 seconde.
stopifnot(all.equal(EXPECTED_ZERO_RESULT,
                    try(cost(ZERO_DURATION, "2020")),
                    check.attributes = TRUE))

## Test avec une seule durée.
stopifnot(all.equal(EXPECTED_SINGLE_RESULT,
                    try(cost(SINGLE_DURATION, tariff = "2020")),
                    check.attributes = TRUE))

## Test avec un vecteur de durées.
stopifnot(all.equal(EXPECTED_VECTOR_RESULTS,
                    try(cost(tariff = "2020", VECTOR_DURATIONS)),
                    check.attributes = TRUE))

## Données de test pour la structure de tarif 2024. Le montant maximal
## est atteint après 93 minutes, soit 5580 secondes. Nous prenons
## aussi soin de tester les cas limites:
##
## - une durée nulle;
## - une durée de moins d'une minute;
## - une durée d'une minute exactement;
## - une durée entre 1 et 92 minutes;
## - une durée de 93 minutes moins quelques secondes;
## - une durée de plus de 93 minutes.
ZERO_DURATION <- 0
SINGLE_DURATION <- 42
VECTOR_DURATIONS <- c(60, 3601, 5570, 6320)

## Valeurs cibles.
EXPECTED_ZERO_RESULT <-
    structure(1.35, tariff = "2024")
EXPECTED_SINGLE_RESULT <-
    structure(1.55, tariff = "2024")
EXPECTED_VECTOR_RESULTS <-
    structure(c(1.55, 13.55, 19.95, 20), tariff = "2024")

## Test avec une durée de 0 seconde.
stopifnot(all.equal(EXPECTED_ZERO_RESULT,
                    try(cost(ZERO_DURATION, "2024")),
                    check.attributes = TRUE))

## Test avec une seule durée.
stopifnot(all.equal(EXPECTED_SINGLE_RESULT,
                    try(cost(SINGLE_DURATION, tariff = "2024")),
                    check.attributes = TRUE))

## Test avec un vecteur de durées.
stopifnot(all.equal(EXPECTED_VECTOR_RESULTS,
                    try(cost(tariff = "2024", VECTOR_DURATIONS)),
                    check.attributes = TRUE))

