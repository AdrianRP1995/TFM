#!/bin/bash

#This script takes the output of MINCED program (candidate spacers from CRISPR cassettes) and separates each array (all the FASTA lines with same sample, contig and CRIPR)


rm -r ~/TFM/crispr/spacers/spacers_entries
rm -r ~/TFM/crispr/spacers/candidate_arrays
rm ~/TFM/crispr/spacers/spacers_entries/*_list
mkdir ~/TFM/crispr/spacers/spacers_entries
#We make the directory which will contain the entries .txt and the .fasta

mkdir ~/TFM/crispr/spacers/spacers_entries/list
mkdir ~/TFM/crispr/spacers/spacers_entries/curated
mkdir ~/TFM/crispr/spacers/spacers_entries/uniq
#We make folders to contain all the steps of the text processing


for file in $(ls -p ~/TFM/crispr/spacers | grep -v /); do cat ~/TFM/crispr/spacers/$file | grep ">" > ~/TFM/crispr/spacers/spacers_entries/list/"$file"_list; done
#We make a list for each spacers fasta file and send it to a .txt
#Note the grep command in the begginig of the loop, to avoid listing directories when using ls

for file in $(ls ~/TFM/crispr/spacers/spacers_entries/list); do
  cat ~/TFM/crispr/spacers/spacers_entries/list/$file | sed -E 's/_spacer_[0-9]+//g' > ~/TFM/crispr/spacers/spacers_entries/curated/curated_$file
done
#We remove "ugly" (unnecesary) parts from the list of entries


for file in $(ls ~/TFM/crispr/spacers/spacers_entries/curated); do
  uniq ~/TFM/crispr/spacers/spacers_entries/curated/$file > ~/TFM/crispr/spacers/spacers_entries/uniq/uniq_$file
done
#We keep only the entries that have a different contig and CRISPR array
#Now we can use the list to grep arrays in our spacers




cat ~/TFM/crispr/spacers/spacers_entries/uniq/* > ~/TFM/crispr/spacers/spacers_entries/merged_arrays_names.txt
#We merge all the entries to make the loops easier

rm -r ~/TFM/crispr/spacers/candidate_arrays
mkdir ~/TFM/crispr/spacers/candidate_arrays
#We make another directory that will contain the .fasta files with one array each


for file in $(ls -p ~/TFM/crispr/spacers | grep -v /); do
  mkdir ~/TFM/crispr/spacers/candidate_arrays/$file
done



for fasta in $(ls -p ~/TFM/crispr/spacers | grep -v /); do
  for array in $(cat ~/TFM/crispr/spacers/spacers_entries/uniq/uniq_curated_"$fasta"_list); do
    egrep -A 1 "$array"_spacer_[0-9]+ ~/TFM/crispr/spacers/$fasta >> ~/TFM/crispr/spacers/candidate_arrays/$fasta/$array
  done
done
#Using the names form the list we extract the headers and the sequences of each spacers fasta and introduce them in separated fastas for each array
