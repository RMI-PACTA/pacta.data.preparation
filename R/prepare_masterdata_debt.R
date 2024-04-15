#' Prepare the `masterdata_debt_datastore` object from a raw masterdata_debt CSV
#'
#' @param masterdata_debt_raw A data frame containing the raw data from a
#'   masterdata_debt CSV
#' @param ar_company_id__country_of_domicile A data frame containing an
#'   `ar_company_id` to `country_of_domicile` lookup
#' @param ar_company_id__credit_parent_ar_company_id A data frame containing an
#'   `ar_company_id` to `credit_parent_ar_company_id` lookup
#' @param pacta_financial_timestamp A single character vector containing the
#'   PACTA financial timestamp, e.g. `2023Q4`
#' @param zero_emission_factor_techs A character vector containing the zero
#'   emission factor technologies
#'
#' @return A data frame containing the prepared masterdata_debt_datastore
#'
#' @export

prepare_masterdata_debt <- function(masterdata_debt_raw,
                                    ar_company_id__country_of_domicile,
                                    ar_company_id__credit_parent_ar_company_id,
                                    pacta_financial_timestamp,
                                    zero_emission_factor_techs) {

  company_id__creditor_company_id <-
    prepare_company_id__creditor_company_id(masterdata_debt_raw)

  masterdata_debt_raw %>%
    prepare_masterdata(
      ar_company_id__country_of_domicile,
      pacta_financial_timestamp,
      zero_emission_factor_techs
    ) %>%
    dplyr::left_join(company_id__creditor_company_id, by = c(id = "company_id")) %>%
    dplyr::left_join(ar_company_id__credit_parent_ar_company_id, by = c(id = "ar_company_id")) %>%
    dplyr::mutate(id = dplyr::if_else(
      !is.na(.data$credit_parent_ar_company_id),
      .data$credit_parent_ar_company_id,
      .data$id
    )) %>%
    dplyr::mutate(id = dplyr::if_else(
      !is.na(.data$creditor_company_id),
      .data$creditor_company_id,
      .data$id
    )) %>%
    dplyr::mutate(id_name = "credit_parent_ar_company_id") %>%
    dplyr::summarise(
      ald_emissions_factor = stats::weighted.mean(.data$ald_emissions_factor, .data$ald_production, na.rm = TRUE),
      ald_production = sum(.data$ald_production, na.rm = TRUE),
      .by = c(
        "id",
        "id_name",
        "ald_sector",
        "ald_location",
        "technology",
        "year",
        "country_of_domicile",
        "ald_production_unit",
        "ald_emissions_factor_unit"
      )
    )
}
