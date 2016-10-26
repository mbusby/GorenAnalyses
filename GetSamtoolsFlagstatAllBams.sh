#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_FILE=$2

source /broad/software/scripts/useuse
use UGER
use .samtools-1.3 

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_FILE



fileNames=( $( ls $INPUT_DIR/*.bam) )

echo "samtools flagstat for " $INPUT_DIR >$OUTPUT_FILE 

for f in ${fileNames[@]}; do
	echo $f >> $OUTPUT_FILE	
  	samtools flagstat $f >>$OUTPUT_FILE

done

