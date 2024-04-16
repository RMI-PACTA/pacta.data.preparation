test_that("returns a data frame with expected columns and no `NA`s", {
  input <- data.frame(
    company_id = c("123-AB", "456-CD"),
    creditor_company_id = c("Power", "Oil&Gas")
  )

  output <- prepare_company_id__creditor_company_id(input)

  expect_s3_class(output, class = "data.frame")
  expect_identical(names(output), c("company_id", "creditor_company_id"))
  expect_true(all(!is.na(output$company_id)))
  expect_true(all(!is.na(output$creditor_company_id)))
})

test_that("returns error if input is not a data frame", {
  expect_error(prepare_company_id__creditor_company_id("xxx"))
})

test_that("returns error if input does not have the necessary columns", {
  expect_error(prepare_company_id__creditor_company_id(data.frame(x = 1L)))
})

test_that("returns error if output has duplicated `company_id`s", {
  input <- data.frame(
    company_id = c("123-AB", "123-AB"),
    creditor_company_id = c("Power", "Oil&Gas")
  )
  expect_error(prepare_company_id__creditor_company_id(input))
})
