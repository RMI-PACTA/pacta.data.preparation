expand_by_scenario_geography <-
  function(data, scen_geos, scenario_regions, .default = "Global", .iso2c = "ald_location") {
    stopifnot(.iso2c %in% names(data))
    stopifnot(all(scen_geos %in% scenario_regions$scenario_geography))

    dict <-
      scenario_regions %>%
      filter(.data$scenario_geography %in% .env$scen_geos) %>%
      select("country_iso", "scenario_geography") %>%
      distinct()

    data %>%
      left_join(dict, by = stats::setNames("country_iso", .iso2c)) %>%
      mutate(scenario_geography = dplyr::case_when(
        is.na(.data$scenario_geography) ~ .default,
        .data$scenario_geography == "" ~ .default,
        TRUE ~ .data$scenario_geography
      ))
  }


expand_by_country_of_domicile <-
  function(data, index_regions, .default = "GlobalMarket", .iso2c = "country_of_domicile") {
    stopifnot(.iso2c %in% names(data))

    dict <- index_regions %>%
      select("equity_market", "country_iso") %>%
      distinct()

    data %>%
      left_join(dict, by = stats::setNames("country_iso", .iso2c)) %>%
      mutate(equity_market = dplyr::case_when(
        is.na(.data$equity_market) ~ .env$.default,
        .data$equity_market == "" ~ .env$.default,
        TRUE ~ .data$equity_market
      ))
  }
