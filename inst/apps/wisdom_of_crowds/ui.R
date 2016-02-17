shinyUI(
  navbarPage(
    title = "The Wisdom of Crowds",
    theme = "bootstrap.css",
    fluid = FALSE,
    collapsible = TRUE,
    
    tabPanel("Model",
             
             # Sidebar
             sidebarLayout(
               sidebarPanel(
                 width = 3, 
                 
                 sliderInput("n", "Number of individuals in the group", 
                             min = 50, max = 500, value = 100, step = 1, width = "100%"), hr(),
                 
                 sliderInput("error", "% error of individual guesses", 
                             min = 0, max = 100, value = 20, width = "100%"), hr(),
                 
                 sliderInput("soc", "Intensity of social influence", 
                             min = 0, max = 1, value = 0, width = "100%"), hr(),
                 
                 div(style = "text-align: center;",
                     actionButton("goButton", "Rerun", icon = icon("refresh"))
                 )
                 
               ),
               
               # Main panel
               mainPanel(
                 fluidRow(
                   column(6,
                          plotOutput("IBM.plot1")),
                   
                   column(6,
                          plotOutput("IBM.plot2"))
                 ),
                 
                 tags$hr(),
                 
                 p(tags$b("Control"), " = no social influence"),
                 p(tags$b("Experimental"), " = social influence set to slider value"),
                 p(tags$b("Number of gumballs"), " = 200")
               )
             )
    ),
    
    tabPanel("Instructions", 
             
             fluidRow(
               tags$hr(),
               
               h2("Goal"),
               
               p("This webapp simulates a classical experiment in the social 
                 sciences that aims at demonstrating the so-called 'Wisdom of 
                 Crowds'."), 
               
               p("In this experiment, a number of people (set by the user) are 
                 asked to guess the number of gumballs placed in a jar. Each 
                 guess is likely to be off the true number of gumballs in the 
                 jar. However, if all the guesses are made independently and in
                 the absence of general perceptual or cognitive bias to 
                 systematically under- or overestimate this number, the average
                 guess of the group will be close to the exact number of 
                 gumballs. This observation, ", a("made originally by Sir Francis 
                 Galton in 1906", 
                 href = "https://en.wikipedia.org/wiki/Francis_Galton#Variance_and_standard_deviation"),
                 ", is at the origin of concept of 'Wisdom of Crowds', where the
                 crowd as a whole is better than any of the people who compose 
                 it"),
               
               p("However, if the guesses are not made independently (e.g. if 
                 each person knows about previous guesses), then things can get
                 quickly out of hands, and the 'Wisdom of Crowds' disappear. 
                 The goal of this simulation if to help you understand how 
                 social feedback (i.e. knowledge of other people's guesses in 
                 this case) can undermine the ability of a group to act as a 
                 reliable collective estimator."),
               
               tags$hr(),
               
               h2("Parameters"),
               
               p("This simulation takes 3 parameters that you can modify using 
                 the sliders in the 'Model' tab."),
               
               tags$ol(
                 tags$li(tags$b("Number of individuals in the group: "), "this 
                         sets the number of people who are asked to guess in 
                         each replicate of the virtual experiment."), 
                 tags$li(tags$b("% error of individual guesses: "), "this sets
                         the average error of each person's guess. For instance,
                         if sets to 20%, this means that people make guesses 
                         that in average 20% off the real number of gumballs in 
                         the jar (above or below this number)."), 
                 tags$li(tags$b("Intensity of social influence: "), "this 
                         determines how much each individual cares about the 
                         guesses made by previous individuals. If set to 0, it 
                         means that they ignore them completely before making a 
                         guess (independent guesses).")
               ),
               
               p("Every time you re-run the experiment with a different set of 
                 parameters, the software simulates 1,000 replicates."),
               
               tags$hr(),
               
               h2("Outputs"),
               
               p("This simulation returns 2 graphs."),
               
               tags$ol(
                 tags$li("The left represents the percentage of individuals in 
                         each replicate that made a worse guess that the group's
                         average in that replicate. Higher values indicates that
                         the group perform better than most of its members."), 
                 tags$li("The right graph represents the distribution of the 
                         groups' standard deviations. Smaller values indicates
                         that individual opinions are more similar to each other.")
               ),
               
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
                   href = "https://github.com/swarm-lab/Shiny/tree/master/wisdom_of_crowds/model",
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

