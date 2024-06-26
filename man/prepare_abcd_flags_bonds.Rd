% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_abcd_flags_bonds.R
\name{prepare_abcd_flags_bonds}
\alias{prepare_abcd_flags_bonds}
\title{Title}
\usage{
prepare_abcd_flags_bonds(
  financial_data,
  factset_entity_id__ar_company_id,
  factset_entity_id__security_mapped_sector,
  ar_company_id__sectors_with_assets__debt,
  factset_entity_id__credit_parent_id
)
}
\arguments{
\item{financial_data}{A data frame containing financial data}

\item{factset_entity_id__ar_company_id}{A data frame containing a
factset_entity_id to ar_company_id look up table}

\item{factset_entity_id__security_mapped_sector}{A data frame containing a
factset_entity_id to security_mapped_sector look up table}

\item{ar_company_id__sectors_with_assets__debt}{A data frame containing
a ar_company_id to sectors_with_assets look up table for debt}

\item{factset_entity_id__credit_parent_id}{A data frame containing a
factset_entity_id to credit_parent_id look up table}
}
\value{
A data frame
}
\description{
Title
}
