test_that("for valid input, outputs as expected", {
  expect_equal(quarter_to_imf_timestamp(quarter = "2021Q1"), "2021-Q1")
  expect_equal(quarter_to_imf_timestamp(quarter = "2021Q2"), "2021-Q2")
  expect_equal(quarter_to_imf_timestamp(quarter = "2021Q3"), "2021-Q3")
  expect_equal(quarter_to_imf_timestamp(quarter = "2021Q4"), "2021-Q4")
  expect_equal(quarter_to_imf_timestamp(quarter = "2022Q4"), "2022-Q4")
})

test_that("for invalid input, errors as expected", {
  expect_error(quarter_to_imf_timestamp(quarter = "2021Q5"))
  expect_error(quarter_to_imf_timestamp(quarter = "2021-Q4"))
  expect_error(quarter_to_imf_timestamp(quarter = "2022-Q4"))
  expect_error(quarter_to_imf_timestamp(quarter = "XXX"))
})

test_that("for valid vector of inpouts, outputs as expected", {
  expect_equal(
    quarter_to_imf_timestamp(quarter = c("2021Q4", "2022Q4")),
    c("2021-Q4", "2022-Q4")
  )
})
