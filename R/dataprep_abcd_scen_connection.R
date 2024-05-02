#' Combine ABCD and scenario data into the `[equity/bonds]_abcd_scenario.rds`
#' format that is used by portfolio.analysis
#'
#' @param abcd_data A tibble containing the ABCD data
#' @param scenario_data A tibble containing the scenario data
#' @param reference_year A single numeric specifying the market share target
#'   reference year
#' @param relevant_years A numeric vector containing all relevant years to be
#'   calculated
#' @param tech_exclude A character vector containing the technologies to be
#'   excluded
#' @param scenario_geographies_list A character vector containing the scenario
#'   geographies to be used
#' @param sector_list A character vector containing the sectors to be included
#' @param other_sector_list A character vector containing the sectors considered
#'   "other"
#' @param global_aggregate_scenario_sources_list A character vector containing
#'   the scenario sources to be included in the global aggreagte
#' @param global_aggregate_sector_list A character vector containing the sectors
#'   to be included in the global aggregate
#' @param scenario_regions A character vector containing the scenario regions
#' @param index_regions A character vector containing the index regions
#'
#' @return A tibble with the combined ABCD and scenario data
#'
#' @export

dataprep_abcd_scen_connection <- function(abcd_data,
                                          scenario_data,
                                          reference_year,
                                          relevant_years,
                                          tech_exclude,
                                          scenario_geographies_list,
                                          sector_list,
                                          other_sector_list,
                                          global_aggregate_scenario_sources_list,
                                          global_aggregate_sector_list,
                                          scenario_regions,
                                          index_regions) {
  abcd_scenario <- dataprep_connect_abcd_with_scenario(
    abcd_data,
    scenario_data,
    global_aggregate = FALSE,
    reference_year = reference_year,
    relevant_years = relevant_years,
    tech_exclude = tech_exclude,
    scenario_geographies_list = scenario_geographies_list,
    sector_list = sector_list,
    other_sector_list = other_sector_list,
    global_aggregate_scenario_sources_list = global_aggregate_scenario_sources_list,
    global_aggregate_sector_list = global_aggregate_sector_list,
    scenario_regions,
    index_regions
  )

  if (any(unique(scenario_data$scenario_source) %in% global_aggregate_scenario_sources_list)) {
    abcd_scenario_global_aggregate <- dataprep_connect_abcd_with_scenario(
      abcd_data,
      scenario_data,
      global_aggregate = TRUE,
      reference_year = reference_year,
      relevant_years = relevant_years,
      tech_exclude = tech_exclude,
      scenario_geographies_list = scenario_geographies_list,
      sector_list = sector_list,
      other_sector_list = other_sector_list,
      global_aggregate_scenario_sources_list = global_aggregate_scenario_sources_list,
      global_aggregate_sector_list = global_aggregate_sector_list,
      scenario_regions,
      index_regions
    )
  } else {
    abcd_scenario_global_aggregate <- data.frame()
  }


  # Combine Global aggregate dataset with regional dataset:
  abcd_scenario_short <- dplyr::bind_rows(
    abcd_scenario,
    abcd_scenario_global_aggregate
  )

  return(abcd_scenario_short)
}

dataprep_connect_abcd_with_scenario <- function(abcd_data,
                                                scenario_data,
                                                global_aggregate = FALSE,
                                                reference_year,
                                                relevant_years,
                                                tech_exclude,
                                                scenario_geographies_list,
                                                sector_list,
                                                other_sector_list,
                                                global_aggregate_scenario_sources_list,
                                                global_aggregate_sector_list,
                                                scenario_regions,
                                                index_regions) {
  scenario_data <- scenario_data[!(grepl("Cap", scenario_data$technology) & scenario_data$ald_sector == "Demand"), ]

  ald <- abcd_data %>%
    select(
      "ald_sector",
      "technology",
      "year",
      "id",
      "country_of_domicile",
      "ald_location",
      "ald_production",
      "ald_production_unit",
      "ald_emissions_factor",
      "id_name"
    ) %>%
    filter(
      .data$year %in% relevant_years,
      !is.na(.data$id) & !.data$id %in% c("NonListedProduction", "NoMatchingCorpBondTicker"),
      !.data$technology %in% .env$tech_exclude
    ) %>%
    mutate(
      ald_sector = dplyr::case_when(
        .data$technology == "Coal" ~ "Coal",
        .data$technology %in% c("Gas", "Oil") ~ "Oil&Gas",
        TRUE ~ .data$ald_sector
      )
    )

  if (global_aggregate == TRUE) {
    scenario_data <-
      scenario_data %>%
      filter(.data$scenario_source %in% .env$global_aggregate_scenario_sources_list)

    ald_ga_input <-
      scenario_regions %>%
      select("scenario_geography", "country_iso", "reg_count") %>%
      unique() %>%
      left_join(
        unique(
          select(
            scenario_data,
            "scenario_source",
            "scenario",
            "scenario_geography",
            "ald_sector"
          )
        ),
        by = "scenario_geography"
      ) %>%
      group_by(.data$scenario_source, .data$scenario, .data$ald_sector, .data$country_iso) %>%
      mutate(rank = rank(.data$reg_count, ties.method = "first")) %>%
      filter(
        .data$rank == 1,
        .data$scenario_source %in% .env$global_aggregate_scenario_sources_list
      ) %>%
      select(-"reg_count", -"rank")

    ald_sr <- ald %>%
      filter(
        .data$ald_sector %in% .env$global_aggregate_sector_list
      ) %>%
      left_join(
        ald_ga_input,
        by = c("ald_location" = "country_iso", "ald_sector" = "ald_sector")
      ) %>%
      mutate(
        scenario_geography = ifelse(
          is.na(.data$scenario_geography) | .data$scenario_geography == "",
          "Global",
          .data$scenario_geography
        )
      )
  } else {
    ald_sr <- expand_by_scenario_geography(ald, scenario_geographies_list, scenario_regions)
  }

  if (unique(ald_sr$id_name) == "ar_company_id") {
    ald_sr_ir <- expand_by_country_of_domicile(ald_sr, index_regions)
  } else {
    ald_sr_ir <- ald_sr %>% mutate(equity_market = "GlobalMarket")
  }

  if (global_aggregate == TRUE) {
    ald_sr_ir_agg <-
      ald_sr_ir %>%
      group_by(
        .data$scenario_source,
        .data$scenario,
        .data$id_name,
        .data$id,
        .data$equity_market,
        .data$scenario_geography,
        .data$ald_sector,
        .data$technology,
        .data$year
      ) %>%
      summarise(
        plan_emission_factor = stats::weighted.mean(
          .data$ald_emissions_factor,
          .data$ald_production,
          na.rm = TRUE
        ),
        plan_tech_prod = sum(.data$ald_production, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      mutate(
        current_plan_row = 1
      ) %>%
      ungroup()
  } else {
    ald_sr_ir_agg <-
      ald_sr_ir %>%
      group_by(
        .data$id_name,
        .data$id,
        .data$equity_market,
        .data$scenario_geography,
        .data$ald_sector,
        .data$technology,
        .data$year
      ) %>%
      summarise(
        plan_emission_factor = stats::weighted.mean(
          .data$ald_emissions_factor,
          .data$ald_production,
          na.rm = TRUE
        ),
        plan_tech_prod = sum(.data$ald_production, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      mutate(current_plan_row = 1)
  }


  ### ########################################################################## #
  ### ADD THE EXTRA TECHNOLOGY LINES -----
  ### ########################################################################## #

  ald_full <- ald_sr_ir_agg
  ald_full <- expand_tech_rows(ald_full, global_aggregate = global_aggregate)


  ### ########################################################################## #
  ### DO CALCS WITHIN id, equity_market, SCENARIO GEOGRAPHY ----
  ### ########################################################################## #

  ald_full_calcs <- do_calcs_within_id(ald_full, reference_year = reference_year, global_aggregate = global_aggregate)


  ### ########################################################################## #
  ### ADD REFERENCE YEAR PRODUCTION PLANS ----
  ### ########################################################################## #
  if (global_aggregate == TRUE) {
    ald_full_calcs <- ald_full_calcs %>%
      group_by(
        .data$scenario_source,
        .data$scenario,
        .data$id,
        .data$ald_sector,
        .data$equity_market,
        .data$scenario_geography,
        .data$technology
      )
  } else {
    ald_full_calcs <- ald_full_calcs %>%
      group_by(
        .data$id,
        .data$ald_sector,
        .data$equity_market,
        .data$scenario_geography,
        .data$technology
      )
  }
  ald_full_calcs <- ald_full_calcs %>%
    mutate(
      ref_plan_tech_prod = sum(
        if_else(
          .data$year == .env$reference_year,
          .data$plan_tech_prod,
          0
        ),
        na.rm = TRUE
      ),
      ref_emission_factor = sum(
        if_else(
          .data$year == .env$reference_year,
          .data$plan_emission_factor,
          0
        ),
        na.rm = TRUE
      )
    ) %>%
    ungroup()

  ### ########################################################################## #
  ### ADD SCENARIOS ####
  ### ########################################################################## #
  if (global_aggregate == TRUE) {
    ald_scen <-
      ald_full_calcs %>%
      filter(.data$ald_sector %in% .env$sector_list) %>%
      left_join(
        scenario_data,
        by = c("scenario_source", "scenario", "scenario_geography", "year", "ald_sector", "technology")
      )

    ald_scen_other <-
      ald_full_calcs %>%
      filter(.data$ald_sector %in% .env$other_sector_list) %>%
      left_join(
        select(scenario_data, -"technology"),
        by = c("scenario_source", "scenario", "scenario_geography", "year", "ald_sector")
      )
  } else {
    ald_scen <-
      ald_full_calcs %>%
      filter(.data$ald_sector %in% .env$sector_list) %>%
      left_join(
        distinct(scenario_data),
        by = c("scenario_geography", "year", "ald_sector", "technology")
      )

    ald_scen_other <-
      ald_full_calcs %>%
      filter(.data$ald_sector %in% .env$other_sector_list) %>%
      left_join(
        select(scenario_data, -"technology"),
        by = c("scenario_geography", "year", "ald_sector")
      )
  }
  ald_scen <- rbind(ald_scen, ald_scen_other)


  ### apply fair share

  ald_scen_calcs <- apply_fair_share(ald_scen, other_sector_list)


  ### ########################################################################## #
  ### AGGREGATION FOR GLOBAL AGGREGATE (IF SLECETED)####
  ### ########################################################################## #
  if (global_aggregate == TRUE) {
    ald_scen_calcs <- ald_scen_calcs %>%
      group_by(
        .data$scenario_source,
        .data$scenario,
        .data$id_name,
        .data$id,
        .data$equity_market,
        .data$ald_sector,
        .data$technology,
        .data$year,
        .data$scenario_exists
      ) %>%
      summarise(
        plan_emission_factor = stats::weighted.mean(.data$plan_emission_factor, .data$plan_tech_prod, na.rm = TRUE),
        scen_emission_factor = stats::weighted.mean(.data$scen_emission_factor, .data$scen_tech_prod, na.rm = TRUE),
        plan_tech_prod = sum(.data$plan_tech_prod, na.rm = TRUE),
        plan_br_wt_factor = sum(.data$plan_br_wt_factor, na.rm = TRUE),
        plan_br_wt_techshare = sum(.data$plan_br_wt_techshare, na.rm = TRUE),
        scen_tech_prod = sum(.data$scen_tech_prod, na.rm = TRUE),
        scen_br_wt_factor = sum(.data$scen_br_wt_factor, na.rm = TRUE),
        scen_br_wt_techshare = sum(.data$scen_br_wt_techshare, na.rm = TRUE),
        ref_plan_tech_prod = sum(.data$ref_plan_tech_prod, na.rm = TRUE),
        ref_plan_sector_prod = sum(.data$ref_plan_sector_prod, na.rm = TRUE)
      ) %>%
      mutate(
        scenario_geography = "GlobalAggregate",
        fair_share_perc = NA,
        direction = NA,
        current_plan_row = if_else(.data$ref_plan_tech_prod > 0, 1, 0)
      ) %>%
      ungroup()
  }


  ### ########################################################################## #
  ### ADD ID COLS AND REORDER #####
  ### ########################################################################## #
  ald_scen_calcs_with_id <- ald_scen_calcs %>%
    group_by(.data$id, .data$ald_sector) %>%
    mutate(ald_company_sector_id = dplyr::cur_group_id()) %>%
    ungroup()

  ald_scen_calcs_short <-
    ald_scen_calcs_with_id %>%
    select(
      "scenario_source",
      "scenario",
      "id_name",
      "id",
      "ald_company_sector_id",
      "equity_market",
      "scenario_geography",
      "ald_sector",
      "technology",
      "year",
      "plan_tech_prod",
      "plan_br_wt_factor",
      "plan_br_wt_techshare",
      "plan_emission_factor",
      "scen_tech_prod",
      "scen_br_wt_factor",
      "scen_br_wt_techshare",
      "scen_emission_factor",
      "current_plan_row",
      "scenario_exists"
    ) %>%
    filter(.data$scenario_exists == 1) %>%
    ungroup()

  return(ald_scen_calcs_short)
}
