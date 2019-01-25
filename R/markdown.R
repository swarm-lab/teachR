#' # Functions copied from the markdown package
#' .mathJax <- local({
#'   js <- NULL
#'   
#'   function(embed=FALSE, force=FALSE) {
#'     if (!embed)
#'       return(paste(readLines(system.file(
#'         'resources', 'mathjax.html', package = 'markdown'
#'       )), collapse = '\n'))
#'     
#'     url <- 'https://cdn.bootcss.com/mathjax/2.7.0/MathJax.js?config=TeX-MML-AM_CHTML'
#'     
#'     # Insert or link to MathJax script?
#'     html <- c('<!-- MathJax scripts -->', if (embed) {
#'       # Already in cache?
#'       if (force || is.null(js)) {
#'         js <<- readLines(url, warn = FALSE)
#'       }
#'       c('<script type="text/javascript">', js)
#'     } else {
#'       sprintf('<script type="text/javascript" src="%s">', url)
#'     }, '</script>')
#'     
#'     paste(html, collapse = "\n")
#'   }
#' })
#' 
#' 
#' .requiresMathJax <- function(html) {
#'   regs <- c("\\\\\\(([\\s\\S]+?)\\\\\\)", "\\\\\\[([\\s\\S]+?)\\\\\\]")
#'   for (i in regs) if (any(grepl(i, html, perl = TRUE))) 
#'     return(TRUE)
#'   FALSE
#' }
#' 
#' .requiresHighlighting <- function(html) {
#'   any(grepl("<pre><code class=\"r\"", html))
#' }
#' 
#' option2char <- function(x) {
#'   if (!is.character(x)) 
#'     return("")
#'   paste(if (length(x) == 1 && file.exists(x)) 
#'     readLines(x)
#'     else x, collapse = "\n")
#' }
#' 
#' .b64EncodeFile <- function(inFile) {
#'   fileSize <- file.info(inFile)$size
#'   if (fileSize <= 0) {
#'     warning(inFile, "is empty!")
#'     return(inFile)
#'   }
#'   paste("data:", mime::guess_type(inFile), ";base64,", .Call(rmd_b64encode_data, 
#'                                                              readBin(inFile, "raw", n = fileSize)), sep = "")
#' }
#' 
#' #' @importFrom utils URLdecode
#' .b64EncodeImages <- function(html) {
#'   if (length(html) == 0) 
#'     return(html)
#'   reg <- "<\\s*[Ii][Mm][Gg]\\s+[Ss][Rr][Cc]\\s*=\\s*[\"']([^\"']+)[\"']"
#'   m <- gregexpr(reg, html, perl = TRUE)
#'   if (m[[1]][1] != -1) {
#'     .b64EncodeImgSrc <- function(imgSrc) {
#'       src <- sub(reg, "\\1", imgSrc)
#'       if (grepl("^data:.+;base64,.+", src)) 
#'         return(imgSrc)
#'       inFile <- URLdecode(src)
#'       if (length(inFile) && file.exists(inFile)) 
#'         imgSrc <- sub(src, .b64EncodeFile(inFile), imgSrc, 
#'                       fixed = TRUE)
#'       imgSrc
#'     }
#'     regmatches(html, m) <- list(unlist(lapply(regmatches(html, 
#'                                                          m)[[1]], .b64EncodeImgSrc)))
#'   }
#'   html
#' }