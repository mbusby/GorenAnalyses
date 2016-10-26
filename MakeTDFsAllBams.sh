#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
GENOME=$3

source /broad/software/scripts/useuse
use Samtools
use igvtools_2.3

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
	samtools index $f

  STEM=$(basename "${f}" .aligned.duplicates_marked.bam) 
echo "bsub -q week -o LSF igvtools count -e 100 $f $OUTPUT_DIR/$STEM.tdf $GENOME"
  bsub -q week -o LSF igvtools count -e 100 $f $OUTPUT_DIR/$STEM.tdf $GENOME	
done




