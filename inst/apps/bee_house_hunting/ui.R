shinyUI(
  navbarPage(
    title = "\"House hunting\" in honeybees",
    theme = shinytheme("cosmo"),
    fluid = FALSE,
    collapsible = TRUE,
    
    tabPanel("Model",
             
             includeCSS("www/custom.css"),
             
             # Sidebar
             sidebarLayout(
               sidebarPanel(
                 width = 3, 
                 
                 sliderInput("duration", "Duration of the trial:",
                             min = 1, max = 200, value = 200, width = "100%"),
                 sliderInput("scouts", "Number of scouts:",
                             min = 1, max = 200, value = 100, width = "100%"),
                 sliderInput("quorum", "Quorum number:",
                             min = 1, max = 200, value = 25, width = "100%"),
                 sliderInput("theta", "Time to introduce a 3rd nest:",
                             min = 1, max = 200, value = 100, width = "100%")
               ),
               
               # Main panel
               mainPanel(
                 fluidRow(
                   id = "the_display_row",
                   column(12, plotlyOutput("the_display", height = "100%"))
                 ),
                 
                 fluidRow(
                   column(4,
                          wellPanel(h5("Nest #1"),
                                    sliderInput("gamma1", "Discovery rate:",
                                                min = 0, max = 10, value = 1.5, step = 0.1),
                                    sliderInput("alpha1", "Desertion rate:",
                                                min = 0, max = 10, value = 1, step = 0.1),
                                    sliderInput("rho1", "Recruitment rate:",
                                                min = 0, max = 10, value = 2, step = 0.1),
                                    sliderInput("sigma1", "Deconversion rate:",
                                                min = 0, max = 10, value = 2, step = 0.1))
                   ),
                   column(4,
                          wellPanel(h5("Nest #2"),
                                    sliderInput("gamma2", "Discovery rate:",
                                                min = 0, max = 10, value = 2, step = 0.1),
                                    sliderInput("alpha2", "Desertion rate:",
                                                min = 0, max = 10, value = 1.5, step = 0.1),
                                    sliderInput("rho2", "Recruitment rate:",
                                                min = 0, max = 10, value = 2, step = 0.1),
                                    sliderInput("sigma2", "Deconversion rate:",
                                                min = 0, max = 10, value = 2, step = 0.1))
                   ),
                   column(4,
                          wellPanel(h5("Nest #3"),
                                    sliderInput("gamma3", "Discovery rate:",
                                                min = 0, max = 10, value = 2, step = 0.1),
                                    sliderInput("alpha3", "Desertion rate:",
                                                min = 0, max = 10, value = 1, step = 0.1),
                                    sliderInput("rho3", "Recruitment rate:",
                                                min = 0, max = 10, value = 2, step = 0.1),
                                    sliderInput("sigma3", "Deconversion rate:",
                                                min = 0, max = 10, value = 2, step = 0.1))
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
                   href = "https://github.com/swarm-lab/teachR/tree/master/inst/apps/bee_house_hunting",
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
                              height="20")),
             value = "RStudio",
             tags$head(tags$script(src = "actions.js"))
    )    
  )
)
