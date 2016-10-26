#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2


source /broad/software/scripts/useuse
use .bedtools-2.25.0-bugfixed 
use GridEngine8

echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi



fileNames=( $( ls $INPUT_DIR/*.bed) )

for fa in ${fileNames[@]}; do
	for fb in ${fileNames[@]}; do
		STEMA=$(basename "${fa}" .bed) 
		STEMB=$(basename "${fb}" .bed) 
		echo "qsub -V -cwd -b y -o $OUTPUT_DIR -j y bedtools intersect -a $fa -b $fb -wa -f .5 | sort | uniq>$OUTPUT_DIR/intersect$STEMA._x_.$STEMB.bed "
  		qsub -V -cwd -b y -o $OUTPUT_DIR -j y "bedtools intersect -a $fa -b $fb -wa -f .5 | sort | uniq>$OUTPUT_DIR/intersect$STEMA._x_.$STEMB.bed"
	done
done




