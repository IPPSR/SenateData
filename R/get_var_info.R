#' Get information about SenateData variables
#'
#' `get_var_info()` looks up variables in the SenateData codebook. For each
#' variable it returns the years the variable is observed, a short and long
#' description, its source, its category, and its citations in plain text and
#' BibTeX. With no arguments it returns the whole codebook.
#'
#' @param var_names Default is `NULL`. A character vector of variable names.
#'   Matching is partial unless `exact = TRUE`, so `"lcv"` returns every
#'   variable whose name contains "lcv".
#' @param related_to Default is `NULL`. A character vector of search terms,
#'   matched against each variable's name, short and long description, source,
#'   and category (plain-text match, not case sensitive).
#' @param exact Default is `FALSE`. If `TRUE`, `var_names` must match variable
#'   names exactly.
#'
#' @return A tibble of codebook rows with columns `variable`, `years`,
#'   `short_desc`, `long_desc`, `sources`, `category`, and the citation columns
#'   `plaintext_cite`, `bibtex_cite`, and `plaintext_cite2`-`5` /
#'   `bibtex_cite2`-`5`. When both `var_names` and `related_to` are given, rows
#'   must match both.
#'
#' @seealso [get_cites()] to collect the citations for a set of variables.
#'
#' @export
#'
#' @examples
#' # the whole codebook
#' get_var_info()
#'
#' # every variable whose name contains "dime_"
#' get_var_info(var_names = "dime_")
#'
#' # one variable, exactly
#' get_var_info(var_names = "lcv_score", exact = TRUE)
#'
#' # variables related to population or poverty
#' get_var_info(related_to = c("population", "poverty"))
get_var_info <- function(var_names = NULL, related_to = NULL, exact = FALSE) {

  cb <- .codebook()

  if (!is.null(var_names)) {
    if (!is.character(var_names)) {
      stop("`var_names` must be a character vector.", call. = FALSE)
    }
    keep <- if (exact) {
      cb$variable %in% var_names
    } else {
      Reduce(`|`, lapply(tolower(var_names),
                         function(v) grepl(v, tolower(cb$variable), fixed = TRUE)),
             rep(FALSE, nrow(cb)))
    }
    cb <- cb[keep, , drop = FALSE]
  }

  if (!is.null(related_to) && any(nzchar(related_to))) {
    cb <- .search_codebook(related_to, cb)
  }

  if (nrow(cb) == 0) {
    warning("Your request returned no variables.", call. = FALSE)
  }

  tibble::as_tibble(cb)
}
