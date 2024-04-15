#' Minimal datasets that allow over-writing
#'
#' These functions are developer-oriented. They all call [tibble::tibble()] so
#' you can expect all the goodies that come with that.
#'
#' @section Params
#' The arguments are the column names of the datasets being faked. They all have
#' a default and it can be overwritten.
#'
#' @section Pros and cons
#' These functions help you to avoid duplicating test code, and help
#' the reader of your code to focus on the one thing you want to test, instead
#' of burying that thing in the much longer code you need to create a fake
#' object from scratch.
#'
#' But `fake_*()` functions hide the explicit content. If the reader of your
#' code wants to inspect the data being tested, they need to jump to the
#' function definition or call them interactively.
#'
#' @return A data frame
#'
#' @examples
#' fake_entity_info()
#'
#' # Helps invalidate values for tests
#' fake_entity_info(factset_entity_id = "bad")
#'
#' # tibble() goodies:
#'
#' # Create new columns on the fly
#' fake_entity_info(a = "new")
#'
#' # Support for trailing commas
#' fake_entity_info(id = 1, )
#' @noRd
fake_entity_info <- function(factset_entity_id = NULL,
                             company_name = NULL,
                             country_of_domicile = NULL,
                             bics_sector = NULL,
                             security_bics_subgroup = NULL,
                             security_mapped_sector = NULL,
                             ar_company_id = NULL,
                             ...) {
  dplyr::tibble(
    factset_entity_id = factset_entity_id %||% "002KY7-E",
    company_name = company_name %||% "WW Energy, Inc.",
    country_of_domicile = country_of_domicile %||% "US",
    bics_sector = bics_sector %||% "Industrial Services",
    security_bics_subgroup = security_bics_subgroup %||% "Oil & Gas Power Plant",
    security_mapped_sector = security_mapped_sector %||% "Oil&Gas",
    ...
  )
}

fake_masterdata <- function(creditor_company_id = NULL,
                            company_id = NULL,
                            company_name = NULL,
                            is_ultimate_parent = NULL,
                            is_ultimate_listed_parent = NULL,
                            has_financial_data = NULL,
                            sector = NULL,
                            technology = NULL,
                            technology_type = NULL,
                            asset_type = NULL,
                            asset_country = NULL,
                            emissions_factor = NULL,
                            emissions_factor_unit = NULL,
                            metric = NULL,
                            unit = NULL,
                            `_2021` = NULL,
                            asset_level_timestamp = NULL,
                            ...) {
  dplyr::tibble(
    company_id = company_id %||% "10001",
    sector = sector %||% "Power",
    technology = technology %||% "CoalCap",
    asset_country = asset_country %||% "US",
    emissions_factor = emissions_factor %||% 0.123,
    emissions_factor_unit = emissions_factor_unit %||% "tCO2e/MWh",
    metric = metric %||% "direct production",
    unit = unit %||% "MW",
    `_2021` = `_2021` %||% 123.45,
    asset_level_timestamp = asset_level_timestamp %||% "2021Q4",
    ...
  )
}

fake_ar_company_id__country_of_domicile <- function(ar_company_id = NULL,
                                                    country_of_domicile = NULL,
                                                    ...) {
  dplyr::tibble(
    ar_company_id = ar_company_id %||% "10001",
    country_of_domicile = country_of_domicile %||% "US",
    ...
  )
}

`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}
