#!/bin/bash

ml BLAST+/2.9.0-gompi-2019a

for file in $(head "-$1" ~/TFM/crispr/lists/files_list.txt | tail -1); do
  blastn -query ~/TFM/mapping/merged_files/autoblast_queries/$file -outfmt 6 -db ~/TFM/mapping/databases/virus_genomes -perc_identity 95 -qcov_hsp_perc 95 -max_target_seqs 1000000 -out ~/TFM/mapping/results/auto_blast_2/reports/$file.blast
done
