#' Title
#'
#' @param financial_data A data frame containing financial data
#' @param factset_entity_id__ar_company_id A data frame containing a
#'   factset_entity_id to ar_company_id look up table
#' @param factset_entity_id__security_mapped_sector A data frame containing a
#'   factset_entity_id to security_mapped_sector look up table
#' @param ar_company_id__sectors_with_assets__debt A data frame containing
#'   a ar_company_id to sectors_with_assets look up table for debt
#' @param factset_entity_id__credit_parent_id A data frame containing a
#'   factset_entity_id to credit_parent_id look up table
#'
#' @return A data frame
#'
#' @export

prepare_abcd_flags_bonds <-
  function(financial_data,
           factset_entity_id__ar_company_id,
           factset_entity_id__security_mapped_sector,
           ar_company_id__sectors_with_assets__debt,
           factset_entity_id__credit_parent_id) {
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

    stopifnot(is.data.frame(ar_company_id__sectors_with_assets__debt))
    stopifnot(
      all(c("ar_company_id", "sectors_with_assets") %in% names(ar_company_id__sectors_with_assets__debt))
    )

    stopifnot(is.data.frame(factset_entity_id__credit_parent_id))
    stopifnot(
      all(c("factset_entity_id", "credit_parent_id") %in% names(factset_entity_id__credit_parent_id))
    )

    financial_data %>%
      dplyr::left_join(factset_entity_id__ar_company_id, by = "factset_entity_id") %>%
      dplyr::left_join(factset_entity_id__security_mapped_sector, by = "factset_entity_id") %>%
      dplyr::left_join(ar_company_id__sectors_with_assets__debt, by = "ar_company_id") %>%
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
      dplyr::left_join(factset_entity_id__credit_parent_id, by = "factset_entity_id") %>%
      dplyr::mutate(
        # If FactSet has no credit_parent, we define the company as it's own parent
        credit_parent_id = dplyr::if_else(
          is.na(.data$credit_parent_id),
          .data$factset_entity_id,
          .data$credit_parent_id
        )
      ) %>%
      dplyr::summarise(
        has_asset_level_data = sum(.data$has_asset_level_data, na.rm = TRUE) > 0,
        has_ald_in_fin_sector = sum(.data$has_ald_in_fin_sector, na.rm = TRUE) > 0,
        sectors_with_assets = paste(sort(unique(stats::na.omit(unlist(stringr::str_split(.data$sectors_with_assets, pattern = " [+] "))))), collapse = " + "),
        .by = "credit_parent_id"
      )
  }
