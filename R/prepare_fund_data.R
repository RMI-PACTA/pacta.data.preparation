#' Prepare fund data, filtering to funds with data according to a given
#' threshold and adding a `MISSINGWEIGHT` holding for the difference
#'
#' @param fund_data A data frame containing fund data
#' @param threshold A numeric value between 0 and 1 (inclusive) indicating the
#'   allowable percentage of the total fund value that the summed values of its
#'   component holdings should be equal to or greater than
#'
#' @return A tibble
#'
#' @export

prepare_fund_data <- function(fund_data, threshold = 0) {
  stopifnot(is.data.frame(fund_data))
  stopifnot(
    all(c("factset_fund_id", "holding_isin", "fund_reported_mv", "holding_reported_mv") %in% names(fund_data))
  )

  stopifnot(threshold >= 0 && threshold <= 1)

  # filter out funds where component holdings summed value is significantly
  # greater than the reported total fund value
  fund_data <-
    fund_data %>%
    dplyr::filter(
      (.data$fund_reported_mv[[1]] - sum(.data$holding_reported_mv)) / .data$fund_reported_mv[[1]] > -1e-5,
      .by = c("factset_fund_id", "fund_reported_mv")
    )

  # filter out funds where component holdings summed value is less than the
  # threshold percentage of the reported total fund value
  fund_data <-
    fund_data %>%
    dplyr::filter(
      sum(.data$holding_reported_mv) / .data$fund_reported_mv[[1]] >= .env$threshold,
      .by = c("factset_fund_id", "fund_reported_mv")
    )

  # calculate missing weight values for each fund
  fund_missing_mv <-
    fund_data %>%
    dplyr::summarise(
      holding_isin = "MISSINGWEIGHT",
      holding_reported_mv = .data$fund_reported_mv[[1]] - sum(.data$holding_reported_mv),
      .by = c("factset_fund_id", "fund_reported_mv")
    ) %>%
    dplyr::filter(.data$holding_reported_mv != 0)

  # add missing weight holdings for each fund
  dplyr::bind_rows(fund_data, fund_missing_mv)
}
