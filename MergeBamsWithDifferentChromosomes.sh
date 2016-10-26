#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
SHARED_HEADER=$3

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR
echo Header with all chromosomes: $SHARED_HEADER

#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi

cp  $SHARED_HEADER $OUTPUT_DIR/merged.sam

fileNames=( $( ls $INPUT_DIR/*.bam) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}") 
	echo $f
	samtools view $f >> $OUTPUT_DIR/merged.sam
done

echo "samtools view -bS $OUTPUT_DIR/merged.sam $OUTPUT_DIR/merged"

samtools view -bS $OUTPUT_DIR/merged.sam > $OUTPUT_DIR/merged.bam

echo "samtools sort $OUTPUT_DIR/merged.bam merged.sorted"
samtools sort $OUTPUT_DIR/merged.bam merged.sorted


