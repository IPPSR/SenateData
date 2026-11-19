# Checks on the bundled data: senate and codebook.
#
# The "known gaps" tests record codebook problems that existed when the tests
# were written (Nov 2026). They pass as long as things do not get worse, and
# fail if a new gap appears. When a gap is fixed in the codebook xlsx files,
# tighten the matching number or list below.

id_vars <- SenateData:::.id_vars
cb_all  <- SenateData::codebook
cb      <- cb_all[!is.na(cb_all$variable) & nzchar(cb_all$variable), ]
sen     <- SenateData::senate

test_that("senate has the identifier columns and one row per senator-state-year", {
  expect_s3_class(sen, "data.frame")
  expect_true(all(id_vars %in% names(sen)))
  expect_false(anyNA(sen$bioguide))
  expect_equal(anyDuplicated(sen[c("bioguide", "st", "year")]), 0)
  expect_true(all(sen$st %in% datasets::state.abb))
})

test_that("codebook has the template columns", {
  cols <- c("variable", "years", "short_desc", "long_desc", "sources", "category",
            "plaintext_cite", "bibtex_cite",
            paste0("plaintext_cite", 2:5), paste0("bibtex_cite", 2:5))
  expect_true(all(cols %in% names(cb_all)))
})

test_that("codebook has one row per variable, all of them in senate", {
  expect_equal(sum(duplicated(cb$variable)), 0)
  expect_equal(setdiff(cb$variable, names(sen)), character(0))
})

test_that("every documented variable has a plain-text citation", {
  no_cite <- cb$variable[is.na(cb$plaintext_cite) | !nzchar(trimws(cb$plaintext_cite))]
  expect_equal(no_cite, character(0))
})

test_that("known gap: data columns without a codebook entry do not grow", {
  known <- c("congress", "RankInParty2", "seniority_cg", "party_cg", "FIRSTCON_clean")
  undocumented <- setdiff(names(sen), c(cb$variable, id_vars))
  expect_true(all(undocumented %in% known),
              info = paste("New undocumented:", paste(setdiff(undocumented, known), collapse = ", ")))
})

test_that("known gap: blank codebook rows do not grow", {
  expect_lte(nrow(cb_all) - nrow(cb), 5)
})

test_that("known gap: variables without a BibTeX citation do not grow", {
  expect_lte(sum(is.na(cb$bibtex_cite) | !nzchar(trimws(cb$bibtex_cite))), 88)
})

test_that("known gap: bibtex_cite values that are not BibTeX do not grow", {
  # gender, birthday (a URL) and first_congyear, memberswitch ("We created this variable")
  b <- SenateData:::.clean_cite(cb$bibtex_cite)
  not_bib <- cb$variable[!is.na(b) & !grepl("^@", b)]
  known <- c("gender", "birthday", "first_congyear", "memberswitch")
  expect_true(all(not_bib %in% known),
              info = paste("New non-BibTeX entries:", paste(setdiff(not_bib, known), collapse = ", ")))
})

test_that("known gap: BibTeX entries wrapped in quote marks do not grow", {
  # the committee (com_*) and education (enroll_age, drop_age, ...) entries are
  # stored as "\"@article{...}\""; get_cites() strips the quotes
  b <- unlist(cb[grep("^bibtex_cite", names(cb))], use.names = FALSE)
  expect_lte(sum(grepl('^\\s*"', b)), 200)
})

test_that("known gap: BibTeX keys shared by different entries do not grow", {
  b <- unlist(cb[grep("^bibtex_cite", names(cb))], use.names = FALSE)
  b <- unique(SenateData:::.clean_cite(b[!is.na(b)]))
  b <- b[!is.na(b) & grepl("^@", b)]
  keys <- sub("^\\s*@\\w+\\s*\\{\\s*([^,[:space:]]+).*$", "\\1", b)
  shared <- unique(keys[duplicated(keys)])
  expect_true(all(shared %in% "beer2018extending"),
              info = paste("New shared keys:", paste(setdiff(shared, "beer2018extending"), collapse = ", ")))
})
