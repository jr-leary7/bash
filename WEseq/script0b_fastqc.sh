#!/bin/bash

RUNNAME=$1
ONYEN=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

cd $WD
module add fastqc
mkdir fastqc_res

for file in *.fastq.gz; do
	sbatch -t 8:00:00 -c 2 --mem=5G --wrap="fastqc $file -o fastqc_res"
done 
