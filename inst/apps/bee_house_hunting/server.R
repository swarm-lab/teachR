# Required libraries
library(shiny)
library(deSolve)
library(ggplot2)

# Shiny server call
shinyServer(function(input, output) {
  
  output$ODE.plot <- renderPlot({
    parms <- list(gamma = c(input$gamma1, input$gamma2, input$gamma3),  # discovery rate
                  alpha = c(input$alpha1, input$alpha2, input$alpha3),  # spontaneous uncommitment 
                  rho = c(input$rho1, input$rho2, input$rho3),          # recruitment rate 
                  sigma = c(input$sigma1, input$sigma2, input$sigma3),  # conversion rate
                  theta = input$theta)                                  # time at which 3rd nest is introduced
    
    out <- lsoda(c(0, 0, 0), seq(0, input$duration, 0.1), ode_sys, parms)
    out[, 2:4] <- out[, 2:4] * input$scouts
    out <- as.data.frame(out)
    names(out) <- c("time", paste0("nest", 1:3))
    
    g <- ggplot(data = out,
                aes(x = time)) + 
      geom_path(aes(y = nest1, color = "Nest 1  "), size = 1) + 
      geom_path(aes(y = nest2, color = "Nest 2  "), size = 1) +
      geom_path(aes(y = nest3, color = "Nest 3  "), size = 1) +
      geom_hline(yintercept = input$quorum, size = 1, linetype = 2) +
      theme_minimal(base_size = 18) + 
      theme(legend.position = "top", legend.title = element_blank()) +
      xlab("Time") + ylab("Number of committed scouts") +
      scale_color_manual(values = c("tomato3", "palegreen3", "dodgerblue3"))
    
    print(g)
  })
  
})
