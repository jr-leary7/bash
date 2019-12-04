#!/bin/bash

ONYEN=$1
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
RUNNAME=$2
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
MSDIR=/ms/depts/lineberger/jjyehlab/RNAseq/$RUNNAME

if [ ! -e MSDIR ] ; then
  mkdir $MSDIR
fi

cd $WD
sbatch -J fastq.gz -t 16:00:00 --partition ms --wrap="rsync --include="*/" --include="*_R*fastq.gz" --exclude="*" /ms/depts/lineberger/jjyehlab/RNAseq/$RUNNAME"

 

