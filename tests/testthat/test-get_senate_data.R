id_vars <- SenateData:::.id_vars
sen     <- SenateData::senate

test_that("no arguments returns the full dataset as a tibble", {
  out <- get_senate_data()
  expect_s3_class(out, "tbl_df")
  expect_equal(dim(out), dim(sen))
})

test_that("states accepts full names and abbreviations in any case", {
  by_name <- get_senate_data(states = "Michigan", years = 2008)
  expect_equal(sort(by_name$lastname), c("Levin", "Stabenow"))
  expect_equal(get_senate_data(states = "MI", years = 2008), by_name)
  expect_equal(get_senate_data(states = "mi", years = 2008), by_name)
  expect_equal(get_senate_data(states = " michigan ", years = 2008), by_name)
})

test_that("states can mix several states", {
  out <- get_senate_data(states = c("Michigan", "OH"), years = 2008)
  expect_setequal(unique(out$st), c("MI", "OH"))
})

test_that("unknown states are dropped with a warning", {
  expect_warning(out <- get_senate_data(states = c("MI", "Narnia"), years = 2008), "Narnia")
  expect_equal(unique(out$st), "MI")
})

test_that("states must be character", {
  expect_error(get_senate_data(states = 26), "character")
})

test_that("years takes a single year or a range in either order", {
  expect_true(all(get_senate_data(years = 2000)$year == 2000))
  r1 <- get_senate_data(years = c(2000, 2008))
  expect_true(all(r1$year >= 2000 & r1$year <= 2008))
  expect_setequal(unique(r1$year), 2000:2008)
  expect_equal(get_senate_data(years = c(2008, 2000)), r1)
})

test_that("invalid years give an error", {
  expect_error(get_senate_data(years = "2000"), "years")
  expect_error(get_senate_data(years = c(2000, 2004, 2008)), "years")
  expect_error(get_senate_data(years = NA_real_), "years")
})

test_that("no matching rows gives a warning", {
  expect_warning(out <- get_senate_data(years = 1700), "No rows")
  expect_equal(nrow(out), 0)
})

test_that("related_to keeps matching variables plus identifier columns", {
  out <- get_senate_data(related_to = "environment")
  expect_true(all(id_vars %in% names(out)))
  expect_true("lcv_score" %in% names(out))
  expect_lt(ncol(out), ncol(sen))
  expect_equal(nrow(out), nrow(sen))           # selects columns, not rows
})

test_that("related_to is not case sensitive and takes several terms", {
  expect_equal(names(get_senate_data(related_to = "ENVIRONMENT")),
               names(get_senate_data(related_to = "environment")))
  both <- names(get_senate_data(related_to = c("League of Conservation", "Bonica")))
  expect_true("lcv_score" %in% both)
  expect_true(any(grepl("^dime_", both)))
})

test_that("related_to keeps the data's column order", {
  out <- get_senate_data(related_to = "dime_")
  expect_equal(names(out), names(sen)[names(sen) %in% names(out)])
})

test_that("empty related_to returns every column", {
  expect_equal(ncol(get_senate_data(related_to = "")), ncol(sen))
})

test_that("related_to with no match warns and returns identifier columns only", {
  expect_warning(out <- get_senate_data(related_to = "zzqqxx_no_such_term"), "No variables")
  expect_setequal(names(out), intersect(id_vars, names(sen)))
})

test_that("all three filters combine", {
  out <- get_senate_data(states = "MI", related_to = "lcv", years = c(2005, 2010))
  expect_true(all(out$st == "MI" & out$year >= 2005 & out$year <= 2010))
  expect_true("lcv_score" %in% names(out))
})
