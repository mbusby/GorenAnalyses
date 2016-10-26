#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
QUEUE=$3

source /broad/software/scripts/useuse
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



fileNames=( $( ls $INPUT_DIR/*/*/*.bam) )

count=0;
for f in ${fileNames[@]}; do
	DIRNAME=$(dirname $f )	
	SAMPLE_NAMES[count]=$(basename $DIRNAME )	
	count=`expr $count + 1`
done

SAMPLE_NAMES_U=( $(
    for el in "${SAMPLE_NAMES[@]}"
    do
        echo "$el"
    done | sort | uniq) )


echo done sorting

for s in ${SAMPLE_NAMES_U[@]}; do
	fileNames=( $( ls $INPUT_DIR/*/$s/*.bam) )	
	echo $s

	echo samtools merge $OUTPUT_DIR/$s.bam ${fileNames[@]}
	bsub -q $QUEUE samtools merge $OUTPUT_DIR/$s.bam ${fileNames[@]}

done

	