#!/bin/bash

RUNNAME=$1
ONYEN=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

cd $WD
module add picard

for file in *R1*fastq.gz; do
	samplename=`echo $file | sed 's/_R1_001.fastq.gz//g'`
	cd $samplename
	sbatch -t 24:00:00 -c 4 --mem=40G --wrap="picard SamFormatConverter I=${samplename}.sam O=${samplename}.bam"
	cd $WD
done
	
