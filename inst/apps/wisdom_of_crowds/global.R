pacman::p_load(shiny, shinythemes, dplyr, plotly, compiler, memoise, msm)

enableJIT(3)

memoise(sigmoid <- function(x, a = 0, k = 1, b = 0.1, m = 100, v = 1, q = 1) {
  s <- a + (k - a) / ((1 + q * exp(-b * (x - m))) ^ (1 / v))
  s0 <- a + (k - a) / ((1 + q * exp(-b * (0 - m))) ^ (1 / v))
  (s - s0) / diff(c(s0, 1)) * diff(c(0, 1))
})

memoise(woc <- function(n = 100, val = 200, error = 0.1, soc = 1) {
  res <- rtnorm(n, mean = val, sd = val * error, lower = 0)
  soc <- sigmoid(0:n, m = (1 - soc) * n, b = 0.5)
  
  for (i in 2:n) {
    res[i] <- res[i] * (1 - soc[i]) + mean(res[1:(i - 1)]) * soc[i]
  }
  
  res
})
