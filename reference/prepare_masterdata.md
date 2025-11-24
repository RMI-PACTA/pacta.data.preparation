# Prepare the `masterdata_ownership_datastore` or `masterdata_debt_datastore` output data frame from an import of a raw AR masterdata\_\* CSV

Prepare the `masterdata_ownership_datastore` or
`masterdata_debt_datastore` output data frame from an import of a raw AR
masterdata\_\* CSV

## Usage

``` r
prepare_masterdata(
  data,
  ar_company_id__country_of_domicile,
  pacta_financial_timestamp,
  zero_emission_factor_techs
)
```

## Arguments

- data:

  A dataframe containing the raw input of an AR masterdata\_\* CSV files

- ar_company_id\_\_country_of_domicile:

  A data frame with two columns mapping `ar_company_id` to
  `country_of_domicile`

- pacta_financial_timestamp:

  A single element character vector specifying the timestamp in the
  PACTA format, e.g. "2021Q4"

- zero_emission_factor_techs:

  A character vector listing technologies that will have emission
  factors manually forced to 0

## Value

A tibble properly prepared to be saved as the
`masterdata_ownership_datastore.rds` or `masterdata_debt_datastore.rds`
output file
