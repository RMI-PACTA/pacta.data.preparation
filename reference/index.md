# Package index

## All functions

- [`calc_shares_all_classes()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/calc_shares_all_classes.md)
  : Calculate the number of shares across all equity asset classes

- [`dataprep_abcd_scen_connection()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/dataprep_abcd_scen_connection.md)
  :

  Combine ABCD and scenario data into the
  `[equity/bonds]_abcd_scenario.rds` format that is used by
  portfolio.analysis

- [`determine_relevant_years()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/determine_relevant_years.md)
  : Determine relevant years

- [`import_ar_advanced_company_indicators()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/import_ar_advanced_company_indicators.md)
  : Import the data from a version of Asset Resolution's proprietary
  Advanced Company Indicators XLSX into a tidy data frame.

- [`import_ar_masterdata()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/import_ar_masterdata.md)
  :

  Import the data from a version of Asset Resolution's bespoke
  `masterdata_*.csv` files into a tidy data frame.

- [`prepare_abcd_flags_bonds()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_abcd_flags_bonds.md)
  : Title

- [`prepare_abcd_flags_equity()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_abcd_flags_equity.md)
  : Title

- [`prepare_ar_company_id__country_of_domicile()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_ar_company_id__country_of_domicile.md)
  :

  Prepare an `ar_company_id__country_of_domicile` lookup table from the
  `entity_info` data

- [`prepare_ar_company_id__credit_parent_ar_company_id()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_ar_company_id__credit_parent_ar_company_id.md)
  :

  Prepare an `ar_company_id__credit_parent_ar_company_id` lookup table
  from the `entity_info` data

- [`prepare_ar_company_id__sectors_with_assets__debt()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_ar_company_id__sectors_with_assets__debt.md)
  :

  Prepare an `ar_company_id__sectors_with_assets__debt` lookup table
  from the `masterdata_debt_datastore` data

- [`prepare_ar_company_id__sectors_with_assets__ownership()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_ar_company_id__sectors_with_assets__ownership.md)
  :

  Prepare an `ar_company_id__sectors_with_assets__ownership` lookup
  table from the `masterdata_ownership_datastore` data

- [`prepare_company_id__creditor_company_id()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_company_id__creditor_company_id.md)
  :

  Prepare a `company_id__creditor_company_id` lookup table from Asset
  Impact's `masterdata_debt` data

- [`prepare_entity_info()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_entity_info.md)
  :

  Prepare the `entity_info` output data frame from data frames imported
  from the `factset_entity_info.rds` and
  `ar_company_id__factset_entity_id.rds` files

- [`prepare_factset_entity_id__ar_company_id()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_factset_entity_id__ar_company_id.md)
  :

  Prepare a `factset_entity_id__ar_company_id` lookup table from Asset
  Impact's `ar_company_id__factset_entity_id` crosswalk

- [`prepare_factset_entity_id__credit_parent_id()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_factset_entity_id__credit_parent_id.md)
  :

  Prepare a `factset_entity_id__credit_parent_id` lookup table from
  `entity_info`

- [`prepare_factset_entity_id__security_mapped_sector()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_factset_entity_id__security_mapped_sector.md)
  :

  Prepare a `factset_entity_id__security_mapped_sector` lookup table
  from `entity_info`

- [`prepare_financial_data()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_financial_data.md)
  :

  Prepare the `financial_data` output data frame from the imported
  `factset_financial_data.rds` file

- [`prepare_fund_data()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_fund_data.md)
  :

  Prepare fund data, filtering to funds with data according to a given
  threshold and adding a `MISSINGWEIGHT` holding for the difference

- [`prepare_isin_to_fund_table()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_isin_to_fund_table.md)
  :

  Prepare `isin_to_fund_table`, filtering out fsyms that have more than
  1 row and either no fund data or fund data for both rows

- [`prepare_iss_average_sector_emission_intensities()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_iss_average_sector_emission_intensities.md)
  :

  Prepare a `iss_average_sector_emission_intensities` object

- [`prepare_iss_company_emissions()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_iss_company_emissions.md)
  :

  Prepare an `iss_company_emissions` object from
  `factset_iss_emissions_data`

- [`prepare_iss_entity_emission_intensities()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_iss_entity_emission_intensities.md)
  :

  Prepare a `iss_entity_emission_intensities` object

- [`prepare_masterdata()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_masterdata.md)
  :

  Prepare the `masterdata_ownership_datastore` or
  `masterdata_debt_datastore` output data frame from an import of a raw
  AR masterdata\_\* CSV

- [`prepare_masterdata_debt()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_masterdata_debt.md)
  :

  Prepare the `masterdata_debt_datastore` object from a raw
  masterdata_debt CSV

- [`prepare_total_fund_list()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/prepare_total_fund_list.md)
  :

  Prepare a `total_fund_list` object from `fund_data`

- [`quarter_to_factset_timestamp()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/quarter_to_factset_timestamp.md)
  : Convert a PACTA style quarter string to a FactSet style date string
  for the last day of that quarter

- [`quarter_to_imf_timestamp()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/quarter_to_imf_timestamp.md)
  : Convert a PACTA style quarter string to an IMF style quarter string

- [`standardize_asset_type_names()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/standardize_asset_type_names.md)
  : Standardize asset type names

- [`write_manifest()`](https://rmi-pacta.github.io/pacta.data.preparation/reference/write_manifest.md)
  : Write a manifest.json file to the specified path including critical
  information about the files and parameters used to prepare the data
