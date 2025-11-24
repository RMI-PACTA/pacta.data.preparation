# Convert a PACTA style quarter string to a FactSet style date string for the last day of that quarter

Convert a PACTA style quarter string to a FactSet style date string for
the last day of that quarter

## Usage

``` r
quarter_to_factset_timestamp(quarter)
```

## Arguments

- quarter:

  A character vector containing PACTA style quarter strings in the form
  e.g. "2021Q4"

## Value

A character vector containing the equivalent FactSet style date strings
for the last day of the quarter e.g. "2021-12-31"
