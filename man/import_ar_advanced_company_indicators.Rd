% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_ar_advanced_company_indicators.R
\name{import_ar_advanced_company_indicators}
\alias{import_ar_advanced_company_indicators}
\title{Import the data from a version of Asset Resolution's proprietary Advanced
Company Indicators XLSX into a tidy data frame.}
\usage{
import_ar_advanced_company_indicators(
  filepath,
  drop_nas = TRUE,
  fix_names = FALSE,
  as_factor = TRUE
)
}
\arguments{
\item{filepath}{Path to the XLSX file.}

\item{drop_nas}{A logical indicating whether rows with an \code{NA} value after
pivoting to long-format should be dropped (default is \code{TRUE}).}

\item{fix_names}{A logical indicating whether the column names should be
fixed to snakecase format. (e.g. \verb{Company Name} becomes \code{company_name}). By
default, column names are not changed (i.e. \code{FALSE}).}

\item{as_factor}{A logical indicating whether the character columns should be
converted to factors(default is \code{TRUE}).}
}
\value{
A tibble including all the data from the "Company Information",
"Company ISINs", "Company Emissions", and "Company Activities" tabs
combined into one tidy tibble.
}
\description{
Import the data from a version of Asset Resolution's proprietary Advanced
Company Indicators XLSX into a tidy data frame.
}
