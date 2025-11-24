# Prepare the `financial_data` output data frame from the imported `factset_financial_data.rds` file

Prepare the `financial_data` output data frame from the imported
`factset_financial_data.rds` file

## Usage

``` r
prepare_financial_data(data, issue_code_bridge)
```

## Arguments

- data:

  A data frame containing the imported `factset_financial_data.rds` file

- issue_code_bridge:

  A data frame containing data that bridges from factset issue codes to
  one of `c("Listed Equity", "Corporate Bond", "Fund", "Other")`

## Value

A tibble properly prepared to be saved as the `financial_data.rds`
output file
