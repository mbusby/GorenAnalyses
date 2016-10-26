#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2

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
  STEM=$(basename "${f}" .aligned.duplicates_marked.bam) 
  #bsub -q forest makeTagDirectory $STEM $f  -genome /seq/references/Homo_sapiens_assembly19/v1/Homo_sapiens_assembly19.fasta -checkGC
   findPeaks $STEM -style histone -o $OUTPUT_DIR/Peaks/$STEM.calls
   cut -f2,3,4  ./Peaks/$STEM> $OUTPUT_DIR/Peaks/bed/$STEM.bed
	
done




