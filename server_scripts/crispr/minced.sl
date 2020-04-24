#!/bin/bash


ml MinCED/0.4.2-Java-13.0.2


#This script takes FASTAs as input and finds CRISPR cassettes in them
#In this case, we are using contigs from metagenomics
#The output is a .GFF3 with rerpesentative sequences for repeats, and one FASTA with all the spacers

rm -r ~/TFM/crispr/crispr_finds/*
rm -r ~/TFM/crispr/spacers/*
rm ~/TFM/crispr/merged_files/merged_spacers.fasta


for file in $(cat ~/TFM/crispr/lists/files_list.txt); do
  java -jar $EBROOTMINCED/minced.jar -spacers -gff ~/TFM/crispr/contigs/uncompressed/$file > ~/TFM/crispr/crispr_finds/$file.gff
done


mv ~/TFM/crispr/contigs/uncompressed/*.fa ~/TFM/crispr/spacers/
#The spacers FASTA appears in the same folder as the contigs, so we move them to their folder

cat ~/TFM/crispr/spacers/* >> ~/TFM/crispr/merged_files/merged_spacers.fasta
