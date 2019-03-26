.PHONY: init_qc trim_reads multiqc clean

# Specify variables
path_to_splice_site := /illumina/pipeline_in/GENOMES/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/splicesites.txt
path_to_index := /illumina/pipeline_in/GENOMES/Homo_sapiens/Ensembl/GRCh37/Sequence/HISAT2Index/genome
path_to_gtf := /illumina/pipeline_in/GENOMES/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf
stranded := F
stranded_count := 1
trimmed_fastq := $(wildcard *.fq)
sam_files := $(trimmed_fastq:%.fq=%.sam)
bam_files := $(sam_files:%.sam=%.bam)
bam_index_files := $(bam_files:%.bam=%.bam.bai)
count_files := $(bam_files:%.bam=%.count)

all: init_qc trim_reads ${sam_files} ${bam_files} ${bam_index_files} ${count_files} multiqc

# Run initial quality control on raw untrimmed reads in fastq format
init_qc: 
	fastqc *.fastq

# trim reads
trim_reads: 
	trim_galore --illumina --fastqc *.fastq	

# map reads
%.sam: %.fq 
	hisat2 -q --rna-strandness $(stranded) --phred33 -p 4 --known-splicesite $(path_to_splice_site) -x $(path_to_index) -U $^ -S $@

# convert sam to bam and index
%.bam: %.sam
	samtools sort $^ > $@

# index sorted bam files
%.bam.bai: %.bam 
	samtools index $^ $@

# Get counts of reads mapping to features (gene level)
%.count: %.bam
	featureCounts -T 4 -s $(stranded_count) -a $(path_to_gtf) -o $@ $^

# Now after everything was done run multiqc analysis
multiqc:
	multiqc .

# Remove SAM files
clean:
	rm *.sam





