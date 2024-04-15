#' Prepare a `company_id__creditor_company_id` lookup table from Asset Impact's
#' `masterdata_debt` data
#'
#' @param masterdata_debt A data frame containing raw production data from Asset
#'   Impact's masterdata_debt CSV
#'
#' @return A tibble
#'
#' @export

prepare_company_id__creditor_company_id <- function(masterdata_debt) {
  stopifnot(is.data.frame(masterdata_debt))
  stopifnot(
    all(c("company_id", "creditor_company_id") %in% names(masterdata_debt))
  )

  out <-
    masterdata_debt %>%
    dplyr::select("company_id", "creditor_company_id") %>%
    dplyr::filter(!is.na(.data$company_id)) %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      dplyr::across(.cols = dplyr::everything(), .fns = as.character)
    )

  stopifnot(all(!duplicated(out[["company_id"]])))
  stopifnot(is.character(out[["company_id"]]))
  stopifnot(is.character(out[["creditor_company_id"]]))
  out
}
