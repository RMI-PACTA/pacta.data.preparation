# Import the data from a version of Asset Resolution's proprietary Advanced Company Indicators XLSX into a tidy data frame.

Import the data from a version of Asset Resolution's proprietary
Advanced Company Indicators XLSX into a tidy data frame.

## Usage

``` r
import_ar_advanced_company_indicators(
  filepath,
  drop_nas = TRUE,
  fix_names = FALSE,
  as_factor = TRUE
)
```

## Arguments

- filepath:

  Path to the XLSX file.

- drop_nas:

  A logical indicating whether rows with an `NA` value after pivoting to
  long-format should be dropped (default is `TRUE`).

- fix_names:

  A logical indicating whether the column names should be fixed to
  snakecase format. (e.g. `Company Name` becomes `company_name`). By
  default, column names are not changed (i.e. `FALSE`).

- as_factor:

  A logical indicating whether the character columns should be converted
  to factors(default is `TRUE`).

## Value

A tibble including all the data from the "Company Information", "Company
ISINs", "Company Emissions", and "Company Activities" tabs combined into
one tidy tibble.
