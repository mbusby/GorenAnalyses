#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
CONTROL_DIR=$3
PEAK_STYLE=$4
GENOME_FILE=$5
PAIRED_END=$6

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

if [ -d $OUTPUT_DIR/DownsampledBams ] ; then 
    echo "Output directory $OUTPUT_DIR/DownsampledBams exists."
else 	
   echo "Output directory $OUTPUT_DIR/DownsampledBams does not exists. Creating directory."
   mkdir $OUTPUT_DIR/DownsampledBams
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
	echo $STEM
	for DS in 1 0.95 0.9 0.85 0.8 0.75 0.7 0.65 0.60 0.55 0.50 0.45 0.4 0.35 0.3 0.25 0.2 0.15 0.1 0.05 
do
   echo $ds
	java -Xmx16g -jar /seq/software/picard/current/bin/picard.jar DownsampleSam INPUT=$f OUTPUT=$OUTPUT_DIR/DownsampledBams/$STEM$DS.bam PROBABILITY=$DS VALIDATION_STRINGENCY=SILENT	
	echo "Running"
	echo bsub -q forest sh HomerSingleSample.sh 	$OUTPUT_DIR/DownsampledBams/$STEM$DS.bam $OUTPUT_DIR $CONTROL_DIR $PEAK_STYLE $GENOME_FILE $PAIRED_END
	bsub -q forest -o $OUTPUT_DIR/LSF_$STEM sh HomerSingleSample.sh 	$OUTPUT_DIR/DownsampledBams/$STEM$DS.bam $OUTPUT_DIR $CONTROL_DIR $PEAK_STYLE $GENOME_FILE $PAIRED_END
	
done

done


