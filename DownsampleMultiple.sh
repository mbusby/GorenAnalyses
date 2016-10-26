#!/bin/sh -x
INPUT_DIR=$1
OUTPUT_DIR=$2
N_READS=$3


source /broad/software/scripts/useuse
use .bedtools-2.25.0-bugfixed
use UGER


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
	STEM=$(basename "${f}".bam) 
	echo "qsub -V -cwd -b y -o $OUTPUT_DIR  -l h_vmem=12G -j y -q long /cil/shed/apps/internal/bam_utilities/GetRandomSampleByRead/GetRandomByRead -bam $f -out $OUTPUT_DIR/$STEM.$N_READS.bam -nReads $N_READS -aligned_only false"
  	qsub -V -cwd -b y -o $OUTPUT_DIR -j y -l h_vmem=12G -q long /cil/shed/apps/internal/bam_utilities/GetRandomSampleByRead/GetRandomByRead -bam $f -out $OUTPUT_DIR/$STEM.$N_READS.bam -nReads $N_READS -aligned_only false
done




