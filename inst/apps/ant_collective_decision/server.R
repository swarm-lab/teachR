library(shiny)
library(deSolve)
library(ggplot2)

# Shiny server call
shinyServer(function(input, output) {
  
  output$ODE.plot = renderPlot({
    parms <- list(iniN = input$N, 
                  iniS = rep(0,2), 
                  iniQ = rep(0,2), 
                  l = c(input$l1, input$l2), 
                  q = c(input$q1, input$q2), 
                  qe = 0, 
                  alpha = 0.01, 
                  beta = 5, 
                  gamma = 1200, 
                  eta = 2, 
                  psi = 0.05, 
                  rho = 0.01, 
                  k = c(100 - input$k1 + 1, 100 - input$k2 + 1), 
                  n = 2)
    
    out <- dede(c(N = parms$iniN, S = parms$iniS, Q = parms$iniQ), 
                0:input$t, 
                ode_sys, 
                parms)
    
    out <- as.data.frame(out)
        
    g <- ggplot(data = out,
                aes(x = time)) + 
      geom_path(aes(y = S1, color = "Source 1  "), size = 1) + 
      geom_path(aes(y = S2, color = "Source 2  "), size = 1) +
      theme_minimal(base_size = 18) + 
      theme(legend.position = "top", legend.title=element_blank()) +
      xlab("Time") + ylab("Number of ants") +
      scale_color_manual(values = c("tomato3", "dodgerblue3"))
    
    print(g)  
  })
})
