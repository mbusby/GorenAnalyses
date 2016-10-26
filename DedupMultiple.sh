#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
QUEUE=$3

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

source /broad/software/scripts/useuse
use Java-1.8
use UGER


#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi



#If output directory does not exist make it
if [ -d $OUTPUT_DIR/logs ] ; then 
    echo "Output directory $OUTPUT_DIR/logs exists."
else 	
   echo "Output directory $OUTPUT_DIR/logs does not exists. Creating directory."
   mkdir $OUTPUT_DIR/logs 
fi



fileNames=( $( ls $INPUT_DIR/*.bam) )

for f in ${fileNames[@]}; do
	STEM=$(basename "${f}" .bam) 
	echo "qsub -q $QUEUE -V -cwd -b y -j y -l h_vmem=12G -o $OUTPUT_DIR/logs java -Xmx8g -jar /seq/software/picard/current/bin/picard.jar  MarkDuplicates INPUT=$f OUTPUT=$OUTPUT_DIR/$STEM.dupsRemoved.bam REMOVE_DUPLICATES=true ASSUME_SORTED=true METRICS_FILE=$OUTPUT_DIR/$STEM.metrics"
  	qsub -q $QUEUE -V -cwd -b y -j y -l h_vmem=12G -o $OUTPUT_DIR/logs java -Xmx8g -jar /seq/software/picard/current/bin/picard.jar MarkDuplicates INPUT=$f OUTPUT=$OUTPUT_DIR/$STEM.dupsRemoved.bam REMOVE_DUPLICATES=true ASSUME_SORTED=true METRICS_FILE=$OUTPUT_DIR/$STEM.metrics VALIDATION_STRINGENCY=LENIENT
done




