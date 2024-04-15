# pacta.data.preparation 0.1.0.9003

* Gained functions `prepare_abcd_flags_equity()` and `prepare_abcd_flags_debt()` to prepare  (#353).

* Gained function `prepare_isin_to_fund_table()` to prepare an isin-to-fund lookup table, filtering out fsyms that have more than 1 row and either no fund data or fund data for both rows (#352).

* Gained function `prepare_fund_data()` to prepare fund data, filtering to funds with data according to a given threshold and adding a `MISSINGWEIGHT` holding for the difference (#325).

* added numerous, minor `prepare_*()` functions (#348).

* `import_ar_advanced_company_indicators()` output now includes all parental attributes from the "Company Ownership" tab (#344).

* `import_ar_advanced_company_indicators()` gains an `as_factor` arg to specify whether or not character columns should be auto-converted to factor (default `TRUE`, maintaining previous behavior) (#345).

* *breaking change* - `write_manifest()` now takes a pair of vectors with filepaths to input and output files, rather than a set of directories (#340).

# pacta.data.preparation 0.1.0.9002

* *breaking change* - `prepare_entity_info()` has a new mandatory argument `factset_manual_pacta_sector_override` because the internally accessible `factset_manual_pacta_sector_override` has been removed (#338).

* *breaking change* - `factset_manual_pacta_sector_override` has been removed and is now exported by [workflow.factset](https://github.com/RMI-PACTA/workflow.factset) (#338).

* *breaking change* - `prepare_entity_info()` has a new mandatory argument `factset_industry_map_bridge` because the internally accessible  `factset_industry_map_bridge` has been removed (#336).

* *breaking change* - `factset_industry_map_bridge` has been removed and is now exported by [workflow.factset](https://github.com/RMI-PACTA/workflow.factset) (#336). 

* `factset_issue_code_bridge` has been removed and is now exported by [workflow.factset](https://github.com/RMI-PACTA/workflow.factset) (#335). 

* *breaking change* - `write_manifest()` arguments have changed to allow passing an input directory specifically for FactSet data

* FactSet database connection functions have been removed and migrated to https://github.com/RMI-PACTA/workflow.factset

* release version of {dbplyr} 2.4.0 or greater is now required

* `import_ar_advanced_company_indicators()` now also imports the `is_ultimate_listed_parent` column (only for individual companies, not the entire ownership tree, e.g. `` `Ownership Level` == 0``) from the somewhat new "Company Ownership" tab. This breaks compatibility with older PAMS datasets that do not have this tab.

# pacta.data.preparation 0.1.0

* Gained functions `quarter_to_factset_timestamp()` and `quarter_to_imf_timestamp()`, that convert PACTA style quarter string references (e.g. "2021Q4") to the equivalent FactSet and IMF references (e.g. "2021-12-31" and "2021-Q4" respectively)

* Data scraping functions (`get_currency_exchange_rates()`, `get_ishares_index_data()`, `process_ishares_index_data()`, and `index_regions`) have been removed and extracted to a new [{pacta.data.scraping} package](https://github.com/RMI-PACTA/pacta.data.scraping)

* Gained functions: (`get_factset_entity_financing_data()`, `get_factset_entity_info()`, `get_factset_financial_data()`, `get_factset_fund_data()`, `get_factset_isin_to_fund_table()`, `get_factset_iss_emissions_data()`, `write_manifest()`, and `dataprep_abcd_scen_connection()`)

* `prepare_masterdata` gained functionality to handle Power technologies both with and without `"Cap` suffix (#285). 

* `factset_issue_code_bridge` gained updated mapping of FactSet `asset_type_code` to PACTA `asset_type` (#261). 

* Several changes to facilitate a new share ownership methodology: (#268)
  * `one_adr_eq` value from the `own_v5_own_sec_adr_ord_ratio` table is included in the `get_factset_financial_data()` output
  * new function `calc_shares_all_classes()` added
  * `prepare_financial_data()` now calculates and exports `current_shares_outstanding_all_classes` column according to the new share ownership methodology, summing the outstanding shares of all relevant equity classes for a given entity
  * now depends on dplyr (>= 1.1.0)
  * {knitr} and {rmarkdown} have been added to Suggests to support vignette rendering
  * new "Share ownership weight attribution method" vignette. see `vignette("share_ownership_methodology")`

* Workflow script and Dockerfile removed/extracted into a new [workflow.data.preparation](https://github.com/RMI-PACTA/workflow.data.preparation) repo.

* Bond roll-up is now calculated. Holdings are roll-ed up with priority to the FactSet defined credit parent, followed by the AI defined credit parent (#243). 

* Gained functions `prepare_masterdata`, `prepare_financial_data` and `prepare_entity_info` (#235, #236, #237).

# pacta.data.preparation 0.0.1

* Added a `NEWS.md` file to track changes to the package.
