#' Pick the most recent value of `asset_level_timestamp` relative to `timestamp`
#'
#' Filter a dataset for values of `asset_level_timestamp`, that are most recent
#' relative to some input `timestamp`.
#'
#' @param data A dataframe containing the column `asset_level_timestamp`.
#' @param timestamp A character indicating the desired timestamp, by year and
#'   quarter, "YYYYQQ" (e.g. "2020Q1").
#' @param ... Variables to group by.
#'
#' @return A dataframe where the value of `asset_level_timestamp` is filtered to
#'   the most recent value, relative to `timestamp` (by group, if provided).
#'
#' @examples
#' data <- tibble::tribble(
#'   ~sector,      ~asset_level_timestamp,
#'   "aviation",   "2021Q4",
#'   "power",      "2021Q1",
#'   "power",      "2021Q2",
#'   "automotive", "2020Q4",
#'   "automotive", "2022Q1"
#' )
#'
#' timestamp <- "2021Q4"
#'
#' filter_most_recent_timstamp(data, timestamp, sector)
#' @noRd

filter_most_recent_timestamp <- function(data, timestamp, ...) {
  stopifnot(
    is.data.frame(data),
    is.character(timestamp),
    "asset_level_timestamp" %in% names(data)
  )

  data %>%
    mutate(.asset_level_timestamp = lubridate::yq(.data$asset_level_timestamp)) %>%
    group_by(...) %>%
    filter(.data$.asset_level_timestamp <= lubridate::yq(.env$timestamp)) %>%
    filter(.data$.asset_level_timestamp == max(.data$.asset_level_timestamp)) %>%
    select(-".asset_level_timestamp") %>%
    ungroup()
}
