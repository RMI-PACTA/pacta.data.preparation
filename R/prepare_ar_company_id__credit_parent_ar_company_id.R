#' Prepare an `ar_company_id__credit_parent_ar_company_id` lookup table from the
#' `entity_info` data
#'
#' @param entity_info A data frame containing the entity info
#'
#' @return A tibble
#'
#' @export

prepare_ar_company_id__credit_parent_ar_company_id <- function(entity_info) {
  stopifnot(is.data.frame(entity_info))
  stopifnot(
    all(c("ar_company_id", "credit_parent_ar_company_id") %in% names(entity_info))
  )

  out <-
    entity_info %>%
    dplyr::select("ar_company_id", "credit_parent_ar_company_id") %>%
    dplyr::filter(!is.na(.data$ar_company_id)) %>%
    dplyr::distinct()

  stopifnot(all(!duplicated(out[["ar_company_id"]])))
  out
}
