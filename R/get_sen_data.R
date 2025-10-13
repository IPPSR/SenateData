#' Load SenateData into the R environment
#'
#' @param states Default is NULL. If left blank, returns all states. Takes a
#' string or vector of strings of state names.
#' @param related_to Default is "". Provide a string to search a variable's name,
#' short/long descriptions from the codebook, and its citation for non-exact matches
#' of a search term.
#' @param years Default is NULL. If left blank, returns all years. Input can be
#' a single year (e.g. 2001) or a two-year vector representing the first and last
#' years desired (e.g. \code{c(1989, 2001)}).
#'
#' @return A tibble containing SenateData. The tibble has columns corresponding
#' to variables in the dataset, and rows corresponding to observations that match
#' the filtering criteria specified by \code{states}, \code{related_to}, and \code{years}.
#' @export
#'
#' @examples
#' get_senate_data()
#' get_senate_data(states = "Michigan", years = c(2000, 2008))
#' get_senate_data(related_to = "tax")
get_senate_data <- function(states = NULL, related_to = "", years = NULL) {

  # --- Ensure dataset is available ---
  if (!exists("SenateData", envir = asNamespace("SenateData"))) {
    data("SenateData", package = "SenateData", envir = environment())
  }

  df <- get("SenateData", envir = asNamespace("SenateData"))

  # --- Filter by state ---
  if (!is.null(states)) {
    df <- df[df$state %in% states, ]
  }

  # --- Filter by related_to keyword ---
  if (nzchar(related_to)) {
    cols_to_search <- c("variable_name", "short_description", "long_description", "citation")
    found_cols <- intersect(cols_to_search, names(df))
    if (length(found_cols) > 0) {
      pattern <- tolower(related_to)
      keep <- apply(df[found_cols], 1, function(x) any(grepl(pattern, tolower(x))))
      df <- df[keep, ]
    }
  }

  # --- Filter by years ---
  if (!is.null(years)) {
    if (length(years) == 1) {
      df <- df[df$year == years, ]
    } else if (length(years) == 2) {
      df <- df[df$year >= years[1] & df$year <= years[2], ]
    } else {
      warning("`years` must be NULL, a single year, or a two-element numeric vector.")
    }
  }

  # --- Return as tibble ---
  if (requireNamespace("tibble", quietly = TRUE)) {
    df <- tibble::as_tibble(df)
  }

  return(df)
}

devtools::document()
devtools::load_all()
?get_senate_data

