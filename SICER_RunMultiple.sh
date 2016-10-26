#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
CONTROL=$3 #Control bam 
SPECIES=$4 #genome, has to be listed in the /cil/shed/apps/external/chipseq/SICER_V1.1/SICER/lib/Genome.py file


echo Searching directory: $INPUT_DIR
echo Writing to: $OUTPUT_DIR

source /broad/software/scripts/useuse
use .bedtools-version-2.17.0 



#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi

if [ -d $OUTPUT_DIR/Peaks ] ; then 
    echo "Output directory $OUTPUT_DIR/SicerPeaks exists."
else 	
   echo "Output directory $OUTPUT_DIR/SicerPeaks  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/SicerPeaks 
fi


if [ -d $OUTPUT_DIR/Peaks/bed ] ; then 
    echo "Output directory $OUTPUT_DIR/SicerPeaks/bed exists."
else 	
   echo "Output directory $OUTPUT_DIR/SicerPeaks/bed  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/SicerPeaks/bed 
fi


if [ -d $OUTPUT_DIR/bamAsBed ] ; then 
    echo "Output directory $OUTPUT_DIR/bamAsBed exists."
else 	
   echo "Output directory $OUTPUT_DIR/bamAsBed  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/bamAsBed 
fi


CONTROL_STEM=$(basename "${CONTROL}" .bam) 

if [ -f $OUTPUT_DIR/bamAsBed/$CONTROL_STEM.bed ] ; then 
    echo "Control file exists as a bed."
else 	
	echo "Making control file into a bed file."
	echo "bedtools bamtobed -i $f > $OUTPUT_DIR/bamAsBed/$CONTROL_STEM.bed"
	bedtools bamtobed -i $f > $OUTPUT_DIR/bamAsBed/$CONTROL_STEM.bed

fi

fileNames=( $( ls $INPUT_DIR/*.bam) )

for f in ${fileNames[@]}; do

	STEM=$(basename "${f}" .bam) 
	
	echo "bedtools bamtobed -i $f > $OUTPUT_DIR/bamAsBed/$STEM.bed"
	

	if [ -f $OUTPUT_DIR/bamAsBed/$STEM.bed ] ; then 
    echo "$STEM file exists as a bed."
else 	
	echo "Making $STEM into a bed file."
	echo "bedtools bamtobed -i $f > $OUTPUT_DIR/bamAsBed/$STEM.bed"
	bedtools bamtobed -i $f > $OUTPUT_DIR/bamAsBed/$STEM.bed

fi


	
	
	echo "sh /cil/shed/apps/external/chipseq/SICER_V1.1/SICER/SICER.sh $OUTPUT_DIR/bamAsBed $STEM.bed $OUTPUT_DIR/bamAsBed/$CONTROL_STEM.bed $OUTPUT_DIR/Peaks $SPECIES 1 200 150 0.9 400 1E-2 "

	sh /cil/shed/apps/external/chipseq/SICER_V1.1/SICER/SICER.sh $OUTPUT_DIR/bamAsBed $STEM.bed $OUTPUT_DIR/bamAsBed/$CONTROL_STEM.bed $OUTPUT_DIR/Peaks $SPECIES 1 200 150 0.9 400 1E-2 


	
done




