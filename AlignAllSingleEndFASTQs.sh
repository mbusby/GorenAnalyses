#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
GENOME=$3
QUEUE=$4

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi



fileNames=( $( ls $INPUT_DIR/*.fastq) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}".fastq) 
	echo   	bsub -q $QUEUE -o $OUTPUT_DIR/LSF_$STEM -n 6 sh /btl/projects/epigenomics/MicheleAnalyses/scripts/doAlignment_bwa-0.7.4_singleEnd $GENOME $OUTPUT_DIR/$STEM.bam $f 

 
  	bsub -q $QUEUE -o $OUTPUT_DIR/LSF_$STEM -n 6 sh /btl/projects/epigenomics/MicheleAnalyses/scripts/doAlignment_bwa-0.7.4_singleEnd $GENOME $OUTPUT_DIR/$STEM.bam $f 
done

