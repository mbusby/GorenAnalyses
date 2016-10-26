#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
QUEUE=$3

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

source /broad/software/scripts/useuse
use Java-1.8
use R


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
	echo "qsub -V -cwd -b y -j y -o $OUTPUT_DIR -l h_vmem=8G java -Xmx8g -jar /seq/software/picard/current/bin/picard.jar CollectInsertSizeMetrics INPUT=$f OUTPUT=$OUTPUT_DIR/$STEM.insert_size_metrics.txt  HISTOGRAM_FILE=$STEM.insert_size_histogram.pdf VALIDATION_STRINGENCY=LENIENT "
  	qsub -V -cwd -b y -j y -o $OUTPUT_DIR -l h_vmem=8G java -Xmx8g -jar /seq/software/picard/current/bin/picard.jar CollectInsertSizeMetrics INPUT=$f OUTPUT=$OUTPUT_DIR/$STEM.insert_size_metrics.txt  HISTOGRAM_FILE=$STEM.insert_size_histogram.pdf VALIDATION_STRINGENCY=LENIENT
done




