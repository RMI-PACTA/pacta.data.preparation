#' Prepare a `total_fund_list` object from `fund_data`
#'
#' @param fund_data A data frame containing fund data
#'
#' @return A tibble
#'
#' @export

prepare_total_fund_list <- function(fund_data) {
  stopifnot(is.data.frame(fund_data))
  stopifnot("factset_fund_id" %in% names(fund_data))

  fund_data %>%
    dplyr::select("factset_fund_id") %>%
    dplyr::filter(!is.na(.data$factset_fund_id)) %>%
    dplyr::distinct()
}
