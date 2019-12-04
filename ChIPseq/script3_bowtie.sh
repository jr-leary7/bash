#!/bin/bash

module add bowtie2/2.3.4.1

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
CF=${WD}/*config.txt
echo $CF

cd $WD
mkdir samfiles

REFH=/proj/seq/data/hg38_UCSC/Sequence/Bowtie2Index/genome
REFM=/proj/seq/data/MM10_UCSC/Sequence/Bowtie2Index/genome

while read sample type genome; do
  echo $sample $type $genome
done < $CF

while read sample type genome; do
  # PDX -------------------------------------------------------
  if [ "$type" = "PDX" ]; then 
    echo $type
    # graft
    FQR1=${sample}_R1.fastq.gz
    FQR2=${sample}_R2.fastq.gz
    OUTG=${sample}_bowtie2_hg38
    mkdir $WD/$OUTG
    sbatch -t 24:00:00 -J ${sample}_BT2g -c 8 --mem=64G -e $WD/$OUTG/${sample}.err -o $WD/$OUTG/${sample}.out --wrap="bowtie2 -x $REFH -1 $FQR1 -2 $FQR2 --very-sensitive -X 2000 -S $WD/samfiles/${sample}_graft.sam"
    sleep 0.5 
    # host
    OUTH=${sample}_bowtie2_mm10
    mkdir $WD/$OUTH
    sbatch -t 24:00:00 -J ${sample}_BT2h -c 8 --mem=64G -e $WD/$OUTH/${sample}.err -o $WD/$OUTH/${sample}.out --wrap="bowtie2 -x $REFM -1 $FQR1 -2 $FQR2 --very-sensitive -X 2000 -S $WD/samfiles/${sample}_host.sam"
    sleep 0.5
  fi

  # Human -----------------------------------------------------
  if [ "$type" = "Human" ]; then
    echo $type
    FQR1=${sample}_R1.fastq.gz
    FQR2=${sample}_R2.fastq.gz
    OUTG=${sample}_bowties2_hg38
    mkdir $WD/$OUTG
    sbatch -t 24:00:00 -J ${sample}_BT2g -c 8 --mem=64G -e $WD/$OUTG/${sample}.err -o $WD/$OUTG/${sample}.out --wrap="bowtie2 -x $REFH -1 $FQR1 -2 $FQR2 --very-sensitive -X 2000 -S $WD/samfiles/${sample}.sam"
    sleep 0.5
  fi

  # Mouse ----------------------------------------------------
  if [ "$type" = "Mouse" ]; then
    echo $type
    FQR1=${sample}_R1.fastq.gz
    FQR2=${sample}_R2.fastq.gz
    OUTM=${sample}_bowtie2_mm10
    mkdir $WD/$OUTM
    sbatch -t 24:00:00 -J ${sample}_BT2h -c 8 --mem=64G -e $WD/$OUTM/${sample}.err -o $WD/$OUTM/${sample}.out --wrap="bowtie2 -x $REFM -1 $FQR1 -2 $FQR2 --very-sensitive -X 2000 -S $WD/samfiles/${sample}.sam"
    sleep 0.5
  fi

done < $CF

 
