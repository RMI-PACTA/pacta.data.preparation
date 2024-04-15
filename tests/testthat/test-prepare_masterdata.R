test_that('masterdata with Power technologies both w/ and wo/ "Cap" are formatted as expected (#285)', {

  out <- fake_masterdata(
    company_id = c(1, 2, 3),
    sector = c("Power", "Power", "Coal"), # test several sectors
    technology = c("Coal", "CoalCap", "Coal") # test input both w/ and wo/ "Cap"
  ) %>%
    prepare_masterdata(
      ar_company_id__country_of_domicile = fake_ar_company_id__country_of_domicile(),
      pacta_financial_timestamp = "2021Q4",
      zero_emission_factor_techs = "RenewablesCap"
    )

  expect_equal(out$technology, c("CoalCap", "CoalCap", "Coal"))
})
