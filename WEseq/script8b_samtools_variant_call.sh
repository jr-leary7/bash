#!/bin/bash

RUNNAME=$1
ONYEN=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
REF_FASTA=/proj/seq/data/hg38_UCSC/Sequence/WholeGenomeFasta/genome.fa

cd $WD
module add samtools

for file in *R1*fastq.gz; do
	samplename=`echo $file | sed 's/_R1_001.fastq.gz//g'`
	cd $samplename
	sbatch -t 24:00:00 -c 4 --mem=100G --wrap="bcftools mpileup -b $WD/$samplename/${samplename}_sorted_noDups.bam -f $REF_FASTA | bcftools call -mv -O v --output $WD/$samplename/${samplename}_samtools_calls.vcf"
done
