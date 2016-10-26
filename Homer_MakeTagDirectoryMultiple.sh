#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
CONTROL=$3 #Control bam or homer directory or NONE
PEAK_STYLE=$4 #Usually factor or histone
GENOME_FILE=$5
PAIRED_END=$6 #TRUE If paired end or else FALSE

source /broad/software/scripts/useuse
use .homer-4.7
use .bedtools-version-2.17.0 
use .igvtools_2.1.7
use .samtools-0.1.18


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

	if [ "$PAIRED_END" == "TRUE" ]; 
then
	echo "Paired end"
	echo "makeTagDirectory $OUTPUT_DIR/$STEM $INPUT_BAM -genome $GENOME_FILE -checkGC -illuminaPE"
	bsub -q forest -o $OUTPUT_DIR/LSF$STEM  makeTagDirectory $OUTPUT_DIR/$STEM $f -genome $GENOME_FILE -checkGC -illuminaPE

else
	echo "Not paired end"
	echo "makeTagDirectory $OUTPUT_DIR/$STEM $INPUT_BAM -genome $GENOME_FILE -checkGC "
	bsub -q forest -o $OUTPUT_DIR/LSF$STEM  makeTagDirectory $OUTPUT_DIR/$STEM $f -genome $GENOME_FILE -checkGC
fi



	
done




