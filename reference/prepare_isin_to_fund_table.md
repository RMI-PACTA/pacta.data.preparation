# Prepare `isin_to_fund_table`, filtering out fsyms that have more than 1 row and either no fund data or fund data for both rows

Prepare `isin_to_fund_table`, filtering out fsyms that have more than 1
row and either no fund data or fund data for both rows

## Usage

``` r
prepare_isin_to_fund_table(isin_to_fund_table, fund_data)
```

## Arguments

- isin_to_fund_table:

  A data frame containing isin_to_fund_table data

- fund_data:

  A data frame containing fund data

## Value

A tibble
