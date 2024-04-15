#' Convert a PACTA style quarter string to an IMF style quarter string
#'
#' @param quarter A character vector containing PACTA style quarter strings in
#'   the form e.g. "2021Q4"X
#'
#' @return A character vector containing the equivalent IMF style quarter
#'   strings e.g. "2021-Q4"
#'
#' @export

quarter_to_imf_timestamp <-
  function(quarter) {
    stopifnot(all(grepl(pattern = "20[0-9]{2}Q[1-4]", x = quarter)))
    sub("(20[0-9]{2})(Q[1-4])", "\\1-\\2", quarter)
  }
