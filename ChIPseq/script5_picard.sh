#!/bin/bash

module add picard/2.2.4
module add java

ONYEN=$1
RUNNAME=$2  
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38  # where fastqs are

cd $WD/bamfiles  # where sorted .bam were outputted from samtools script
find *sorted.bam

for file in *sorted.bam; do
  sample=`basename $file .bam`
  sbatch -t 8:00:00 -J picard -c 4 --mem=16GB --wrap="java -Xmx8g -jar /nas/longleaf/apps/picard/2.2.4/picard-tools-2.2.4/picard.jar MarkDuplicates I=$file O=${sample}_marked_dups.bam M=marked_dups.txt VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=true"
done  
