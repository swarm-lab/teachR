library(shiny)

shinyUI(
  navbarPage(
    title = "Aggregation, segregation",
    theme = "bootstrap.css",
    fluid = FALSE,
    collapsible = TRUE,
    
    tabPanel("Model",
             
             # Sidebar
             sidebarLayout(
               sidebarPanel(
                 width = 3, 
                 
                 sliderInput("n", "Number of individuals", 
                             min = 2, max = 500, value = 200, step = 2, width = "100%"), hr(),
                 
                 sliderInput("affin_same", "Affinity with same color", 
                             min = -1, max = 1, value = 1, step = 0.1, width = "100%"), hr(),
                 
                 sliderInput("affin_diff", "Affinity with different color", 
                             min = -1, max = 1, value = 0, step = 0.1, width = "100%"), hr(),
                 
                 div(style = "text-align: center;",
                     actionButton("goButton", "Rerun", icon = icon("refresh"))
                 )
                 
               ),
               
               # Main panel
               mainPanel(
                 fluidRow(
                   column(6, plotOutput("plot1")),
                   
                   column(6, plotOutput("plot2"))
                 ),
                 
                 sliderInput("time", "Timeline (move cursor or click on play button)", 
                             min = 0, max = 100, value = 0, width = "100%",
                             animate = animationOptions(
                               interval = 500, loop = FALSE,
                               playButton = tag("span", list(class = "glyphicon glyphicon-play")),
                               pauseButton = tag("span", list(class = "glyphicon glyphicon-pause"))))),
               
               
             )
    ),
    
    tabPanel("Instructions"),
    
    tabPanel("About",
             
             fluidRow(
               tags$hr(),
               
               p(strong("Author:"), " Simon Garnier (", a("New Jersey Institute of Technology",
                                                          href = "http://www.njit.edu",
                                                          target = "_blank"), ")"),
               
               p(strong("Twitter:"), a("@sjmgarnier", 
                                       href = "https://twitter.com/sjmgarnier",
                                       target = "_blank")),
               
               p(strong("Website:"), a("http://www.theswarmlab.com", 
                                       href = "http://www.theswarmlab.com",
                                       target = "_blank")),
               
               p(strong("Source code:"), 
                 a("GitHub",
                   href = "https://github.com/swarm-lab/Shiny/tree/master/aggregation_segregation",
                   target = "_blank")),
               
               p(strong("Created with:"), 
                 a("RStudio",
                   href = "http://www.rstudio.com/",
                   target = "_blank"), 
                 " and ",
                 a("Shiny.",
                   href = "http://shiny.rstudio.com",
                   target = "_blank")),
               
               p(strong("License:"), 
                 a("GPL v3",
                   href = "http://www.gnu.org/copyleft/gpl.html",
                   target = "_blank")),
               
               tags$hr()
             )
    ),
        
    tabPanel(tagList(tags$html("Powered by"),
                     tags$img(src = "https://dq3p0g5ijakv8.cloudfront.net/assets/build-40/img/white-rstudio-logo.png",
                              height="20")),
             value = "RStudio",
             tags$head(tags$script(src = "actions.js"))
    )    
  )
)

