#!/bin/bash

module add fastqc

ONYEN=$1
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
RUNNAME=$2

# hm38 folder
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

if [[ ! -e $WD/logs ]]; then
  mkdir $WD/logs
fi

cd $WD

for R1 in *R1.fastq.gz; do
  R2=`echo $R1 | sed 's/_R1.fastq.gz/_R2.fastq.gz/g'`
  NAME=${R1%_*}  # trims _R1.fastq.gz from input to give us the samplename
  sbatch -J fastqc --output=$WD/logs/${NAME}_R1_fastqc.out --mem=4G --wrap="fastqc $R1 --outdir $WD/"
  sleep 0.5
  sbatch -J fastqc --output=$WD/logs/${NAME}_R2_fastqc.out --mem=4G --wrap="fastqc $R2 --outdir $WD/"
  sleep 0.5
done


