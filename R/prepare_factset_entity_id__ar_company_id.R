#' Prepare a `factset_entity_id__ar_company_id` lookup table from Asset Impact's
#' `ar_company_id__factset_entity_id` crosswalk
#'
#' @param ar_company_id__factset_entity_id A data frame containing a production
#'   data company ID to financial data entity lookup table
#'
#' @return A tibble
#'
#' @export

prepare_factset_entity_id__ar_company_id <-
  function(ar_company_id__factset_entity_id) {
    stopifnot(is.data.frame(ar_company_id__factset_entity_id))
    stopifnot(
      all(c("factset_id", "company_id") %in% names(ar_company_id__factset_entity_id))
    )

    out <-
      ar_company_id__factset_entity_id %>%
      dplyr::select(
        factset_entity_id = "factset_id",
        ar_company_id = "company_id"
      ) %>%
      dplyr::filter(!is.na(.data$factset_entity_id)) %>%
      dplyr::filter(!is.na(.data$ar_company_id)) %>%
      dplyr::distinct() %>%
      dplyr::mutate(
        dplyr::across(.cols = dplyr::everything(), .fns = as.character)
      )

    stopifnot(all(!duplicated(out[["factset_entity_id"]])))
    stopifnot(all(!is.na(out[["factset_entity_id"]])))
    stopifnot(all(!is.na(out[["ar_company_id"]])))
    stopifnot(is.character(out[["factset_entity_id"]]))
    stopifnot(is.character(out[["ar_company_id"]]))
    out
  }
