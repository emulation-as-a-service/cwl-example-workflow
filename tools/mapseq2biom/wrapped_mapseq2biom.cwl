s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
class: CommandLineTool
inputs:
- id: label
  label: label to add to the top of the outfile OTU table
  inputBinding:
    prefix: --label
  type: string
- id: otu_table
  doc: |
    the OTU table produced for the taxonomies found in the reference
    databases that was used with MAPseq
  inputBinding:
    prefix: --otuTable
  type: File
- id: query
  label: the output from the MAPseq that assigns a taxonomy to a sequence
  inputBinding:
    prefix: --query
  type: File
- id: taxid_flag
  label: output NCBI taxids for all databases bar UNITE
  inputBinding:
    prefix: --taxid
  type:
  - 'null'
  - boolean
outputs:
- id: otu_tsv
  outputBinding:
    glob: $(inputs.query.basename).tsv
  format: http://edamontology.org/format_3746
  type: File
- id: otu_tsv_notaxid
  outputBinding:
    glob: $(inputs.query.basename).notaxid.tsv
  format: http://edamontology.org/format_3746
  type:
  - 'null'
  - File
- id: otu_txt
  outputBinding:
    glob: $(inputs.query.basename).txt
  format: https://www.iana.org/assignments/media-types/text/tab-separated-values
  type: File
requirements:
- class: EnvVarRequirement
  envDef:
  - envName: HELLO
    envValue: /usr/bin:/var/
  - envName: PATH
    envValue: "/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
- class: ResourceRequirement
  coresMin: 2
  ramMin: 200
  tmpdirMin: 200
- class: DockerRequirement
  dockerPull: registry.gitlab.com/emulation-as-a-service/experiments/cwl-wrapper:latest
  dockerOutputDirectory: /app/output
- class: InitialWorkDirRequirement
  listing:
  - entryname: config.json
    entry: |-
      {
          "environmentId": "930e4481-d60f-4e5f-be15-c7cff2a92bdb",
          "initialWorkDirRequirements": [],
          "eaasUrl": "https://c6564661-6070-42cc-b6e0-ad1277a1ca7e.fr.bw-cloud-instance.org/emil",
          "environmentVariables": {
              "HELLO": "/usr/bin:/var/",
              "PATH": "/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          }
      }
hints: []
cwlVersion: v1.0
baseCommand:
- python3
- /app/wrapper.py
- mapseq2biom.pl
arguments:
- prefix: --outfile
  valueFrom: $(inputs.query.basename).tsv
- prefix: --krona
  valueFrom: $(inputs.query.basename).txt
$namespaces:
  edam: http://edamontology.org/
  iana: https://www.iana.org/assignments/media-types/
  s: http://schema.org/
$schemas:
- http://edamontology.org/EDAM_1.16.owl
- https://schema.org/version/latest/schemaorg-current-http.rdf

