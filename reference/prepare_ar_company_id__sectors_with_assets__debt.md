# Prepare an `ar_company_id__sectors_with_assets__debt` lookup table from the `masterdata_debt_datastore` data

Prepare an `ar_company_id__sectors_with_assets__debt` lookup table from
the `masterdata_debt_datastore` data

## Usage

``` r
prepare_ar_company_id__sectors_with_assets__debt(
  masterdata_debt_datastore,
  relevant_years
)
```

## Arguments

- masterdata_debt_datastore:

  A data frame containing processed production data from Asset Impact's
  masterdata_ownership CSV

- relevant_years:

  A numeric vector containing the relevant years of data to include

## Value

A tibble
