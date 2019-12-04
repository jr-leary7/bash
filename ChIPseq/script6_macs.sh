#!/bin/bash

module add macs/2.1.2

ONYEN=$1
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
RUNNAME=$2
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

# need to run w/ different params for human and house due to genome size

cd $WD/bamfiles
find *marked*.bam

DIR=macs2_results

if [ ! -e $DIR ] ; then
  mkdir $DIR
fi

for file in *marked*.bam; do
  sample=`basename $file .bam`
  if [[ $file == *"host"* ]]; then
    sbatch -t 16:00:00 -c 6 --mem=20GB --wrap="macs2 callpeak -t $file -f BAM -g 1.87e9 -n $sample -q 0.01 --outdir macs2_results 2> macs2_results/${sample}_macs2.log"
  fi

  if [[ $file == *"graft"* ]]; then
    sbatch -t 16:00:00 -c 6 --mem=20GB --wrap="macs2 callpeak -t $file -f BAM -g 2.7e9 -n $sample -q 0.01 --outdir macs2_results 2> macs2_results/${sample}_macs2.log"
  fi

done




