library(shiny)
library(simecol)
library(ggplot2)
library(scales)
library(dplyr)
library(grid)
library(gridExtra)

shinyServer(function(input, output, session) {  
  data <- reactiveValues()
  
  observe({
    input$rerun
    
    mat <- matrix(0, nrow = 25, ncol = 25)
    mat[sample(1:(25 * 25), 2, FALSE)] <- c(1, -1)
    
    m1 <- new("gridModel", main = grid_sys, parms = list(w1 = input$w1, w2 = input$w2),
              times = 0:input$max.time, init = mat, solver = "iteration")
    
    data$steps <- out(sim(m1))
    
    data$summary <- data.frame(time = 0:input$max.time,
                               s1 = sapply(data$steps, function(x) sum(x > 0)),
                               s2 = sapply(data$steps, function(x) sum(x < 0)))
  })    
  
  output$timeline <- renderUI({
    sliderInput("time", "Timeline (move cursor or click on play button)", 
                min = 0, max = input$max.time, value = 0, width = "100%",
                animate = animationOptions(interval = 500, loop = FALSE,
                                           playButton = tag("span", list(class = "glyphicon glyphicon-play")),
                                           pauseButton = tag("span", list(class = "glyphicon glyphicon-pause"))))
  })
  
  output$plot <- renderPlot({
    print(input$time)
    tiles <- data.frame(expand.grid(x = 1:25, y = 1:25),
                        z = as.vector(data$steps[[input$time + 1]]))
    tiles$z <- factor(sign(tiles$z), levels = as.character(-1:1))
    
    g1 <- ggplot(tiles,
                 aes(x = x, y = y, fill = z)) +
      geom_tile(color = "grey", size = 0.5) +
      coord_fixed() +
      scale_fill_manual(values = c("dodgerblue", "white", "tomato"), 
                        drop = FALSE) +
      theme_minimal() + 
      theme(axis.line = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            legend.position = "none",
            panel.background = element_blank(),
            panel.border = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            plot.background = element_blank(),
            plot.margin = unit(c(0, 1, 0, 0), "line"))
    
    g2 <- ggplot() + 
      geom_line(data = data$summary,
                aes(x = time, y = 25 * 25 - s1 - s2), 
                color = alpha("black", 0.25), size = 1) +
      geom_line(data = data$summary,
                aes(x = time, y = s1), 
                color = alpha("tomato", 0.25), size = 1) +
      geom_line(data = data$summary,
                aes(x = time, y = s2), 
                color = alpha("dodgerblue", 0.25), size = 1) +
      geom_line(data = filter(data$summary, time <= (input$time + 1)),
                aes(x = time, y = 25 * 25 - s1 - s2, color = "Uncommitted"), 
                size = 1) +
      geom_line(data = filter(data$summary, time <= (input$time + 1)),
                aes(x = time, y = s1, color = "Opinion 1    "), 
                size = 1) + 
      geom_line(data = filter(data$summary, time <= (input$time + 1)),
                aes(x = time, y = s2, color = "Opinion 2    "), 
                size = 1) +  
      geom_vline(xintercept = input$time, color = "grey") +
      coord_fixed(ratio = input$max.time / 625) +
      theme_minimal(base_size = 18) +
      theme(legend.position = "top", 
            legend.title = element_blank(),
            plot.margin = unit(c(0, 1, 1, 1), "line")) + 
      xlab("Time") + ylab("Number of people") +
      scale_color_manual(values = c("tomato", "dodgerblue", "black"))
    
    g3 <- arrangeGrob(g1, g2 + theme(legend.position = "none"), ncol = 2)
    
    tmp <- ggplot_gtable(ggplot_build(g2 + theme(plot.margin = unit(c(0, 0, 0, 0), "line"))))
    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
    g4 <- tmp$grobs[[leg]]
    
    grid.arrange(g4, g3, heights = c(0.1, 1))
  })
})


