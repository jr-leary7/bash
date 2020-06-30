#!/bin/bash

module add bcl2fastq2

# var definition
ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/yehlab/RawRNAseq/$RUNNAME  # working directory
SS=$WD/${RUNNAME}_samplesheet.csv  # samplesheet

# convert .bcl to .fastq
sbatch -t 24:00:00 -c 16 --mem=75G --wrap="bcl2fastq -r 4 -w 4 -p 16 -R $WD -o $WD/TwoIndexes --sample-sheet $SS --barcode-mismatches 1"

