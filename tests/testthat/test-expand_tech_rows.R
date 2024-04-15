data <- dplyr::tribble(
  ~id_name,        ~id,      ~equity_market,    ~scenario_geography, ~ald_sector, ~technology,     ~year, ~plan_emission_factor, ~plan_tech_prod, ~current_plan_row,
  "ar_company_id", "100067", "DevelopedMarket", "Global",            "Power",     "HydroCap",      2022,  0,                     41.9770564,      1,
  "ar_company_id", "100067", "DevelopedMarket", "Global",            "Power",     "HydroCap",      2023,  0,                     41.9770564,      1,
  "ar_company_id", "100067", "DevelopedMarket", "Global",            "Power",     "HydroCap",      2024,  0,                     41.9770564,      1,
  "ar_company_id", "100067", "DevelopedMarket", "Global",            "Power",     "RenewablesCap", 2022,  0,                     1.06002,         1
)

output <- expand_tech_rows(data)


test_that("for given input, returns a tibble", {
  expect_s3_class(output, "tbl_df")
})

test_that("for given input, expands the tibble to the proper number of rows", {
  expect_equal(nrow(output), 6L)
})

test_that("for given input, adds the expected years to the technology that was missing them", {
  renew_years <- output$year[output$technology == "RenewablesCap"]
  expect_equal(renew_years, c(2022, 2023, 2024))
})

test_that("for given input, adds `NA` to `plan_emission_factor` for the added years", {
  expect_equal(rev(output$plan_emission_factor)[1:2], c(NA_real_, NA_real_))
})

test_that("for given input, adds `0` to `plan_tech_prod` for the added years", {
  expect_equal(rev(output$plan_tech_prod)[1:2], c(0, 0))
})

test_that("for given input, adds `0` to `current_plan_row` for the added years", {
  expect_equal(rev(output$current_plan_row)[1:2], c(0, 0))
})
