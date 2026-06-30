###
### cost(x, tariff = c("2020", "2024"))
###
##
##  Cette fonction calcule les coûts de déplacements selon 2 différentes
##  structure de tariff (2020 ou 2024).
##
##
##  Arguments
##
##  x: Vecteur de durées de déplacements en secondes.
##
##  tariff: Chaine de caractères du nom de la structure de tarif. 
##          Peut être soit 2020 ou 2024.
##
##
##  Valeur
##
##  un vecteur de coûts en dollars muni d’un attribut tariff
##  contenant le nom de la structure de tarif utilisée dans le calcul.
##
##  Exemples
##
##  cost(c(1000, 2000, 4000), "2024")
##  cost(c(1000, 2000, 4000), "2020")
##


cost <- function(x, tariff = c("2020", "2024")){

  base_2020 <- 2.99
  supplement_2020 <- 1.80
  supplement2_2020 <- 3
  temps_2020 <- 900
  intervalle1_2020 <- 1800
  intervalle2_2020 <- 2700
  base_2024 <- 1.35
  supplement_2024 <- 0.20
  temps_2024 <- 60
  maximum_2024 <- 20

  tariff <- match.arg(tariff)

  y <- numeric(length(x))

  if (tariff == "2020") {
    
    y[x <= intervalle1_2020] <- base_2020
    
    y[x > intervalle1_2020 & x <= intervalle2_2020] <- base_2020 + supplement_2020
    
    y[x > intervalle2_2020] <- base_2020 + supplement_2020 + supplement2_2020 * 
          ceiling((x[x > intervalle2_2020] - intervalle2_2020) / temps_2020)
    
  }
    
  
  if (tariff == "2024") {
    
    y <- base_2024 + supplement_2024 * ceiling(x / temps_2024)
    y[y > maximum_2024] <- maximum_2024
  }
    
  attr(y, "tariff") <- tariff
  y
}