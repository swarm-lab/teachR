shinyServer(function(input, output) {
  
  res <- reactive({
    parms <- list(gamma = c(input$gamma1, input$gamma2, input$gamma3),  # discovery rate
                  alpha = c(input$alpha1, input$alpha2, input$alpha3),  # spontaneous uncommitment 
                  rho = c(input$rho1, input$rho2, input$rho3),          # recruitment rate 
                  sigma = c(input$sigma1, input$sigma2, input$sigma3),  # conversion rate
                  theta = input$theta)                                  # time at which 3rd nest is introduced
    
    tmp <- lsoda(c(0, 0, 0), seq(0, input$duration, 0.05), ode_sys, parms)
    tmp[, 2:4] <- tmp[, 2:4] * input$scouts
    out <- data.frame(time = rep(tmp[, 1], 3),
                      nest = rep(c("Nest 1", "Nest 2", "Nest 3"), each = nrow(tmp)),
                      val = c(tmp[, 2], tmp[, 3], tmp[, 4]))
    out
  })
  
  output$the_display <- renderPlotly({
    g <- ggplot(data = res(), aes(x = time, y = val, color = nest)) +
      geom_path(size = 0.75) +
      geom_hline(yintercept = input$quorum, size = 0.5, linetype = 2) +
      theme_minimal(base_size = 16) +
      theme(legend.title = element_blank()) +
      xlab("Time") + ylab("Number of committed scouts") +
      scale_color_manual(values = c("#2678B2", "#FD7F28", "#339734"))
    
    ggplotly(g) %>%
      layout(legend = list(x = 0.5, y = 1.1, orientation = "h", xanchor = "center"),
             hovermode = "x")
  })
  
})
