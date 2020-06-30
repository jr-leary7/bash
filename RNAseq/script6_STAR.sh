#!/bin/bash

module add star/2.6.0a

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}

WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

cd $WD

for R1 in *R1.fastq.gz; do
  R2=`echo $R1 | sed 's/_R1/_R2/g'`
  NAME=${R1%_*}

  if [[ "$NAME" == *Human* || "$NAME" == *Germ* ]]; then
    echo "$NAME"
    INDEX=/proj/seq/data/STAR_genomes/GRCh38_p10_GENCODE
    REF=/proj/seq/data/STAR_genomes/GRCh38_p10_GENCODE/GRCh38.p10.genome.fa
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="STAR --runThreadN 8 --readFilesCommand zcat --genomeDir $INDEX --readFilesIn $R1 $R2 --outSAMtype BAM Unsorted SortedByCoordinate --quantMode TranscriptomeSAM --outFileNamePrefix $NAME/${NAME}_STAR --outSAMunmapped Within"
  fi

  if [[ "$NAME" == *Mouse* || "$NAME" == *KPC* ]]; then
    echo "$NAME"
    INDEX=/proj/seq/data/STAR_genomes/GRCm38_p5_GENCODE
    REF=/proj/seq/data/STAR_genomes/GRCm38_p5_GENCODE/GRCm38.p5.genome.fa
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="STAR --runThreadN 8 --readFilesCommand zcat --genomeDir $INDEX readFilesIn $R1 $R2 --outSAMtype BAM Unsorted SortedByCoordinate --quantMode TranscriptomeSAM --outfileNamePrefix $NAME/${NAME}_STAR --outSAMunmapped Within"
  fi

  if [[ "$NAME" == *PDX* ]]; then
    echo "$NAME"
    sbatch -t 24:00:00 -c 16 --mem=140G --wrap="~/RNAseq_scripts/subroutines/STAR_PDX.sh $file"
  fi

done
