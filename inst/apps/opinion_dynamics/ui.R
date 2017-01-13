shinyUI(
  navbarPage(
    title = "Opinion dynamics",
    theme = shinytheme("cosmo"),
    fluid = FALSE,
    collapsible = TRUE,
    
    tabPanel("Model",
             
             includeCSS("www/custom.css"),
             
             # Sidebar
             sidebarLayout(
               sidebarPanel(
                 width = 3, 
                 sliderInput("max.time", "Duration of the trial:",
                             min = 1, max = 500, value = 200, width = "100%"),
                 sliderInput("w1", "Strength of opinion 1:",
                             min = 0, max = 1, value = 0.25, step = 0.01, width = "100%"),
                 sliderInput("w2", "Strength of opinion 2:",
                             min = 0, max = 1, value = 0.25, step = 0.01, width = "100%"),
                 p(align = 'center',
                   actionButton("rerun", "Rerun"))
               ),
               
               # Main panel
               mainPanel(
                 fluidRow(
                   column(6, 
                          tags$div(class = "box", 
                                   tags$div(class = "content", 
                                            ggvisOutput("display1")))
                          # plotOutput("plot", height = "500px")
                 ),
                 column(6, 
                        tags$div(class = "box", 
                                 tags$div(class = "content", 
                                          ggvisOutput("display2")))
                        # plotOutput("plot", height = "500px")
                 ),
                 uiOutput("timeline"))
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
                   href = "https://github.com/swarm-lab/teachR/tree/master/inst/apps/opinion_dynamics",
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
                     tags$img(src = "white-rstudio-logo.png",
                              height = "20")),
             value = "RStudio",
             tags$head(tags$script(src = "actions.js"))
    )    
  )
)
