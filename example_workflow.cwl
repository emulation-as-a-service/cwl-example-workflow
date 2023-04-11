#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}
  EnvVarRequirement: 
    envDef:
      HELLO: /usr/bin:/var/
      TEST_ENV: "ENV_VAR_TEST"

inputs:
  map_otu_table: File
  map_query: File
  map_label: string
  return_dirname: string

outputs:
  out_dir:
    type: Directory?
    outputSource: return_output_dir/out

steps:

  mapseq2biom:
    run: ./tools/mapseq2biom/mapseq2biom.cwl
    in:
       otu_table: map_otu_table
       label: map_label
       query: map_query
    out: [ otu_tsv, otu_txt, otu_tsv_notaxid ]

  counts_to_hdf5:
    run: ./tools/biom-convert/biom-convert.cwl
    in:
       biom: mapseq2biom/otu_tsv
       hdf5: { default: true }
       table_type: { default: 'OTU table' }
    out: [ result ]

  counts_to_json:
    run: ./tools/biom-convert/biom-convert.cwl
    in:
       biom: mapseq2biom/otu_tsv
       json: { default: true }
       table_type: { default: 'OTU table' }
    out: [ result ]

  return_output_dir:
    run: ./utils/return_directory.cwl
    in:
      dir_name: return_dirname
      file_list:
        - mapseq2biom/otu_tsv
        - mapseq2biom/otu_txt
        - counts_to_hdf5/result
        - counts_to_json/result
    out: [ out ]

  