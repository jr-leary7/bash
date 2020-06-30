#!/bin/bash

module add salmon/0.9.1

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
REF=/proj/jjyehlab/users/zhabotyn/salmonref

# hm38 folder
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
cd $WD

for R1 in *R1.fastq.gz; do
  R2=`echo $R1 | sed 's/_R1/_R2/g'`
  NAME=${R1%_*}  # retrieves samplename from fastq.gz filename by splitting string at last "_"
  if [[ "$NAME" == *PDX* ]]; then
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="salmon quant --gcBias --seqBias -i ${REF}/hg38 -l A -g ${REF}/hg38.gff -1 $R1 -2 $R2 -p 8 -o ${NAME}_graft"
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="salmon quant --gcBias --seqBias -i ${REF}/mm10 -l A -g ${REF}/mm10.gff -1 $R1 -2 $R2 -p 8 -o ${NAME}_host"
  fi

  if [[ "$NAME" == *Human* || "$NAME" == *Germ* ]]; then
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="salmon quant --gcBias --seqBias -i ${REF}/hg38 -l A -g ${REF}/hg38.gff -1 $R1 -2 $R2 -p 8 -o $NAME"
  fi

  if [[ "$NAME" == *Mouse* || "$NAME" == *KPC* ]]; then
    sbatch -t 24:00:00 -c 8 --mem=80G --wrap="salmon quant --gcBias --seqBias -i ${REF}/mm10 -l A -g ${REF}/mm10.gff -1 $R1 -2 $R2 -p 8 -o $NAME"
  fi
done 
