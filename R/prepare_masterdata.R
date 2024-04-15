#' Prepare the `masterdata_ownership_datastore` or `masterdata_debt_datastore`
#' output data frame from an import of a raw AR masterdata_* CSV
#'
#' @param data A dataframe containing the raw input of an AR masterdata_* CSV
#'   files
#' @param ar_company_id__country_of_domicile A data frame with two columns
#'   mapping `ar_company_id` to `country_of_domicile`
#' @param pacta_financial_timestamp A single element character vector specifying
#'   the timestamp in the PACTA format, e.g. "2021Q4"
#' @param zero_emission_factor_techs A character vector listing technologies
#'   that will have emission factors manually forced to 0
#'
#' @return A tibble properly prepared to be saved as the
#'   `masterdata_ownership_datastore.rds` or `masterdata_debt_datastore.rds`
#'   output file
#'
#' @export

prepare_masterdata <-
  function(data,
           ar_company_id__country_of_domicile,
           pacta_financial_timestamp,
           zero_emission_factor_techs) {
    data %>%
      filter_most_recent_timestamp(pacta_financial_timestamp, .data$sector) %>%
      pivot_longer(
        cols = dplyr::matches("^_20[0-9]{2}$"),
        names_to = "year",
        names_prefix = "_",
        names_transform = list(year = as.integer),
        values_to = "ald_production",
        values_ptypes = numeric(),
        values_drop_na = TRUE
      ) %>%
      mutate(sector = if_else(.data$sector == "LDV", "Automotive", .data$sector)) %>%
      mutate(
        technology = dplyr::case_when(
          .data$sector == "Coal" ~ "Coal",
          .data$sector == "HDV" ~ paste0(.data$technology, "_HDV"),
          .data$technology %in% c("ICE Gasoline", "ICE Diesel", "ICE E85+", "ICE Propane", "ICE CNG", "Hybrid No-Plug") ~ "ICE",
          .data$technology == "Electric" ~ "Electric",
          .data$technology == "Hybrid Plug-In" ~ "Hybrid",
          .data$technology == "Fuel Cell" ~ "FuelCell",
          .data$technology == "Oil and Condensate" ~ "Oil",
          .data$sector == "Power" ~ sub("([^(Cap)]$)", "\\1Cap", .data$technology),
          TRUE ~ .data$technology
        )
      ) %>%
      rename(dplyr::any_of(c(
        "emission_factor" = "emissions_factor",
        "emission_factor_unit" = "emissions_factor_unit"
      ))) %>%
      mutate(
        emission_factor = if_else(
          .data$technology %in% .env$zero_emission_factor_techs & .data$ald_production > 0,
          0,
          .data$emission_factor
        )
      ) %>%
      group_by(
        .data$company_id, .data$sector, .data$asset_country, .data$technology,
        .data$year, .data$unit, .data$emission_factor_unit
      ) %>%
      summarise(
        emission_factor = stats::weighted.mean(.data$emission_factor, .data$ald_production, na.rm = TRUE),
        ald_production = sum(.data$ald_production, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      transmute(
        id = as.character(.data$company_id),
        id_name = "ar_company_id",
        ald_sector = as.character(.data$sector),
        ald_location = as.character(.data$asset_country),
        technology = as.character(.data$technology),
        year = as.numeric(.data$year),
        ald_production = as.numeric(.data$ald_production),
        ald_production = if_else(.data$ald_production <= 0, 0, .data$ald_production),
        ald_production_unit = as.character(.data$unit),
        ald_emissions_factor = as.numeric(.data$emission_factor),
        ald_emissions_factor_unit = as.character(.data$emission_factor_unit)
      ) %>%
      left_join(ar_company_id__country_of_domicile, by = c(id = "ar_company_id"))
  }
