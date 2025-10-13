#' Senate Data
#'
#' A dataset containing information related to the United States Senate,
#' including members, bills, and state-level variables.
#'
#' @format A list of data frames:
#' \describe{
#'   \item{members}{Information on Senate members. Columns may include:
#'     \code{member_id}, \code{name}, \code{party}, \code{state}, \code{chamber}, \code{start_date}, \code{end_date}}
#'   \item{bills}{Legislative bill information. Columns may include:
#'     \code{bill_id}, \code{title}, \code{introduced_date}, \code{sponsor}, \code{status}, \code{subjects}}
#'   \item{states}{State-level data associated with Senate representation.
#'     Columns may include: \code{state}, \code{population}, \code{region}, \code{median_income}, \code{partisan_lean}}
#'   \item{other}{Other Senate-related variables depending on the dataset contents.}
#' }
#'
#' @details
#' The dataset integrates multiple aspects of Senate data, including member
#' metadata, legislative information, and state-level attributes. Exact
#' column names and structures may vary depending on updates.
#'
#' @source Institute for Public Policy and Social Research (IPPSR)
"SenateData"
