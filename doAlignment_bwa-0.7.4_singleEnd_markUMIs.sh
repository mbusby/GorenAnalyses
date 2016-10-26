#!/bin/bash

source /broad/software/scripts/useuse
use .bwa-0.7.4
use Java-1.8


if [ ! $# -ge 3 ]
then
    echo "doAlignment referenceSequence outputName read1fastq UMIFastq startPos UMILength outputDirectory"
    exit 255
fi

source /broad/software/scripts/useuse


STEM=$(basename "${2}" .bam) 

echo STEM is $STEM


OUTPUT=$7/$STEM.duplicates_marked.UMIs_marked.bam 
echo $OUTPUT




use .bwa-0.7.4

echo "doAlignment $1 $2 $3"
echo "executing bwa aln $1 $3"
bwa aln -t 6 $1 $3 > ${2}_1.sai

bwa samse $1 ${2}_1.sai $3 > ${2}_bwa.sam

echo "executing samtools import $1.fai ${2}_bwa.sam ${2}_bwa.bam"
/btl/prod/apps/samtools-0.1.18/samtools import $1.fai ${2}_bwa.sam ${2}_bwa.bam
echo "executing samtools sort ${2}_bwa.bam ${2}_bwa.sorted"
/btl/prod/apps/samtools-0.1.18/samtools sort ${2}_bwa.bam ${2}
mv ${2}.bam ${2}
echo "executing samtools index ${2}"
/btl/prod/apps/samtools-0.1.18/samtools index ${2}
echo "removing temporary intermediate files"
rm ${2}_1.sai
rm ${2}_bwa.sam
rm ${2}_bwa.bam


echo /cil/shed/apps/internal/RNA_utilities/AddUMIsToBam/AddUMIsToBam -bam $2 -fastq $4 -start_pos $5 -umi_length $6 -out_dir $7

/cil/shed/apps/internal/RNA_utilities/AddUMIsToBam/AddUMIsToBam -bam $2 -fastq $4 -start_pos $5 -umi_length $6 -out_dir $7



echo java -jar /seq/software/picard/current/bin/picard.jar MarkDuplicates INPUT=$7/$STEM.umis_marked.bam  OUTPUT=$7/$STEM.duplicates_marked.UMIs_marked.bam METRICS_FILE=$7/$STEM.metrics VALIDATION_STRINGENCY=LENIENT AS=TRUE


java -jar /seq/software/picard/current/bin/picard.jar MarkDuplicates INPUT=$7/$STEM.umis_marked.bam  OUTPUT=$7/$STEM.duplicates_marked.UMIs_marked.bam METRICS_FILE=$7/$STEM.metrics VALIDATION_STRINGENCY=LENIENT AS=TRUE

rm $7/$STEM.umis_marked.bam
rm $2
rm $2.bai

samtools index $7/$STEM.duplicates_marked.UMIs_marked.bam 


