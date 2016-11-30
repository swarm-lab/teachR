#' @title List \code{\link[<teachR>:<teachR>-package]{teachR}} Apps
#'
#' @description This function generates a webpage listing all the apps available 
#'  through the \code{\link[<teachR>:<teachR>-package]{teachR}} library. The 
#'  list can be filtered by category (type \code{list_categories()} for a list 
#'  of existing categories) and keywords (type \code{list_keywords()} for a list 
#'  of existing keywords).
#' 
#' @param categories A character string or a vector of character strings 
#' corresponding to existing app categories (case insensitive).
#' 
#' @param keywords A character string or a vector of character strings 
#' corresponding to existing app keywords (case insensitive).
#' 
#' @return This function opens an html file.
#' 
#' @author Simon Garnier: \email{garnier@@njit.edu}, \link[https://twitter.com/sjmgarnier]{@@sjmgarnier}
#' 
#' @details If called from RStudio, the list will open in the internal RStudio 
#' viewer. If called from a terminal, it will open in your default internet browser.
#' 
#' @examples
#' list_apps(categories = c("biology", "social science"))
#' 
#' @export
#'
list_apps <- function(categories=NULL, keywords=NULL) {  
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
  
  md <- .make_list(info_table, categories, keywords)
  
  tmp_file <- tempfile(pattern = "file", fileext = ".html")  
  out <- knit(text = md)
  .markdownToHTML(text = out, output = tmp_file, options = c("toc"),
                  title = "Apps available in teachR",
                  template = paste0(find.package("teachR"), "/html/template.html"))
  
  viewer <- getOption("viewer")
  if (!is.null(viewer))
    viewer(tmp_file)
  else
    utils::browseURL(tmp_file)
}


.index <- function(x, pattern) {
  pattern <- paste(tolower(pattern), collapse= "|")
  x <- tolower(x)
  grepl(pattern, x)
}


.make_list <- function(info_table, categories = NULL, keywords = NULL) {  
  require(dplyr)
  require(knitr)
  require(markdown)
  
  if (!is.null(categories)) {
    info_table <- filter(info_table, .index(Category, categories))
  }
  if (!is.null(keywords)) {
    info_table <- filter(info_table, .index(Keywords, keywords))
  }
  
  if (nrow(info_table) > 0) {
    categories <- sort(unique(unlist(strsplit(info_table$Category, ","))))
    md <- c("---")
    
    for (i in 1:length(categories)) {
      category <- sub(" ", "", categories[i])
      md <- c(md, paste0("### ", category))
      
      tmp <- filter(info_table, .index(Category, categories[i]))
      
      for (j in 1:nrow(tmp)) {
        md <- c(md, "<table class='full'>")
        
        md <- c(md, "<tr class='title'>")
        md <- c(md, paste0("<td class='title' colspan='2'>", sub(" ", "", tmp$Title[j]), "</td>"))
        md <- c(md, "</tr>")
        
        md <- c(md, "<tr class='normal'>")
        md <- c(md, "<td class='title'>Command: </td>")
        md <- c(md, paste0("<td><code>", "run_app(\"", sub(" ", "", tmp$Command[j]), "\")</code></td>"))
        md <- c(md, "</tr>")
        
        md <- c(md, "<tr class='normal'>")
        md <- c(md, "<td class='title'>Description: </td>")
        md <- c(md, paste0("<td>", sub(" ", "", tmp$Description[j]), "</td>"))
        md <- c(md, "</tr>")
        
        md <- c(md, "<tr class='normal'>")
        md <- c(md, "<td class='title'>Keywords: </td>")
        md <- c(md, paste0("<td>", sub(" ", "", tmp$Keywords[j]), "</td>"))
        md <- c(md, "</tr>")
        
        md <- c(md, "<tr class='normal'>")
        md <- c(md, "<td class='title'>Depends on: </td>")
        md <- c(md, paste0("<td>", sub(" ", "", tmp$Depends[j]), "</td>"))
        md <- c(md, "</tr>")
        
        md <- c(md, "<tr class='normal'>")
        md <- c(md, "<td class='title'>Author: </td>")
        md <- c(md, paste0("<td>", sub(" ", "", tmp$Author[j]), "</td>"))
        md <- c(md, "</tr>")
        
        md <- c(md, "</table>")
      }
    } 
  } else {
    stop(paste0("There is no app matching these categories and/or keywords."))
  }
  
  md
}


.markdownToHTML <- function(file, output = NULL, text = NULL, options = getOption("markdown.HTML.options"), 
                            extensions = getOption("markdown.extensions"), title = "", 
                            stylesheet = getOption("markdown.HTML.stylesheet"), 
                            header = getOption("markdown.HTML.header"), 
                            template = getOption("markdown.HTML.template"), fragment.only = FALSE, 
                            encoding = getOption("encoding")) {
  if (fragment.only) 
    options <- c(options, "fragment_only")
  ret <- renderMarkdown(file, output = NULL, text, renderer = "HTML", 
                        renderer.options = options, extensions = extensions, 
                        encoding = encoding)
  ret <- enc2native(ret)
  if ("base64_images" %in% options) {
    filedir <- if (!missing(file) && is.character(file) && 
                     file.exists(file)) {
      dirname(file)
    }
    else "."
    ret <- local({
      oldwd <- setwd(filedir)
      on.exit(setwd(oldwd))
      .b64EncodeImages(ret)
    })
  }
  if (!"fragment_only" %in% options) {
    if (is.null(template)) 
      template <- system.file("resources", "markdown.html", 
                              package = "markdown")
    html <- paste(readLines(template), collapse = "\n")
    html <- sub("#!html_output#", ret, html, fixed = TRUE)
    if (is.character(stylesheet)) {
      html <- sub("#!markdown_css#", markdown:::option2char(stylesheet), 
                  html, fixed = TRUE)
    }
    else {
      warning("stylesheet must either be valid CSS or a file containing CSS!")
    }
    html <- sub("#!header#", markdown:::option2char(header), html, fixed = TRUE)
    if (!is.character(title) || title == "") {
      m <- regexpr("<[Hh][1-6].*?>(.*)</[Hh][1-6].*?>", 
                   html, perl = TRUE)
      if (m > -1) {
        title <- regmatches(html, m)
        title <- sub("<[Hh][1-6].*?>", "", title)
        title <- sub("</[Hh][1-6].*?>", "", title)
      }
      else {
        title <- ""
      }
    }
    html <- gsub("#!title#", title, html, fixed = TRUE)
    if ("mathjax" %in% options && .requiresMathJax(html)) {
      mathjax <- .mathJax(embed = "mathjax_embed" %in% 
                            options)
    }
    else mathjax <- ""
    html <- sub("#!mathjax#", mathjax, html, fixed = TRUE)
    if ("highlight_code" %in% options && .requiresHighlighting(html)) {
      highlight <- paste(readLines(system.file("resources", 
                                               "r_highlight.html", package = "markdown")), collapse = "\n")
    }
    else highlight <- ""
    html <- sub("#!r_highlight#", highlight, html, fixed = TRUE)
    ret <- html
  }
  if (is.character(output)) {
    ret2 <- iconv(ret, to = "UTF-8")
    if (any(is.na(ret2))) {
      warning("failed to convert output to UTF-8; wrong input encoding or locale?")
    }
    else ret <- ret2
    writeLines(ret, output, useBytes = TRUE)
    ret <- NULL
  }
  invisible(ret)
}


