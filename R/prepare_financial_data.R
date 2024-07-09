#' Prepare the `financial_data` output data frame from the imported
#' `factset_financial_data.rds` file
#'
#' @param data A data frame containing the imported `factset_financial_data.rds`
#'   file
#' @param issue_code_bridge A data frame containing data that bridges from
#'   factset issue codes to one of `c("Listed Equity", "Corporate Bond",
#'   "Fund", "Other")`
#'
#' @return A tibble properly prepared to be saved as the `financial_data.rds`
#'   output file
#'
#' @export

prepare_financial_data <-
  function(data, issue_code_bridge) {
    data %>%
      filter(!is.na(.data$issue_type)) %>%
      left_join(
        issue_code_bridge,
        by = c(issue_type = "issue_type_code")
      ) %>%
      mutate(
        shares_all_classes = calc_shares_all_classes(
          shares_outstanding = .data$adj_shares_outstanding,
          asset_type_id = .data$issue_type,
          include_types = c("CP", "EQ", "PF")
        ),
        .by = "factset_entity_id"
      ) %>%
      filter(
        case_when(
          asset_type == "Bonds" ~ TRUE,
          asset_type == "Others" ~ TRUE,
          asset_type == "Funds" ~ !is.na(.data$adj_price),
          asset_type == "Equity" ~ .data$adj_price > 0 & .data$adj_shares_outstanding > 0
        )
      ) %>%
      select(
        isin = "isin",
        unit_share_price = "adj_price",
        current_shares_outstanding_all_classes = "shares_all_classes",
        asset_type = "asset_type",
        factset_entity_id = "factset_entity_id"
      )
  }
