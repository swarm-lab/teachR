#' @title Export \code{teachR} Apps
#'
#' @description This function exports a Shiny app provided by the 
#'  \code{teachR} library to a local folder on 
#'  a user's computer. Useful for modifying the app or running it on a Shiny 
#'  Server instance for example. 
#' 
#' @param app The name of the app to export.
#' 
#' @param dest The destination of the app folder on the user's computer. A folder
#'  with the name of the app will be created at this location. 
#' 
#' @return This function does not return anything.
#' 
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'  
#' @examples
#' \dontrun{
#'  # Export app to the current working directory
#'  export_app("aggregation_segregation", ".")
#' }
#' 
#' @export
export_app <- function(app, dest) {
  app_path <- paste0(find.package("teachR"), "/apps/", app)  
  file.copy(from = app_path, to = dest, recursive = TRUE)
}

