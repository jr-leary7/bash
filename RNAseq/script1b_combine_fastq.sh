#!/bin/bash

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/yehlab/RawRNAseq/$RUNNAME

cd $WD/TwoIndexes

# combine .fastq lanes
for L1R1 in *L001_R1_001.fastq.gz; do
  L1R2=`echo $L1R1 | sed 's/_R1_/_R2_/g'`
  echo "Read 1: $L1R1"
  echo "Read 2: $L1R2"
  
  OUT1=`echo $L1R1 | sed 's/L001_R1_001.fastq.gz/R1.fastq.gz/g'`
  L2R1=`echo $L1R1 | sed 's/L001_/L002_/g'`
  L3R1=`echo $L1R1 | sed 's/L001_/L003_/g'`
  L4R1=`echo $L1R1 | sed 's/L001_/L004_/g'`
  cat $L1R1 $L2R1 $L3R1 $L4R1 > $OUT1
 
  OUT2=`echo $L1R2 | sed 's/L001_R2_001.fastq.gz/R2.fastq.gz/g'`
  L2R2=`echo $L1R2 | sed 's/L001_/L002_/g'`
  L3R2=`echo $L1R2 | sed 's/L001_/L003_/g'`
  L4R2=`echo $L1R2 | sed 's/L001_/L004_/g'`
  cat $L1R2 $L2R2 $L3R2 $L4R2 > $OUT2
done
