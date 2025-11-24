# Prepare the `masterdata_debt_datastore` object from a raw masterdata_debt CSV

Prepare the `masterdata_debt_datastore` object from a raw
masterdata_debt CSV

## Usage

``` r
prepare_masterdata_debt(
  masterdata_debt_raw,
  ar_company_id__country_of_domicile,
  ar_company_id__credit_parent_ar_company_id,
  pacta_financial_timestamp,
  zero_emission_factor_techs
)
```

## Arguments

- masterdata_debt_raw:

  A data frame containing the raw data from a masterdata_debt CSV

- ar_company_id\_\_country_of_domicile:

  A data frame containing an `ar_company_id` to `country_of_domicile`
  lookup

- ar_company_id\_\_credit_parent_ar_company_id:

  A data frame containing an `ar_company_id` to
  `credit_parent_ar_company_id` lookup

- pacta_financial_timestamp:

  A single character vector containing the PACTA financial timestamp,
  e.g. `2023Q4`

- zero_emission_factor_techs:

  A character vector containing the zero emission factor technologies

## Value

A data frame containing the prepared masterdata_debt_datastore
