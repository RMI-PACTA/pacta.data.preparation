test_that("with known input, outputs as expected", {
  entity_info <- fake_entity_info(
    factset_entity_id = "002KY7-E",
    security_mapped_sector = "Other"
  )

  sector_override <- dplyr::tibble(
    factset_entity_id = "002KY7-E",
    pacta_sector_override = "Power"
  )

  out <- override_sector_by_factset_entity_id(entity_info, sector_override)

  expect_equal(out$security_mapped_sector, "Power")
})

test_that("with no matching factset_entity_id, outputs original sector", {
  entity_info <- fake_entity_info(
    factset_entity_id = "002KY7-E",
    security_mapped_sector = "Other"
  )

  sector_override <- dplyr::tibble(
    factset_entity_id = "Bad",
    pacta_sector_override = "Power"
  )

  out <- override_sector_by_factset_entity_id(entity_info, sector_override)

  expect_equal(out$security_mapped_sector, "Other")
})

test_that("only modifies sector of matched entity", {
  entity_info <- fake_entity_info(
    factset_entity_id = c("002KY7-E", "Other"),
    security_mapped_sector = "Other"
  )

  sector_override <- dplyr::tibble(
    factset_entity_id = "002KY7-E",
    pacta_sector_override = "Power"
  )

  out <- override_sector_by_factset_entity_id(entity_info, sector_override)

  expect_equal(out$security_mapped_sector, c("Power", "Other"))
})
