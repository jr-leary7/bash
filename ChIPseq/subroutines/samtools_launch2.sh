#!/bin/bash

module add samtools

WD=$1

cd $WD/samfiles

for file in *.sam; do
  sample=`basename $file .sam`
  samtools sort ${sample}.bam > ${sample}_sorted.bam
done
