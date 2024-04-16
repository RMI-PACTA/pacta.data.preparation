test_that("returns a data frame with expected columns and no `NA`s", {
  input <- data.frame(
    factset_id = c("123-AB", "456-CD"),
    company_id = c("Power", "Oil&Gas")
  )

  output <- prepare_factset_entity_id__ar_company_id(input)

  expect_s3_class(output, class = "data.frame")
  expect_identical(names(output), c("factset_entity_id", "ar_company_id"))
  expect_true(all(!is.na(output$factset_id)))
  expect_true(all(!is.na(output$company_id)))
})

test_that("returns error if input is not a data frame", {
  expect_error(prepare_factset_entity_id__ar_company_id("xxx"))
})

test_that("returns error if input does not have the necessary columns", {
  expect_error(prepare_factset_entity_id__ar_company_id(data.frame(x = 1L)))
})

test_that("returns error if output has duplicated `factset_id`s", {
  input <- data.frame(
    factset_id = c("123-AB", "123-AB"),
    company_id = c("Power", "Oil&Gas")
  )
  expect_error(prepare_factset_entity_id__ar_company_id(input))
})
