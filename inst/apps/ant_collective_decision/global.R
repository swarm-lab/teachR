#### LOAD LIBRARIES #### 
pacman::p_load(shiny, shinythemes, deSolve, dplyr, plotly)


#### DEFINE CUSTOM FUNCTIONS ####
#' @title ODE System
#' 
#' @description This function represents the ODE system to simulate the 
#'  collective selection of a food source by ant colonies.  
#' 
#' @param t The time step to compute the ODE at.
#' @param y The values of the state variables of the ODE at the time step: 
#'  number of ants at the nest (N) and at each food source (S1...Sn), quantity 
#'  of pheromone on the routes to each food source (Q1...Qn).
#' @param parms Parameters of the ODE system:
#'  \itemize{
#'   \item l: Distance to each food source in seconds.
#'   \item q: Quantity of pheromone deposited by the ants on the way back from 
#'    each food source.
#'   \item qe: Quantity of pheromone deposited by the ants on the way to the 
#'    food sources.
#'   \item alpha, beta, gamma, eta: Regulates recruitment at the nest as a 
#'    function of the quantity of pheromone at the nest entrance.
#'   \item psi: Probability for an ant to leave the food source.
#'   \item rho: Rate of evaporation of the pheromone.
#'   \item k: Intrinsic attractiveness of each route.
#'   \item n: Degree of nonlinearity.
#'  }
#' 
#' @return A list of the changes in \code{y} suitable for \code{\link{dede}} 
#'  function. 
#' 
#' @author Simon Garnier: \email{garnier@@njit.edu}, 
#'  \link[https://twitter.com/sjmgarnier]{@@sjmgarnier}
#' 
ode_sys <- function(t, y, parms) {
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
