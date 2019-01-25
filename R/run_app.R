#' @title Run \code{teachR} Apps
#'
#' @description This function calls a Shiny app provided by the 
#'  \code{teachR} library. The list of available Shiny apps can be obtained by 
#'  typing \code{list_apps()} in your R terminal. 
#' 
#' @param app The name of the app to run.
#' 
#' @return This function does not return anything.
#' 
#' @author Simon Garnier, \email{garnier@@njit.edu}
#' 
#' @details If called from RStudio, the app will open in the internal RStudio 
#'  internet browser. If called from a terminal, it will open in your default 
#'  internet browser. All apps should work without any problem with the internal 
#'  RStudio internet browser, as well as with recent versions of most internet 
#'  browsers. It is likely to break with older versions.
#' 
#' @examples
#' \dontrun{
#'  run_app("aggregation_segregation")
#' }
#' 
#' @export
run_app <- function(app) {
  app_path <- paste0(find.package("teachR"), "/apps/", app)
  shiny::runApp(app_path)
}

