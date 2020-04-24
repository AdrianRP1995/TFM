#!/bin/bash

ml BLAST+/2.9.0-gompi-2019a


rm ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_list.tsv
rm ~/TFM/blast/results/cas_genes/*


mkdir ~/TFM/blast/results/cas_genes


grep acquisition_1 ~/TFM/blast/databases/fastas/HMMMS_cas_genes/profFam.tab > ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_list.tsv
grep acquisition_2 ~/TFM/blast/databases/fastas/HMMMS_cas_genes/profFam.tab >> ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_list.tsv
grep effector_ ~/TFM/blast/databases/fastas/HMMMS_cas_genes/profFam.tab >> ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_list.tsv
#We make a list of the files we are going to use


cut -f 1 ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_list.tsv > ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_list.txt
rm ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_list.tsv
#We keep only the names of the files


ls ~/TFM/blast/databases/fastas/HMMMS_cas_genes/ | grep -f ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_list.txt > ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_files_list.txt
rm ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_list.txt
#We use the full name of the files


rm -r ~/TFM/blast/databases/fastas/HMMMS_cas_genes/sr_files


mkdir ~/TFM/blast/databases/fastas/HMMMS_cas_genes/sr_files
cp ~/TFM/blast/databases/fastas/HMMMS_cas_genes/Type_VI_profiles/* ~/TFM/blast/databases/fastas/HMMMS_cas_genes/sr_files
cp ~/TFM/blast/databases/fastas/HMMMS_cas_genes/Type_V_profiles/* ~/TFM/blast/databases/fastas/HMMMS_cas_genes/sr_files


for file in $(cat ~/TFM/blast/databases/fastas/HMMMS_cas_genes/cas_genes_files_list.txt); do
  sed -zE 's/>(\w*\.\w*)(\s)/\1\t/g' ~/TFM/blast/databases/fastas/HMMMS_cas_genes/$file | sed -zE 's/>(\w*)(\s)/\1\t/g' | sed -zE 's/>(\S*)(\s)/\1\t/g' > ~/TFM/blast/databases/fastas/HMMMS_cas_genes/sr_files/$file.sr
done
#To use PSI-Blast in_msa option, we must convert all FASTA files into .sr format


makeblastdb -dbtype prot -in ~/TFM/gene_prediction/merged_files/merged_filtered_protreins.fasta -title cas_genes -out ~/TFM/blast/databases/cas_genes


for file in $(ls ~/TFM/blast/databases/fastas/HMMMS_cas_genes/sr_files/); do
  psiblast -in_msa ~/TFM/blast/databases/fastas/HMMMS_cas_genes/sr_files/$file -db ~/TFM/blast/databases/cas_genes -outfmt 7 -max_target_seqs 1 -evalue 0.000001 -out ~/TFM/blast/results/cas_genes/$file.blast
done


cat ~/TFM/blast/results/cas_genes/* | egrep -A 1 "[^0] hits found" | egrep -o "\w*_contigs.fna_[0-9]*" | sort -u > ~/TFM/blast/results/lists/cas_genes_hits_contigs.txt
