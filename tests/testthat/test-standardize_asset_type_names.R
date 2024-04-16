test_that("returns a data frame with proper asset type names", {
  input <- data.frame(
    issue_type_code = "XXX",
    asset_type = c(
      "Listed Equity",
      "Corporate Bond",
      "Fund",
      "Other",
      "XXX"
    )
  )

  proper_asset_type_names <- c(
    "Equity",
    "Bonds",
    "Funds",
    "Others"
  )

  output <- standardize_asset_type_names(input)

  expect_s3_class(output, class = "data.frame")
  expect_in(output$asset_type, proper_asset_type_names)
})
