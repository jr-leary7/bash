#!/bin/bash

WD=$1

module add samtools

cd $WD/samfiles

for file in *.sam; do
  sample=`basename $file .sam`
  samtools index ${sample}_sorted.bam
done

mkdir $WD/bamfiles
cp *bam* $WD/bamfiles
