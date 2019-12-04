#!/bin/bash

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

module add multiqc

cd $WD

for file in *R1*.fastq.gz; do

  len=`echo $file | awk -F"_" '{print NF - 1}'`  # get number of underscores in filename
  sample=`echo $file | cut -d'_' -f 1-$len`  # get samplename from filename
  
  if [[ $sample == *"Human"* ]]; then
    cp ${sample}_bowtie2_hg38/*.err $WD/multiqc
    if [[ $sample != *"input"* ]]; then
      cp macs2_results/$sample/*.xls $WD/multiqc
    fi
  fi

  if [[ $sample == *"PDX"* ]]; then
    cp ${sample}_bowtie2_hg38/*.err $WD/multiqc
    cp ${sample}_bowtie2_mm10/*.err $WD/multiqc
    if [[ $sample != *"input"* ]]; then
      # need to separate peak files into graft and host
      resg=$WD/multiqc/${sample}_graft_peaks.xls
      resh=$WD/multiqc/${sample}_host_peaks.xls
      cp macs2_results/${sample}_graft/*.xls $resg
      cp macs2_results/${sample}_host/*.xls $resh
    fi
  fi

  if [[ $sample == *"Mouse"* ]]; then
    if [[ $sample != *"input"* ]]; then
      cp ${sample}_bowtie2_mm10/*.err $WD/multiqc
      cp macs2_results/$sample/*.xls $WD/multiqc
    fi
  fi

done

multiqc multiqc/*

