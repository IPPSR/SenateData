dime_vars <- grep("^dime_", names(SenateData::senate), value = TRUE)

bib_keys <- function(x) sub("^\\s*@\\w+\\s*\\{\\s*([^,[:space:]]+).*$", "\\1", unclass(x))

test_that("returns the SenateData citation first, then the variable's source", {
  out <- get_cites("lcv_score")
  expect_s3_class(out, "senatedata_cites")
  expect_length(out, 2)
  expect_match(out[1], "Yoel, Benjamin, and Iliya Liampert", fixed = TRUE)
  expect_match(out[2], "League of Conservation Voters", fixed = TRUE)
})

test_that("include_senatedata = FALSE drops the SenateData citation", {
  out <- get_cites("lcv_score", include_senatedata = FALSE)
  expect_length(out, 1)
  expect_match(out[1], "League of Conservation Voters", fixed = TRUE)
})

test_that("a data frame gives the same result as its column names", {
  df <- get_senate_data(related_to = "dime_", years = 2010)
  expect_equal(get_cites(df), get_cites(names(df)))
})

test_that("identifier columns are skipped without a warning", {
  expect_no_warning(out <- get_cites(c("st", "year", "bioguide", "icpsr", "lcv_score")))
  expect_equal(out, get_cites("lcv_score"))
})

test_that("shared sources are cited once", {
  out <- get_cites(dime_vars)
  expect_equal(anyDuplicated(unclass(out)), 0)
  expect_lt(length(out), length(dime_vars))
  expect_true(any(grepl("Database on Ideology, Money in Politics, and Elections", out, fixed = TRUE)))
})

test_that("additional citations (cite2-cite5) are included", {
  out <- get_cites("dime_recipient.cfscore", include_senatedata = FALSE)
  expect_length(out, 2)
  expect_true(any(grepl("Mapping the Ideological Marketplace", out, fixed = TRUE)))
})

test_that("undocumented variables are named in a warning", {
  expect_warning(out <- get_cites(c("lcv_score", "zzqqxx_no_such_var")), "zzqqxx_no_such_var")
  expect_equal(out, get_cites("lcv_score"))
})

test_that("BibTeX output is clean and has unique keys", {
  out <- suppressWarnings(get_cites(SenateData::senate, format = "bibtex"))
  expect_equal(attr(out, "format"), "bibtex")
  expect_true(all(grepl("^@\\w+\\s*\\{", out)))
  expect_false(any(grepl("\r", out, fixed = TRUE)))
  expect_equal(anyDuplicated(bib_keys(out)), 0)
  expect_equal(bib_keys(out)[1], "yoel_liampert_senatedata")
})

test_that("quote marks around BibTeX entries are removed", {
  com <- grep("^com_", SenateData:::.codebook()$variable, value = TRUE)
  skip_if(length(com) == 0, "no committee variables")
  out <- suppressWarnings(get_cites(com, format = "bibtex"))
  expect_false(any(grepl('^"|"$', out)))
})

test_that("a non-BibTeX value in bibtex_cite counts as missing BibTeX", {
  skip_if_not("gender" %in% SenateData:::.codebook()$variable)
  expect_warning(out <- get_cites("gender", format = "bibtex", include_senatedata = FALSE),
                 "No BibTeX citation.*gender")
  expect_length(out, 0)
})

test_that("variables without BibTeX are named in a warning", {
  cb <- SenateData:::.codebook()
  no_bib <- cb$variable[is.na(cb$bibtex_cite) | !nzchar(trimws(cb$bibtex_cite))]
  skip_if(length(no_bib) == 0, "every variable has BibTeX")
  expect_warning(get_cites(no_bib[1], format = "bibtex"), "No BibTeX citation")
})

test_that("file = writes the citations and returns them invisibly", {
  f <- tempfile(fileext = ".bib")
  on.exit(unlink(f))
  expect_message(expect_invisible(out <- get_cites(dime_vars, "bibtex", file = f)), "Wrote")
  txt <- paste(readLines(f), collapse = "\n")
  for (k in bib_keys(out)) expect_match(txt, k, fixed = TRUE)
})

test_that("print shows one citation per paragraph", {
  expect_output(print(get_cites("lcv_score")), "IPPSR\\.\n\nLeague of Conservation Voters")
  expect_output(print(get_cites(character(0), include_senatedata = FALSE)), "no citations")
})

test_that("bad input gives an error", {
  expect_error(get_cites(123), "character vector")
  expect_error(get_cites("lcv_score", format = "apa"))
})

test_that("SenateData's own citation matches inst/CITATION", {
  cit_file <- system.file("CITATION", package = "SenateData")
  skip_if(!nzchar(cit_file), "CITATION file not installed")
  cit <- utils::readCitationFile(cit_file)
  expect_equal(attr(unclass(cit)[[1]], "textVersion"), unclass(SenateData:::.senatedata_cite("plaintext")))
})
