#!/usr/bin/env nextflow
/*
vim: syntax=groovy
-*- mode: groovy;-*-

Daniel B. Stribling
Renne Lab, University of Florida
Hybkit Project : http://www.github.com/RenneLab/hybkit
Analysis for summary_analysis pipeline performed as a nextflow workflow.
Provided as an example of using command-line calls to hybkit scripts as a 
nextflow workflow. File names are accessed relative to the analysis directory.
See: "summary_analysis_notes.rst" for more information.
*/


process testHybkit {
    """
    #!/usr/bin/env python3
    import hybkit
    """
}

params.in_files = file("GSM*.hyb")
params.in_files.sort()
params.out_dir = file("output")

println('\nPerforming QC & Summary Analysis...')

if( !params.out_dir.exists() ) {
    println( 'Creating Output Directory:\n    %s\n' % out_dir )
    params.out_dir.mkdir
}

println( 'Analyzing Files:' )
println( "    ${params.in_files.join('\n    ')}" )
print(params.in_files)
//Channel
//    .fromList(params.in_files)
//    .toSortedList()
//    .subscribe { println "${params.in_files.join("\n    ")}" }


process summaryAnalysis {

    input:
    file in_file from params.in_files

    output:
    stdout result

    """
    echo "$in_file"
    """
}

result
    .toSortedList()
    .subscribe { print "    ${it.join('    ')}" }

print(result)

//print(result)
//for i in result:
//    print(i)

/*
    os.mkdir(out_dir)
print('Analyzing Files:')
print('    ' + '\n    '.join(input_files) + '\n')
# Tell hybkit that identifiers are in Hyb-Program standard format.
hybkit.HybFile.settings['hybformat_id'] = True
# Set the method of finding segment type
match_parameters = hybkit.HybRecord.make_string_match_parameters(match_legend_file)
hybkit.HybRecord.select_find_type_method('string_match', match_parameters)
# Initialize Two Sets of Analysis Dict Objects
analysis_dict = hybkit.analysis.summary_dict()
analysis_dicts = []
# Set hybrid segment types to remove as part of quality control (QC)
remove_types = ['rRNA', 'mitoch_rRNA']
# Iterate over each input file, find the segment types, and save the output 
#   in the output directory.
for in_file_path in input_files:
    in_file_name = os.path.basename(in_file_path)
    in_file_label = in_file_name.replace('.hyb', '')
    out_file_name = in_file_name.replace('.hyb', '_qc.hyb')
    out_file_path = os.path.join(out_dir, out_file_name)
    print('Analyzing:\n    %s' % in_file_path)
    print('Outputting to:\n    %s\n' % out_file_path)
    # Open one HybFile entry for reading, and one for writing
    with hybkit.HybFile(in_file_path, 'r') as in_file, \
         hybkit.HybFile(out_file_path, 'w') as out_file:
        # Iterate over each record of the input file
        for hyb_record in in_file:
            # Find the segments type of each record
            hyb_record.find_seg_types()
            # Determine if record has type that is excluded
            use_record = True
            for remove_type in remove_types:
                if hyb_record.has_property('seg_type', remove_type):
                    use_record = False
                    break
            # If record has an excluded type, continue to next record without analyzing.
            if not use_record:
                continue 
            # Perform record analysis
            hyb_record.mirna_analysis()
            # Add summary_analysis details to analysis_dict, using record numbers for counts
            hybkit.analysis.addto_summary(hyb_record,
                                          analysis_dict, 
                                          count_mode=count_mode)
            # Write the modified record to the output file  
            out_file.write_record(hyb_record)
    # Write mirna_analysis for input file to outputs. 
    analysis_file_basename = out_file_path.replace('.hyb', '')
    print('Outputting Analyses to:\n    %s\n' % analysis_file_basename)
    hybkit.analysis.write_summary(analysis_file_basename, 
                                  analysis_dict, 
                                  multi_files=True, 
                                  name=in_file_label)
   
    analysis_dicts.append(analysis_dict)
# Create a combined summary analysis
combined_analysis_dict = hybkit.analysis.combine_summary_dicts(analysis_dicts) 
# Write combined summary analysis to files.
combined_analysis_file_basename = os.path.join(out_dir, 'combined_analysis')
print('Outputting Combined Analysis to:\n    %s\n' % combined_analysis_file_basename)
hybkit.analysis.write_summary(combined_analysis_file_basename, 
                              combined_analysis_dict, 
                              multi_files=True,
                              name='Combined')
print('Done!')  
*/
