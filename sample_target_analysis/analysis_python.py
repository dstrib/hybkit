#!/usr/bin/env python3
# Daniel B. Stribling
# Renne Lab, University of Florida
# Hybkit Project : http://www.github.com/RenneLab/hybkit

'''
Analysis for sample_hyb_analysis performed as a python workflow, as an example of direct 
usage of hybkit functions. File names are hardcoded, and functions are accessed directly.
'''

import os
import sys
import hybkit
import datetime

# Set script directories and input file names.
analysis_dir = os.path.abspath(os.path.dirname(__file__))
out_dir = os.path.join(analysis_dir, 'output')
in_file_name = os.path.join(analysis_dir, 'GSM2720020_WT_BR1.hyb')
match_legend_file = os.path.join(analysis_dir, 'string_match_legend.csv')

# Begin Analysis

print('\nPerforming Analysis')
print('Starting at: %s\n' % str(datetime.datetime.now()))

if not os.path.isdir(out_dir):
    print('Creating Output Directory:\n    %s\n' % out_dir)
    os.mkdir(out_dir)

print('Analyzing File:')
print('    ' + in_file_name + '\n')

# Set the method of finding segment type
match_parameters = hybkit.HybRecord.make_string_match_parameters(match_legend_file)
hybkit.HybRecord.select_find_type_method('string_match', match_parameters)

# Create custom list of miRNA types for analysis
mirna_types = hybkit.HybRecord.MIRNA_TYPES + ['kshv_microRNA']

out_file_name = in_file_name.replace('.hyb', '_KSHV_only.hyb')
out_file_name = out_file_name.replace(analysis_dir, out_dir)
out_file_path = os.path.join(out_dir, out_file_name)

print('Outputting KSHV-Specific Sequences to:\n    %s\n' % out_file_path)

# Open one HybFile entry for reading, and one for writing
with hybkit.HybFile(in_file_name, 'r') as in_file, \
     hybkit.HybFile(out_file_path, 'w') as out_kshv_file:

    # Prepare Target Analysis dict
    target_analysis = {}

    count = 0

    # Iterate over each record of the input file
    for hyb_record in in_file:

        count += 1
        if count > 5000:
            break


        # Find the segments type of each record
        hyb_record.find_seg_types()
        hyb_record.mirna_analysis(mirna_types=mirna_types)
        if hyb_record.has_property('seg_contains', 'kshv'):
            out_kshv_file.write_record(hyb_record)

sys.stdout.flush() # DEBUG
print('Performing Target Analysis...\n')
# Reiterate over output HybFile and perform target analysis.
with hybkit.HybFile(out_file_path, 'r') as out_kshv_file:
    # Prepare target analysis dict:
    target_dict = {}

    for hyb_record in out_kshv_file:
        hyb_record.mirna_analysis(mirna_types=mirna_types)
        hybkit.analysis.running_target_analysis(hyb_record, target_dict, 
                                                double_count_duplexes=True)
        
    # Process and sort dictionary of miRNA and targets
    sorted_target_dict, counts, total_count = hybkit.analysis.process_target_analysis(target_dict)

    # Write target information to output file
    hybkit.analysis.write_target_analysis_file(out_file_path.replace('.hyb','.csv'), 
                                               sorted_target_dict,
                                               counts=counts,
                                               sep=',')

print('Ending At: %s' % str(datetime.datetime.now()))
sys.stdout.flush()  # DEBUG
