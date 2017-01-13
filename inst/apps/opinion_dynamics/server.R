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
                min = 0, max = input$max.time, value = 0, step = 1, width = "100%", 
                animate = animationOptions(interval = 250, loop = FALSE,
                                           playButton = tag("span", list(class = "glyphicon glyphicon-play")),
                                           pauseButton = tag("span", list(class = "glyphicon glyphicon-pause"))))
  })
  
  observe({
    if (is.null(input$time)) {
      return()
    } 
    
    data.frame(expand.grid(x = 1:25, y = 1:25),
               z = sign(as.vector(data$steps[[input$time + 1]])) + 2) %>%
      mutate(color = c("#1E90FF", "#FFFFFF", "#FF6347")[z]) %>%
      ggvis(x = ~factor(x), y = ~factor(y), fill := ~color) %>%
      layer_rects(width = band(), height = band(), strokeWidth := 0.1) %>%
      hide_axis("x") %>%
      hide_axis("y") %>%
      hide_legend("fill") %>%
      set_options(width = "auto", height = "100%", resizable = FALSE, 
                  duration = 30) %>%
      bind_shiny("display1")
    
    filter(data$summary, time <= (input$time + 1)) %>%
      ggvis(x = ~time) %>%
      layer_paths(y = ~100 * (25 * 25 - s1 - s2) / 625, stroke := "black", strokeWidth := 2) %>%
      layer_paths(y = ~100 * s1 / 625, stroke := "tomato", strokeWidth := 2) %>%
      layer_paths(y = ~100 * s2 / 625, stroke := "dodgerblue", strokeWidth := 2) %>%
      scale_numeric("x", domain = c(0, input$max.time), nice = FALSE) %>%
      add_axis("x", title = "Time") %>%
      add_axis("y", title = "% population") %>%
      set_options(width = "auto", height = "100%", resizable = FALSE, 
                  duration = 30) %>%
      bind_shiny("display2")
  })
})


