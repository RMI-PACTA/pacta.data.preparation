# Calculate the number of shares across all equity asset classes

`calc_shares_all_classes()` calculates the number of shares across all
equity asset classes. The asset class is defined by the value in
`asset_type_id`, and only asset classes included in `include_types` are
summed.

`calc_shares_all_classes()` assumes that all input values are from the
same entity/company, so a single summed value is returned. If it is
desired to calculate the shares in all classes for multiple entities at
the same time, a typical usage would be to apply this function "by" some
entity id, e.g.

`mutate(data, shares_all_classes = calc_shares_all_classes(shares_outstanding, asset_type_id), .by = "entity_id")`

For more details see
[`vignette("share_ownership_methodology")`](https://rmi-pacta.github.io/pacta.data.preparation/articles/share_ownership_methodology.md).

## Usage

``` r
calc_shares_all_classes(
  shares_outstanding,
  asset_type_id,
  include_types = c("CP", "EQ", "PF")
)
```

## Arguments

- shares_outstanding:

  (numeric vector) contains the number of shares outstanding

- asset_type_id:

  (character vector) contains an the asset type identifier

- include_types:

  (character vector) defines which of the `asset_type_id` values should
  be included in the sum

## Value

a numeric value containing the number of shares across all equity asset
classes
