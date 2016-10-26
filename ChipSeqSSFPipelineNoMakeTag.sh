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

if [ -d $OUTPUT_DIR/Tags ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Tags
fi

if [ -d $OUTPUT_DIR/Peaks ] ; 
then 
    echo "Output directory $OUTPUT_DIR/Peaks exists."
else 	
   echo "Output directory $OUTPUT_DIR/Peaks  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Peaks 
fi

if [ -d $OUTPUT_DIR/Peaks/bed ] ; 
then 
    echo "Output directory $OUTPUT_DIR/Peaks/bed exists."
else 	
   echo "Output directory $OUTPUT_DIR/Peaks/bed  does not exists. Creating directory."
   mkdir $OUTPUT_DIR/Peaks/bed 
fi

if [ -d $OUTPUT_DIR/tdfs ] ; 
then 
    echo "Output directory $OUTPUT_DIR/tdfs exists."
else 	
   echo "Output directory $OUTPUT_DIR/tdfs does not exists. Creating directory."
   mkdir $OUTPUT_DIR/tdfs
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
#Get stem
##########################################

STEM=$(basename "${INPUT_BAM}" .bam) 

##########################################
#Make bam a tdf
##########################################

echo "igvtools count -e 100 $INPUT_BAM $OUTPUT_DIR/tdfs/$STEM.tdf $GENOME_FILE"

igvtools count -e 100 $INPUT_BAM $OUTPUT_DIR/tdfs/$STEM.tdf $GENOME_FILE


##########################################
#Homer has to parts: makes a tag directory then does peak calling
#Make tag directory for input bam
##########################################


if [ "$PAIRED_END" == "TRUE" ]; 
then
	echo "Paired end"
	echo "makeTagDirectory $OUTPUT_DIR/$STEM $INPUT_BAM -genome $GENOME_FILE -checkGC -illuminaPE"
	makeTagDirectory $OUTPUT_DIR/Tags/$STEM $INPUT_BAM -genome $GENOME_FILE -checkGC -illuminaPE

else
	echo "Not paired end"
	echo "makeTagDirectory $OUTPUT_DIR/$STEM $INPUT_BAM -genome $GENOME_FILE -checkGC "
	makeTagDirectory $OUTPUT_DIR/Tags/$STEM $INPUT_BAM -genome $GENOME_FILE -checkGC
fi

##########################################
#Make tag directory for control bam
##########################################


if [ "$CONTROL"  != "NONE" ]  &&   [ -f  "$CONTROL" ];
then 
	echo "Control is a file, assuming bam"
	CONTROL_STEM=$(basename "${CONTROL}" .bam) 
	CONTROL_BAM=$CONTROL;
	CONTROL_DIR="$OUTPUT_DIR/Tags/$CONTROL_STEM"

	if [ "$PAIRED_END" == "TRUE" ]; then
		echo "Paired end"
		echo "makeTagDirectory $OUTPUT_DIR/$CONTROL_STEM$CONTROL_BAM -genome $GENOME_FILE -checkGC -illuminaPE"
		makeTagDirectory $CONTROL_DIR $CONTROL_BAM -genome $GENOME_FILE  -illuminaPE -checkGC

	else
		echo "Not paired end"
		echo "makeTagDirectory $OUTPUT_DIR/$CONTROL_STEM $CONTROL_BAM -genome $GENOME_FILE -checkGC "
		makeTagDirectory $CONTROL_DIR $CONTROL_BAM -genome $GENOME_FILE -checkGC	
	
	fi
elif [ "$CONTROL"  != "NONE" ]  &&  [ -d  "$CONTROL" ]; then
		echo "Control is a directory, assuming processed homer peaks"
		CONTROL_DIR="$CONTROL";
		echo "Control dir is $CONTROL_DIR "
		
else
	echo "Nothing found for control $CONTROL" 
fi

##########################################
#Find peaks
##########################################

if [ "$CONTROL" == "NONE" ]; 
then
	echo "findPeaks $OUTPUT_DIR/$STEM -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$STEM.calls "
	findPeaks $OUTPUT_DIR/Tags/$STEM -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$STEM.calls 	

else
	echo "findPeaks $OUTPUT_DIR/$STEM -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$STEM.calls -i $CONTROL_DIR"
	findPeaks $OUTPUT_DIR/Tags/$STEM -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$STEM.calls -i $CONTROL_DIR

fi

##########################################
#Make calls file a bed
##########################################

echo "cut -f2,3,4  $OUTPUT_DIR/Peaks/$STEM.calls> $OUTPUT_DIR/Peaks/bed/$STEM.bed"

cut -f2,3,4  $OUTPUT_DIR/Peaks/$STEM.calls> $OUTPUT_DIR/Peaks/bed/$STEM.bed

echo "sed -i 's/^chr\t/#chr\t/g' $OUTPUT_DIR/Peaks/bed/$STEM.bed"

sed -i 's/^chr\t/#chr\t/g' $OUTPUT_DIR/Peaks/bed/$STEM.bed


##########################################
#Get the SPOT calls
##########################################

echo "Writing spot score to $OUTPUT_DIR/Peaks/spotscores.txt"

readsInPeaks=$(bedtools intersect -abam $INPUT_BAM -b $OUTPUT_DIR/Peaks/bed/$STEM.bed -bed | wc -l)
readsInAlignment=$(samtools view $INPUT_BAM | wc -l)


spotScore=$(echo "scale=4; $readsInPeaks/$readsInAlignment" |bc)
echo "$STEM $spotScore" >> $OUTPUT_DIR/Peaks/spotscores.txt

##########################################
#Find the N Peaks of downsampled fields
##########################################

for ((i=1; i<20; i=i+1));
	do 	N_READS=$(echo "scale=0; $i//*$readsInAlignment/20" |bc)	
	echo sh ChipSeqCallPeaksDownsampled.sh $INPUT_BAM $OUTPUT_DIR $CONTROL $PEAK_STYLE $GENOME_FILE $PAIRED_END $N_READS $CONTROL_DIR 
	
	bsub -q forest -o downsample.out -R "rusage[mem=8]" sh ChipSeqCallPeaksDownsampled.sh $INPUT_BAM $OUTPUT_DIR $CONTROL $PEAK_STYLE $GENOME_FILE $PAIRED_END $N_READS $CONTROL_DIR 
done

done
