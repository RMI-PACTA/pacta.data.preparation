#' Prepare a `factset_entity_id__security_mapped_sector` lookup table from
#' `entity_info`
#'
#' @param entity_info A data frame containing the entity info
#'
#' @return A tibble
#'
#' @export

prepare_factset_entity_id__security_mapped_sector <- function(entity_info) {
  stopifnot(is.data.frame(entity_info))
  stopifnot(
    all(c("factset_entity_id", "security_mapped_sector") %in% names(entity_info))
  )

  out <-
    entity_info %>%
    dplyr::select("factset_entity_id", "security_mapped_sector") %>%
    dplyr::filter(!is.na(.data$factset_entity_id)) %>%
    dplyr::filter(!is.na(.data$security_mapped_sector)) %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      dplyr::across(.cols = dplyr::everything(), .fns = as.character)
    )

  stopifnot(all(!duplicated(out[["factset_entity_id"]])))
  stopifnot(all(!is.na(out[["factset_entity_id"]])))
  stopifnot(all(!is.na(out[["security_mapped_sector"]])))
  stopifnot(is.character(out[["factset_entity_id"]]))
  stopifnot(is.character(out[["security_mapped_sector"]]))
  out
}
