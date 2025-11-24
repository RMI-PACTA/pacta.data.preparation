# Prepare fund data, filtering to funds with data according to a given threshold and adding a `MISSINGWEIGHT` holding for the difference

Prepare fund data, filtering to funds with data according to a given
threshold and adding a `MISSINGWEIGHT` holding for the difference

## Usage

``` r
prepare_fund_data(fund_data, threshold = 0)
```

## Arguments

- fund_data:

  A data frame containing fund data

- threshold:

  A numeric value between 0 and 1 (inclusive) indicating the allowable
  percentage of the total fund value that the summed values of its
  component holdings should be equal to or greater than

## Value

A tibble
