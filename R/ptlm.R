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

#' Calculate the Light absorption of a PAH from results of the TUV model.
#'
#' @param tuv_results data.frame of TUV results
#' @param PAH name of PAH to calculate light absorption for
#' @param time_delta the number of hours between each time step in the TUV
#'   results
#' @param time_multiplier multiplier to get the total exposure time. I.e., if
#'   the tuv_results contains 24 hours of data, and you need a 48 exposure, the
#'   multiplier would be 2. (this is the default)
#'
#' @return The value of `Pabs` for the TUV results.
#' @export
p_abs <- function(tuv_results, PAH, time_delta = 1, time_multiplier = 2) {

  if (!inherits(tuv_results, c("tuv_results", "data.frame"))) {
    stop("tuv_results must be a data.frame of class 'tuv_results'", call. = FALSE)
  }

  if (!PAH %in% molar_absorption$PAH) {
    stop(
      "PAH must be one of:\n  ",
      paste(unique(molar_absorption$PAH), collapse = "\n  "),
      call. = FALSE
    )
  }

  delta_wavelength <- max(diff(tuv_results$wl))

  # conversion constants from Appendix D of ARIS report
  unit_conversion_constant <- 3.01e-08 # (mol photon cm3)/(uW h nm L). Eq 3-2
  unit_conversion <- 100 # (uW cm-2)/(W m-2). TUV output to Eq 3-2 units

  pah_ma <- molar_absorption[
    molar_absorption$PAH == PAH,
    c("wavelength", "molar_absorption")
  ]

  tuv_results <- merge(
    tuv_results,
    pah_ma,
    by.x = "wl",
    by.y = "wavelength"
  )

  res_mat <- as.matrix(tuv_results)

  # Eq 3-2, ARIS report
  Pabs_mat <- res_mat[, grepl("t_", colnames(res_mat))] *
    res_mat[, "wl"] * # wavelength
    res_mat[, "molar_absorption"] # molar absorption of PAH

  sum(Pabs_mat) *
    unit_conversion_constant *
    unit_conversion *
    delta_wavelength *
    time_delta *
    time_multiplier
}

#' Calculate the PLC50 for a given Pabs and NLC50.
#'
#' PLC50 is the LC50 of a phototoxic PAH based on calculations of site-specific
#' or field-level light absorption.
#'
#' @param p_abs light absorption, calculated from `p_abs()`
#' @param NLC50 the narcotic toxicity (i.e., in the absence of light) of the PAH.
#'
#' @return the PLC50 of the PAH.
#' @export
#'
#' @examples
#' plc_50(590, 450)
plc_50 <- function(p_abs, NLC50) {
  #TODO: Implement eqn 2-1, ARIS report to calculate NLC50

  # a' and R' from Marzooghi et al 2017
  TLM_a	<- 0.426
  TLM_R	<- 0.511

  # Eqn 2-2, ARIS report
  NLC50 / (1 + p_abs^TLM_a/TLM_R)
}
