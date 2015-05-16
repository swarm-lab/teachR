library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  
  dat <- reactiveValues(tab = NULL)
  
  observe({
    input$goButton
    
    isolate({
      withProgress(message = "Running simulation", detail = "Please wait...", {
        dat$tab <- agg_seg_model(n = input$n, affin_diff = input$affin_diff, affin_same = input$affin_same)})
    })
    
  }) 
  
  output$plot1 <- renderPlot({
    ggplot(filter(dat$tab, t == input$time), aes(x = x, y = y, color = color)) +
      geom_point(size = 3, alpha = 0.75) + 
      coord_fixed() + 
      xlim(0, 1) + ylim(0, 1) +
      theme_minimal(base_size = 18) + 
      guides(color = FALSE) + 
      scale_colour_manual(values = c("#0072B2", "#D55E00")) +
      theme(axis.text = element_blank(), axis.title = element_blank(), axis.ticks = element_blank())
  })
  
  output$plot2 <- renderPlot({
    res <- filter(dat$tab, t == input$time)
    dist <- pdist(as.matrix(res[, 2:3]), as.matrix(res[, 2:3]))
    
    res$closest_blue <- apply(dist, 2, function(dist, color) {
      min(dist[color == "blue" & dist > 0])
    }, color = res$color)
    
    res$closest_red <- apply(dist, 2, function(dist, color) {
      min(dist[color == "red" & dist > 0])
    }, color = res$color)
    
    res <- group_by(res, color) %>%
      mutate(closest_same = ifelse(color == "blue", closest_blue, closest_red),
             closest_diff = ifelse(color == "blue", closest_red, closest_blue))
    
    cols <- c("same color" = "#0072B2", "different color" = "#D55E00")
    
    ggplot(res) +
      geom_histogram(aes(x = closest_same, fill = "same color"), alpha = 0.75, binwidth = 0.0125) + 
      geom_histogram(aes(x = closest_diff, fill = "different color"), alpha = 0.75, binwidth = 0.0125) +
      xlim(0, 0.4) + xlab("Distance") + ylab("Count") +
      scale_fill_manual(name = "Distance to\nclosest neighbor", values = cols) + 
      theme_minimal(base_size = 18) +
      theme(legend.justification = c(1, 1), legend.position = c(1, 1))
  })
})
