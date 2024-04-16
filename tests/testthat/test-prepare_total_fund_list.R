test_that("returns a data frame with the proper column and no `NA`s", {
  input <- data.frame(
    factset_fund_id = c("XXX", NA, "ZZZ")
  )

  output <- prepare_total_fund_list(input)

  expect_s3_class(output, class = "data.frame")
  expect_true(all(!is.na(output$factset_fund_id)))
})

test_that("returns error if input is not a data frame", {
  expect_error(prepare_total_fund_list("xxx"))
})

test_that("returns error if input does not have `factset_fund_id` column", {
  expect_error(prepare_total_fund_list(data.frame(x = 1L)))
})
