#!/bin/bash


ml BLAST+/2.9.0-gompi-2019a


#This script makes a Blast of our confirmed spacers against our own database, to search for viral sequences outside the CRISPR arrays

rm -r ~/TFM/mapping/results/contigs/ ~/TFM/mapping/results/contigs/not_autohits_autoblast_results.tsv
mkdir ~/TFM/mapping/results/contigs/
mkdir ~/TFM/mapping/results/contigs/reports


cat ~/TFM/crispr/contigs/uncompressed/* > ~/TFM/mapping/databases/fastas/merged_contigs.fasta
#We merge all contigs in one file to make the database


egrep -o "\w*_contigs.fna_[0-9]*" ~/TFM/crispr/contigs/uncompressed/* | sed -E 's@/home/adrian/TFM/crispr/contigs/uncompressed/\w*_contigs.fna:@@g' | sort -u > ~/TFM/mapping/lists/contigs_list.txt
#We make a list of all contigs


sed -iE 's/\sflag=[0-9]*.*//g' ~/TFM/mapping/databases/fastas/merged_contigs.fasta
#We preocess the id entry of each contig to be able to access it with out list


makeblastdb -dbtype nucl -in ~/TFM/mapping/databases/fastas/merged_contigs.fasta -title contigs_db -parse_seqids -out ~/TFM/mapping/databases/contigs_db
#First, we make a Blast database with all our sequences


#blastn -query ~/TFM/mapping/merged_files/confirmed_spacers.fasta -outfmt 6 -db ~/TFM/mapping/databases/contigs_db -perc_identity 95 -qcov_hsp_perc 95 -dust no -word_size 8 -max_target_seqs 10 -out ~/TFM/mapping/results/contigs/reports/auto_blast.blast
#We make a Blast search using all contigs as a db, and store them in one file
#DONE IN ANOTHER SCRIPT
