# Import the data from a version of Asset Resolution's bespoke `masterdata_*.csv` files into a tidy data frame.

Import the data from a version of Asset Resolution's bespoke
`masterdata_*.csv` files into a tidy data frame.

## Usage

``` r
import_ar_masterdata(filepath, drop_nas = TRUE, id_as_string = FALSE)
```

## Arguments

- filepath:

  Path to the CSV file.

- drop_nas:

  A logical indicating whether rows with an `NA` value after pivoting to
  long-format should be dropped (deafult is `TRUE`).

- id_as_string:

  A logical indicating whether the `company_id` column should be
  imported as a character vector. By default, the `company_id` column is
  imported as a numeric (i.e. `FALSE`).

## Value

A tidy, long-format tibble of all the data in the `masterdata_*.csv`
file with an added `consolidation_method` column to record which of
"ownership" or "debt" file was imported.
