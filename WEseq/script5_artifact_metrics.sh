#!/bin/bash

RUNNAME=$1
ONYEN=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
REF_FASTA=/proj/seq/data/hg38_UCSC/Sequence/BWAIndex/genome.fa

cd $WD
module add gatk

for file in *R1*fastq.gz; do
        samplename=`echo $file | sed 's/_R1_001.fastq.gz//g'`
	cd $samplename
        sbatch -t 24:00:00 -c 2 --mem=40G --wrap="gatk CollectSequencingArtifactMetrics -R $REF_FASTA -I ${samplename}_sorted_noDups.bam -O ${samplename}_artifacts.txt"
done
