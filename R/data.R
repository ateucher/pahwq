# Copyright 2023 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#' Molar absorption coefficients for multiple PAHs at different wavelengths.
#'
#' The data were taken from Table S5-a and S5-b: Molar absorption spectra
#' \eqn{\epsilon}(\eqn{\lambda}) at different wavelength \eqn{\lambda} (nm) in:
#'
#' Marzooghi, S., Finch, B. E., Stubblefield, W. A., Dmitrenko, O., Neal, S. L.,
#' & Di Toro, D. M. (2017). Phototoxic target lipid model of single polycyclic
#' aromatic hydrocarbons. Environmental toxicology and chemistry, 36(4),
#' 926-937.
#'
#' @format ## `molar_absorption` A data frame with 2640 rows and 3 columns: One
#'   column for `wavelength` (nm), a column for PAH, and a column with molar
#'   absorption coefficients for each PAH at each wavelength. Units are (L*mol/cm).
#' @source < https://doi.org/10.1002/etc.3601>
"molar_absorption"
