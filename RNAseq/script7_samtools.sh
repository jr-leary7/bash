#!/bin/bash

module add samtools

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

cd $WD

for R1 in *R1.fastq.gz; do
  NAME=${R1%_*}
  sbatch -t 24:00:00 -c 2 --mem=20G --wrap="samtools index -b $NAME/*sortedByCoord*bam -@ 2"
done
