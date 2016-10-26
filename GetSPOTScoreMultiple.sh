#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_FILE=$2
BED_FILE=$3

source /broad/software/scripts/useuse
use .bedtools-2.25.0-bugfixed
use UGER
use .samtools-0.1.18

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_FILE
echo bed: $BED_FILE


fileNames=( $( ls $INPUT_DIR/*.bam) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}") 

	echo "Writing spot score $OUTPUT_FILE"

readsInPeaks=$(bedtools intersect -abam $f -b $BED_FILE -bed | wc -l)
readsInAlignment=$(samtools view $f | wc -l)

echo Reads in Alignment: $readsInAlignment


spotScore=$(echo "scale=4; $readsInPeaks/$readsInAlignment" |bc)
echo "$f $BED_FILE $readsInPeaks $readsInAlignment $spotScore" >> $OUTPUT_FILE

	
done




