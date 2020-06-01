#!/bin/bash

RUNNAME=$1
ONYEN=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
REF_FASTA=/proj/seq/data/hg38_UCSC/Sequence/BWAIndex/genome.fa

cd $WD
module add bwa

for file in *R1_001.fastq.gz; do
	file2=`echo $file | sed 's/_R1_001.fastq.gz/_R2_001.fastq.gz/g'`
	samplename=`echo $file | sed 's/_R1_001.fastq.gz//g'`
	mkdir $samplename
	sbatch -t 24:00:00 -c 8 --mem=120G --wrap="bwa mem $REF_FASTA $file $file2 -R '@RG\tID:${samplename}\tPL:ILLUMINA\tSM:${samplename}' > $samplename/${samplename}.sam"
done

