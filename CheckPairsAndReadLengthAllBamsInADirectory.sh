#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_FILE=$2

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_FILE


fileNames=( $( ls $INPUT_DIR/*.bam) )

for f in ${fileNames[@]}; do
	 
	FIRST_SEQ="$(samtools view $f | head -1 | cut -f10)"	
echo FIRST_SEQ is $FIRST_SEQ
	FIRST_SAM_FLAG="$(samtools view $f| head -1 | cut -f2)"
echo FIRST_SAM_FLAG is $FIRST_SAM_FLAG

	echo $f $FIRST_SAM_FLAG $FIRST_SEQ >> $OUTPUT_FILE

done




