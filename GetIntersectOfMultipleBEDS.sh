#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
BED_FILE=$3
QUEUE=$4

source /broad/software/scripts/useuse
use .bedtools-2.25.0-bugfixed
use UGER

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi

#If output directory does not exist make it
if [ -d $OUTPUT_DIR/logs ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR/logs does not exists. Creating directory."
   mkdir $OUTPUT_DIR/logs
fi



fileNames=( $( ls $INPUT_DIR/*.bed) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}") 
	echo "qsub -V -cwd -o $OUTPUT_DIR/ -b y -j y -q $QUEUE -l m_mem_used=16g -o $OUTPUT_DIR/logs bedtools intersect -b $f -F .6 -a $3 -wa -wb >$OUTPUT_DIR/$STEM.txt "
  	qsub -V -cwd -o $OUTPUT_DIR/ -b y -j y -q $QUEUE -l m_mem_used=16g -o $OUTPUT_DIR/logs "bedtools intersect -b $f -F .6 -a $3 -wa -wb  >$OUTPUT_DIR/$STEM.txt"
done




