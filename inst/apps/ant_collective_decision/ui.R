shinyUI(
  navbarPage(
    title = "Collective food source selection in ants",
    theme = shinytheme("cosmo"),
    fluid = FALSE,
    collapsible = TRUE,
    
    tabPanel("Model",
             
             includeCSS("www/custom.css"),
             
             # Sidebar
             sidebarLayout(
               sidebarPanel(
                 width = 3, 
                 
                 h4(tags$b("Source #1")),
                 sliderInput('l1', 'Distance:', ticks = FALSE,
                             min = 0, max = 100, value = 20, step = 1, width = "100%"),
                 sliderInput('q1', 'Quality:', ticks = FALSE,
                             min = 0, max = 2, value = 1, step = 0.01, width = "100%"),
                 sliderInput('k1', 'Light intensity:', ticks = FALSE,
                             min = 0, max = 100, value = 20, step = 1, width = "100%"),
                 
                 hr(),
                 
                 h4(tags$b("Source #2")),
                 sliderInput('l2', 'Distance:', ticks = FALSE,
                             min = 0, max = 100, value = 25, step = 1, width = "100%"),
                 sliderInput('q2', 'Quality:', ticks = FALSE,
                             min = 0, max = 2, value = 1, step = 0.01, width = "100%"),
                 sliderInput('k2', 'Light intensity:', ticks = FALSE,
                             min = 0, max = 100, value = 20, step = 1, width = "100%")
               ),
               
               # Main panel
               mainPanel(
                 fluidRow(
                   id = "the_display_row",
                   column(12, plotlyOutput("the_display", height = "100%"))
                 ),
                 
                 fluidRow(
                   column(12, 
                          sliderInput('N', 'Number of ants in the colony:', 
                                      min = 0, max = 5000, value = 1000, step = 10, width = "100%")
                   )
                 )
               )
             )
    ),
    
    tabPanel("Instructions",
             
             fluidRow(
               tags$hr(),
               
               h2("Goal"),
               
               p("This webapp simulates the collective decision-making mechanism
                 of mass-recruiting ant colonies."),
               
               p("The underlying model is a system of differential equations 
                 directly inspired from the work of Jean-Louis Deneubourg and 
                 his collaborators during the 1980's and 1990's. Hereafter are a 
                 couple relevant publications regarding the equations that served 
                 as a basis for this simulation:"),
               
               tags$ol(
                 tags$li(
                   tags$a(href = "http://doi.org/10.1007/BF00462870",
                          "Goss, S., Aron, S., Deneubourg, J. L., & Pasteels, 
                          J. M. (1989). Self-organized shortcuts in the Argentine 
                          ant. Die Naturwissenschaften, 76(12), 579–581.")), 
                 tags$li(
                   tags$a(href = "http://doi.org/10.1007/BF02224053",
                          "Beckers, R., Deneubourg, J.-L., Goss, S., & Pasteels, 
                          J. M. (1990). Collective decision making through food 
                          recruitment. Insectes Sociaux, 37(3), 258–267."))
               ),
               
               tags$hr(),
               
               h2("Parameters"),
               
               p("This simulation takes 4 parameters that you can modify using 
                 the sliders in the 'Model' tab."),
               
               tags$ol(
                 tags$li(tags$b("Number of ants in the colony: "), "this sets the 
                         total number of ants in the colony. Change this value to
                         observe the effect of colony size on the speed and
                         strength of the collective decision."), 
                 tags$li(tags$b("Distance: "), "this determines the distance in 
                         centimeters of the corresponding food source to the nest. 
                         The larger this value, the longer it will take ants to 
                         reach the food source and come back to the nest, and 
                         hence the longer it will take them to reinforce the 
                         pheromeone trail in between."), 
                 tags$li(tags$b("Quality: "), "this determines the sugar 
                         concentration in molar of the corresponding food source.
                         Larger values indicates a more beneficial food source. 
                         Ants lay more pheromone on their trails when coming 
                         back from rich food sources than from poor ones."),
                 tags$li(tags$b("Light intensity: "), "this determines how 
                         exposed to light is the path between the nest and a food
                         source. Light is repellent for ants that prefer to walk
                         along less exposed paths (most likely to reduce risks 
                         of predation or dessication). Higher values of this 
                         parameter indicate a more exposed path, and therefore a
                         less attractive path.")
               ),
               
               tags$hr(),
               
               h2("Outputs"),
               
               p("This simulation returns a graph representing the number of ants
                 at each food source (blue: source 1; orange: source 2) as a 
                 function of time (total time: 1 hour)."),
               
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
                   href = "https://github.com/swarm-lab/teachR/tree/master/inst/apps/ant_collective_decision",
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


