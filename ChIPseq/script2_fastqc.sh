#!/bin/bash

module add fastqc/0.11.8
module add r/3.6.0

echo running fastqc

ONYEN=$1
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
RUNNAME=$2
CONFIG=${RUNNAME}_config.txt
echo $ONYEN $RUNNAME $CONFIG

WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
LOGS=${WD}/fastqc_logs
CF=$WD/$CONFIG

if [ ! -e $LOGS ] ; then
  mkdir $LOGS
fi

echo $LOGS

cd $WD

while read sample type genome; do
  echo $sample $type $genome
done < $CF

while read sample type genome; do 
  echo $sample 
  echo $type
  job='sbatch -J '$RUNNAME' -c 8 -t 8:00:00 --mem=16G -e '${LOGS}'/'${sample}'_fastq.err -o '${LOGS}'/'${sample}'_fastq.out /nas/longleaf/home/$ONYEN/ChIPseq_scripts/subroutines/fastqc_launch.sh '$sample' '$WD''
  
  echo $job
  sleep 0.5
  eval $job
  sleep 0.5
done < $CF

mkdir qc
