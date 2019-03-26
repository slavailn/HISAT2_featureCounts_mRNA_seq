#! /bin/bash

mkdir fastq
mv *.fastq fastq/
mkdir fastqc_results/
mv *fastqc.zip *fastqc.html fastqc_results/
mkdir trimmed_fastq
mv *_trimmed.fq trimmed_fastq/
mkdir bam
mv *trimmed.bam*  bam/
mkdir trimming_reports
mv *trimming_report.txt trimming_reports/
mkdir counts/
mv *_trimmed.count* counts/
mkdir multiqc_result
mv multiqc_data/ multiqc_report.html multiqc_result/
