#!/bin/bash
if [ ! $# -ge 4 ]
then
    echo "doAlignment referenceSequence outputName read1fastq read2fastq"
    exit 255
fi

#These take each of the inputs and gives them a variable name
REERENCE_SEQUENCE=$1
OUTPUT_NAME=$2
READ1_FASTQ=$3
READ2_FASTQ=$4

#This tells the server to use the Broad dotkits
source /broad/software/scripts/useuse

#This loads the dotkit
use .bwa-0.7.10 

echo "doAlignment $REERENCE_SEQUENCE $OUTPUT_NAME $READ1_FASTQ $READ2_FASTQ"
echo "bwa aln -t 10 $REERENCE_SEQUENCE $READ1_FASTQ > ${OUTPUT_NAME}_1.sai"

#This aligns the first read to the genome
bwa aln $REERENCE_SEQUENCE $READ1_FASTQ > ${OUTPUT_NAME}_1.sai
echo "executing bwa aln $REERENCE_SEQUENCE $READ2_FASTQ"

#This aligns the second read to the genome
bwa aln -t 10 $REERENCE_SEQUENCE $READ2_FASTQ > ${OUTPUT_NAME}_2.sai
echo "execuing bwa sampe $REERENCE_SEQUENCE ${OUTPUT_NAME}_1.sai ${OUTPUT_NAME}_1.sai $READ1_FASTQ $READ2_FASTQ"

#This takes the two alignments from the paired end file and resolves them into a bam binary file
bwa sampe $REERENCE_SEQUENCE ${OUTPUT_NAME}_1.sai ${OUTPUT_NAME}_2.sai $READ1_FASTQ $READ2_FASTQ > ${OUTPUT_NAME}_bwa.sam

echo "executing samtools import $REERENCE_SEQUENCE.fai ${OUTPUT_NAME}_bwa.sam ${OUTPUT_NAME}_bwa.bam"

/btl/prod/apps/samtools-0.1.18/samtools import $REERENCE_SEQUENCE.fai ${OUTPUT_NAME}_bwa.sam ${OUTPUT_NAME}_bwa.bam

#This sorts the alignment

echo "executing samtools sort ${OUTPUT_NAME}_bwa.bam ${OUTPUT_NAME}_bwa.sorted"
/btl/prod/apps/samtools-0.1.18/samtools sort ${OUTPUT_NAME}_bwa.bam ${OUTPUT_NAME}
mv ${OUTPUT_NAME}.bam ${OUTPUT_NAME}

#This creates the index file (.bai) for the alignment
echo "executing samtools index ${OUTPUT_NAME}"
/btl/prod/apps/samtools-0.1.18/samtools index ${OUTPUT_NAME}
echo "removing temporary intermediate files"

#This cleans up (removes) the intermediate files that take up lots of space
rm ${OUTPUT_NAME}_1.sai
rm ${OUTPUT_NAME}_2.sai
rm ${OUTPUT_NAME}_bwa.sam
rm ${OUTPUT_NAME}_bwa.bam
