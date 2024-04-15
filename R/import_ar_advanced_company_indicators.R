#' Import the data from a version of Asset Resolution's proprietary Advanced
#' Company Indicators XLSX into a tidy data frame.
#'
#' @param filepath Path to the XLSX file.
#' @param drop_nas A logical indicating whether rows with an `NA` value after
#'   pivoting to long-format should be dropped (default is `TRUE`).
#' @param fix_names A logical indicating whether the column names should be
#'   fixed to snakecase format. (e.g. `Company Name` becomes `company_name`). By
#'   default, column names are not changed (i.e. `FALSE`).
#' @param as_factor A logical indicating whether the character columns should be
#'   converted to factors(default is `TRUE`).
#'
#' @return A tibble including all the data from the "Company Information",
#'   "Company ISINs", "Company Emissions", and "Company Activities" tabs
#'   combined into one tidy tibble.
#'
#' @export

import_ar_advanced_company_indicators <-
  function(filepath, drop_nas = TRUE, fix_names = FALSE, as_factor = TRUE) {
    stopifnot(
      is.character(filepath),
      file.exists(filepath),
      file.access(filepath, mode = 4) == 0,
      is.logical(drop_nas),
      is.logical(fix_names)
    )

    stopifnot(
      requireNamespace("readxl", quietly = TRUE),
      !is.na(readxl::excel_format(filepath))
    )

    sheet_names <- readxl::excel_sheets(path = filepath)

    stopifnot(
      "Company Information" %in% sheet_names,
      "Company Ownership" %in% sheet_names,
      "Company ISINs" %in% sheet_names,
      "Company Emissions" %in% sheet_names,
      "Company Activities" %in% sheet_names
    )

    company_info <-
      readxl::read_excel(path = filepath, sheet = "Company Information") %>%
      select(-"Is Ultimate Parent") # also included in "Company Ownership" tab

    company_ownership <-
      readxl::read_excel(path = filepath, sheet = "Company Ownership") %>%
      filter(.data$`Ownership Level` == 0) %>%
      select(
        "Company ID",
        dplyr::any_of(c(
          "Is Parent",
          "Is Credit Parent",
          "Is Ultimate Parent",
          "Is Ultimate Listed Parent"
        ))
      )

    company_isins <-
      readxl::read_excel(path = filepath, sheet = "Company ISINs") %>%
      group_by(.data$`Company ID`) %>%
      summarise(ISINs = list(.data$ISIN))

    company_emissions <-
      readxl::read_excel(path = filepath, sheet = "Company Emissions") %>%
      pivot_longer(
        cols = dplyr::matches(" [0-9]{4}$"),
        names_to = c("consolidation_method", "year"),
        names_pattern = "^(.*) (20[0-9]{2})$",
        names_transform = list("year" = as.integer),
        values_to = "value",
        values_ptypes = numeric(),
        values_drop_na = drop_nas
      ) %>%
      mutate(value_type = "emission_intensity", .before = "year") %>%
      select(-"Company Name")

    company_activities <-
      readxl::read_excel(path = filepath, sheet = "Company Activities") %>%
      pivot_longer(
        cols = dplyr::matches(" [0-9]{4}$"),
        names_to = c("consolidation_method", "year"),
        names_pattern = "^(.*) (20[0-9]{2})$",
        names_transform = list("year" = as.integer),
        values_to = "value",
        values_ptypes = numeric(),
        values_drop_na = drop_nas
      ) %>%
      mutate(value_type = "production", .before = "year") %>%
      select(-"Company Name")

    output <-
      company_info %>%
      dplyr::full_join(company_ownership, by = "Company ID") %>%
      dplyr::full_join(company_isins, by = "Company ID") %>%
      dplyr::right_join(
        dplyr::bind_rows(company_emissions, company_activities),
        by = "Company ID"
      )

    if (fix_names) {
      names(output) <- gsub(" ", "_", tolower(names(output)))
    }

    if (as_factor) {
      output <- mutate(output, across(where(is.character), as.factor))
    }

    output
  }


#' Import the data from a version of Asset Resolution's bespoke
#' `masterdata_*.csv` files into a tidy data frame.
#'
#' @param filepath Path to the CSV file.
#' @param drop_nas A logical indicating whether rows with an `NA` value after
#'   pivoting to long-format should be dropped (deafult is `TRUE`).
#' @param id_as_string A logical indicating whether the `company_id` column
#'   should be imported as a character vector. By default, the `company_id`
#'   column is imported as a numeric (i.e. `FALSE`).
#'
#' @return A tidy, long-format tibble of all the data in the `masterdata_*.csv`
#'   file with an added `consolidation_method` column to record which of
#'   "ownership" or "debt" file was imported.
#'
#' @export

import_ar_masterdata <-
  function(filepath, drop_nas = TRUE, id_as_string = FALSE) {
    stopifnot(
      is.character(filepath),
      file.exists(filepath),
      file.access(filepath, mode = 4) == 0,
      is.logical(drop_nas),
      is.logical(id_as_string)
    )

    stopifnot(
      requireNamespace("readr", quietly = TRUE)
    )

    col_spec <-
      readr::cols(
        company_id = if_else(id_as_string, "c", "d"),
        .default = "?"
      )

    readr::read_csv(
      file = filepath,
      na = "",
      col_types = col_spec
    ) %>%
      pivot_longer(
        cols = dplyr::matches("^_20[0-9]{2}$"),
        names_to = "year",
        names_prefix = "_",
        names_transform = list(year = as.integer),
        values_to = "value",
        values_ptypes = numeric(),
        values_drop_na = drop_nas
      ) %>%
      mutate(
        consolidation_method = sub(pattern = "^.*masterdata_(.*)_.*$", "\\1", basename(filepath)),
        .before = "year"
      )
  }
