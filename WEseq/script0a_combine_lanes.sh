#!/bin/bash

RUNNAME=$1
ONYEN=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38/uncombined_fastq

cd $WD

for lane1 in *L001_R1*fastq.gz; do
	lane2=`echo $lane1 | sed 's/L001/L002/g'`
	out=`echo $lane1 | sed 's/L001_R1_001.fastq.gz/R1.fastq/g'`
	echo $lane1 $lane2 "-->" $out
	sbatch -t 24:00:00 -c 2 --mem=20G --wrap="zcat $lane1 $lane2 > $out"
done

for lane1 in *L001_R2*fastq.gz; do
        lane2=`echo $lane1 | sed 's/L001/L002/g'`
        out=`echo $lane1 | sed 's/L001_R2_001.fastq.gz/R2.fastq/g'`
        echo $lane1 $lane2 "-->" $out
        sbatch -t 24:00:00 -c 2 --mem=20G --wrap="zcat $lane1 $lane2 > $out"
done
