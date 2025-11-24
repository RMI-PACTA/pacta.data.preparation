# Combine ABCD and scenario data into the `[equity/bonds]_abcd_scenario.rds` format that is used by portfolio.analysis

Combine ABCD and scenario data into the
`[equity/bonds]_abcd_scenario.rds` format that is used by
portfolio.analysis

## Usage

``` r
dataprep_abcd_scen_connection(
  abcd_data,
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
  index_regions
)
```

## Arguments

- abcd_data:

  A tibble containing the ABCD data

- scenario_data:

  A tibble containing the scenario data

- reference_year:

  A single numeric specifying the market share target reference year

- relevant_years:

  A numeric vector containing all relevant years to be calculated

- tech_exclude:

  A character vector containing the technologies to be excluded

- scenario_geographies_list:

  A character vector containing the scenario geographies to be used

- sector_list:

  A character vector containing the sectors to be included

- other_sector_list:

  A character vector containing the sectors considered "other"

- global_aggregate_scenario_sources_list:

  A character vector containing the scenario sources to be included in
  the global aggreagte

- global_aggregate_sector_list:

  A character vector containing the sectors to be included in the global
  aggregate

- scenario_regions:

  A character vector containing the scenario regions

- index_regions:

  A character vector containing the index regions

## Value

A tibble with the combined ABCD and scenario data
