#!/bin/bash
#This script takes the GFF3 files with the repeats information from MinCed and turns them into FASTA files


rm -r ~/TFM/crispr/merged_files/all_repeats_arrays.txt
rm -r ~/TFM/crispr/crispr_finds/gff_no_headers ~/TFM/crispr/gff_files

mkdir ~/TFM/crispr/crispr_finds/gff_no_headers
mkdir ~/TFM/crispr/gff_files


for file in $(ls -p ~/TFM/crispr/crispr_finds | grep -v /); do
  tail -n +2 ~/TFM/crispr/crispr_finds/$file > ~/TFM/crispr/crispr_finds/gff_no_headers/$file
done
#We remove the headers from the GFF3. files


for file in $(ls -p ~/TFM/crispr/crispr_finds/gff_no_headers | grep -v /); do
  sed -i 's/rpt_unit_seq=//g' ~/TFM/crispr/crispr_finds/gff_no_headers/$file
done


for file in $(ls -p ~/TFM/crispr/crispr_finds/gff_no_headers | grep -v /); do
  sed -i 's/ID=//g' ~/TFM/crispr/crispr_finds/gff_no_headers/$file
done
#We remove unnecesary information from the GFF3 files to make easier the parsing


mv ~/TFM/crispr/crispr_finds/*.gff ~/TFM/crispr/gff_files
#We move all the GFF3 files to a different folder


for file in $(ls -p ~/TFM/crispr/crispr_finds/gff_no_headers | grep -v /); do
  python ~/TFM/crispr/scripts/gff_to_fasta.py ~/TFM/crispr/crispr_finds/gff_no_headers/$file ~/TFM/crispr/crispr_finds/$file.fasta
done
#This Python script receives the modified GFF3 files as input and turns them into FASTA files
#The FASTA files contain the repeat representative sequence from each array

rm -r ~/TFM/crispr/crispr_finds/gff_no_headers


for sample in $(ls ~/TFM/crispr/crispr_finds); do
  sed -i 's/_CRISPR/_CRISPR_/g' ~/TFM/crispr/crispr_finds/$sample
done
#We format the fasta files to match with the rest of the database

for file in $(ls ~/TFM/crispr/crispr_finds); do
  grep ">" ~/TFM/crispr/crispr_finds/$file >> ~/TFM/crispr/merged_files/all_repeats_arrays.txt
done
#We make a merged fasta with all spacers and a list of all candidate arrays from the repeat list
