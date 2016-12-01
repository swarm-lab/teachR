shinyUI(
  navbarPage(
    title = "Aggregation, segregation",
    theme = shinytheme("cosmo"),
    fluid = FALSE,
    collapsible = TRUE,
    
    tabPanel("Model",
             
             includeCSS("www/custom.css"),
             
             # Sidebar
             sidebarLayout(
               sidebarPanel(
                 width = 3, 
                 
                 sliderInput("nIndiv", "Number of individuals", 
                             min = 2, max = 500, value = 200), 
                 
                 tags$hr(),
                 
                 sliderInput("affinSame", "Affinity with same color", 
                             min = -1, max = 1, value = 0, step = 0.1),
                 
                 tags$hr(),
                 
                 sliderInput("affinOther", "Affinity with different color", 
                             min = -1, max = 1, value = 0, step = 0.1),
                 
                 tags$hr(),
                 
                 actionButton("start", "Start", style = "border: 2px solid; border-color: green; background-color: green;"),
                 actionButton("stop", "Stop", style = "border: 2px solid; border-color: red; background-color: red;"),
                 actionButton("reset", "Reset", style = "border: 2px solid; border-color: black;"),
                 
                 tags$hr(),
                 
                 tags$p("Step:", textOutput("count", inline = TRUE)),
                 
                 tags$hr()
                 
               ),
               
               # Main panel
               mainPanel(
                 fluidRow(
                   ggvisOutput("display")
                 )
               )
             )
    ),
    
    tabPanel("Instructions",
             
             fluidRow(
               tags$hr(),
               
               h2("Goal"),
               
               p("This webapp simulates a simple aggregation mechanism."),
               
               p("In the absence of interaction, each individual particle moves 
                 randomly at maximum speed. When two particles move close to 
                 each other, they slow down if they have a positive affinity for 
                 each other, or accelerate if they have a negative affinity for 
                 each other. The amount of deceleration (resp. acceleration)
                 depends on the strength of the affinity and the number of 
                 particles within the interaction range of each particle."),
               
               tags$hr(),
               
               h2("Parameters"),
               
               p("This simulation takes 3 parameters that you can modify using 
                 the sliders in the 'Model' tab."),
               
               tags$ol(
                 tags$li(tags$b("Number of individuals: "), "this sets the number 
                         of particles in the simulation. Change this value to 
                         observe the effect of the particles' density on their 
                         aggregation behavior. The new value will not be taken 
                         into account unless you hit the 'Reset' button."), 
                 tags$li(tags$b("Affinity with same color: "), "this determines 
                         the level of affinity between particles of the same
                         color. This parameter can be changed while the 
                         simulation is running."), 
                 tags$li(tags$b("Affinity with different color: "), "this determines 
                         the level of affinity between particles of different
                         colors. This parameter can be changed while the 
                         simulation is running.")
                 ),
               
               p("Use the 'Start' and 'Stop' buttons to run or pause the 
                 simulation. The 'Reset' button will disperse the particles 
                 randomly and update their number - if the corresponding 
                 parameter has been modified."),
               
               tags$hr(),
               
               h2("Outputs"),
               
               p("This simulation returns an animated graph representing the XY 
                 positions of the particles."),
               
               tags$hr()
             )
    ),
    
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
                   href = "https://github.com/swarm-lab/teachR/tree/master/inst/apps/aggregation_segregation",
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

