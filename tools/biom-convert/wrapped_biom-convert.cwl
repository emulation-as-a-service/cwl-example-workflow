s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder: "EMBL - European Bioinformatics Institute"
class: CommandLineTool
inputs:
- id: biom
  format: http://edamontology.org/format_3746
  inputBinding:
    prefix: --input-fp
  type:
  - 'null'
  - File
- id: hdf5
  label: Output as HDF5-formatted table.
  inputBinding:
    prefix: --to-hdf5
  type:
  - 'null'
  - boolean
- id: header_key
  doc: |
    The observation metadata to include from the input BIOM table file when
    creating a tsv table file. By default no observation metadata will be
    included.
  inputBinding:
    prefix: --header-key
  type:
  - 'null'
  - string
- id: json
  label: Output as JSON-formatted table.
  inputBinding:
    prefix: --to-json
  type:
  - 'null'
  - boolean
- id: table_type
  inputBinding:
    prefix: --table-type
    separate: true
    valueFrom: $(inputs.table_type)
  type:
  - 'null'
  - string
- id: tsv
  label: Output as TSV-formatted (classic) table.
  inputBinding:
    prefix: --to-tsv
  type:
  - 'null'
  - boolean
outputs:
- id: result
  outputBinding:
    glob: |
      ${ var ext = "";
      if (inputs.json) { ext = "_json.biom"; }
      if (inputs.hdf5) { ext = "_hdf5.biom"; }
      if (inputs.tsv) { ext = "_tsv.biom"; }
      var pre = inputs.biom.nameroot.split('.');
      pre.pop()
      return pre.join('.') + ext; }
  type: File
requirements:
- class: InlineJavascriptRequirement
- class: ResourceRequirement
  ramMin: 300
- class: DockerRequirement
  dockerPull: registry.gitlab.com/emulation-as-a-service/experiments/cwl-wrapper:latest
  dockerOutputDirectory: /app/output
- class: InitialWorkDirRequirement
  listing:
  - entryname: config.json
    entry: |-
      {
          "environmentId": "6cb04e56-4bab-45aa-b208-6984b13af42a",
          "initialWorkDirRequirements": [],
          "eaasUrl": "https://c6564661-6070-42cc-b6e0-ad1277a1ca7e.fr.bw-cloud-instance.org/emil"
      }
hints: []
cwlVersion: v1.0
baseCommand:
- python3
- /app/wrapper.py
- biom
- convert
arguments:
- prefix: --output-fp
  valueFrom: |
    ${ var ext = "";
       if (inputs.json) { ext = "_json.biom"; }
       if (inputs.hdf5) { ext = "_hdf5.biom"; }
       if (inputs.tsv) { ext = "_tsv.biom"; }
       var pre = inputs.biom.nameroot.split('.');
       pre.pop()
       return pre.join('.') + ext; }
- valueFrom: "--collapsed-observations"
$namespaces:
  edam: http://edamontology.org/
  s: http://schema.org/
$schemas:
- http://edamontology.org/EDAM_1.16.owl
- https://schema.org/version/latest/schemaorg-current-http.rdf

