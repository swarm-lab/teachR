#' Export teaching apps provided by \code{\link[<teachR>:<teachR>-package]{teachR}}
#'
#' This function expor a Shiny app provided by the \code{\link[<teachR>:<teachR>-package]{teachR}} 
#' library to a local folder on a user's computer. Useful for modifying the app 
#' or running it on a Shiny Server instance for example. 
#' 
#' @param app The name of the app to run.
#' 
#' @param dest The destination of the app folder on the user's computer. A folder
#' with the name of the app will be created at this location. 
#' 
#' @return This function does not return anything.
#' 
#' @author Simon Garnier: \email{garnier@@njit.edu}, \link[https://twitter.com/sjmgarnier]{@@sjmgarnier}
#' 
#' @examples
#' # Export app to the current working directory
#' export_app("aggregation_segregation", ".")
#' 
#' @export
#'
export_app <- function(app, dest) {
  app_path <- paste0(find.package("teachR"), "/apps/", app)  
  file.copy(from = app_path, to = dest, recursive = TRUE)
}

