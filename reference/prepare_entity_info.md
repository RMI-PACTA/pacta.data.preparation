# Prepare the `entity_info` output data frame from data frames imported from the `factset_entity_info.rds` and `ar_company_id__factset_entity_id.rds` files

Prepare the `entity_info` output data frame from data frames imported
from the `factset_entity_info.rds` and
`ar_company_id__factset_entity_id.rds` files

## Usage

``` r
prepare_entity_info(
  data,
  factset_entity_id__ar_company_id,
  factset_industry_map_bridge,
  factset_manual_pacta_sector_override
)
```

## Arguments

- data:

  A data frame containing the imported `factset_entity_info.rds` file

- factset_entity_id\_\_ar_company_id:

  A data frame containing the imported
  `ar_company_id__factset_entity_id.rds` file with columns
  `factset_entity_id` and `ar_company_id`

- factset_industry_map_bridge:

  A data frame containing the imported `factset_industry_map_bridge.rds`

- factset_manual_pacta_sector_override:

  A data frame containing the imported
  `factset_manual_pacta_sector_override`

## Value

A tibble properly prepared to be saved as the `entity_info.rds` output
file
