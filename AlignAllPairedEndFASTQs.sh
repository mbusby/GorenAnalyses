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

fileNames=( $( ls $INPUT_DIR/*_R1_*.fastq))



for f in ${fileNames[@]}; do
	STEM=$(basename "${f}".fastq) 


	f2="${f/.1_/.2_}"

	echo   	bsub -q $QUEUE -n 10 -o $OUTPUT_DIR/LSF_$STEM sh /btl/projects/epigenomics/MicheleAnalyses/scripts/doAlignment_bwa-0.7.10_pairedEnd.sh $GENOME $OUTPUT_DIR/$STEM.bam $f $f2


  	bsub -q $QUEUE -n 10 -o $OUTPUT_DIR/LSF_$STEM sh /btl/projects/epigenomics/MicheleAnalyses/scripts/doAlignment_bwa-0.7.10_pairedEnd.sh $GENOME $OUTPUT_DIR/$STEM.bam $f $f2

done

