#!/bin/bash

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
RAWDIR=/pine/scr/$FIRST/$SECOND/$ONYEN/yehlab/RawRNAseq/$RUNNAME/TwoIndexes

WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
if [[ ! -e $WD ]]; then 
  mkdir $WD
fi

# create symlinks to .fastq files
cd $WD
find $RAWDIR -regex '.*S[0-9]+_R.?.fastq.gz' -execdir sh -c "echo \"{}\" ; ln -s ${RAWDIR}/\"{}\" ${WD}/\"{}\"" \;

# create config files
ls *R1.fastq.gz | sed "s/_R1.fastq.gz//" | sed -r "s/Human(.*)/Human\1\tHuman\thg38/" | sed -r "s/Mouse(.*)/Mouse\1\tMouse\tmm10/" | sed -r "s/PDX(.*)/PDX\1\tPDX\thm38/" | sed -r "s/Germ(.*)/Germ\1\tHuman\thg38/" | sort -k2,2g -t 'S' > ${RUNNAME}_config.txt

