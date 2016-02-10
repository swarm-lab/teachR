shinyServer(function(input, output, session) {
  
  react <- reactiveValues(tab = {}, count = -1)
  
  observe({
    if (react$count != input$goButton) {
      react$count <- input$goButton
      
      withProgress(message = "Simulating 1000 experiments", {
        m1 <- replicate(N, woc(n = input$n, 
                               val = 200,
                               error = input$error / 100,
                               soc = 0))
        tmp1 <- abs(m1 - 200) 
        tmp2 <- abs(matrix(apply(m1, 2, mean), nrow = input$n, ncol = 1000, byrow = TRUE) - 200)
        r1 <- apply(tmp2 < tmp1, 2, sum)
        
        m2 <- replicate(N, woc(n = input$n, 
                               val = 200,
                               error = input$error / 100,
                               soc = input$soc))
        tmp1 <- abs(m2 - 200) 
        tmp2 <- abs(matrix(apply(m2, 2, mean), nrow = input$n, ncol = 1000, byrow = TRUE) - 200)
        r2 <- apply(tmp2 < tmp1, 2, sum)
        
        react$tab <- data.frame(
          SOC = as.factor(rep(c("Control   ", "Experimental   "), each = N * 2)),
          TYPE = rep(c("mean", "sd", "mean", "sd"), each = N),
          VAL = c(100 * (r1 / input$n),
                  apply(m1, 2, sd),
                  100 * (r2 / input$n),
                  apply(m2, 2, sd)))
      }) 
    }
  })
  
  output$IBM.plot1 <- renderPlot({
    g <- ggplot(filter(react$tab, TYPE == "mean"),
                aes(x = VAL, color = SOC, fill = SOC)) + 
      geom_histogram(position = "identity", bins = 40) +
      geom_vline(xintercept = 50, linetype = 2) +
      xlim(0, 100) +
      theme_minimal(base_size = 16) + 
      theme(legend.position = "top", legend.title = element_blank()) +
      xlab("Average > x% of group members") + ylab("Density") +
      scale_color_manual(values = c("tomato3", "dodgerblue3")) + 
      scale_fill_manual(values = alpha(c("tomato3", "dodgerblue3"), 0.25))
    
    print(g)
  })
  
  output$IBM.plot2 <- renderPlot({
    g <- ggplot(filter(react$tab, TYPE == "sd"),
                aes(x = VAL, color = SOC, fill = SOC)) + 
      geom_histogram(position = "identity", bins = 40) +
      theme_minimal(base_size = 16) + 
      theme(legend.position = "top", legend.title = element_blank()) +
      xlab("Group standard deviation") + ylab("Density") +
      scale_color_manual(values = c("tomato3", "dodgerblue3")) + 
      scale_fill_manual(values = alpha(c("tomato3", "dodgerblue3"), 0.25))
    
    print(g)
  })
})
