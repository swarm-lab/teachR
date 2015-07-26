# ODE function
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
