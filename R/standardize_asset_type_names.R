#' Standardize asset type names
#'
#' @param factset_issue_code_bridge A data frame containing the FactSet issue
#'   code bridge
#'
#' @return A data frame containing a FactSet `issue_type_code` to `asset_type`
#'   lookup
#'
#' @export

standardize_asset_type_names <- function(factset_issue_code_bridge) {
  factset_issue_code_bridge %>%
    dplyr::select("issue_type_code", "asset_type") %>%
    dplyr::mutate(
      asset_type = dplyr::case_when(
        .data$asset_type == "Listed Equity" ~ "Equity",
        .data$asset_type == "Corporate Bond" ~ "Bonds",
        .data$asset_type == "Fund" ~ "Funds",
        .data$asset_type == "Other" ~ "Others",
        TRUE ~ "Others"
      )
    )
}
