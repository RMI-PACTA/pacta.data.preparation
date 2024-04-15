#' Overwrite the value of `security_mapped_sector` by `factset_entity_id`
#'
#' This function will overwrite the value of the column `security_mapped_sector`
#' for every `factset_entity_id`. If no over-write value isn't present, it will
#' return the original value. Can be used, for example, to manually override
#' these values in the `entity_info` dataset.
#'
#' @param data A data-frame with the crucial columns `factset_entity_id` and
#'   `security_mapped_sector`.
#' @param sector_overrides A data-frame of sector overrides, with crucial columns
#'   `factset_entity_id` and `pacta_sector_override`.
#'
#' @return A data-frame where the input column `security_mapped_sector` has been
#'   overwritten with values from the column `pacta_sector_override`.
#'
#' @noRd
override_sector_by_factset_entity_id <- function(data, sector_overrides) {
  stopifnot(
    is.data.frame(data),
    is.data.frame(sector_overrides)
  )

  crucial_names <- c("factset_entity_id", "security_mapped_sector")
  check_crucial_names(data, crucial_names)

  crucial_names_sector_overrides <- c("factset_entity_id", "pacta_sector_override")
  check_crucial_names(sector_overrides, crucial_names_sector_overrides)

  sector_overrides <- select(
    sector_overrides,
    dplyr::all_of(crucial_names_sector_overrides)
  )

  original_names <- names(data)

  data %>%
    left_join(sector_overrides, by = "factset_entity_id") %>%
    mutate(
      security_mapped_sector = dplyr::case_when(
        !is.na(.data$pacta_sector_override) ~ .data$pacta_sector_override,
        TRUE ~ .data$security_mapped_sector
      )
    ) %>%
    select(dplyr::all_of(original_names))
}
