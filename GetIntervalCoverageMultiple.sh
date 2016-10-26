#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
BED_FILE=$3

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



fileNames=( $( ls $INPUT_DIR/*.bam) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}") 
	STEM_BED=$(basename "${3}") 
	echo "qsub -V -cwd -o $OUTPUT_DIR/ -j y -b y  -l h_vmem=260g -q long bedtools coverage -b $f -a $3 >$OUTPUT_DIR/out$STEM.$STEM_BED.txt "
  	qsub -V -cwd -o $OUTPUT_DIR/ -j y -b y -l h_vmem=260g -q long "bedtools coverage -b $f -a $3 >$OUTPUT_DIR/out$STEM.$STEM_BED.txt"
	
done




