#!/bin/bash

ml BLAST+/2.9.0-gompi-2019a


#This script uses blast to compare our repeats and spacers with the database from CRISPR Web Service.
#This database contains only confirmed CRISPR arrays.

mkdir ~/TFM/blast/results/crispr_ws


rm -r ~/TFM/blast/results/crispr_ws/*
rm ~/TFM/blast/results/reports/crispr_ws* ~/TFM/blast/results/lists/crispr_ws*


mkdir ~/TFM/blast/results/crispr_ws/repeats
mkdir ~/TFM/blast/results/crispr_ws/spacers


makeblastdb -dbtype nucl -in ~/TFM/blast/databases/fastas/crispr_ws_repeats.fa -title crispr_ws_repeats -out ~/TFM/blast/databases/crispr_ws_repeats
makeblastdb -dbtype nucl -in ~/TFM/blast/databases/fastas/crispr_ws_spacers.fa -title crispr_ws_spacers -out ~/TFM/blast/databases/crispr_ws_spacers
#We make one database for the repeats and other for the spacers


for file in $(ls ~/TFM/crispr/crispr_finds); do
  blastn -query ~/TFM/crispr/crispr_finds/$file -outfmt 7 -db ~/TFM/blast/databases/crispr_ws_repeats -qcov_hsp_perc 90 -dust no -word_size 8 -perc_identity 90  -max_target_seqs 1 -out ~/TFM/blast/results/crispr_ws/repeats/$file.blast
done
#We use a loop for the repeat files, since they are separated by sample


blastn -query ~/TFM/crispr/merged_files/merged_spacers.fasta -outfmt 7 -qcov_hsp_perc 90 -dust no -word_size 8 -db ~/TFM/blast/databases/crispr_ws_spacers -evalue 0.001  -max_target_seqs 1 -out ~/TFM/blast/results/crispr_ws/spacers/crispr_ws_spacers.blast
#We use all the spacers, since we want to test whether they are present in our database


for file in $(ls ~/TFM/crispr/crispr_finds); do
  echo "$file has $(grep -c "# 1 hits found" ~/TFM/blast/results/crispr_ws/repeats/$file.blast)/$(grep -c ">" ~/TFM/crispr/crispr_finds/$file) hits" >> ~/TFM/blast/results/reports/crispr_ws_repeats_results.txt
done
#We make a report of the hits, to check if necessary


for file in $(ls ~/TFM/crispr/crispr_finds); do
  grep -B3 "# 1 hits found" ~/TFM/blast/results/crispr_ws/repeats/$file.blast | grep -oe "\w*_contigs.fna_[0-9]*_CRISPR_[0-9]*" >> ~/TFM/blast/results/lists/crispr_ws_repeats_hits.txt
done
#We make a list of the repeats that appear in the database


egrep -B 3 "[^0] hits found" ~/TFM/blast/results/crispr_ws/spacers/crispr_ws_spacers.blast | grep -oe "\w*_contigs.fna_[0-9]*_CRISPR_[0-9]*_spacer_[0-9]*" | sed  -e "s/_spacer_[0-9]*//g" | uniq > ~/TFM/blast/results/lists/crispr_ws_spacers_hits.txt
#We make a list with the arrays that contain hit for the spacers from the db
