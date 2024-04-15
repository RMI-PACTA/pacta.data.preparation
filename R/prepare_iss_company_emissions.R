#' Prepare an `iss_company_emissions` object from `factset_iss_emissions_data`
#'
#' @param factset_iss_emissions_data A data frame containing ISS emissions data
#'
#' @return A tibble
#'
#' @export

prepare_iss_company_emissions <- function(factset_iss_emissions_data) {
  stopifnot(is.data.frame(factset_iss_emissions_data))
  stopifnot(
    all(c("factset_entity_id", "icc_total_emissions", "icc_scope_3_emissions") %in% names(factset_iss_emissions_data))
  )

  factset_iss_emissions_data %>%
    dplyr::summarise(
      icc_total_emissions = sum(.data$icc_total_emissions + .data$icc_scope_3_emissions, na.rm = TRUE),
      .by = "factset_entity_id"
    ) %>%
    # units are defined in the ISS/FactSet documentation
    dplyr::mutate(icc_total_emissions_units = "tCO2e")
}
