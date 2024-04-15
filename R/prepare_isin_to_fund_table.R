#' Prepare `isin_to_fund_table`, filtering out fsyms that have more than 1 row
#' and either no fund data or fund data for both rows
#'
#' @param isin_to_fund_table A data frame containing isin_to_fund_table data
#' @param fund_data A data frame containing fund data
#'
#' @return A tibble
#'
#' @export

prepare_isin_to_fund_table <- function(isin_to_fund_table, fund_data) {
  stopifnot(is.data.frame(isin_to_fund_table))
  stopifnot(
    all(c("factset_fund_id", "fsym_id") %in% names(isin_to_fund_table))
  )

  stopifnot(is.data.frame(fund_data))
  stopifnot(
    all(c("factset_fund_id") %in% names(fund_data))
  )

  # filter out fsyms that have more than 1 row and no fund data
  isin_to_fund_table <-
    isin_to_fund_table %>%
    dplyr::mutate(has_fund_data = .data$factset_fund_id %in% fund_data$factset_fund_id) %>%
    dplyr::mutate(n = dplyr::n(), .by = "fsym_id") %>%
    dplyr::filter(.data$n == 1 | (.data$n > 1 & .data$has_fund_data), .by = "fsym_id") %>%
    dplyr::select(-"n", -"has_fund_data")

  # filter out fsyms that have more than 1 row and have fund data for both rows
  isin_to_fund_table %>%
    dplyr::mutate(has_fund_data = .data$factset_fund_id %in% fund_data$factset_fund_id) %>%
    dplyr::mutate(n = dplyr::n(), .by = "fsym_id") %>%
    dplyr::filter(!(all(.data$has_fund_data) & .data$n > 1), .by = "fsym_id") %>%
    dplyr::select(-"n", -"has_fund_data")
}
