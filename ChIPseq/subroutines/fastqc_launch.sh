#!/bin/bash

module add fastqc/0.11.7
module add r/3.6.0

FQR=$1  # this is the samplename
WD=$2  # this is the directory containing all fastqs

FQR1=${FQR}_R1.fastq.gz
FQR2=${FQR}_R2.fastq.gz

echo $WD
cd $WD
echo $FQR1
echo $FQR2
echo "running fastqc"

job='sbatch -J fastqc --output='${WD}'/fastqc_logs/'${FQR1}_fastqc.out' --mem=4G --wrap="fastqc $FQR1 --outdir '$WD'"'
echo $job
eval $job
sleep 0.5

job='sbatch -J fastqc --output='${WD}'/fastqc_logs/'${FQR2}_fastqc.out' --mem=4G --wrap="fastqc $FQR2 --outdir '$WD'"'
echo $job
eval $job
sleep 0.5 

echo "finished fastqc"

