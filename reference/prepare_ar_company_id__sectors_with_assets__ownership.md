# Prepare an `ar_company_id__sectors_with_assets__ownership` lookup table from the `masterdata_ownership_datastore` data

Prepare an `ar_company_id__sectors_with_assets__ownership` lookup table
from the `masterdata_ownership_datastore` data

## Usage

``` r
prepare_ar_company_id__sectors_with_assets__ownership(
  masterdata_ownership_datastore,
  relevant_years
)
```

## Arguments

- masterdata_ownership_datastore:

  A data frame containing processed production data from Asset Impact's
  masterdata_ownership CSV

- relevant_years:

  A numeric vector containing the relevant years of data to include

## Value

A tibble
