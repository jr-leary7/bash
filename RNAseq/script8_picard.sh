#!/bin/bash

module add picard

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
# hg38 reference data
REFH=/proj/seq/data/STAR_genomes/GRCh38_p10_GENCODE/GRCh38.p10.genome.fa
FLATH=/proj/jjyehlab/projects/RNAseq/helper/refFlat.GRCh38_p10_GENCODE.txt.gz
INTH=/proj/jjyehlab/projects/RNAseq/helper/ribosomal_hg38.interval_list
# mm10 reference data
REFM=/proj/seq/data/STAR_genomes/GRCm38_p5_GENCODE/GRCm38.p5.genome.fa
FLATM=/proj/jjyehlab/projects/RNAseq/helper/refFlat.GRCm38_p5_GENCODE.txt.gz
INTM=/proj/jjyehlab/projects/RNAseq/helper/ribosomal_mm10.interval_list

cd $WD

for R1 in *R1.fastq.gz; do
  NAME=${R1%_*}
  if [[ "$NAME" == *Human* || "$NAME" == *Germ* ]]; then
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard CollectMultipleMetrics I=$NAME/STARAligned.sortedByCoord.out.bam O=$NAME/multiple_metrics R=$REFH"
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard CollectRnaseqMetrics I=$NAME/STARAligned.sortedByCoord.out.bam O=$NAME/RNAseq_metrics R=$REFH  REF_FLAT=$FLATH STRAND_SPECIFICITY=SECOND_READ_TRANSCRIPTION_STRAND RIBOSOMAL_INTERVALS=$INTH"
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard EstimateLibraryComplexity I=$NAME/STARAligned.sortedByCoord.out.bam O=$NAME/est_lib_complexity.txt"
  fi

  if [[ "$NAME" == *Mouse* || "$NAME" == *KPC* ]]; then
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard CollectMultipleMetrics I=$NAME/STARAligned.sortedByCoord.out.bam O=$NAME/multiple_metrics R=$REFM"
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard CollectRnaseqMetrics I=$NAME/STARAligned.sortedByCoord.out.bam O=$NAME/RNAseq_metrics R=$REFM  REF_FLAT=$FLATM STRAND_SPECIFICITY=SECOND_READ_TRANSCRIPTION_STRAND RIBOSOMAL_INTERVALS=$INTM"
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard EstimateLibraryComplexity I=$NAME/STARAligned.sortedByCoord.out.bam O=$NAME/est_lib_complexity.txt"
  fi

  if [[  "$NAME" == *PDX* ]]; then
    # hg38 
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard CollectMultipleMetrics I=${NAME}_graft/STARAligned.sortedByCoord.out.bam O=${NAME}_graft/multiple_metrics_graft R=$REFH"
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard CollectRnaseqMetrics I=${NAME}_graftSTARAligned.sortedByCoord.out.bam O=${NAME}_graft/RNAseq_metrics_graft R=$REFH  REF_FLAT=$FLATH STRAND_SPECIFICITY=SECOND_READ_TRANSCRIPTION_STRAND RIBOSOMAL_INTERVALS=$INTH"
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard EstimateLibraryComplexity I=${NAME}_graft/STARAligned.sortedByCoord.out.bam O=$NAME/est_lib_complexity.txt"
    # mm10
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard EstimateLibraryComplexity I=${NAME}_host/STARAligned.sortedByCoord.out.bam O=$NAME/est_lib_complexity.txt"
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard CollectMultipleMetrics I=${NAME}_host/STARAligned.sortedByCoord.out.bam O=${NAME}_host/multiple_metrics_host R=$REFM"
    sbatch -t 8:00:00 -c 1 --mem=10G --wrap="picard CollectRnaseqMetrics I=${NAME}_host/STARAligned.sortedByCoord.out.bam O=${NAME}_host/RNAseq_metrics_host R=$REFM  REF_FLAT=$FLATM STRAND_SPECIFICITY=SECOND_READ_TRANSCRIPTION_STRAND RIBOSOMAL_INTERVALS=$INTM"
  fi

done
