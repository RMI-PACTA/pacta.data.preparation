do_calcs_within_id <- function(ald_full,
                               reference_year,
                               global_aggregate) {
  if (global_aggregate == TRUE) {
    ald_full <- ald_full %>%
      group_by(
        .data$scenario_source,
        .data$scenario,
        .data$id,
        .data$equity_market,
        .data$scenario_geography,
        .data$year,
        .data$ald_sector
      )
  } else {
    ald_full <- ald_full %>%
      group_by(
        .data$id,
        .data$equity_market,
        .data$scenario_geography,
        .data$year,
        .data$ald_sector
      )
  }

  ald_full_calcs <- ald_full %>%
    mutate(
      plan_sector_prod = sum(.data$plan_tech_prod, na.rm = TRUE),
      plan_tech_share = if_else(
        .data$plan_sector_prod != 0,
        .data$plan_tech_prod / .data$plan_sector_prod,
        NA_real_
      )
    ) %>%
    ungroup()

  if (global_aggregate == TRUE) {
    ald_full_calcs <-
      ald_full_calcs %>%
      group_by(
        .data$id,
        .data$ald_sector,
        .data$equity_market,
        .data$scenario,
        .data$scenario_geography
      ) %>%
      mutate(
        ref_plan_sector_prod = sum(
          if_else(
            .data$year == .env$reference_year,
            .data$plan_tech_prod,
            0
          ),
          na.rm = TRUE
        )
      ) %>%
      group_by(.data$id, .data$ald_sector, .data$scenario) %>%
      mutate(
        plan_global_sec_prod_ref = sum(
          if_else(
            .data$equity_market == "GlobalMarket" & .data$year == .env$reference_year,
            .data$plan_tech_prod,
            0
          ),
          na.rm = TRUE
        ),
        plan_br_wt_factor = if_else(
          .data$plan_global_sec_prod_ref != 0,
          .data$ref_plan_sector_prod / .data$plan_global_sec_prod_ref,
          NA_real_
        ),
        plan_br_wt_techshare = .data$plan_br_wt_factor * .data$plan_tech_share
      ) %>%
      ungroup()
  } else {
    ald_full_calcs <-
      ald_full_calcs %>%
      group_by(.data$id, .data$ald_sector) %>%
      mutate(
        plan_global_sec_prod_ref = sum(
          if_else(
            .data$scenario_geography == "Global" & .data$equity_market == "GlobalMarket" & .data$year == .env$reference_year,
            .data$plan_tech_prod,
            0
          ),
          na.rm = TRUE
        )
      ) %>%
      group_by(
        .data$id,
        .data$ald_sector,
        .data$equity_market,
        .data$scenario_geography
      ) %>%
      mutate(
        ref_plan_sector_prod = sum(
          if_else(.data$year == .env$reference_year, .data$plan_tech_prod, 0),
          na.rm = TRUE
        )
      ) %>%
      ungroup() %>%
      mutate(
        plan_br_wt_factor = if_else(
          .data$plan_global_sec_prod_ref != 0,
          .data$ref_plan_sector_prod / .data$plan_global_sec_prod_ref,
          NA_real_
        ),
        plan_br_wt_techshare = .data$plan_br_wt_factor * .data$plan_tech_share
      )
  }
}
