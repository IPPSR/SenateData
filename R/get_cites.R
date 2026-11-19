#' Get citations for SenateData variables
#'
#' `get_cites()` collects the citations for the SenateData variables you use.
#' Give it variable names or a data frame (for example, the output of
#' [get_senate_data()]); it looks up every variable in the codebook and returns
#' each distinct citation once, so variables that share a source are not cited
#' twice. The citation for SenateData itself comes first.
#'
#' @param x A character vector of variable names, or a data frame whose column
#'   names are SenateData variables. Identifier columns (names, `st`,
#'   `bioguide`, `icpsr`, `year`, `congress_number`, and so on) are skipped.
#' @param format Either `"plaintext"` (default) or `"bibtex"`.
#' @param file Default is `NULL`. A file path (for example `"refs.bib"`). If
#'   given, the citations are also written to that file.
#' @param include_senatedata Default is `TRUE`. Whether to include the citation
#'   for SenateData itself.
#'
#' @return A character vector of citations with class `senatedata_cites`,
#'   which prints one citation per paragraph. Returned invisibly when `file` is
#'   given.
#'
#' @details Variables without a codebook entry are reported in a warning. In
#'   `"bibtex"` format, variables whose codebook entry has no BibTeX citation
#'   (or has something other than a BibTeX entry, such as a bare URL) are also
#'   reported, and entries that repeat a BibTeX key already returned are
#'   dropped so the result can be used as a `.bib` file.
#'
#' @seealso [get_var_info()] to see which citation belongs to which variable.
#'
#' @export
#'
#' @examples
#' # citations for named variables
#' get_cites(c("lcv_score", "dime_recipient.cfscore"))
#'
#' # citations for everything in a subset, as BibTeX
#' env <- get_senate_data(related_to = "environment")
#' get_cites(env, format = "bibtex")
#'
#' # write a .bib file
#' \dontrun{
#' get_cites(env, format = "bibtex", file = "senatedata_refs.bib")
#' }
get_cites <- function(x, format = c("plaintext", "bibtex"), file = NULL,
                      include_senatedata = TRUE) {

  format <- match.arg(format)

  vars <- if (is.data.frame(x)) {
    names(x)
  } else if (is.character(x)) {
    x
  } else {
    stop("`x` must be a character vector of variable names or a data frame.",
         call. = FALSE)
  }
  vars <- unique(setdiff(vars, .id_vars))

  cb <- .codebook()
  cb <- cb[cb$variable %in% vars, , drop = FALSE]
  cb <- cb[match(intersect(vars, cb$variable), cb$variable), , drop = FALSE]  # keep the user's order

  missing <- setdiff(vars, cb$variable)
  if (length(missing)) {
    warning("No codebook entry, so no citation, for: ",
            paste(missing, collapse = ", "), call. = FALSE)
  }

  base <- if (format == "plaintext") "plaintext_cite" else "bibtex_cite"
  cols <- intersect(c(base, paste0(base, 2:5)), names(cb))

  # one row per variable, citations in order (cite, cite2, ..., cite5)
  m <- as.matrix(as.data.frame(lapply(cb[cols], as.character), stringsAsFactors = FALSE))
  m[] <- .clean_cite(m)
  if (format == "bibtex") m[!is.na(m) & !grepl("^@", m)] <- NA  # e.g. a bare URL is not BibTeX
  has_cite <- rowSums(!is.na(m)) > 0
  if (format == "bibtex" && any(!has_cite)) {
    warning("No BibTeX citation in the codebook for: ",
            paste(cb$variable[!has_cite], collapse = ", "),
            ". Use format = \"plaintext\" for these.", call. = FALSE)
  }

  cites <- as.vector(t(m))
  cites <- unique(cites[!is.na(cites)])

  if (format == "bibtex" && length(cites)) {
    keys <- sub("^\\s*@\\w+\\s*\\{\\s*([^,[:space:]]+).*$", "\\1", cites)
    cites <- cites[!duplicated(keys)]
  }

  if (include_senatedata) {
    cites <- c(.senatedata_cite(format), cites)
  }

  out <- structure(cites, class = c("senatedata_cites", "character"), format = format)

  if (!is.null(file)) {
    writeLines(unclass(out), file, sep = "\n\n")
    message("Wrote ", length(out), " citation(s) to ", file)
    return(invisible(out))
  }

  out
}

#' @export
print.senatedata_cites <- function(x, ...) {
  if (length(x) == 0) {
    cat("<no citations>\n")
  } else {
    cat(unclass(x), sep = "\n\n")
    cat("\n")
  }
  invisible(x)
}

# Tidy codebook citation strings: normalize Windows line endings, drop quote
# marks wrapped around the whole entry, and turn empty strings into NA.
.clean_cite <- function(x) {
  x <- trimws(gsub("\r\n?", "\n", x))
  x <- trimws(gsub('^"+|"+$', "", x))
  x[!is.na(x) & !nzchar(x)] <- NA
  x
}

# Citation for SenateData itself (matches README.md and inst/CITATION).
.senatedata_cite <- function(format = c("plaintext", "bibtex")) {
  format <- match.arg(format)
  if (format == "plaintext") {
    "Yoel, Benjamin, and Iliya Liampert. 2026. SenateData Project. V.1.2. IPPSR."
  } else {
    paste0(
      "@misc{yoel_liampert_senatedata,\n",
      "  author       = {Yoel, Benjamin and Liampert, Iliya},\n",
      "  title        = {{SenateData} Project},\n",
      "  year         = {2026},\n",
      "  note         = {Version 1.2},\n",
      "  publisher    = {Institute for Public Policy and Social Research (IPPSR), Michigan State University},\n",
      "  howpublished = {\\url{https://github.com/IPPSR/SenateData}}\n",
      "}"
    )
  }
}
