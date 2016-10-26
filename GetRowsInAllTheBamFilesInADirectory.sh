#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2

source /broad/software/scripts/useuse
use UGER
use .samtools-1.3 

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi


fileNames=( $( ls $INPUT_DIR/*.bam) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}" .bam) 
	
  	qsub -V -cwd -b y -o $OUTPUT_DIR -j y -l h_vmem=24G "samtools view $f | wc -l > $OUTPUT_DIR/out$STEM.rows"	

done

