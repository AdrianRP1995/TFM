#!/bin/bash

ml BEDTools/2.28.0-GCC-8.2.0-2.31.1
ml Biopython/1.73-foss-2019a

#This script takes the output of the contigs_auto_blast.sl script and processes them to search viral sequences in the coordinates obtained

rm -r mkdir ~/TFM/mapping/results/virus_genomes/
mkdir ~/TFM/mapping/results/virus_genomes/
mkdir ~/TFM/mapping/results/virus_genomes/reports


rm ~/TFM/mapping/results/contigs/autoblast_filtered_results.tsv ~/TFM/mapping/results/contigs/autoblast_filtering_report.txt ~/TFM/mapping/results/contigs/filtered_neighbourhoods.bed


cat ~/TFM/mapping/results/contigs/reports/* > ~/TFM/mapping/results/contigs/reports/auto_blast.blast
#First, we merge all blast results into one big report


sed -E 's/_CRISPR_[0-9]*_spacer_[0-9]*//g' ~/TFM/mapping/results/contigs/reports/auto_blast.blast > ~/TFM/mapping/results/contigs/reports/processed_auto_blast.blast
#We change the name of the subject sequences, since we only need the contig information and this way it will be easier to find autohits


python ~/TFM/mapping/scripts/filter_autoblast_results.py
#This script filters the blast results and only keeps the ones that are not autohits and also filters out the ones that are known CRISPR arrays
#The output is a .tsv file with filtered arrays and their coordinates


cut -f 2 ~/TFM/mapping/results/contigs/autoblast_filtered_results.tsv | sort -u > ~/TFM/mapping/lists/filtered_autoblasts_contigs.txt
#From this .tsv we extract the contig names
########

rm ~/TFM/mapping/merged_files/autoblast_contigs.fasta



blastdbcmd -entry_batch ~/TFM/mapping/lists/filtered_autoblasts_contigs.txt -db ~/TFM/mapping/databases/contigs_db -out ~/TFM/mapping/merged_files/autoblast_contigs_test.fasta
#This script extracts all filtered contigs and their sequences and makes a new fasta file


python ~/TFM/mapping/scripts/count_contigs_sequences.py
#This script makes a .tsv file with the filtered contigs that we'll use in the next script


python ~/TFM/mapping/scripts/create_bed_file.py
#This script uses the coordinates file from before, and adds a neighbourhood of 5 Kb, down and upstream


sort -u ~/TFM/mapping/results/contigs/filtered_neighbourhoods.bed > ~/TFM/mapping/results/contigs/filtered_sorted_coordinates.bed
#We make sure no coordinate is repeated. Overlapping neighbourhoods can occur, but not identical ones

bedtools getfasta -fi ~/TFM/mapping/merged_files/autoblast_contigs_test.fasta -bed ~/TFM/mapping/results/contigs/filtered_sorted_coordinates.bed -fo ~/TFM/mapping/merged_files/autoblast_filtered_contigs.fasta
#This program uses the .bed file and extracts the sequences from said  coordinates


rm ~/TFM/mapping/merged_files/autoblast_queries/*


mkdir ~/TFM/mapping/merged_files/autoblast_queries


for file in $(cat ~/TFM/crispr/lists/files_list.txt); do
  grep -A 1 $file ~/TFM/mapping/merged_files/autoblast_filtered_contigs.fasta >> ~/TFM/mapping/merged_files/autoblast_queries/$file
done
#At last, we separate the filtered neighbourhoods by each sample name, to make the next Blast faster
