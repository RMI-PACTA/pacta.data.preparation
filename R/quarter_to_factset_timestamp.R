#' Convert a PACTA style quarter string to a FactSet style date string for the
#' last day of that quarter
#'
#' @param quarter A character vector containing PACTA style quarter strings in
#'   the form e.g. "2021Q4"
#'
#' @return A character vector containing the equivalent FactSet style date
#'   strings for the last day of the quarter e.g. "2021-12-31"
#'
#' @export

quarter_to_factset_timestamp <-
  function(quarter) {
    stopifnot(grepl(pattern = "20[0-9]{2}Q[1-4]", x = quarter))
    as.character(quarter(lubridate::yq(quarter), type = "date_last"))
  }
