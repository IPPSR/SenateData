cb_all <- SenateData::codebook
cb     <- cb_all[!is.na(cb_all$variable) & nzchar(cb_all$variable), ]

test_that("no arguments returns the codebook without blank rows", {
  out <- get_var_info()
  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), nrow(cb))
  expect_false(anyNA(out$variable))
})

test_that("var_names matches partially by default", {
  out <- get_var_info("dime_")
  expect_equal(nrow(out), sum(grepl("dime_", cb$variable, fixed = TRUE)))
  expect_true(all(grepl("dime_", out$variable, fixed = TRUE)))
})

test_that("var_names matching is not case sensitive", {
  expect_equal(get_var_info("LCV_SCORE")$variable, get_var_info("lcv_score")$variable)
})

test_that("exact = TRUE matches whole names only", {
  out <- get_var_info(c("lcv_score", "dime_cand.gender"), exact = TRUE)
  expect_setequal(out$variable, c("lcv_score", "dime_cand.gender"))
  expect_warning(none <- get_var_info("lcv", exact = TRUE), "no variables")
  expect_equal(nrow(none), 0)
})

test_that("related_to searches descriptions and sources", {
  out <- get_var_info(related_to = "League of Conservation Voters")
  expect_true("lcv_score" %in% out$variable)
})

test_that("var_names and related_to must both match", {
  out <- get_var_info(var_names = "dime_", related_to = "Voteview")
  expect_gt(nrow(out), 0)
  expect_true(all(grepl("dime_", out$variable, fixed = TRUE)))
  expect_lt(nrow(out), nrow(get_var_info("dime_")))
})

test_that("bad input gives an error, no match gives a warning", {
  expect_error(get_var_info(var_names = 1), "character")
  expect_error(get_var_info(related_to = 1), "character")
  expect_warning(get_var_info("zzqqxx_no_such_var"), "no variables")
})

test_that("every row carries its citation columns", {
  out <- get_var_info("lcv_score", exact = TRUE)
  expect_match(out$plaintext_cite, "League of Conservation Voters")
  expect_match(out$bibtex_cite, "^@")
})
