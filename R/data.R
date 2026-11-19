#' SenateData
#'
#' The SenateData panel: one row per senator-year, covering every U.S. senator
#' from 1789 to 2025, with over 1,100 variables on senators, their states, and
#' their behavior in office.
#'
#' Load it with [get_senate_data()], which can subset by state, year, and
#' topic, or use `SenateData::senate` directly.
#'
#' @format A tibble with 17,842 rows and 1,133 columns. Each row is a
#'   senator-year, identified by:
#' \describe{
#'   \item{firstname, lastname}{Senator's first and last name.}
#'   \item{st}{Two-letter postal abbreviation of the senator's state.}
#'   \item{year}{Calendar year.}
#'   \item{congress_number}{Number of the Congress in session that year.}
#'   \item{bioguide}{Congressional Biographical Directory ID (complete).}
#'   \item{icpsr}{ICPSR/Voteview member ID.}
#'   \item{govtrack, wikipedia, wikidata, google_entity_id, house_history}{Other
#'     member identifiers.}
#'   \item{start, end}{Start and end dates (class `Date`) of the senator's
#'     current term.}
#' }
#' The remaining columns are member- and state-level variables. Use
#' [get_var_info()] to see what each variable measures and [get_cites()] to
#' cite its source.
#'
#' @source Institute for Public Policy and Social Research (IPPSR), Michigan
#'   State University. Variable-level sources are listed in [codebook].
"senate"

#' SenateData codebook
#'
#' Documentation and citations for every variable in [senate]. This is the
#' table that [get_var_info()] searches and [get_cites()] draws citations
#' from.
#'
#' @format A tibble with one row per variable and 16 columns:
#' \describe{
#'   \item{variable}{Variable name, as it appears in [senate].}
#'   \item{years}{Years in which the variable is observed.}
#'   \item{short_desc}{Short description.}
#'   \item{long_desc}{Long description.}
#'   \item{sources}{Source of the data.}
#'   \item{category}{Topic category.}
#'   \item{plaintext_cite, bibtex_cite}{Main citation, in plain text and BibTeX.}
#'   \item{plaintext_cite2, bibtex_cite2, plaintext_cite3, bibtex_cite3,
#'     plaintext_cite4, bibtex_cite4, plaintext_cite5, bibtex_cite5}{Additional
#'     citations, where a variable has more than one.}
#' }
#'
#' @source Institute for Public Policy and Social Research (IPPSR), Michigan
#'   State University.
"codebook"
