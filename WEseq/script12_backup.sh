#!/bin/bash

RUNNAME=$1
ONYEN=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

cd $WD
mkdir /ms/depts/lineberger/jjyehlab/ExomeSeq/$RUNNAME

for file in *R1*fastq.gz; do
	samplename=`echo $file | sed 's/_R1_001.fastq.gz//g'`
	cd $samplename
	sbatch -t 24:00:00 -c 4 --mem=50G --wrap="rsync -P *fastq.gz /ms/depts/lineberger/jjyehlab/ExomeSeq/$RUNNAME"
	sbatch -t 24:00:00 -c 4 --mem=50G --wrap="rsync -P *noDups.bam /ms/depts/lineberger/jjyehlab/ExomeSeq/$RUNNAME/BAMs"
	sbatch -t 24:00:00 -c 4 --mem=50G --wrap="rsync -P *filtered_annotated.vcf /ms/depts/lineberger/jjyehlab/ExomeSeq/$RUNNAME/VCFs"
        sbatch -t 24:00:00 -c 4 --mem=50G --wrap="rsync -P *sam*.vcf /ms/depts/lineberger/jjyehlab/ExomeSeq/$RUNNAME/VCFs"
done	
