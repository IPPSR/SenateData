#' Load SenateData into the R environment
#'
#' `get_senate_data()` returns the SenateData panel (one row per senator-year),
#' either in full or subset by state, year, and topic.
#'
#' @param states Default is `NULL`, which returns all states. A character vector
#'   of state names (e.g. `"Michigan"`) or two-letter postal abbreviations
#'   (e.g. `"MI"`), in any letter case.
#' @param related_to Default is `NULL`, which returns all variables. A character
#'   vector of search terms. Keeps every variable whose name, short or long
#'   description, source, or category in the codebook contains any of the terms
#'   (plain-text match, not case sensitive), plus the identifier columns
#'   (names, `st`, `bioguide`, `icpsr`, `year`, `congress_number`, and so on).
#'   For example, `"tax"` matches variables described with "taxes" or "taxable".
#' @param years Default is `NULL`, which returns all years. A single year
#'   (e.g. `2001`) or a two-element vector giving the first and last years
#'   (e.g. `c(1989, 2001)`).
#'
#' @return A tibble with one row per senator-year that matches `states` and
#'   `years`, and the columns selected by `related_to`.
#'
#' @seealso [get_var_info()] to look up variables in the codebook, and
#'   [get_cites()] to get the citations for the variables you use.
#'
#' @export
#'
#' @examples
#' # the full dataset
#' senate_all <- get_senate_data()
#'
#' # Michigan's senators, 2000-2008
#' mi <- get_senate_data(states = "Michigan", years = c(2000, 2008))
#'
#' # environment-related variables in 2010, and their citations
#' env <- get_senate_data(related_to = "environment", years = 2010)
#' get_cites(env)
get_senate_data <- function(states = NULL, related_to = NULL, years = NULL) {

  df <- .sd_get("senate")

  # --- Filter by state ---
  if (!is.null(states)) {
    if (!is.character(states)) {
      stop("`states` must be a character vector of state names or abbreviations.",
           call. = FALSE)
    }
    df <- df[df$st %in% .state_abb(states), , drop = FALSE]
  }

  # --- Filter by years ---
  if (!is.null(years)) {
    if (!is.numeric(years) || !length(years) %in% 1:2 || anyNA(years)) {
      stop("`years` must be NULL, a single year, or a two-element numeric vector.",
           call. = FALSE)
    }
    yr <- range(years)
    df <- df[!is.na(df$year) & df$year >= yr[1] & df$year <= yr[2], , drop = FALSE]
  }

  # --- Select variables by related_to keyword(s) ---
  if (!is.null(related_to) && any(nzchar(related_to))) {
    hits <- .search_codebook(related_to)$variable
    if (length(hits) == 0) {
      warning("No variables match `related_to`; returning identifier columns only.",
              call. = FALSE)
    }
    df <- df[, names(df) %in% c(.id_vars, hits), drop = FALSE]
  }

  if (nrow(df) == 0) {
    warning("No rows match the requested states and years.", call. = FALSE)
  }

  tibble::as_tibble(df)
}
