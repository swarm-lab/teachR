pacman::p_load(shiny, shinythemes, deSolve, ggvis)

library(deSolve)

ode_sys <- function(t, y, parms) {
  # ODE system to simulate the collective selection of a food source by ant colonies. 
  #
  # Args:
  #   t: Current time step.
  #   y: Current number of ants at the nest (N) and at each food source (S1...Sn) + current quantity of pheromone on the routes to each food source (Q1...Qn).
  #   parms: Parameters of the equations.
  #             l: Distance to each food source in seconds.
  #             q: Quantity of pheromone deposited by the ants on the way back from each food source.
  #             qe: Quantity of pheromone deposited by the ants on the way to the food sources. 
  #             alpha, beta, gamma, eta: Regulates recruitment at the nest as a function of the quantity of pheromone at the nest entrance.
  #             psi: Probability for an ant to leave the food source.
  #             rho: Rate of evaporation of the pheromone.
  #             k: Intrinsic attractiveness of each route. 
  #             n: Degree of nonlinearity.
  #
  # Returns:
  #   A list of the changes in number of ants at the nest and at each food source + changes in quantity of pheromone on the routes to each food source. 
    
  nS <- length(parms$l)
  
  Q <- sum(y[(nS + 2):(2 * nS + 1)])
  phi <- (parms$alpha * (parms$beta + Q) ^ parms$eta) / ((parms$beta + Q) ^ parms$eta + parms$gamma)
  
  dN <- -phi*y[1]
  dS <- rep(0,nS)
  dQ <- rep(0,nS)
  
  ylag <- {}
  
  for (i in 1:nS) {
    if (t < parms$l[i]) {
      ylag <- c(parms$iniN, parms$iniS, parms$iniQ)
      Qlag <- 0
      philag <- 0
    } else {
      ylag <- lagvalue(t - parms$l[i])
      Qlag <- sum(ylag[(nS + 2):(2 * nS + 1)])
      philag <- (parms$alpha * (parms$beta + Qlag) ^ parms$eta) / ((parms$beta + Qlag) ^ parms$eta + parms$gamma)
    }
    
    P <- ((parms$k[i] + y[i + nS + 1]) ^ parms$n) / sum((parms$k + y[(nS + 2):(2 * nS + 1)]) ^ parms$n)
    Plag <- ((parms$k[i] + ylag[i + nS + 1]) ^ parms$n) / sum((parms$k + ylag[(nS + 2):(2 * nS + 1)]) ^ parms$n)
    
    dN <- dN + parms$psi*ylag[i + 1]
    
    dS[i] <- -parms$psi*y[i + 1] + philag * ylag[1] * Plag
    
    dQ[i] <- parms$qe * P * phi * y[1] + parms$q[i] * parms$psi * ylag[i + 1] - parms$rho * y[i + nS + 1]
    
  }
  
  return(list(c(dN, dS, dQ)))
}
