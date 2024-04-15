#' Write a manifest.json file to the specified path including critical
#' information about the files and parameters used to prepare the data
#'
#' @param path A single string specifying a filepath to save the JSON file to
#' @param parameters A list containing all parameters used to create the data
#' @param input_files A vector with filepaths of input files used to create the
#' output data.
#' @param output_files A vector with filepaths of output files created.
#'
#' @return Called for the side-effect of writing a JSON file to disk
#'
#' @export

write_manifest <- function(
  path,
  parameters,
  input_files,
  output_files
) {
    list(
      parameters = parameters,
      inputs_manifest = get_info_for_files(input_files),
      outputs_manifest = get_info_for_files(output_files),
      git = list(
        local_git_tag = get_local_git_tag(),
        local_git_hash = get_local_git_hash(),
        local_git_status = get_local_git_status()
      ),
      sessionInfo = get_sessionInfo(),
      creation_time_date = format(Sys.time(), "%F %R", tz = "UTC", usetz = TRUE)
    ) %>%
      jsonlite::write_json(
        path = path,
        pretty = TRUE,
        auto_unbox = TRUE
      )
  }


get_info_for_files <-
  function(file_paths) {
    get_file_info <-
      function(file_path) {
        list(
          list(
            "file name" = basename(file_path),
            "file extension" = tools::file_ext(file_path),
            "file path" = file_path,
            "file size" = format(structure(file.info(file_path)$size, class = "object_size"), units = "auto", standard = "SI"),
            "file last modified" = format(as.POSIXlt(file.info(file_path)$mtime, tz = "UTC"), "%Y-%m-%dT%H:%M:%S+00:00"),
            "filehash" = cli::hash_file_md5(paths = file_path)
          )
        )
      }

    output <- vapply(X = file_paths, FUN = get_file_info, FUN.VALUE = list(1), USE.NAMES = TRUE)
    setNames(output, basename(file_paths))
  }


get_sessionInfo <-
  function() {
    session_info <- devtools::session_info(pkgs = "attached", info = "all")
    list(
      platform = unclass(session_info$platform),
      packages = as.data.frame(unclass(session_info$packages)),
      external = unclass(session_info$external)
    )
  }


is_git_repo <- function(dir = ".") {
  system2("git", args = c(paste("-C", dir), "status"), stderr = FALSE, stdout = FALSE) == 0
}


get_local_git_hash <- function(repo = ".") {
  if (is_git_repo(repo)) {
    response <-
      suppressWarnings(
        system2(
          "git",
          args = c(paste("-C", repo), "log", "-1", "--pretty=format:'%H'"),
          stdout = TRUE,
          stderr = FALSE
        )
      )
    if (length(response) > 0) {
      return(response)
    }
    return("no git hashes found")
  }
  "not a git repo"
}


get_local_git_tag <- function(repo = ".") {
  if (is_git_repo(repo)) {
    response <-
      suppressWarnings(
        system2(
          "git",
          args = c(paste("-C", repo), "describe", "--tags", "--abbrev=0"),
          stdout = TRUE,
          stderr = FALSE
        )
      )
    if (length(response) > 0) {
      return(response)
    }
    return("no git tags found")
  }
  "not a git repo"
}


get_local_git_status <- function(repo = ".") {
  if (is_git_repo(repo)) {
    response <-
      suppressWarnings(
        system2(
          "git",
          args = c(paste("-C", repo), "status", "--short", "--", "config.yml", "run_pacta_data_preparation.R", "DESCRIPTION"),
          stdout = TRUE,
          stderr = FALSE
        )
      )
    if (length(response) > 0) {
      return(
        dplyr::tibble(response) %>%
          tidyr::separate(
            col = 1,
            into = c("status", "filename"),
            sep = " ",
            extra = "merge"
          )
      )
    }
    return("git status is clean")
  }
  "not a git repo"
}
