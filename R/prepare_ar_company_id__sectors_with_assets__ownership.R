#' Prepare an `ar_company_id__sectors_with_assets__ownership` lookup table from
#' the `masterdata_ownership_datastore` data
#'
#' @param masterdata_ownership_datastore A data frame containing processed
#'   production data from Asset Impact's masterdata_ownership CSV
#' @param relevant_years A numeric vector containing the relevant years of data
#'   to include
#'
#' @return A tibble
#'
#' @export

prepare_ar_company_id__sectors_with_assets__ownership <- function(
    masterdata_ownership_datastore,
    relevant_years) {
  stopifnot(is.data.frame(masterdata_ownership_datastore))
  stopifnot(
    all(c("year", "id", "ald_sector") %in% names(masterdata_ownership_datastore))
  )
  stopifnot(is.numeric(relevant_years))
  stopifnot(length(relevant_years) > 0L)
  stopifnot(all(grepl("20[0-9]{2}", relevant_years)))

  out <-
    masterdata_ownership_datastore %>%
    dplyr::filter(.data$year %in% .env$relevant_years) %>%
    dplyr::select(ar_company_id = "id", "ald_sector") %>%
    dplyr::filter(!is.na(.data$ar_company_id)) %>%
    dplyr::distinct() %>%
    dplyr::summarise(
      sectors_with_assets = paste(unique(.data$ald_sector), collapse = " + "),
      .by = "ar_company_id"
    )

  stopifnot(all(!duplicated(out[["ar_company_id"]])))
  out
}
