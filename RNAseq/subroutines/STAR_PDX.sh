#!/bin/bash

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38

cd $WD
module add star/2.6.0a

R1=$1
R2=`echo $R1 | sed 's/_R1/_R2/g'`
NAME=${R1%_*}

# Run STAR w/ hg38 reference
INDEX=/proj/seq/data/STAR_genomes/GRCh38_p10_GENCODE
REF=/proj/seq/data/STAR_genomes/GRCh38_p10_GENCODE/GRCh38.p10.genome.fa
FLAT=/proj/jjyehlab/projects/RNAseq/helper/refFlat.GRCh38_p10_GENCODE.txt.gz
INTERVALS=/proj/jjyehlab/projects/RNAseq/helper/ribosomal_hg38.interval_list
STAR --runThreadN 16 --readFilesCommand zcat --genomeDir $INDEX --readFilesIn $R1 $R2 --outSAMtype BAM Unsorted SortedByCoordinate --quantMode TranscriptomeSAM --outFileNamePrefix $NAME/${NAME}_STAR_graft --outSAMunmapped Within

# Run STAR w/ mm10 reference
INDEX=/proj/seq/data/STAR_genomes/GRCm38_p5_GENCODE
REF=/proj/seq/data/STAR_genomes/GRCm38_p5_GENCODE/GRCm38.p5.genome.fa
FLAT=/proj/jjyehlab/projects/RNAseq/helper/refFlat.GRCm38_p5_GENCODE.txt.gz
INTERVALS=/proj/jjyehlab/projects/RNAseq/helper/ribosomal_mm10.interval_list
STAR --runThreadN 16 --readFilesCommand zcat --genomeDir $INDEX readFilesIn $R1 $R2 --outSAMtype BAM Unsorted SortedByCoordinate --quantMode TranscriptomeSAM --outfileNamePrefix $NAME/${NAME}_STAR_host --outSAMunmapped Within
