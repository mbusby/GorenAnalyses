#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
CONTROL=$3 #Control bam or homer directory or NONE
PEAK_STYLE=$4 #Usually factor or histone
GENOME_FILE=$5
PAIRED_END=$6 #TRUE If paired end or else FALSE

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi

if [ -d $OUTPUT_DIR/Peaks ] ; then 
    echo "Output directory $OUTPUT_DIR/Peaks exists."
else 	
   echo "Output directory $OUTPUT_DIR/Peaks  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Peaks 
fi

if [ -d $OUTPUT_DIR/Peaks/bed ] ; then 
    echo "Output directory $OUTPUT_DIR/Peaks/bed exists."
else 	
   echo "Output directory $OUTPUT_DIR/Peaks/bed  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Peaks/bed 
fi


fileNames=( $( ls $INPUT_DIR/*.bam) )

for f in ${fileNames[@]}; do

	STEM=$(basename "${f}" .bam) 

	echo "bsub -q forest -o $OUTPUT_DIR/LSF_$STEM.txt sh HomerSingleSample.sh $f $OUTPUT_DIR $CONTROL $PEAK_STYLE $GENOME_FILE $PAIRED_END"

  	bsub -q forest -o $OUTPUT_DIR/LSF_$STEM.txt sh HomerSingleSample.sh $f $OUTPUT_DIR $CONTROL $PEAK_STYLE $GENOME_FILE $PAIRED_END

	
done




