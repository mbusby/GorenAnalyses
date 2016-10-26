#!/bin/sh -x
INPUT=$1  #homer directories or bam
OUTPUT_DIR=$2
CONTROL_DIR=$3
PEAK_STYLE=$4 #Usually factor or histone
GENOME_FILE=$5
PAIRED_END=$6 #TRUE If paired end or else FALSE

source /broad/software/scripts/useuse
use .homer-4.7
use .bedtools-version-2.17.0 
use .igvtools_2.1.7
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


#If the Input is a bam make it into a homer directory

if [ -f  "$INPUT" ];
then 
	echo "Input is a file, assuming bam"
	INPUT_STEM=$(basename "${INPUT}" .bam) 
	ORIGINAL_INPUT_BAM=$INPUT

	echo INPUT_STEM is $INPUT_STEM
	
	INPUT_BAM=$INPUT
	INPUT_DIR="$OUTPUT_DIR/Tags/$INPUT_STEM"

	if [ "$PAIRED_END" == "TRUE" ]; then
		echo "Paired end"
		echo "makeTagDirectory $INPUT_DIR $INPUT_BAM -genome $GENOME_FILE -illuminaPE -checkGC -tbp 1"
		makeTagDirectory $INPUT_DIR $INPUT_BAM -genome $GENOME_FILE  -illuminaPE -checkGC -tbp 1


	else
		echo "Not paired end"
		echo "makeTagDirectory $INPUT_DIR $INPUT_BAM -genome $GENOME_FILE -checkGC -tbp 1"
		makeTagDirectory $INPUT_DIR $INPUT_BAM -genome $GENOME_FILE  -checkGC -tbp 1
	
	fi
elif  [ -d  "$INPUT" ]; then
		echo "Input is a directory, assuming processed homer peaks"
		INPUT_DIR="$INPUT"
		echo "INPUT dir is $INPUT_DIR "
		INPUT_STEM=$(basename $INPUT)
		
else
	echo "Something has gone terribly wrong. Nothing found for INPUT $INPUT.  I don't know what to do next." 
fi


#Call peaks
 
fileDirectories=( $( ls -d $CONTROL_DIR/* ))

for f in ${fileDirectories[@]}; do

	CONTROL_STEM=$(basename $f)
	
	echo $CONTROL_STEM

	echo "findPeaks $INPUT_DIR -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$INPUT_STEM.$CONTROL_STEM.calls -i $f"
	bsub -q week -o $OUTPUT_DIR/LSF$INPUT_STEM.$CONTROL_STEM findPeaks $INPUT_DIR -style $PEAK_STYLE -o $OUTPUT_DIR/Peaks/$INPUT_STEM.$CONTROL_STEM.calls -i $f

	
done




