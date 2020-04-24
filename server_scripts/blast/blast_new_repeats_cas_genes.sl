#!/bin/bash

ml BLAST+/2.9.0-gompi-2019a


#This script uses the repeats we confirmed with our gene prediction pipeline, and makes a Blast to try to retrieve more confirmed arrays

rm ~/TFM/blast/databases/fastas/cas_genes_confirmed_repeats.fasta ~/TFM/blast/results/lists/cas_genes_confirmed_repeats_hits.txt
rm -r ~/TFM/blast/results/cas_genes_confirmed_repeats
mkdir ~/TFM/blast/results/cas_genes_confirmed_repeats


for sample in $(ls ~/TFM/crispr/crispr_finds); do
  grep -A 1 -f ~/TFM/blast/results/lists/cas_genes_hits_contigs.txt ~/TFM/crispr/crispr_finds/$sample | sed -zE "s/--\n//g" >> ~/TFM/blast/databases/fastas/cas_genes_confirmed_repeats.fasta
done


makeblastdb -dbtype nucl -in ~/TFM/blast/databases/fastas/cas_genes_confirmed_repeats.fasta -title cas_genes_confirmed_repeats -out ~/TFM/blast/databases/cas_genes_confirmed_repeats
#First, we extract the repeats from the arrays that have hits with the Cas genes database to make a fasta file and a Blast database


for file in $(ls ~/TFM/crispr/crispr_finds); do
  blastn -query ~/TFM/crispr/crispr_finds/$file -outfmt 6 -db ~/TFM/blast/databases/cas_genes_confirmed_repeats -perc_identity 90  -qcov_hsp_perc 90 -dust no -word_size 8 -max_target_seqs 10 -out ~/TFM/blast/results/cas_genes_confirmed_repeats/$file.blast
done


for file in $(ls ~/TFM/blast/results/cas_genes_confirmed_repeats); do
  cut -f 1 ~/TFM/blast/results/cas_genes_confirmed_repeats/$file >> ~/TFM/blast/results/lists/cas_genes_confirmed_repeats_hits.txt
done


sort -u ~/TFM/blast/results/lists/cas_genes_confirmed_repeats_hits.txt > ~/TFM/blast/results/lists/sorted_cas_genes_confirmed_repeats_hits.txt
#We make the blast and use the output to make a list of the repeats that have any hit. Most of them will abe auto-hits, but some of them will be new confirmed repeats
