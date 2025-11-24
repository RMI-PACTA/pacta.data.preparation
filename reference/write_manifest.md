# Write a manifest.json file to the specified path including critical information about the files and parameters used to prepare the data

Write a manifest.json file to the specified path including critical
information about the files and parameters used to prepare the data

## Usage

``` r
write_manifest(path, parameters, input_files, output_files)
```

## Arguments

- path:

  A single string specifying a filepath to save the JSON file to

- parameters:

  A list containing all parameters used to create the data

- input_files:

  A vector with filepaths of input files used to create the output data.

- output_files:

  A vector with filepaths of output files created.

## Value

Called for the side-effect of writing a JSON file to disk
