#### LOAD LIBRARIES #### 
pacman::p_load(shiny, shinythemes, deSolve, plotly, dplyr)


#### DEFINE CUSTOM FUNCTIONS ####
#' @title ODE System
#' 
#' @description This function represents the ODE system to simulate the 
#'  collective selection of a nest by honeybee colonies.  
#' 
#' @param t The time step to compute the ODE at.
#' @param y The values of the state variables of the ODE at the time step.
#' @param parms Parameters of the ODE system.
#' 
#' @return A list of the changes in \code{y} suitable for \code{\link{dede}} 
#'  function. 
#' 
#' @author Simon Garnier: \email{garnier@@njit.edu}, 
#'  \link[https://twitter.com/sjmgarnier]{@@sjmgarnier}
#' 
ode_sys <- function(t, y, parms) {
  yu <- 1 - sum(y)
  
  dy <- rep(0, 3)
  
  for (i in 1:3) {
    if (i == 3 & t < parms$theta) {
      dy[i] <- 0
    } else {
      idx <- which(1:length(dy) != i)
      
      dy[i] <-  yu * parms$gamma[i] + 
        y[i] * yu * parms$rho[i] - 
        y[i] * parms$alpha[i] - 
        y[i] * sum(parms$sigma[idx] * y[idx])
    }
  }
  
  list(dy)
}
