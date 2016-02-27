library(shiny)
library(ggvis)
library(deSolve)

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
  
  observe({
    if (is.null(res)) {
      return()
    }
    res %>%
      ggvis(x = ~time, y = ~val, stroke = ~S) %>%
      layer_lines(strokeWidth := 4) %>%
      add_axis("x", title = "Time (sec)", title_offset = 50,
               properties = axis_props(labels = list(fontSize = 16),
                                       title = list(fontSize = 20))) %>%
      add_axis("y", title = "Number of ants", title_offset = 50,
               properties = axis_props(labels = list(fontSize = 16),
                                       title = list(fontSize = 20))) %>%
      add_relative_scales() %>%
      add_legend("stroke", title = "", 
                 properties = legend_props(labels = list(fontSize = 16))) %>%
      set_options(width = "auto", height = "90%", resizable = FALSE, duration = 500) %>%
      bind_shiny("display")
  })
})
