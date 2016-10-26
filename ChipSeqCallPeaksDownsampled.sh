#!/bin/sh -x

##########################################
#Procedure for doing the dowsampling for 
#calculating saturation in ChipSeq data
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
N_READS=$7 #The number of reads being downsampled to
CONTROL_DIR=$8

##########################################
#Call software installed at Broad
##########################################

source /broad/software/scripts/useuse
use .homer-4.7
use .bedtools-version-2.17.0 
use .igvtools_2.1.7
use .samtools-0.1.18


##########################################
#Do stuff
#########################################

STEM=$(basename "${INPUT_BAM}" .bam) 


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

#Downsample data
/cil/shed/apps/internal/bam_utilities/GetRandomSampleByRead/GetRandomByRead -bam $INPUT_BAM -out $OUTPUT_DIR/Downsampling/bams/$STEM.$N_READS.bam -nReads $N_READS

#Make tags and call peaks
makeTagDirectory $OUTPUT_DIR/Downsampling/Tags/$STEM.$N_READS $OUTPUT_DIR/Downsampling/bams/$STEM.$N_READS.bam -genome $GENOME_FILE 

if [ "$CONTROL" == "NONE" ]; 
then
	echo "findPeaks $OUTPUT_DIR/$STEM -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$STEM.calls "
	findPeaks $OUTPUT_DIR/Downsampling/Tags/$STEM.$N_READS -style $PEAK_STYLE -o $OUTPUT_DIR/Downsampling/Peaks/$STEM.$N_READS.calls 	

else
	echo "findPeaks $OUTPUT_DIR/$STEM -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$STEM.calls -i $CONTROL_DIR"
	findPeaks $OUTPUT_DIR/Downsampling/Tags/$STEM.$N_READS -style $PEAK_STYLE -o $OUTPUT_DIR/Downsampling/Peaks/$STEM.$N_READS.calls -i $CONTROL_DIR
fi

#Count peaks
$N_PEAKS=$(grep -v "^#" $OUTPUT_DIR/Downsampling/Peaks/$STEM.$N_READS.calls | wc -l)
echo "$STEM \t $N_READS \t $N_PEAKS">>$OUTPUT_DIR/Downsampling/nPeaksDownsampling.$STEM.txt

#Clean up files
rm $OUTPUT_DIR/Downsampling/Tags/$STEM.$N_READS/*
rmdir $OUTPUT_DIR/Downsampling/Tags/$STEM.$N_READS
rm $OUTPUT_DIR/Downsampling/bams/$STEM.$N_READS.bam


done





