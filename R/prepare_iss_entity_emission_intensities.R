#' Prepare a `iss_entity_emission_intensities` object
#'
#' @param iss_company_emissions A data frame containing `iss_company_emissions`
#'   data
#' @param factset_financial_data A data frame containing
#'   `factset_financial_data` data
#' @param factset_entity_info A data frame containing `factset_entity_info` data
#' @param factset_entity_financing_data A data frame containing
#'   `factset_entity_financing_data` data
#' @param currencies A data frame containing currency exchange rate data
#'
#' @return A data frame containing the prepared
#'   `iss_entity_emission_intensities` object
#'
#' @export

prepare_iss_entity_emission_intensities <- function(iss_company_emissions,
                                                    factset_financial_data,
                                                    factset_entity_info,
                                                    factset_entity_financing_data,
                                                    currencies) {
  factset_financial_data <-
    factset_financial_data %>%
    dplyr::select("factset_entity_id", "issue_type", "adj_price", "adj_shares_outstanding") %>%
    dplyr::filter(!is.na(.data[["factset_entity_id"]]) & !is.na(.data[["adj_shares_outstanding"]])) %>%
    dplyr::filter(.data[["issue_type"]] %in% c("EQ", "PF", "CP")) %>%
    dplyr::summarize(
      mkt_val = sum(.data[["adj_price"]] * .data[["adj_shares_outstanding"]], na.rm = TRUE),
      .by = "factset_entity_id"
    )

  factset_entity_info <-
    factset_entity_info %>%
    dplyr::select("factset_entity_id", "iso_country") %>%
    dplyr::left_join(factset_financial_data, by = "factset_entity_id")

  factset_entity_financing_data %>%
    dplyr::left_join(factset_entity_info, by = "factset_entity_id") %>%
    dplyr::filter(
      countrycode::countrycode(.data[["iso_country"]], "iso2c", "iso4217c") == .data[["currency"]]
    ) %>%
    dplyr::left_join(currencies, by = "currency") %>%
    dplyr::mutate(
      ff_mkt_val = if_else(!is.na(.data[["mkt_val"]]), .data[["mkt_val"]], NA_real_),
      ff_debt = if_else(!is.na(.data[["ff_debt"]]), .data[["ff_debt"]] * .data[["exchange_rate"]], NA_real_),
      currency = "USD"
    ) %>%
    dplyr::summarise(
      ff_mkt_val = mean(.data[["ff_mkt_val"]], na.rm = TRUE),
      ff_debt = mean(.data[["ff_debt"]], na.rm = TRUE),
      .by = "factset_entity_id"
    ) %>%
    dplyr::inner_join(iss_company_emissions, by = "factset_entity_id") %>%
    dplyr::transmute(
      factset_entity_id = .data[["factset_entity_id"]],
      emission_intensity_per_mkt_val = if_else(
        .data[["ff_mkt_val"]] == 0,
        NA_real_,
        .data[["icc_total_emissions"]] / .data[["ff_mkt_val"]]
      ),
      emission_intensity_per_debt = if_else(
        .data[["ff_debt"]] == 0,
        NA_real_,
        .data[["icc_total_emissions"]] / .data[["ff_debt"]]
      ),
      ff_mkt_val = .data[["ff_mkt_val"]],
      ff_debt = .data[["ff_debt"]],
      units = paste0(.data[["icc_total_emissions_units"]], " / ", "$ USD")
    ) %>%
    dplyr::select(-c("ff_mkt_val", "ff_debt"))
}
