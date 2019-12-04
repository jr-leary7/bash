#!/bin/bash

module add cellranger
REFHM=/proj/jjyehlab/users/jrleary/cellranger/GRCh38_and_mm10
REFH=/proj/seq/data/CELLRANGER_genomes/v_30/refdata-cellranger-GRCh38-3.0.0

ONYEN=$1
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
RUNNAME=$2
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/yehlab/RawRNAseq/$RUNNAME

cd $WD/H*/outs/fastq_path

for file in *L001*I*; do
  echo $WD
  sample=`echo $file | cut -d'_' -f 1-3`
  type=`echo $file | cut -d'_' -f 1`

  if [[ $type == "Human" ]]; then
    echo $sample $type
    sbatch -t 36:00:00 -c 8 --mem=50G --wrap="cellranger count --id $sample --sample $sample --fastqs $WD/H*/outs/fastq_path --transcriptome $REFH --localcores=8 --localmem=48"
  fi

  if [[ $type == "PDX" ]]; then
    echo $sample $type
    sbatch -t 36:00:00 -c 8 --mem=50G --wrap="cellranger count --id $sample --sample $sample --fastqs $WD/H*/outs/fastq_path --transcriptome $REFHM --localcores=8 --localmem=48"
  fi

done
