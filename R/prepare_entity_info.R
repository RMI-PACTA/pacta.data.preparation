#' Prepare the `entity_info` output data frame from data frames imported from
#' the `factset_entity_info.rds` and `ar_company_id__factset_entity_id.rds`
#' files
#'
#' @param data A data frame containing the imported `factset_entity_info.rds`
#'   file
#' @param factset_entity_id__ar_company_id A data frame containing the imported
#'   `ar_company_id__factset_entity_id.rds` file with columns
#'   `factset_entity_id` and `ar_company_id`
#' @param factset_industry_map_bridge A data frame containing the imported
#'   `factset_industry_map_bridge.rds`
#' @param factset_manual_pacta_sector_override A data frame containing the imported
#'   `factset_manual_pacta_sector_override`
#' @return A tibble properly prepared to be saved as the `entity_info.rds`
#'   output file
#'
#' @export

prepare_entity_info <- function(
    data,
    factset_entity_id__ar_company_id,
    factset_industry_map_bridge,
    factset_manual_pacta_sector_override) {
  crucial_names <- c(
    "factset_entity_id",
    "entity_proper_name",
    "iso_country",
    "sector_code",
    "factset_sector_desc", #
    "credit_parent_id",
    "industry_code"
  )

  check_crucial_names(data, crucial_names)

  crucial_names_factset_industry_map_bridge <- c(
    "factset_industry_code",
    "pacta_sector"
  )

  check_crucial_names(
    factset_industry_map_bridge,
    crucial_names_factset_industry_map_bridge
  )

  factset_industry_map_bridge_crucial <- select(
    factset_industry_map_bridge,
    dplyr::all_of(crucial_names_factset_industry_map_bridge)
  )

  data %>%
    left_join(factset_entity_id__ar_company_id, by = "factset_entity_id") %>%
    left_join(
      rename(factset_entity_id__ar_company_id, credit_parent_ar_company_id = "ar_company_id"),
      by = c("credit_parent_id" = "factset_entity_id")
    ) %>%
    left_join(
      factset_industry_map_bridge_crucial,
      by = c(industry_code = "factset_industry_code")
    ) %>%
    mutate(pacta_sector = if_else(is.na(.data$pacta_sector), "Other", .data$pacta_sector)) %>%
    select(
      "factset_entity_id",
      company_name = "entity_proper_name",
      country_of_domicile = "iso_country",
      bics_sector_code = "sector_code",
      bics_sector = "factset_sector_desc",
      security_bics_subgroup_code = "industry_code",
      security_bics_subgroup = "factset_industry_desc",
      security_mapped_sector = "pacta_sector",
      "ar_company_id",
      "credit_parent_id",
      "credit_parent_ar_company_id"
    ) %>%
    override_sector_by_factset_entity_id(
      factset_manual_pacta_sector_override
    )
}
