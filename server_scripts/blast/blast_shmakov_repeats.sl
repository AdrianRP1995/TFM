#!/bin/bash

ml BLAST+/2.9.0-gompi-2019a


#This script uses blast to compare our repeats with a database (.tsv file) provided by Sergei Shmakov

rm ~/TFM/blast/results/shmakov/*

rm ~/TFM/blast/results/reports/shmakov* ~/TFM/blast/results/lists/shmakov*

rm ~/TFM/blast/tables/shmakov_repeats_mismatches.tsv


python ~/TFM/blast/scripts/tsv_to_fasta.py
#This Python script converts the .tsv into a fasta file with all the info we need


makeblastdb -dbtype nucl -in ~/TFM/blast/databases/fastas/shmakov_repeats.fasta -title shmakov_repeats -out ~/TFM/blast/databases/shmakov_repeats
#We make the BLAST database


for file in $(ls ~/TFM/crispr/crispr_finds); do
  blastn -query ~/TFM/crispr/crispr_finds/$file -outfmt 7 -db ~/TFM/blast/databases/shmakov_repeats -qcov_hsp_perc 90 -dust no -word_size 8 -perc_identity 90  -max_target_seqs 1 -out ~/TFM/blast/results/shmakov/$file.blast
done
#We use a loop to iterate each fasta containing our repeats (one file per sample)


for file in $(ls ~/TFM/crispr/crispr_finds); do
  echo "$file has $(grep -c "# 1 hits found" ~/TFM/blast/results/shmakov/$file.blast)/$(grep -c ">" ~/TFM/crispr/crispr_finds/$file) hits" >> ~/TFM/blast/results/reports/shmakov_results.txt
done
#We make a report with the hits compared to the total number of arrays


for file in $(ls ~/TFM/crispr/crispr_finds); do
  grep -B3 "# 1 hits found" ~/TFM/blast/results/shmakov/$file.blast | grep -oe "\w*_contigs.fna_[0-9]*_CRISPR_[0-9]*" >> ~/TFM/blast/results/lists/shmakov_repeats_hits.txt
done
#We make a list of the positive arrays
