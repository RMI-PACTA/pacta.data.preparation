test_that("returns a numeric value", {
  expect_type(calc_shares_all_classes(1, "EQ"), "double")
})


test_that("returns a single value", {
  shares_outstanding <- c(NA, 1:5, NA)
  asset_type_id <- "EQ"
  result <- calc_shares_all_classes(shares_outstanding, asset_type_id)
  expect_length(result, 1L)
})


test_that("returns expected value", {
  shares_outstanding <- c(1, 1, 1, 1)
  asset_type_id <- c("CP", "EQ", "PF", "XXX")
  expected_result <- 3

  result <- calc_shares_all_classes(shares_outstanding, asset_type_id)
  expect_equal(result, expected_result)


  shares_outstanding <- c(1, 1, 1, 1)
  asset_type_id <- c("CP", "EQ", "PF", NA)
  expected_result <- 3

  result <- calc_shares_all_classes(shares_outstanding, asset_type_id)
  expect_equal(result, expected_result)


  shares_outstanding <- c(1, 1, NA, 1)
  asset_type_id <- c("CP", "EQ", "PF", "XXX")
  expected_result <- 2

  result <- calc_shares_all_classes(shares_outstanding, asset_type_id)
  expect_equal(result, expected_result)


  shares_outstanding <- c(1, 1, 1, 1)
  asset_type_id <- c("CP", "EQ", "PF", "XXX")
  include_types <- c("CP", "EQ", "PF", "XXX")
  expected_result <- 4

  result <- calc_shares_all_classes(shares_outstanding, asset_type_id, include_types)
  expect_equal(result, expected_result)


  shares_outstanding <- c(1, 1, 1, 1)
  asset_type_id <- c("CP", "EQ", "PF", "XXX")
  include_types <- c("CP")
  expected_result <- 1

  result <- calc_shares_all_classes(shares_outstanding, asset_type_id, include_types)
  expect_equal(result, expected_result)
})


test_that("returns expected values when used in dplyr chain", {
  shares_outstanding <- c(1, 1, 1, 1)
  asset_type_id <- c("CP", "EQ", "PF", "XXX")
  expected_result <- c(3, 3, 3, 3)

  result <-
    data.frame(
      shares_outstanding = shares_outstanding,
      asset_type_id = asset_type_id
    ) %>%
    mutate(shares_all_classes = calc_shares_all_classes(shares_outstanding, asset_type_id)) %>%
    dplyr::pull(shares_all_classes)

  expect_equal(result, expected_result)
})


test_that("returns expected values when used in dplyr chain by an entity ID", {
  shares_outstanding <- c(1, 1, 1, 1, 2, 2, 2, 2)
  asset_type_id <- c("CP", "EQ", "PF", "XXX", "CP", "EQ", "PF", "XXX")
  entity_id <- c("A", "A", "A", "A", "B", "B", "B", "B")
  expected_result <- c(3, 3, 3, 3, 6, 6, 6, 6)

  result <-
    data.frame(
      shares_outstanding = shares_outstanding,
      asset_type_id = asset_type_id,
      entity_id = entity_id
    ) %>%
    mutate(
      shares_all_classes = calc_shares_all_classes(shares_outstanding, asset_type_id),
      .by = "entity_id"
    ) %>%
    dplyr::pull(shares_all_classes)

  expect_equal(result, expected_result)
})
