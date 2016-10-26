#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
BED_FILE=$3

source /broad/software/scripts/useuse
use UGER
 use .bedtools-2.25.0-bugfixed

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
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR/logs
fi



fileNames=( $( ls $INPUT_DIR/*.bed) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}") 
	echo "qsub -V -l m_mem_used=16g  -cwd -o $OUTPUT_DIR/logs -b y -j y bedtools intersect -a $f -b $3 -wa0 >$OUTPUT_DIR/$STEM.txt "
  	qsub -V -l m_mem_used=16g -cwd -o $OUTPUT_DIR/logs -b y -j y  "bedtools intersect -a $f -b $3 -wao >$OUTPUT_DIR/$STEM.txt"
done




