#!/bin/sh -x

##########################################
#Procedure for processing ChipSeq data
#for the basic ChIP Sequencing SSF product
#Written by: Michele Busby
#			 Catherine Li	
#Last Changed: 2/13/15
##########################################

INPUT_BAM=$1
OUTPUT_DIR=$2
CONTROL=$3 #Control bam or homer directory or NONE
PEAK_STYLE=$4 #Usually factor or histone
GENOME_FILE=$5
PAIRED_END=$6 #TRUE If paired end or else FALSE

##########################################
#Call software installed at Broad
##########################################

source /broad/software/scripts/useuse
use .homer-4.7
use .bedtools-version-2.17.0 
use .igvtools_2.1.7
use .samtools-0.1.18

##########################################
#Set up output directories
##########################################


echo input bam: $INPUT_BAM
echo Writing to: $OUTPUT_DIR

#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi

#Downsampling directories

if [ -d $OUTPUT_DIR/Downsampling ] ; 
then 
    echo "Output directory $OUTPUT_DIR/Downsampling exists."
else 	
   echo "Output directory $OUTPUT_DIR/Downsampling does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Downsampling
fi

if [ -d $OUTPUT_DIR/Downsampling/bams ] ; 
then 
    echo "Output directory $OUTPUT_DIR/Downsampling/bams exists."
else 	
   echo "Output directory $OUTPUT_DIR/Downsampling/bams  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Downsampling/bams
fi

if [ -d $OUTPUT_DIR/Downsampling/Tags ] ; 
then 
    echo "Output directory $OUTPUT_DIR/Downsampling/tags exists."
else 	
   echo "Output directory $OUTPUT_DIR/Downsampling/tags  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Downsampling/Tags
fi



##########################################
#Find the N Peaks of downsampled fields
##########################################

for ((i=500000; i<5000000; i=i+500000));
	do

	echo sh ChipSeqCallPeaksDownsampled.sh $INPUT_BAM $OUTPUT_DIR $CONTROL $PEAK_STYLE $GENOME_FILE $PAIRED_END $i $CONTROL_DIR 
	
	bsub -q forest -o downsample.out -R "rusage[mem=8]" sh ChipSeqCallPeaksDownsampled.sh $INPUT_BAM $OUTPUT_DIR $CONTROL $PEAK_STYLE $GENOME_FILE $PAIRED_END $i $CONTROL_DIR 
done

done
