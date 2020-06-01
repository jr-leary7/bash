#!/bin/bash

RUNNAME=$1
ONYEN=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
REF_FASTA=/proj/seq/data/hg38_UCSC/Sequence/WholeGenomeFasta/genome.fa

cd $WD
module add gatk

for file in *R1*fastq.gz; do
	samplename=`echo $file | sed 's/_R1_001.fastq.gz//g'`
	cd $samplename
	sbatch -t 24:00:00 -c 4 --mem=40G --wrap="gatk Funcotator --variant ${samplename}_filtered.vcf --reference $REF_FASTA --ref-version hg38 --data-sources-path /nas/longleaf/home/jrleary/DNAseq_scripts/data/funcotator_dataSources.v1.6.20190124s --output ${samplename}_filtered_annotated.vcf --output-file-format VCF"
done
