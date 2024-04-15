#' Prepare a `factset_entity_id__credit_parent_id` lookup table from
#' `entity_info`
#'
#' @param entity_info A data frame containing the entity info
#'
#' @return A tibble
#'
#' @export

prepare_factset_entity_id__credit_parent_id <- function(entity_info) {
  stopifnot(is.data.frame(entity_info))
  stopifnot(
    all(c("factset_entity_id", "credit_parent_id") %in% names(entity_info))
  )

  out <-
    entity_info %>%
    dplyr::select("factset_entity_id", "credit_parent_id") %>%
    dplyr::filter(!is.na(.data$factset_entity_id)) %>%
    dplyr::filter(!is.na(.data$credit_parent_id)) %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      dplyr::across(.cols = dplyr::everything(), .fns = as.character)
    )

  stopifnot(all(!duplicated(out[["factset_entity_id"]])))
  stopifnot(all(!is.na(out[["factset_entity_id"]])))
  stopifnot(all(!is.na(out[["credit_parent_id"]])))
  stopifnot(is.character(out[["factset_entity_id"]]))
  stopifnot(is.character(out[["credit_parent_id"]]))
  out
}
