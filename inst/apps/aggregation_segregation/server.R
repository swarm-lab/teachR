shinyServer(function(input, output, session) {
  
  react <- reactiveValues(count = 0)
  
  observe({
    input$reset
    isolate({
      pop <<- data.frame(x = runif(input$nIndiv, min = -1, max = 1),
                         y = runif(input$nIndiv, min = -1, max = 1),
                         h = runif(input$nIndiv, min = -pi, max = pi),
                         s = 0.01, 
                         col = sample(c("#107AB6", "#D86810"), input$nIndiv, replace = TRUE))
    })
    react$count <- 0
  })
  
  locs <- reactive({
    invalidateLater(60, NULL)
    
    if (is.null(pop)) {
      return()
    }
    
    if (run) {
      isolate({
        pop <<- sp(pop, input$affinSame, input$affinOther)
        pop <<- rw(pop)
        react$count <- react$count + 1
      })
    }
    
    pop
  })
  
  observe({
    if (input$start > 0) {
      run <<- TRUE
    }
  })
  
  observe({
    if (input$stop > 0) {
      run <<- FALSE
    }
  })
  
  output$count <- renderText({
    react$count
  })
  
  observe({
    if (is.null(locs)) {
      return()
    } 
    
    locs %>%
      ggvis(x = ~x, y = ~y) %>%
      layer_points(fill := ~col) %>%
      scale_numeric("x", domain = c(-1, 1)) %>%
      scale_numeric("y", domain = c(-1, 1)) %>%
      add_axis("x", title = "", properties = axis_props(labels = list(fontSize = 0))) %>%
      add_axis("x", title = "", properties = axis_props(labels = list(fontSize = 0)), orient = "top") %>%
      add_axis("y", title = "", properties = axis_props(labels = list(fontSize = 0))) %>%
      add_axis("y", title = "", properties = axis_props(labels = list(fontSize = 0)), orient = "right") %>%
      set_options(width = "auto", height = "100%", resizable = FALSE, 
                  duration = 30) %>%
      bind_shiny("display")
  })
})

