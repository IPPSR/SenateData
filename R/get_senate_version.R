#' Get your local version of SenateData
#'
#' \code{get_senate_version} prints the current version of SenateData available through the package. It takes no arguments.
#'
#' @name get_senate_version
#' 
#' @importFrom utils read.csv
#' 
#' @return No return value, called for side effects.
#'
#' @export
#'

get_senate_version <- function() {
  vers <- tryCatch(
    suppressWarnings(read.csv(url("https://ippsr.msu.edu/senatehelper"))),
    error = function(e) NA
  )
  
  if (is.na(vers)) {
    message(“SenateData version: not available")
  } else {
    message("You are using SenateData version: ", vers$version)
  }
}