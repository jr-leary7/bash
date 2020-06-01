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
	sbatch -t 120:00:00 -c 1 --mem=500G --wrap="gatk Mutect2 -R $REF_FASTA -I ${samplename}_sorted_noDups.bam -O ${samplename}_unfiltered.vcf"
done
