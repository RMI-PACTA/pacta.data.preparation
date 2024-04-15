expand_tech_rows <- function(data, global_aggregate = FALSE) {
  na_list <- list(
    plan_tech_prod = 0,
    current_plan_row = 0
  )

  group_names <- c("id_name", "id", "equity_market", "scenario_geography")
  if (global_aggregate) group_names <- c("scenario_source", "scenario", group_names)

  data <- dplyr::group_by(data, .data$ald_sector)
  data <-
    tidyr::complete(
      data,
      tidyr::nesting(!!!rlang::syms(group_names)),
      tidyr::nesting(!!rlang::sym("technology")),
      year,
      fill = na_list
    )
  dplyr::ungroup(data)
}
