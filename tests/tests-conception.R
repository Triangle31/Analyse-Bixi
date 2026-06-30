
# source("cost.R")
# source("filename.R")


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

