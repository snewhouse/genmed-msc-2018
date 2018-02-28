#!/bin/bash

__=' 

Author : Risha Govind, Imperial College London, UK

AIM : Prepare a reference sequence so that it is suitable for use with BWA and GATK.

Steps
-----
Generate the BWA index
Generate the Fasta file index
Generate the sequence dictionary

Reference :
http://gatkforums.broadinstitute.org/discussion/2798/howto-prepare-a-reference-for-use-with-bwa-and-gatk

Late updated : December 2015

'

################## Update script.  ###############
referenceFile=/home/shared/data/genomes/hg19/chromosomes

referenceFile=hg19_chr13_chr21.fa

###############################################################################


#Step 0. Prepare Files and Folders
#----------------------------------

#change to $HOME directory and create a directory to save all reference genomes
cd ~
mkdir Reference_Genomes
cd Reference_Genomes


#copy regerence genome here
cp $referenceFileFolder/$referenceFile .



# STEP 1. Generate the BWA index [use BWA]
#--------------------------------------------
 

echo -e "\n Now Generating the BWA index ..... `date` \n"

bwa index -a bwtsw $referenceFile

#-a bwtsw specifies that we want to use the indexing algorithm that is capable of handling the whole human genome.

#Expected Result:This creates a collection of files used by BWA to perform the alignment.




#Step 2. Generate the fasta file indexing [use samtools]
#-------------------------------------------------------

echo -e "\n Now Generate the fasta file indexing ..... `date` \n"


samtools faidx $referenceFile

#Expected Result : This creates a file called reference.fa.fai, with one record per line for each of the contigs in the FASTA reference file. Each record is composed of the contig name, size, location, basesPerLine and bytesPerLine.


#Step 3. Generate the sequence dictionary
#-----------------------------------------

outfile= echo $referenceFile | sed -r 's/fasta|fa/dict/'


java -jar picard-1.119.jar CreateSequenceDictionary \
    REFERENCE=$referenceFile \ 
    OUTPUT=$outfile

#Note that this is the new syntax for use with the latest version of Picard. Older versions used a slightly different syntax because all the tools were in separate jars, so you'd call e.g. java -jar CreateSequenceDictionary.jar directly.

#Expected Result: This creates a file called reference.dict formatted like a SAM header, describing the contents of your reference FASTA file.

