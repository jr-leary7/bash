#!/bin/bash

ONYEN=$1
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
RUNNAME=$2
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/yehlab/RawRNAseq/$RUNNAME

module add cellranger

cd $WD/H*/outs/fastq_path

if [[ ! -e aggr.csv ]]; then
  touch aggr.csv
  echo "library_id,molecule_h5,batch" > aggr.csv  # sets header line
fi

for file in *L001*I*; do
  sample=`echo $file | cut -d'_' -f1-3'  # gets samplename
  hfive=$WD/$sample/outs/molecule_info.h5
  batch="fill this in later"
  echo "$sample,$hfive" >> aggr.csv
done

sbatch -t 24:00:00 -c 1 --mem=8G --wrap="cellranger aggr --id=$RUNNAME --csv=aggr.csv --normalize=mapped"

  
