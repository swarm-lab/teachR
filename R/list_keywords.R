#' List the keywords of all apps available through \code{\link[<teachR>:<teachR>-package]{teachR}}
#'
#' This function generates a listing of all the keywords of apps available through 
#' the \code{\link[<teachR>:<teachR>-package]{teachR}} library. 
#' 
#' @return A vector of character strings, each of them corresponding to a different
#' keyword.
#' 
#' @author Simon Garnier: \email{garnier@@njit.edu}, \link[https://twitter.com/sjmgarnier]{@@sjmgarnier}
#' 
#' @examples
#' list_keywords()
#' 
#' @export
#'
list_keywords <- function() {  
  apps <- dir(paste0(find.package("teachR"), "/apps"))
  info_table <- data.frame()
  
  for (i in 1:length(apps)) {
    info <- read.table(paste0(find.package("teachR"), "/apps/", apps[i], "/info"), sep = ":")
    info <- t(as.matrix(info)[,2])
    info_table <- rbind(info_table, info)
  }
  info_table[] <- lapply(info_table, as.character)
  names(info_table) <- c("Title", "Version", "Date", "Author", 
                         "Maintainer", "Description", "Category", 
                         "Keywords", "License", "Depends", "Command" )
  
  keywords <- strsplit(info_table$Keywords, ",")
  keywords <- sort(unique(unlist(keywords)))
  sub(" ", "", keywords)
}




