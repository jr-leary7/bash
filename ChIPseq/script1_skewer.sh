#!/bin/bash

module add skewer/0.2.2

ONYEN=$1
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
RUNNAME=$2

WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
LOGS=$WD/skewer_logs

if [ ! -e $LOGS ] ; then
  mkdir $LOGS
fi

cd $WD

for file in *R1.fastq.gz; do
  FQR1=$file
  FQR2=`echo $file | sed 's/_R1/_R2/g'`
  SAMPLE=`echo $file | sed 's/_R1.fastq.gz//g'`
  echo $FQR1 $FQR2 $SAMPLE
  sbatch -t 8:00:00 -c 4 --mem=16GB --wrap="skewer -f auto -m pe -z -o $SAMPLE $FQR1 $FQR2"
done 

mv *trimmed.log skewer_logs/
