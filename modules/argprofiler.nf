#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2
//params.OUTPUT="argprofiler_result"

// Align reads to ARGprofiler database
process kma_align {
    conda "${projectDir}/modules/environment.yml"
    publishDir params.OUTPUT, mode: 'copy'

    input:
    tuple val(sample_name), path(R1_fastq), path(R2_fastq)

    output:
    tuple val(sample_name), path("ARGprofiler_report_${sample_name}.txt"), emit: kma_report

    shell:
    '''
    kma -ipe !{R1_fastq} !{R2_fastq} -o !{sample_name} -t_db !{params.argprofilerdb}/panARG -ef -1t1 -nf -vcf -sam -matrix -t !{params.NCPUS} > !{sample_name}.sam 2>log.txt
    Rscript !{projectDir}/bin/mapstatFilters.R -i !{sample_name}.mapstat -o ARGprofiler_report_!{sample_name}.txt -r !{params.argprofilerdb}/panARG_annotations.tsv -d 6
    '''
}
