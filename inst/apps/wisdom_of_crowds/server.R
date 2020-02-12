shinyServer(function(input, output, session) {
  
  react <- reactiveValues(tab = {}, count = -1)
  
  observe({
    if (react$count != input$goButton) {
      react$count <- input$goButton
      
      withProgress(message = paste0("Simulating ", input$rep, " experiments"), {
        m1 <- replicate(input$rep, woc(n = input$n, 
                               val = 200,
                               error = input$error / 100,
                               soc = 0))
        tmp1 <- abs(m1 - 200) 
        tmp2 <- abs(matrix(apply(m1, 2, mean), nrow = input$n, ncol = input$rep, byrow = TRUE) - 200)
        r1 <- apply(tmp2 < tmp1, 2, sum)
        
        m2 <- replicate(input$rep, woc(n = input$n, 
                               val = 200,
                               error = input$error / 100,
                               soc = input$soc))
        tmp1 <- abs(m2 - 200) 
        tmp2 <- abs(matrix(apply(m2, 2, mean), nrow = input$n, ncol = input$rep, byrow = TRUE) - 200)
        r2 <- apply(tmp2 < tmp1, 2, sum)
        
        react$tab <- data.frame(
          SOC = as.factor(rep(c("Control", "Experimental"), each = input$rep * 2)),
          TYPE = rep(c("mean", "sd", "mean", "sd"), each = input$rep),
          VAL = c(apply(m1, 2, mean), # 100 * (r1 / input$n),
                  apply(m1, 2, sd),
                  apply(m2, 2, mean), # 100 * (r2 / input$n),
                  apply(m2, 2, sd)))
      }) 
    }
  })
  
  output$IBM.plot1 <- renderPlotly({
    sub_dat <- filter(react$tab, TYPE == "mean")
    r <- c(min(sub_dat$VAL), max(sub_dat$VAL))
    plot_ly(sub_dat, type = "histogram", alpha = 0.6, 
            x = ~VAL, color = ~SOC, colors = c("tomato3", "dodgerblue3"),
            xbins = list(start = r[1], end = r[2], size = diff(r) / 40), 
            autobinx = FALSE) %>%
      layout(barmode = "overlay", hovermode = "x",
             xaxis = list(title = "Group average"),
             yaxis = list(title = "Count"),
             font = list(size = 14),
             legend = list(x = 0.5, y = 1.1, orientation = "h", xanchor = "center"))
  })
  
  output$IBM.plot2 <- renderPlotly({
    sub_dat <- filter(react$tab, TYPE == "sd")
    r <- c(min(sub_dat$VAL), max(sub_dat$VAL))
    plot_ly(sub_dat, type = "histogram", alpha = 0.6, 
            x = ~VAL, color = ~SOC, colors = c("tomato3", "dodgerblue3"),
            xbins = list(start = r[1], end = r[2], size = diff(r) / 40), 
            autobinx = FALSE) %>%
      layout(barmode = "overlay", hovermode = "x",
             xaxis = list(title = "Group standard deviation"),
             yaxis = list(title = "Count"),
             font = list(size = 14),
             legend = list(x = 0.5, y = 1.1, orientation = "h", xanchor = "center"))
  })
})
