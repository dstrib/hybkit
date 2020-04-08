#!/usr/bin/env sh
# Daniel B. Stribling
# Renne Lab, University of Florida
# Hybkit Project : http://www.github.com/RenneLab/hybkit

# Analysis for summary_analysis pipeline performed as a shell script.

# This is provided as an example of a pipeline utilizing the hybkit toolkit.
# File names are accessed dynamically, and system calls are made using hybkit functions.
# See: "summary_analysis_notes.rst" for more information.

# Set script directories and input file names.
ANALYSIS_DIR="."          # Uses Relative Paths
# ANALYSIS_DIR="$(pwd)"   # Uses Absolute Paths

OUT_DIR="${ANALYSIS_DIR}/output"
COMMAND_LOG="${OUT_DIR}/shell_command_log.txt"
MATCH_LEGEND_FILE="${ANALYSIS_DIR}/string_match_legend.csv"

#INPUTS="$(find ${ANALYSIS_DIR} -name 'GSM*BR1.hyb' -print)"
#INPUTS="$(ls ${ANALYSIS_DIR}/GSM*BR1.hyb)"
for f in ${ANALYSIS_DIR}/GSM*BR1.hyb
do
  INPUTS="${INPUTS} $f"
done

# Begin Analysis
echo ""
echo "Performing QC & Summary Analysis..."
echo "" 

# Create Output Directory if Needed.
if [ ! -d "${OUT_DIR}" ]
then
    echo "Creating Output Directory: ${OUT_DIR}"
    mkdir -v ${OUT_DIR}
    echo ""
fi

echo "Saving Commands to Log File: ${COMMAND_LOG}"
echo ""
echo "" > "${COMMAND_LOG}"


echo "Analyzing Files:"
for f in ${INPUTS}
do
  echo "    ${f}"
done
echo ""

# -t segtype mirna  -->  Do a segtype and a mirna analysis.
# --segtype_method string_match  -->  Use the string_match segment finding type, 
#   as there are non-hyb-format references used.
# --segtype_params ${MATCH_LEGEND_FILE} use custome legend file, that includes 
#   types for KSHV sequences
# --mirna_types miRNA microRNA kshv_microRNA  -->  Assign these three types as miRNA,
#   (instead of the default {miRNA microRNA})

# Setup Analysis Command
HYB_ANALYZE_COMMAND="hyb_analyze -i ${INPUTS} --out_dir ${OUT_DIR} -t segtype mirna \
--segtype_method string_match  --segtype_params ${MATCH_LEGEND_FILE} \
--mirna_types miRNA microRNA kshv_microRNA \
--hybformat_id True --verbose"

# Run Analysis Command
echo "Running Command:"
echo "    ${HYB_ANALYZE_COMMAND}"
echo ""
echo "${HYB_ANALYZE_COMMAND}" >> "${COMMAND_LOG}"
#eval "${HYB_ANALYZE_COMMAND}"

# Setup Filtering Input Files
for f in ${INPUTS}
do
  ANALYZED_INPUT="${f/.hyb/_analyzed.hyb}"
  ANALYZED_INPUT="${ANALYZED_INPUT/.\//${OUT_DIR}/}"
  ANALYZED_INPUTS="${ANALYZED_INPUTS} ${ANALYZED_INPUT}"
done

echo "Filtering Files:"
for f in ${ANALYZED_INPUTS}
do
  echo "    ${f}"
done
echo ""

# Setup Filter Command
# --out_suffix _qc  -->  Name the output files using [base]_qc.hyb 
#   to indicate what was specifically done.
# --exclude seg_type rRNA  -->  Exclude segment types matching rRNA
# --exclude_2 seg_type mitoch_rRNA  -->  Exclude segment types matching mitoch_rRNA

HYB_FILTER_COMMAND="hyb_filter -i ${ANALYZED_INPUTS} --out_dir ${OUT_DIR} \
--out_suffix _qc \
--exclude seg_type rRNA --exclude_2 seg_type mitoch_rRNA --verbose"

# Run Filter Command
echo "Running Command:"
echo "    ${HYB_FILTER_COMMAND}"
echo ""
echo "${HYB_FILTER_COMMAND}" >> "${COMMAND_LOG}"
#eval "${HYB_FILTER_COMMAND}"


# Setup Summary_Analysis Input Files
for f in ${ANALYZED_INPUTS}
do
  FILTERED_INPUT="${f/.hyb/_qc.hyb}"
  FILTERED_INPUTS="${FILTERED_INPUTS} ${FILTERED_INPUT}"
done

echo "Performing Summary Analysis on Files:"
for f in ${FILTERED_INPUTS}
do
  echo "    ${f}"
done
echo ""



# Setup Summary_Analysis Command
HYB_SUMMARY_ANALYSIS_COMMAND="hyb_type_analysis -i ${FILTERED_INPUTS} --out_dir ${OUT_DIR} \
--write_multi_files True --write_combined True --verbose"

# Run Summary_Analysis Command
echo "Running Command:"
echo "    ${HYB_SUMMARY_ANALYSIS_COMMAND}"
echo ""
echo "${HYB_SUMMARY_ANALYSIS_COMMAND}" >> "${COMMAND_LOG}"
eval "${HYB_SUMMARY_ANALYSIS_COMMAND}"



