#' Determine relevant years
#'
#' @param market_share_target_reference_year A single numeric value determining
#'   the Market Share target reference year
#' @param time_horizon A single numeric value determining the number of forward
#'   looking years
#'
#' @return A numeric vector containg all of the relevant years
#'
#' @export

determine_relevant_years <- function(market_share_target_reference_year,
                                     time_horizon) {
  sort(unique(
    market_share_target_reference_year:(market_share_target_reference_year + time_horizon)
  ))
}
