#!/bin/bash

ml BLAST+/2.9.0-gompi-2019a

for file in $(head "-$1" ~/TFM/mapping/lists/confirmed_spacers_file_list.txt | tail -1); do
  blastn -query ~/TFM/mapping/spacers/$file -outfmt 6 -db ~/TFM/mapping/databases/contigs_db -perc_identity 95 -qcov_hsp_perc 95 -dust no -word_size 8 -max_target_seqs 1000 -out ~/TFM/mapping/results/contigs/reports/$file.blast
done
