class: Workflow
id: file:///F:/Thesis/pipeline-v5-master/tools/RNA_prediction/thesis_example_workflow/example_workflow.cwl
inputs:
- id: map_label
  type: string
- id: map_otu_table
  type: File
- id: map_query
  type: File
- id: return_dirname
  type: string
outputs:
- id: out_dir
  outputSource: return_output_dir/out
  type:
  - 'null'
  - Directory
requirements:
- class: InlineJavascriptRequirement
- class: MultipleInputFeatureRequirement
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: SubworkflowFeatureRequirement
cwlVersion: v1.0
steps:
- id: counts_to_hdf5
  in:
  - id: biom
    source: mapseq2biom/otu_tsv
  - id: hdf5
    default: true
  - id: table_type
    default: 'OTU table'
  out:
  - result
  run: F:/Thesis/pipeline-v5-master/tools/RNA_prediction/biom-convert/wrapped_biom-convert.cwl
- id: counts_to_json
  in:
  - id: biom
    source: mapseq2biom/otu_tsv
  - id: json
    default: true
  - id: table_type
    default: 'OTU table'
  out:
  - result
  run: F:/Thesis/pipeline-v5-master/tools/RNA_prediction/biom-convert/wrapped_biom-convert.cwl
- id: mapseq2biom
  in:
  - id: label
    source: map_label
  - id: otu_table
    source: map_otu_table
  - id: query
    source: map_query
  out:
  - otu_tsv
  - otu_txt
  - otu_tsv_notaxid
  run: F:/Thesis/pipeline-v5-master/tools/RNA_prediction/mapseq2biom/wrapped_mapseq2biom.cwl
- id: return_output_dir
  in:
  - id: dir_name
    source: return_dirname
  - id: file_list
    source:
    - mapseq2biom/otu_tsv
    - mapseq2biom/otu_txt
    - counts_to_hdf5/result
    - counts_to_json/result
  out:
  - out
  run: ..\..\..\utils\return_directory.cwl
