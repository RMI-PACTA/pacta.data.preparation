apply_fair_share <- function(data, other_sector_list) {
  out <-
    data %>%
    lazy_dt() %>%
    group_by(
      .data$scenario_source,
      .data$scenario,
      .data$id,
      .data$equity_market,
      .data$scenario_geography,
      .data$year,
      .data$ald_sector,
      .data$technology
    ) %>%
    mutate(
      scen_tech_prod = if_else(.data$direction == "increasing",
        max(.data$ref_plan_tech_prod + (.data$fair_share_perc * .data$ref_plan_sector_prod), 0),
        max(.data$ref_plan_tech_prod + (.data$fair_share_perc * .data$ref_plan_tech_prod), 0)
      ),
      scen_tech_prod = if_else(.data$ald_sector %in% .env$other_sector_list, .data$ref_plan_tech_prod, .data$scen_tech_prod),
      scen_emission_factor = .data$ref_emission_factor + (.data$fair_share_perc * .data$ref_emission_factor)
    ) %>%
    ungroup("technology") %>%
    mutate(scen_sec_prod = sum(.data$scen_tech_prod, na.rm = TRUE)) %>%
    mutate(
      scen_tech_share = if_else(.data$scen_sec_prod != 0, .data$scen_tech_prod / .data$scen_sec_prod, NA_real_),
      scen_br_wt_factor = .data$plan_br_wt_factor,
      scen_br_wt_techshare = .data$scen_br_wt_factor * .data$scen_tech_share
    ) %>%
    ungroup()

  out <-
    out %>%
    group_by(.data$scenario_source, .data$scenario, .data$id, .data$year, .data$ald_sector) %>%
    mutate(
      scen_global_sec_prod = sum(if_else(.data$scenario_geography == "Global" & .data$equity_market == "GlobalMarket", .data$scen_tech_prod, 0), na.rm = TRUE),
      scenario_exists = if_else(!is.na(.data$scenario), 1, 0)
    ) %>%
    ungroup()

  out <-
    out %>%
    group_by(
      .data$scenario_source,
      .data$scenario,
      .data$id,
      .data$equity_market,
      .data$scenario_geography,
      .data$year,
      .data$ald_sector
    ) %>%
    mutate(
      plan_build_out = .data$plan_tech_prod - .data$ref_plan_tech_prod,
      plan_build_out_tech_share = .data$plan_build_out / sum(.data$plan_build_out, na.rm = TRUE),
      scen_build_out = .data$scen_tech_prod - .data$ref_plan_tech_prod
    ) %>%
    ungroup() %>%
    as_tibble()

  return(out)
}
