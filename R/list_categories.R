#' @title List Categories of All \code{teachR} Apps 
#'
#' @description This function generates a listing  of all the categories of apps 
#'  available through the \code{teachR} library. 
#' 
#' @return A vector of character strings, each of them corresponding to a different
#'  category.
#' 
#' @author Simon Garnier, \email{garnier@@njit.edu}
#' 
#' @examples
#' \dontrun{
#'  list_categories()
#' }
#' 
#' @export
list_categories <- function() {  
  apps <- dir(paste0(find.package("teachR"), "/apps"))
  info_table <- data.frame()
  
  for (i in 1:length(apps)) {
    info <- utils::read.table(paste0(find.package("teachR"), "/apps/", apps[i], "/info"), sep = ":")
    info <- t(as.matrix(info)[, 2])
    info_table <- rbind(info_table, info)
  }
  info_table[] <- lapply(info_table, as.character)
  names(info_table) <- c("Title", "Version", "Date", "Author", 
                         "Maintainer", "Description", "Category", 
                         "Keywords", "License", "Depends", "Command" )
  
  categories <- strsplit(info_table$Category, ",")
  categories <- sort(unique(unlist(categories)))
  sub(" ", "", categories)
}
