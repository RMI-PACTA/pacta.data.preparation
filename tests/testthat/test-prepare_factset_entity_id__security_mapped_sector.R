test_that("returns a data frame with expected columns and no `NA`s", {
  input <- data.frame(
    factset_entity_id = c("123-AB", "456-CD"),
    security_mapped_sector = c("Power", "Oil&Gas")
  )

  output <- prepare_factset_entity_id__security_mapped_sector(input)

  expect_s3_class(output, class = "data.frame")
  expect_true(all(!is.na(output$factset_entity_id)))
  expect_true(all(!is.na(output$security_mapped_sector)))
})

test_that("returns error if input is not a data frame", {
  expect_error(prepare_factset_entity_id__security_mapped_sector("xxx"))
})

test_that("returns error if input does not have the necessary columns", {
  expect_error(prepare_factset_entity_id__security_mapped_sector(data.frame(x = 1L)))
})

test_that("returns error if output has duplicated `factset_entity_id`s", {
  input <- data.frame(
    factset_entity_id = c("123-AB", "123-AB"),
    security_mapped_sector = c("Power", "Oil&Gas")
  )
  expect_error(prepare_factset_entity_id__security_mapped_sector(input))
})
