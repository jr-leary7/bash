#!/bin/bash

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/yehlab/RawRNAseq/$RUNNAME

cd $WD

module add cellranger
module add bcl2fastq2

sbatch -t 24:00:00 -c 8 --mem=36G --wrap="cellranger mkfastq --run=$WD --samplesheet=$WD/${RUNNAME}_samplesheet.csv --localcores=8 --localmem=34" 
