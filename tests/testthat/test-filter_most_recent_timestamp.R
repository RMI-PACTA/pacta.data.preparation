test_that("with bad `data` errors with informative message", {
  data <- dplyr::tibble(
    sector = "aviation",
    bad = "2021Q4"
  )

  expect_error(
    filter_most_recent_timestamp("bad", "2020Q4"),
    "data.frame.*not.*TRUE",
  )

  expect_error(
    filter_most_recent_timestamp(data, FALSE),
    "character.*not.*TRUE",
  )
})

test_that("with missing crucial columns errors with informative message", {
  bad_data <- dplyr::tibble(
    sector = "aviation",
    bad = "2021Q4"
  )

  expect_error(
    filter_most_recent_timestamp(bad_data, "2020Q4"),
    "names.*data.*not.*TRUE",
  )
})

test_that("for given input, outputs expected values", {
  pacta_financial_timestamp <- "2021Q4"

  data <- dplyr::tribble(
    ~sector,      ~asset_level_timestamp,
    "aviation",   "2021Q4",
    "power",      "2021Q1",
    "power",      "2021Q2",
    "automotive", "2020Q4",
    "automotive", "2022Q1"
  )

  out <- filter_most_recent_timestamp(data, pacta_financial_timestamp, sector) %>%
    split(.$sector)

  expect_equal(out$automotive$asset_level_timestamp, "2020Q4")
  expect_equal(out$aviation$asset_level_timestamp, "2021Q4")
  expect_equal(out$power$asset_level_timestamp, "2021Q2")
})
