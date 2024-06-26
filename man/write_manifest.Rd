% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_manifest.R
\name{write_manifest}
\alias{write_manifest}
\title{Write a manifest.json file to the specified path including critical
information about the files and parameters used to prepare the data}
\usage{
write_manifest(path, parameters, input_files, output_files)
}
\arguments{
\item{path}{A single string specifying a filepath to save the JSON file to}

\item{parameters}{A list containing all parameters used to create the data}

\item{input_files}{A vector with filepaths of input files used to create the
output data.}

\item{output_files}{A vector with filepaths of output files created.}
}
\value{
Called for the side-effect of writing a JSON file to disk
}
\description{
Write a manifest.json file to the specified path including critical
information about the files and parameters used to prepare the data
}
