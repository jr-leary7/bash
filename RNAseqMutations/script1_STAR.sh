#!/bin/bash

module add star/2.6.0a

ONYEN=$1
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
RUNNAME=$2
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

cd $WD

for R1 in *R1*fastq.gz; do
  R2=`echo $R1 | sed 's/_R1.fastq.gz/_R2.fastq.gz/g'`
  NAME=`echo $R1 | sed 's/_R1.fastq.gz//g'`
  mkdir $NAME
  
  if [[ "$NAME" == *Human* || "$NAME" == *Germ* ]]; then
    INDEX=/proj/seq/data/STAR_genomes/GRCh38_p10_GENCODE
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="STAR --runThreadN 8 --readFilesCommand zcat --genomeDir $INDEX --readFilesIn $R1 $R2 --outSAMtype BAM Unsorted SortedByCoordinate --quantMode TranscriptomeSAM --outFileNamePrefix $NAME/${NAME}_STAR --outSAMunmapped Within"
  fi 

  if [[ "$NAME" == *Mouse* || "$NAME" == *KPC* ]]; then
    INDEX=/proj/seq/data/STAR_genomes/GRCm38_p5_GENCODE
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="STAR --runThreadN 8 --readFilesCommand zcat --genomeDir $INDEX readFilesIn $R1 $R2 --outSAMtype BAM Unsorted SortedByCoordinate --quantMode TranscriptomeSAM --outfileNamePrefix $NAME/${NAME}_STAR --outSAMunmapped Within"
  fi

  if [[ "$NAME" == *PDX* ]]; then
    INDEXH=/proj/seq/data/STAR_genomes/GRCh38_p10_GENCODE
    INDEXM=/proj/seq/data/STAR_genomes/GRCm38_p5_GENCODE
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="STAR --runThreadN 8 --readFilesCommand zcat --genomeDir $INDEXH --readFilesIn $R1 $R2 --outSAMtype BAM Unsorted SortedByCoordinate --quantMode TranscriptomeSAM --outFileNamePrefix $NAME/${NAME}_STAR_graft --outSAMunmapped Within"
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="STAR --runThreadN 8 --readFilesCommand zcat --genomeDir $INDEXM readFilesIn $R1 $R2 --outSAMtype BAM Unsorted SortedByCoordinate --quantMode TranscriptomeSAM --outfileNamePrefix $NAME/${NAME}_STAR_host --outSAMunmapped Within"
  fi

done