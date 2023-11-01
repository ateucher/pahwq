
<!--
Copyright 2023 Province of British Columbia
&#10;Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
&#10;http://www.apache.org/licenses/LICENSE-2.0
&#10;Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
-->
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pahwq

Implementation of the Photoxic Lipid Model (PTLM) for the calculation of
Canadian Water Quality Guidelines for Polycyclic Aromatic Hydrocarbons
(PAH).

<!-- badges: start -->

[![R-CMD-check](https://github.com/ateucher/pahwq/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ateucher/pahwq/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This package uses the Tropospheric Ultraviolet and Visible (TUV)
Radiation Model (<https://github.com/NCAR/TUV>) to calculate the light
penetration through water of a given depth at a given location, with a
specified Dissolved Organic Carbon concentration. The light exposure is
then used (along with the PAH-specific molar absorption across a range
of wavelengths), to calculate the light absorption (Pabs) of the given
PAH at that location. This is then used to determine the PLC50.

## Installation

In order to install this package you will need a development toolchain
installed on your computer (specifically gfortran).

On a Mac, the easiest way to get started is to use
[Homebrew](https://brew.sh/):

    brew install gcc

On Windows, you need to install
[Rtools](https://cran.r-project.org/bin/windows/Rtools/). Make sure that
you install the appropriate version for your version of R (i.e. Rtools
4.0 for R 4.0.x, Rtools 4.3 for R 4.3.x, etc.).

This package is currently hosted in a private GitHub repository. As
such, you will need to authenticate with GitHub to be able to install
it:

``` r
install.packages(c("gitcreds", "devtools"))
```

Then, you will need to create a personal access token (PAT) on GitHub.
See [this article](https://happygitwithr.com/https-pat) for more
details.

``` r
usethis::create_github_token()
```

This will open a page in GitHub to create a new PAT. You can name it
whatever you want, but you will need to select at least the `repo` scope
for this package to install correctly.

Click “Generate Token” and copy the token that is generated. Then, run
the following command in R to save the token to your computer:

``` r
gitcreds::gitcreds_set() # Do not enter your token in the function call, you will be prompted for it.
```

When prompted, paste the token you copied from GitHub into the console.
This will save the token to your computer so that you can install the
package.

Then, install pahwq from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github(
    "ateucher/pahwq", 
    auth_token = gitcreds::gitcreds_get()$password
)
```

## Example usage

To calculate the acute phototoxic water quality guideline (PLC50) for
Anthracene at 0.25 m depth in Okanagan Lake on June 21, 2023, with a
measured DOC of 5 g/m^3, you can use the following code:

``` r
library(pahwq)

# Set the options for the TUV model run:
set_tuv_aq_params(
  depth_m = 0.25,
  lat = 49.601632,
  lon = -119.605862,
  elev_km = 0.342,
  DOC = 5,
  date = "2023-06-21",
  tzone = -8L
)

# Run the TUV model
run_tuv()

# Get the results
res <- get_tuv_results(file = "out_irrad_y")
head(res)
#>   wavelength_start wavelength_end Kd_lambda t_00.00.00 t_01.00.00 t_02.00.00
#> 1            279.5          280.5      31.5          0          0          0
#> 2            280.5          281.5      31.0          0          0          0
#> 3            281.5          282.5      30.4          0          0          0
#> 4            282.5          283.5      29.9          0          0          0
#> 5            283.5          284.5      29.3          0          0          0
#> 6            284.5          285.5      28.8          0          0          0
#>   t_03.00.00 t_04.00.00 t_05.00.00 t_06.00.00 t_07.00.00 t_08.00.00 t_09.00.00
#> 1          0   1.67e-33   5.30e-33   1.02e-32   2.55e-32   2.53e-29   1.86e-25
#> 2          0   6.22e-31   1.97e-30   3.85e-30   9.87e-30   7.49e-27   2.47e-23
#> 3          0   2.60e-28   8.25e-28   1.63e-27   4.32e-27   2.46e-24   3.58e-21
#> 4          0   7.11e-27   2.26e-26   4.48e-26   1.22e-25   5.87e-23   5.37e-20
#> 5          0   3.90e-25   1.24e-24   2.49e-24   7.03e-24   2.67e-21   1.31e-18
#> 6          0   1.39e-23   4.43e-23   9.02e-23   2.69e-22   7.79e-20   2.02e-17
#>   t_10.00.00 t_11.00.00 t_12.00.00 t_13.00.00 t_14.00.00 t_15.00.00 t_16.00.00
#> 1   3.98e-23   7.27e-22   1.83e-21   7.38e-22   4.12e-23   1.97e-25   2.78e-29
#> 2   3.32e-21   4.73e-20   1.10e-19   4.80e-20   3.42e-21   2.60e-23   8.16e-27
#> 3   2.98e-19   3.31e-18   7.13e-18   3.35e-18   3.07e-19   3.76e-21   2.66e-24
#> 4   3.40e-18   3.26e-17   6.72e-17   3.30e-17   3.50e-18   5.62e-20   6.31e-23
#> 5   5.79e-17   4.57e-16   8.87e-16   4.63e-16   5.93e-17   1.37e-18   2.85e-21
#> 6   6.12e-16   3.96e-15   7.21e-15   4.00e-15   6.25e-16   2.10e-17   8.26e-20
#>   t_17.00.00 t_18.00.00 t_19.00.00 t_20.00.00 t_21.00.00 t_22.00.00 t_23.00.00
#> 1   2.59e-32   1.03e-32   5.33e-33   1.70e-33          0          0          0
#> 2   9.99e-30   3.87e-30   1.99e-30   6.33e-31          0          0          0
#> 3   4.37e-27   1.64e-27   8.30e-28   2.65e-28          0          0          0
#> 4   1.23e-25   4.51e-26   2.27e-26   7.23e-27          0          0          0
#> 5   7.14e-24   2.50e-24   1.25e-24   3.97e-25          0          0          0
#> 6   2.73e-22   9.08e-23   4.45e-23   1.41e-23          0          0          0
#>    wl
#> 1 280
#> 2 281
#> 3 282
#> 4 283
#> 5 284
#> 6 285

# Calculate Pabs for Anthracene from the TUV results.
(Pabs <- p_abs(res, "Anthracene"))
#> [1] 426.9667

# Calculate PLC50
plc_50(Pabs, NLC50 = 450)
#> [1] 16.77217
```

### Options

pahwq creates a directory on your computer to store the TUV model input
and output files. By default, the location of this is set automatically
to a standard location (determined by `tools::R_user_dir`). You can
change the location of this directory by setting the
`pahwq.tuv_data_dir` option:

``` r
options("pahwq.tuv_data_dir" = "path/to/my/tuv/data")
```

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/pahwq/issues/).

### How to Contribute

If you would like to contribute to the package, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

### License

    Copyright 2023 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.
