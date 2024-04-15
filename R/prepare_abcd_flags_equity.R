#' Title
#'
#' @param financial_data A data frame containing financial data
#' @param factset_entity_id__ar_company_id A data frame containing a
#'   factset_entity_id to ar_company_id look up table
#' @param factset_entity_id__security_mapped_sector A data frame containing a
#'   factset_entity_id to security_mapped_sector look up table
#' @param ar_company_id__sectors_with_assets__ownership A data frame containing
#'   a ar_company_id to sectors_with_assets look up table for ownership
#'
#' @return A data frame
#'
#' @export

prepare_abcd_flags_equity <-
  function(financial_data,
           factset_entity_id__ar_company_id,
           factset_entity_id__security_mapped_sector,
           ar_company_id__sectors_with_assets__ownership) {
    stopifnot(is.data.frame(financial_data))
    stopifnot("factset_entity_id" %in% names(financial_data))

    stopifnot(is.data.frame(factset_entity_id__ar_company_id))
    stopifnot(
      all(c("factset_entity_id", "ar_company_id") %in% names(factset_entity_id__ar_company_id))
    )

    stopifnot(is.data.frame(factset_entity_id__security_mapped_sector))
    stopifnot(
      all(c("factset_entity_id", "security_mapped_sector") %in% names(factset_entity_id__security_mapped_sector))
    )

    stopifnot(is.data.frame(ar_company_id__sectors_with_assets__ownership))
    stopifnot(
      all(c("ar_company_id", "sectors_with_assets") %in% names(ar_company_id__sectors_with_assets__ownership))
    )

    financial_data %>%
      dplyr::left_join(factset_entity_id__ar_company_id, by = "factset_entity_id") %>%
      dplyr::left_join(factset_entity_id__security_mapped_sector, by = "factset_entity_id") %>%
      dplyr::left_join(ar_company_id__sectors_with_assets__ownership, by = "ar_company_id") %>%
      dplyr::mutate(has_asset_level_data = dplyr::if_else(
        is.na(.data$sectors_with_assets) | .data$sectors_with_assets == "",
        FALSE,
        TRUE
      )) %>%
      dplyr::mutate(has_ald_in_fin_sector = dplyr::if_else(
        stringr::str_detect(.data$sectors_with_assets, .data$security_mapped_sector),
        TRUE,
        FALSE
      )) %>%
      dplyr::select(
        "isin",
        "has_asset_level_data",
        "has_ald_in_fin_sector",
        "sectors_with_assets"
      )
  }
