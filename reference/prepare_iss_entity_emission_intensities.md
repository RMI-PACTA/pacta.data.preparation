# Prepare a `iss_entity_emission_intensities` object

Prepare a `iss_entity_emission_intensities` object

## Usage

``` r
prepare_iss_entity_emission_intensities(
  iss_company_emissions,
  factset_financial_data,
  factset_entity_info,
  factset_entity_financing_data,
  currencies
)
```

## Arguments

- iss_company_emissions:

  A data frame containing `iss_company_emissions` data

- factset_financial_data:

  A data frame containing `factset_financial_data` data

- factset_entity_info:

  A data frame containing `factset_entity_info` data

- factset_entity_financing_data:

  A data frame containing `factset_entity_financing_data` data

- currencies:

  A data frame containing currency exchange rate data

## Value

A data frame containing the prepared `iss_entity_emission_intensities`
object
