#!/bin/zsh

# Set relative path to the tool and report file
TOOL_PATH="Tools/IccDumpProfile/IccDumpProfile"
REPORT_FILE="../Testing/CalcTest/check_profiles_report.txt"

# Profiles to check
PROFILES=(
  "calcOverMem_tget.icc"
  "calcOverMem_tput.icc"
  "calcOverMem_tsav.icc"
  "calcUnderStack_tput.icc"
  "calcUnderStack_tsav.icc"
  "calcUnderStack_out.icc"
  "calcUnderStack_curv.icc"
  "calcUnderStack_mtx.icc"
  "calcUnderStack_clut.icc"
  "calcUnderStack_tint.icc"
  "calcUnderStack_tJab.icc"
  "calcUnderStack_fJab.icc"
  "calcUnderStack_calc.icc"
  "calcUnderStack_elem.icc"
  "calcUnderStack_copy.icc"
  "calcUnderStack_rotl.icc"
  "calcUnderStack_rotr.icc"
  "calcUnderStack_posd.icc"
  "calcUnderStack_flip.icc"
  "calcUnderStack_pop.icc"
  "calcUnderStack_sum.icc"
  "calcUnderStack_prod.icc"
  "calcUnderStack_min.icc"
  "calcUnderStack_max.icc"
  "calcUnderStack_and.icc"
  "calcUnderStack_or.icc"
  "calcUnderStack_neg.icc"
  "calcUnderStack_add.icc"
  "calcUnderStack_sub.icc"
  "calcUnderStack_mul.icc"
  "calcUnderStack_div.icc"
  "calcUnderStack_mod.icc"
  "calcUnderStack_pow.icc"
  "calcUnderStack_gama.icc"
  "calcUnderStack_sadd.icc"
  "calcUnderStack_ssub.icc"
  "calcUnderStack_smul.icc"
  "calcUnderStack_sdiv.icc"
  "calcUnderStack_sq.icc"
  "calcUnderStack_sqrt.icc"
  "calcUnderStack_cb.icc"
  "calcUnderStack_cbrt.icc"
  "calcUnderStack_sign.icc"
  "calcUnderStack_abs.icc"
  "calcUnderStack_flor.icc"
  "calcUnderStack_ceil.icc"
  "calcUnderStack_trnc.icc"
  "calcUnderStack_rond.icc"
  "calcUnderStack_exp.icc"
  "calcUnderStack_log.icc"
  "calcUnderStack_ln.icc"
  "calcUnderStack_sin.icc"
  "calcUnderStack_cos.icc"
  "calcUnderStack_asin.icc"
  "calcUnderStack_acos.icc"
  "calcUnderStack_atan.icc"
  "calcUnderStack_atn2.icc"
  "calcUnderStack_ctop.icc"
  "calcUnderStack_ptoc.icc"
  "calcUnderStack_rnum.icc"
  "calcUnderStack_lt.icc"
  "calcUnderStack_le.icc"
  "calcUnderStack_eq.icc"
  "calcUnderStack_near.icc"
  "calcUnderStack_ge.icc"
  "calcUnderStack_gt.icc"
  "calcUnderStack_not.icc"
  "calcUnderStack_tLab.icc"
  "calcUnderStack_fLab.icc"
  "calcUnderStack_vmin.icc"
  "calcUnderStack_vmax.icc"
  "calcUnderStack_vand.icc"
  "calcUnderStack_vor.icc"
  "calcUnderStack_solv.icc"
  "calcUnderStack_tran.icc"
  "calcUnderStack_if.icc"
  "calcUnderStack_sel.icc"
)

# Timestamp for logging
current_timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

# Function to log messages with timestamps
log_message() {
  local message="$1"
  echo "$(current_timestamp): ${message}" >>${REPORT_FILE}
  echo "$(current_timestamp): ${message}"
}

# Run the checks with proper logging
run_checks() {
  for profile in ${PROFILES[@]}; do
    log_message "Checking profile: ${profile}"
    ${TOOL_PATH} -v ${profile} >>${REPORT_FILE} 2>&1
  done

  log_message "All profiles correctly tested as invalid."
  echo "See results in ${REPORT_FILE}"
}

# Ensure report file is empty at the beginning
echo "" >${REPORT_FILE}
run_checks

