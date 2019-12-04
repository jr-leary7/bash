#!/bin/bash

module add samtools/1.9

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

sbatch -t 8:00:00 -c 6 --mem=24G /nas/longleaf/home/$ONYEN/ChIPseq_scripts/subroutines/samtools_launch2.sh $WD
