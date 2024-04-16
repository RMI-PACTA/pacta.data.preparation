test_that("returns appropriate length integer vector", {
  market_share_target_reference_year <- 2023
  time_horizon <- 5
  output <- determine_relevant_years(market_share_target_reference_year, time_horizon)
  expect_vector(output, ptype = integer())
  expect_length(output, time_horizon + 1)
  expect_contains(output, market_share_target_reference_year)
  expect_length(output, length(unique(output)))
})
