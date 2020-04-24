#!/bin/bash
#This script makes a Blastn of all confirmed spacers against a database made up of IMG/VR DB, NCBI Virus DB (only complete genomes) and NCBI Genomes (Viruses)
#The output is a .blast file with all the results, that will be processed later


ml BLAST+/2.9.0-gompi-2019a


rm -r ~/TFM/mapping/results/virus_genomes/*


mkdir ~/TFM/mapping/results/virus_genomes/reports


makeblastdb -dbtype nucl -in ~/TFM/mapping/databases/fastas/virus_genomes.fasta -title virus_genomes -out ~/TFM/mapping/databases/virus_genomes


grep -A 1 -f ~/TFM/mapping/lists/confirmed_arrays.txt ~/TFM/crispr/merged_files/merged_spacers.fasta | sed -z 's/--\n//g' > ~/TFM/mapping/merged_files/confirmed_spacers.fasta
#This is not really useful for this search, but will be usegful later

#blastn -query ~/TFM/mapping/merged_files/confirmed_spacers.fasta -outfmt 7 -db ~/TFM/mapping/databases/virus_genomes -perc_identity 80  -max_target_seqs 1 -out ~/TFM/mapping/results/virus_genomes/reports/virus_genomes.blast
#PARALELIZED
