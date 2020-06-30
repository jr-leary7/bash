#!/bin/bash

module add multiqc

ONYEN=$1
RUNNAME=$2
FIRST=${ONYEN:0:1}
SECOND=${ONYEN:1:1}
WD=/pine/scr/$FIRST/$SECOND/$ONYEN/${RUNNAME}_hm38
CF=$WD/${RUNNAME}_config.txt

# indicator vars - used to create text files on first iteration of a loop
i=1
j=1
k=1
# files
HOST=""
GRAFT=""
HOST_CNT=""
GRAFT_CNT=""
NAME_HOST=""
NAME_GRAFT=""

echo Sequencing run folder: $WD
cd $WD

for R1 in *R1.fastq.gz; do
  # preprocessing - find TPM count files and verify their existence
  NAME=${R1%_*}
  echo $NAME
  if [[ "$NAME" == *PDX* ]]; then
    TPM1=${NAME}_graft/quant.genes.sf
    TPM2=${NAME}_host/quant.genes.sf
    if [[ -f "$TPM1" && -f "$TPM2" ]]; then 
      echo "found $NAME expression files"
    fi
  fi
    
  if [[ "$NAME" == *Human* || "$NAME" == *Germ* ]]; then 
    TPM1=$NAME/quant.genes.sf
    TPM2=""
    if [[ -f "$TPM1" ]]; then
      echo "found $NAME expression file"
    fi
  fi
  
  if [[ "$NAME" == *Mouse* || "$NAME" == *KPC* ]]; then
    TPM1=""
    TPM2=$NAME/quant.genes.sf
    if [[ -f "$TPM2" ]]; then 
      echo found "$NAME" expression file
    fi
  fi

  # host
  if [[ -f "$TPM2" ]]; then
    if [[ $i -eq 1 ]]; then
      tail -n +2 $TPM2 | sort -d -k1,1 | cut -f 1 > $WD/"hostgenes.tmp"
      i=0
    fi

    HOST=${HOST}" "$WD/${NAME}"_host.tmp"
    HOST_CNT=${HOST_CNT}" "$WD/${NAME}"_host_cnt.tmp"
    NAME_HOST="${NAME_HOST} ${NAME}"    
    tail -n +2 $TPM2 | sort -d -k1,1 | cut -f 4  > "$WD/${NAME}_host.tmp"
    tail -n +2 $TPM2 | sort -d -k1,1 | cut -f 5  > "$WD/${NAME}_host_cnt.tmp"
    cut -f 1 $TPM2 | md5sum
    echo "____________"
  fi

  # graft
  if [[ -f "$TPM1" ]]; then 
    if [[ $j -eq 1 ]]; then 
      tail -n +2 $TPM1 | sort -d -k1,1 | cut -f 1  > $WD/"graftgenes.tmp"
      j=0
    fi

    GRAFT=${GRAFT}" "$WD/${NAME}"_graft.tmp"
    GRAFT_CNT=${GRAFT_CNT}" "$WD/${NAME}"_graft_cnt.tmp"
    NAME_GRAFT="${NAME_GRAFT} ${NAME}"
    tail -n +2 $TPM1 | sort -d -k1,1 | cut -f 4  > $WD/${NAME}"_graft.tmp"
    tail -n +2 $TPM1 | sort -d -k1,1 | cut -f 5  > $WD/${NAME}"_graft_cnt.tmp"
    cut -f 1 $TPM1 | md5sum
    echo "____________"
  fi
done

# process gene expression data
echo paste the row headings along with all the data to a tmp file
paste $WD/graftgenes.tmp $GRAFT > $WD/graftdata.tmp
paste $WD/hostgenes.tmp $HOST > $WD/hostdata.tmp
paste $WD/graftgenes.tmp $GRAFT_CNT > $WD/graftdatacnt.tmp
paste $WD/hostgenes.tmp $HOST_CNT > $WD/hostdatacnt.tmp

echo write the column headings to a tmp file
HEADHOST="gene_id "${NAME_HOST}
echo $HEADHOST | sed 's| |\t|g' > $WD/hostheader.tmp
HEADGRAFT="gene_id "${NAME_GRAFT}
echo $HEADGRAFT | sed 's| |\t|g' > $WD/graftheader.tmp

echo cat the headings on top of the data file
cat $WD/graftheader.tmp $WD/graftdata.tmp > $WD/${RUNNAME}_graft.genes.tpm_tracking
cat $WD/hostheader.tmp $WD/hostdata.tmp > $WD/${RUNNAME}_host.genes.tpm_tracking
cat $WD/graftheader.tmp $WD/graftdatacnt.tmp > $WD/${RUNNAME}_graft.genes.cnt_tracking
cat $WD/hostheader.tmp $WD/hostdatacnt.tmp > $WD/${RUNNAME}_host.genes.cnt_tracking

echo remove tmp files
rm $WD/*.tmp

# run multiqc
multiqc .


