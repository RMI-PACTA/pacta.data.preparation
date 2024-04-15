#' Prepare an `ar_company_id__sectors_with_assets__debt` lookup table from the
#' `masterdata_debt_datastore` data
#'
#' @param masterdata_debt_datastore A data frame containing processed
#'   production data from Asset Impact's masterdata_ownership CSV
#' @param relevant_years A numeric vector containing the relevant years of data
#'   to include
#'
#' @return A tibble
#'
#' @export

prepare_ar_company_id__sectors_with_assets__debt <- function(
    masterdata_debt_datastore,
    relevant_years) {
  stopifnot(is.data.frame(masterdata_debt_datastore))
  stopifnot(
    all(c("year", "id", "ald_sector") %in% names(masterdata_debt_datastore))
  )
  stopifnot(is.numeric(relevant_years))
  stopifnot(length(relevant_years) > 0L)
  stopifnot(all(grepl("20[0-9]{2}", relevant_years)))

  out <-
    masterdata_debt_datastore %>%
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
