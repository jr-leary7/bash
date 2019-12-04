#!/bin/bash

module add samtools/1.9

WD=$1  # this is where the fastq are

cd $WD/samfiles
ls

for file in *.sam; do
  sample=`basename $file .sam`
  samtools view -bS ${sample}.sam > ${sample}.bam
done

