#!/bin/sh -x
INPUT_DIR=$1
OUTPUT=$2

source /broad/software/scripts/useuse
use UGER
use .samtools-1.3 

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT

fileNames=( $( ls $INPUT_DIR/*/*/*.bam) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}" .bam) 
	echo "qsub -V -cwd -b y -o $OUTPUT.UGER.txt -j y samtools view $f | wc -l | awk '{print \$1 " " \" $f\"}' >> $OUTPUT"
 
  	qsub -V -cwd -b y -o $OUTPUT.UGER.txt -j y "samtools view $f | wc -l | awk '{print \$1 \" \" \" $f\"}' >> $OUTPUT"	

done

