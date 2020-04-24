#!/bin/bash
#This script makes a BLAST search of confirmed spacers against themselves to make clusters later


ml BLAST+/2.9.0-gompi-2019a

rm -r ~/TFM/mapping/results/spacers_clustering/

mkdir ~/TFM/mapping/results/spacers_clustering/
mkdir ~/TFM/mapping/results/spacers_clustering/reports
mkdir ~/TFM/mapping/results/spacers_clustering/clusters


rm ~/TFM/mapping/results/spacers_clustering/clusters_address_list.txt


cp ~/TFM/mapping/merged_files/confirmed_spacers.fasta ~/TFM/mapping/databases/fastas
#We move the confirmed spacers FASTA to our database folder


makeblastdb -dbtype nucl -in ~/TFM/mapping/databases/fastas/confirmed_spacers.fasta -title merged_spacers -out ~/TFM/mapping/databases/merged_spacers
#We make the BLAST database


blastn -query ~/TFM/mapping/merged_files/confirmed_spacers.fasta -outfmt 6 -db ~/TFM/mapping/databases/merged_spacers -perc_identity 95 -qcov_hsp_perc 95 -dust no -word_size 8 -max_target_seqs 10000000 -out ~/TFM/mapping/results/spacers_clustering/spacers_clustering.blast
#We do the search. This one doesn't need to be paralelized since it's not a very big search
