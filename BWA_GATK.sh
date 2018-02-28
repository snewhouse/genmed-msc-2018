#!/bin/bash

## This is a very simple pipeline to demostrate NGS data analysis 
## Author - Risha Govind - King's College London - Feb 2018
####################################################################
####################################################################

resultsFile=VariantCallingDay_Output

project=GenMed2018
ReadLen=150
LaneID=Lane2
SampleID=testing

FastqFile_READ_1_MAIN=/home/shared/data/fastq/GIAB.chr13.read1.fq
FastqFile_READ_2_MAIN=/home/shared/data/fastq/GIAB.chr13.read1.fq
  


#Reference File
referenceFile=/home/shared/data/genomes/hg19/chromosomes/hg19_chr13_chr21.fa
 
CDSFile=/home/shared/data/annotation_db/chr13_chr21_ProteinCodingExons.mergeBed.bed

cd ~

mkdir $resultsFile

cd $resultsFile

nt=1
dcovg=1000

FastqFile_READ_1=raw_reads_1.fq
FastqFile_READ_2=raw_reads_2.fq

cp $FastqFile_READ_1_MAIN $FastqFile_READ_1
cp $FastqFile_READ_2_MAIN $FastqFile_READ_2



## Zip reads
gzip $FastqFile_READ_1
gzip $FastqFile_READ_2

FastqFile_READ_1=raw_reads_1.fq.gz
FastqFile_READ_2=raw_reads_2.fq.gz


#count reads and assign to variable
count_lines1=`zcat $FastqFile_READ_1 | wc -l`
count_lines2=`zcat $FastqFile_READ_2 | wc -l`

echo -e "\n number of lines in $FastqFile_READ_1 : $count_lines1 \n"
echo -e "number of lines in $FastqFile_READ_2 : $count_lines2 \n"

#calculate number of reads
count_reads1=`expr $count_lines1 / 4`
count_reads2=`expr $count_lines2 / 4`

echo -e "number of reads in this file : $count_reads1 \n"
echo -e "number of reads in this file : $count_reads2 \n"


#######################################################################################################################################
# ************************************************FASTQC - QC ************************************************************************#
#######################################################################################################################################



echo -e "FastQC started"

fastqc $FastqFile_READ_1
fastqc $FastqFile_READ_2



#######################################################################################################################################
# ************************************************BWA - Alignment ********************************************************************#
#######################################################################################################################################
### -M	 Mark shorter split hits as secondary (for Picard compatibility). -t number of threads

echo -e "\n Now Running Alignment Step [BWA] ..... `date` \n"

bwa mem -M -t $nt $referenceFile $FastqFile_READ_1 $FastqFile_READ_2 > results.sam

#(If fail to locate the index : bwa index $referenceFile)

#Exercise : View SAM file
# less -S results.sam 

samtools view -bS results.sam > results.bam

samtools sort results.bam > results.sorted.bam

mv results.sorted.bam results.bam

samtools index results.bam

## Get BWA version

bwaver=`bwa 2>&1 | grep Version | awk '{print $2}'`

echo -e "Version of BWA is : $bwaver \n"

# Add RG tag [Picard Tools]

#######################################################################################################################################
# ************************************************PICARD - ADD ReadGroup Tags ********************************************************#
#######################################################################################################################################


picard AddOrReplaceReadGroups INPUT=results.bam \
OUTPUT=results.RG.bam \
SORT_ORDER=coordinate \
RGID=$project \
RGLB="$ReadLen"PEBC \
RGPL=ILLUMINA RGPU=$LaneID \
RGSM=$SampleID RGCN=BRU-RBH \
RGDS=BWA-MEM."$bwaver" \
VALIDATION_STRINGENCY=SILENT

mv results.RG.bam results.bam
samtools index results.bam

#These two are no longer necessary with HaplotypeCaller 
###Creating Intervals 
###Indel Realigning  	


#######################################################################################################################################
# ************************************************SAMTOOLS - ONLY KEEP HIGH QUALITY READS ********************************************#
#######################################################################################################################################


### Generate read on $Target MAP qual > 8
infile=results.bam

samtools view -uq 8 -F 1796 $infile > results.highQuality.bam

samtools index results.highQuality.bam

#######################################################################################################################################
# ************************************************GATK - QC **************************************************************************#
#######################################################################################################################################


infile=results.highQuality.bam

###  No of callable Bases by Exon --minDepth 10
  gatk -R $referenceFile \
  -T CallableLoci \
  -I $infile \
  -o results.minDepth10.bases.callable \
  --minMappingQuality 10 \
  --minBaseQuality 20 \
  --minDepth 10 \
  -l INFO -format BED \
  -L $CDSFile \
  -summary results.minDepth10.bases.callable.summary



#######################################################################################################################################
# ************************************************GATK - Indels and SNPs calling************************************************************#
########################################################################################################################################


####HaplotypeCaller


gatk -R $referenceFile \
-L $CDSFile \
-I $infile \
-T HaplotypeCaller \
--min_base_quality_score 10 \
-o results.HaplotypeCaller.vcf \
-stand_call_conf 30 \
--bamOutput HaplotypeCaller.bam

echo -e "\nDone : GATK HaplotypeCaller analysis were completed"

echo -e "End of script\nScript completed successfully"