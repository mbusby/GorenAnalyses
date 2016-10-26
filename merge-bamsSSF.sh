#!/bin/bash

# move all bams to a directory (e.g. unmerged).
indir=$1
OUTPUT_DIR=$2
flowcell=$3

echo indir $indir
echo OUTPUT_DIR $OUTPUT_DIR
echo flowcell $flowcell


source /broad/tools/scripts/useuse
use .samtools-0.1.18
use UGER

#If output directory does not exist make it
if [ -d $OUTPUT_DIR ] ; then 
    echo "Output directory $OUTPUT_DIR exists."
else 	
   echo "Output directory $OUTPUT_DIR does not exists. Creating directory."
   mkdir $OUTPUT_DIR
fi

#If output directory does not exist make it
if [ -d $OUTPUT_DIR/logs ] ; then 
    echo "Output directory $OUTPUT_DIR/logs exists."
else 	
   echo "Output directory $OUTPUT_DIR/logs does not exists. Creating directory."
   mkdir $OUTPUT_DIR/logs
fi


#########

echo "files are"
echo ls ${indir} 

cd $indir

suffix=aligned.duplicates_marked.bam
for experiment in $(ls -d ./*/*/ | cut -f3 -d / | sort | uniq | grep -v Solex | grep -v summary | grep -v logs)
do
    echo Experiment is $experiment
    bamfiles=$(ls ./*/$experiment/*bam | awk '{print $0" "}' | tr -d '\n')

	echo	bamfiles is $bamfiles
echo outfile is ${OUTPUT_DIR}/${experiment}.bam 
echo "samtools merge ${OUTPUT_DIR}/${experiment}.bam $bamfiles"

   qsub -V -b y -j y -h_vmem 8g -cwd -o ${OUTPUT_DIR}/logs/${experiment} "samtools merge ${OUTPUT_DIR}/${experiment}.bam $bamfiles"
done
