# Title

Title

## Usage

``` r
prepare_abcd_flags_equity(
  financial_data,
  factset_entity_id__ar_company_id,
  factset_entity_id__security_mapped_sector,
  ar_company_id__sectors_with_assets__ownership
)
```

## Arguments

- financial_data:

  A data frame containing financial data

- factset_entity_id\_\_ar_company_id:

  A data frame containing a factset_entity_id to ar_company_id look up
  table

- factset_entity_id\_\_security_mapped_sector:

  A data frame containing a factset_entity_id to security_mapped_sector
  look up table

- ar_company_id\_\_sectors_with_assets\_\_ownership:

  A data frame containing a ar_company_id to sectors_with_assets look up
  table for ownership

## Value

A data frame
