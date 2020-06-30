#!/bin/bash

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/yehlab/RawRNAseq/$RUNNAME/TwoIndexes

sbatch --partition ms --wrap="rsync --include="*/" --include="*fastq.gz" --exclude="*_L00*" --exclude="*" $WD/*fastq.gz /ms/depts/lineberger/jjyehlab/RNAseq/$RUNNAME/"
