# Internal helpers shared by get_senate_data(), get_var_info(), and get_cites().

# Columns that identify a senator-year. They are always returned by
# get_senate_data(related_to = ...) and are never cited.
.id_vars <- c("firstname", "lastname", "st", "bioguide", "icpsr", "govtrack",
              "start", "end", "year", "congress_number",
              "wikipedia", "wikidata", "google_entity_id", "house_history")

# Fetch a bundled dataset. getExportedValue() also finds lazy-loaded data, so
# this works whether or not the user called library(SenateData).
.sd_get <- function(name) {
  getExportedValue("SenateData", name)
}

# The codebook without blank rows.
.codebook <- function() {
  cb <- .sd_get("codebook")
  cb[!is.na(cb$variable) & nzchar(cb$variable), , drop = FALSE]
}

# Codebook rows whose name, descriptions, source, or category contain any of
# `terms` (plain-text match, not case sensitive).
.search_codebook <- function(terms, cb = .codebook()) {
  if (!is.character(terms)) {
    stop("`related_to` must be a character vector.", call. = FALSE)
  }
  terms <- tolower(terms[!is.na(terms) & nzchar(terms)])
  fields <- intersect(c("variable", "short_desc", "long_desc", "sources", "category"),
                      names(cb))
  txt <- tolower(do.call(paste, c(lapply(cb[fields], function(x) ifelse(is.na(x), "", x)),
                                  sep = " | ")))
  hit <- Reduce(`|`, lapply(terms, function(t) grepl(t, txt, fixed = TRUE)),
                rep(FALSE, nrow(cb)))
  cb[hit, , drop = FALSE]
}

# Convert state names or abbreviations to postal abbreviations.
.state_abb <- function(states) {
  s <- trimws(states)
  abb <- toupper(s)
  out <- ifelse(abb %in% datasets::state.abb, abb,
                datasets::state.abb[match(tolower(s), tolower(datasets::state.name))])
  bad <- states[is.na(out)]
  if (length(bad)) {
    warning("Unrecognized state(s) ignored: ", paste(bad, collapse = ", "), call. = FALSE)
  }
  unique(out[!is.na(out)])
}
