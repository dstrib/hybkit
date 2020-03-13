#!/usr/bin/env sh
# Daniel B. Stribling
# Renne Lab, University of Florida
# Hybkit Project : http://www.github.com/RenneLab/hybkit

# Analysis for summary_analysis pipeline performed as a shell script.

# This is provided as an example of a pipeline utilizing the hybkit toolkit.
# File names are accessed dynamically, and system calls are made using hybkit functions.
# See: "summary_analysis_notes.rst" for more information.

# Set script directories and input file names.
ANALYSIS_DIR="."
# ANALYSIS_DIR="$(pwd)"

OUT_DIR="${ANALYSIS_DIR}/output"
MATCH_LEGEND_FILE="${ANALYSIS_DIR}/string_match_legend.csv"

#INPUTS="$(find ${ANALYSIS_DIR} -name 'GSM*BR1.hyb' -print)"
INPUTS="$(ls ${ANALYSIS_DIR}/GSM*BR1.hyb)"

# Begin Analysis
echo ""
echo "Performing QC & Summary Analysis..."
echo "" 

if [ ! -d "${OUT_DIR}" ]
then
    echo "Creating Output Directory: ${OUT_DIR}"
    mkdir -v ${OUT_DIR}
    echo ""
fi

# Display Working Files
echo "Analyzing Files:"
for f in ${INPUTS}
do
  echo "    ${f}"
  LINE_INPUTS="${LINE_INPUTS} ${f}"
done
echo ""

# Setup Command
HYB_ANALYZE_COMMAND="hyb_analyze -i ${LINE_INPUTS} --out_dir ${OUT_DIR} \
--segtype_method string_match  --segtype_params ${MATCH_LEGEND_FILE} --hybformat_id True --verbose"

echo "Running Command:"
echo "    ${HYB_ANALYZE_COMMAND}"
echo ""
eval "${HYB_ANALYZE_COMMAND}"

exit

hyb_filter

# # Set hybrid segment types to remove as part of quality control [QC]
# remove_types = ['rRNA', 'mitoch_rRNA']
# 
# # Iterate over each input file, find the segment types, and save the output 
# #   in the output directory.
# for in_file_path in input_files:
#     in_file_name = os.path.basename[in_file_path]
#     in_file_label = in_file_name.replace['.hyb', '']
#     out_file_name = in_file_name.replace['.hyb', '_qc.hyb']
#     out_file_path = os.path.join[out_dir, out_file_name]
# 
#     print['Analyzing:\n    %s' % in_file_path]
#     print['Outputting to:\n    %s\n' % out_file_path]
# 
#     # Open one HybFile entry for reading, and one for writing
#     with hybkit.HybFile[in_file_path, 'r'] as in_file, \
#          hybkit.HybFile[out_file_path, 'w'] as out_file:
# 
#         # Iterate over each record of the input file
#         for hyb_record in in_file:
#             # Find the segments type of each record
#             hyb_record.find_seg_types[]
# 
#             # Determine if record has type that is excluded
#             use_record = True
#             for remove_type in remove_types:
#                 if hyb_record.has_property['seg_type', remove_type]:
#                     use_record = False
#                     break
# 
#             # If record has an excluded type, continue to next record without analyzing.
#             if not use_record:
#                 continue 
# 
#             # Perform record analysis
#             hyb_record.mirna_analysis[]
# 
#             # Add summary_analysis details to analysis_dict, using record numbers for counts
#             hybkit.analysis.addto_summary[hyb_record,
#                                           analysis_dict, 
#                                           count_mode=count_mode]
# 
#             # Write the modified record to the output file  
#             out_file.write_record[hyb_record]
# 
#     # Write mirna_analysis for input file to outputs. 
#     analysis_file_basename = out_file_path.replace['.hyb', '']
#     print['Outputting Analyses to:\n    %s\n' % analysis_file_basename]
#     hybkit.analysis.write_summary[analysis_file_basename, 
#                                   analysis_dict, 
#                                   multi_files=True, 
#                                   name=in_file_label]
#    
#     analysis_dicts.append[analysis_dict]
# 
# # Create a combined summary analysis
# combined_analysis_dict = hybkit.analysis.combine_summary_dicts[analysis_dicts] 
# 
# # Write combined summary analysis to files.
# combined_analysis_file_basename = os.path.join[out_dir, 'combined_analysis']
# print['Outputting Combined Analysis to:\n    %s\n' % combined_analysis_file_basename]
# hybkit.analysis.write_summary[combined_analysis_file_basename, 
#                               combined_analysis_dict, 
#                               multi_files=True,
#                               name='Combined']
# 
# print['Done!']  
# 
# 
