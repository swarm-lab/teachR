library(shiny)

shinyUI(
  navbarPage(
    title = "Collective food source selection in ants",
    theme = "bootstrap.css",
    fluid = FALSE,
    collapsible = TRUE,
    
    tabPanel("Model",
             
             # Sidebar
             sidebarLayout(
               sidebarPanel(
                 width = 3, 
                 
                 sliderInput('N', 'Number of ants in the colony:', 
                             min=0, max=5000, value=1000, step=10, width = "100%"),
                 
                 sliderInput('t', 'Length of the experiment in seconds:', 
                             min=0, max=3600, value=1800, step=10, width = "100%")
               ),
               
               # Main panel
               mainPanel(
                 fluidRow(
                   column(12, plotOutput("ODE.plot"))          
                 ),
                 
                 fluidRow(
                   column(6,
                          wellPanel(
                            h5("Source #1"),
                            sliderInput('l1', 'Distance:', 
                                        min=0, max=100, value=20, step=1, width = "100%"),
                            sliderInput('q1', 'Quality:', 
                                        min=0, max=2, value=1, step=0.01, width = "100%"),
                            sliderInput('k1', 'Light intensity:', 
                                        min=0, max=100, value=20, step=1, width = "100%")
                          )
                   ),
                   
                   column(6,
                          wellPanel(
                            h5("Source #2"),
                            sliderInput('l2', 'Distance:', 
                                        min=0, max=100, value=25, step=1, width = "100%"),
                            sliderInput('q2', 'Quality:', 
                                        min=0, max=2, value=1, step=0.01, width = "100%"),
                            sliderInput('k2', 'Light intensity:', 
                                        min=0, max=100, value=20, step=1, width = "100%")
                          )
                   )
                 )
               )
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


