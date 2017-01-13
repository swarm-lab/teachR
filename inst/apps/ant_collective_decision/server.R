shinyServer(function(input, output) {
  
  res <- reactive({
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
                seq(0, 3600, length.out = 360), 
                ode_sys, 
                parms)
    
    data.frame(time = rep(out[, 1], 2), 
               S = c(rep("Source 1", nrow(out)), rep("Source 2", nrow(out))),
               val = c(out[, 3], out[, 4]))
  })
  
  output$the_display <- renderPlotly({
    g <- ggplot(data = res(), aes(x = time, y = val, color = S)) +
      geom_path(size = 0.75) +
      theme_minimal(base_size = 16) +
      theme(legend.title = element_blank()) +
      xlab("Time") + ylab("Number of ants") +
      scale_color_manual(values = c("#2678B2", "#FD7F28"))
    
    ggplotly(g) %>%
      layout(legend = list(x = 0.5, y = 1.1, orientation = "h", xanchor = "center"),
             hovermode = "x")
  })
  
})
