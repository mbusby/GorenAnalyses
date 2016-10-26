#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
QUEUE=$3

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

source /broad/software/scripts/useuse


#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi


fileNames=( $( ls $INPUT_DIR/*.bed) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}" .bam) 
	echo "bsub -q $QUEUE -o $OUTPUT_DIR/LSF_$STEM.txt sort -k1,1 -k2,2n $f >$OUTPUT_DIR/$STEM.sorted.bed"
  	bsub -q $QUEUE -o $OUTPUT_DIR/LSF_$STEM.txt "sort -k1,1 -k2,2n $f >$OUTPUT_DIR/$STEM.sorted.bed"
done




