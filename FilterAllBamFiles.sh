#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
CHR_TO_KEEP=$3

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
		echo "bsub -q $QUEUE -R mem8 samtools view -b -o $OUTPUT_DIR/$STEM $f $CHR_TO_KEEP"
 # 	bsub -q forest -R mem8 samtools view -b -o $OUTPUT_DIR/$STEM $f chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 
bsub -q forest samtools view -b -o $OUTPUT_DIR/$STEM $f chr19 
done




