#!/bin/bash


#This script uses a clustering program (CD-Hit) at several threslholds, to evaluate wether an array contain repetitive sequences or not
#The output is a TSV with info for each array, formated to be merged with other result tables


rm ~/TFM/crispr/tables/cdhit*

rm -r ~/TFM/crispr/clusters/cdhit
mkdir ~/TFM/crispr/clusters/cdhit


##### CLUSTERING WITH COVERAGE AND IDENTITY = 90 % #####


rm ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt
rm ~/TFM/crispr/merged_files/cdhit_provisional_spacers.fasta


for file in $(ls -p ~/TFM/crispr/spacers | grep -v /); do
  mkdir ~/TFM/crispr/clusters/cdhit/$file;
done
#We create a folder for each sample


for file in $(ls ~/TFM/crispr/clusters/cdhit); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    mkdir ~/TFM/crispr/clusters/cdhit/$file/$array
  done
done
#We create a folder for each CRISPR array, inside each sample folder


for file in $(ls ~/TFM/crispr/clusters/cdhit); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    ~/TFM/crispr/cd-hit-est -i ~/TFM/crispr/spacers/candidate_arrays/$file/$array  -o ~/TFM/crispr/clusters/cdhit/$file/"$array"/$array -g 1 -d 0 -c 0.9 -aL 0.9
  done
done
#We run CD-Hit on each array FASTA file.
#The prograrm returns a fasta with representative sequences and a .txt with info about the number of sequences in each clusters


for file in $(ls ~/TFM/crispr/clusters/cdhit); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    cat ~/TFM/crispr/clusters/cdhit/$file/"$array"/$array >> ~/TFM/crispr/merged_files/cdhit_provisional_spacers.fasta
  done
done
#Merge all fastas


for file in $(ls ~/TFM/crispr/clusters/cdhit); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    cat ~/TFM/crispr/clusters/cdhit/$file/"$array"/"$array.clstr" | egrep -A 2 "^>Cluster\s[0-9]*" | egrep -B 1 "%" | egrep "\*" | grep -Eo "$array"_spacer_[0-9]* >> ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt
  done
done
#Command that creates a list with the representative sequences (centroids) from repeated spacers clusters


sed -iE "s/_spacer_[0-9]*//g" ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt
sed -i "s/>//g" ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt
uniq ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt > ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt.tmp && mv ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt.tmp ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt
#We leave just the array name, since that's what we want to remove


mv ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt ~/TFM/crispr/tables


grep -vf ~/TFM/crispr/tables/cdhit90_repeated_arrays.txt ~/TFM/crispr/merged_files/cdhit_provisional_spacers.fasta > ~/TFM/crispr/merged_files/cdhit90_unique_spacers.fasta
#Script that removes all repeated sequences from the merged FASTA using the previously created list


grep ">" ~/TFM/crispr/merged_files/cdhit90_unique_spacers.fasta > ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt
sed -i "s/>//g" ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt
sed -iE "s/_spacer_[0-9]*//g" ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt
uniq ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt > ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt.tmp && mv ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt.tmp ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt
#We extract the array names from the unique arrays, to make a list of the non-repetitive arrays


rm ~/TFM/crispr/merged_files/cdhit_provisional_spacers.fasta


echo "Total numer of arrays: $(ls ~/TFM/crispr/spacers/candidate_arrays | wc -l)"
echo "Non-repetitive arrays with CD-HIT 90: $(wc -l ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt)"
echo "Repetitive arrays with CD-HIT 90: $(wc -l ~/TFM/crispr/tables/cdhit90_repeated_arrays.txt)"
#We count the sequences from each list to do a sanity-check for this script


echo "Making table of results..."


sed -i 's/$/\tTrue/' ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt
sed -i 's/$/\tFalse/' ~/TFM/crispr/tables/cdhit90_repeated_arrays.txt
#We start a TSV, giving True value to the not-repeated arrays and False to the repeated ones


cat ~/TFM/crispr/tables/cdhit90_repeated_arrays.txt > ~/TFM/crispr/tables/cdhit90_table.tsv
cat ~/TFM/crispr/tables/cdhit90_not_repeated_arrays.txt >> ~/TFM/crispr/tables/cdhit90_table.tsv
#We merge both TSVs to make a list of the results from this clustering


sort -t \t -k3 ~/TFM/crispr/tables/cdhit90_table.tsv > ~/TFM/crispr/tables/cdhit90_sorted_table.tsv
sed -ie '1i\Sample\tCD-Hit 90 Unique Spacers' ~/TFM/crispr/tables/cdhit90_sorted_table.tsv
#We sort the table and give it a header


echo "Done"


##### CLUSTERING WITH COVERAGE AND IDENTITY = 80 % #####


rm -r ~/TFM/crispr/clusters/cdhit
mkdir ~/TFM/crispr/clusters/cdhit


rm ~/TFM/crispr/lists/cdhit90_repeated_arrays.txt
rm ~/TFM/crispr/merged_files/cdhit_provisional_spacers.fasta


for file in $(ls -p ~/TFM/crispr/spacers | grep -v /); do
  mkdir ~/TFM/crispr/clusters/cdhit/$file;
done
#We create a folder for each sample


for file in $(ls ~/TFM/crispr/clusters/cdhit); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    mkdir ~/TFM/crispr/clusters/cdhit/$file/$array
  done
done
#We create a folder for each CRISPR array, inside each sample folder


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    ~/TFM/crispr/cd-hit-est -i ~/TFM/crispr/spacers/candidate_arrays/$file/$array  -o ~/TFM/crispr/clusters/cdhit/$file/"$array"/$array -g 1 -d 0 -c 0.8 -aL 0.8
  done
done
#We run CD-Hit on each array FASTA file.
#The prograrm returns a fasta with representative sequences and a .txt with info about the number of sequences in each clusters


for file in $(ls ~/TFM/crispr/clusters/cdhit); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    cat ~/TFM/crispr/clusters/cdhit/$file/"$array"/$array >> ~/TFM/crispr/merged_files/cdhit_provisional_spacers.fasta
  done
done
#Merge all fastas


for file in $(ls ~/TFM/crispr/clusters/cdhit); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    cat ~/TFM/crispr/clusters/cdhit/$file/"$array"/"$array.clstr" | egrep -A 2 "^>Cluster\s[0-9]*" | egrep -B 1 "%" | egrep "\*" | grep -Eo "$array"_spacer_[0-9]* >> ~/TFM/crispr/lists/cdhit80_repeated_arrays.txt
  done
done
#Command that creates a list with the representative sequences (centroids) from repeated spacers clusters


sed -iE "s/_spacer_[0-9]*//g" ~/TFM/crispr/lists/cdhit80_repeated_arrays.txt
sed -i "s/>//g" ~/TFM/crispr/lists/cdhit80_repeated_arrays.txt
uniq ~/TFM/crispr/lists/cdhit80_repeated_arrays.txt > ~/TFM/crispr/lists/cdhit80_repeated_arrays.txt.tmp && mv ~/TFM/crispr/lists/cdhit80_repeated_arrays.txt.tmp ~/TFM/crispr/lists/cdhit80_repeated_arrays.txt
#We leave just the array name, since that's what we want to remove


mv ~/TFM/crispr/lists/cdhit80_repeated_arrays.txt ~/TFM/crispr/tables


grep -vf ~/TFM/crispr/tables/cdhit80_repeated_arrays.txt ~/TFM/crispr/merged_files/cdhit_provisional_spacers.fasta > ~/TFM/crispr/merged_files/cdhit80_unique_spacers.fasta
#Script that removes all repeated sequences from the merged FASTA using the previously created list


grep ">" ~/TFM/crispr/merged_files/cdhit80_unique_spacers.fasta > ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt
sed -i "s/>//g" ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt
sed -iE "s/_spacer_[0-9]*//g" ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt
uniq ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt > ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt.tmp && mv ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt.tmp ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt
#We extract the array names from the unique arrays, to make a list of the non-repetitive arrays


rm ~/TFM/crispr/merged_files/cdhit_provisional_spacers.fasta


echo "Total numer of arrays: $(ls ~/TFM/crispr/spacers/candidate_arrays | wc -l)"
echo "Non-repetitive arrays with CD-HIT 80: $(wc -l ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt)"
echo "Repetitive arrays with CD-HIT 80: $(wc -l ~/TFM/crispr/tables/cdhit80_repeated_arrays.txt)"
#We count the sequences from each list to do a sanity-check for this script


echo "Making table of results..."


sed -i 's/$/\tTrue/' ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt
sed -i 's/$/\tFalse/' ~/TFM/crispr/tables/cdhit80_repeated_arrays.txt
#We start a TSV, giving True value to the not-repeated arrays and False to the repeated ones


cat ~/TFM/crispr/tables/cdhit80_repeated_arrays.txt > ~/TFM/crispr/tables/cdhit80_table.tsv
cat ~/TFM/crispr/tables/cdhit80_not_repeated_arrays.txt >> ~/TFM/crispr/tables/cdhit80_table.tsv
#We merge both TSVs to make a list of the results from this clustering


sort -t \t -k3 ~/TFM/crispr/tables/cdhit80_table.tsv > ~/TFM/crispr/tables/cdhit80_sorted_table.tsv
sed -ie '1i\Sample\tCD-Hit 80 Unique Spacers' ~/TFM/crispr/tables/cdhit80_sorted_table.tsv
#We sort the table and give it a header


echo "Done"


#### MERGING ALL TABLES OF RESULTS ####


paste ~/TFM/crispr/tables/cdhit90_sorted_table.tsv ~/TFM/crispr/tables/cdhit80_sorted_table.tsv | cut -f 1,2,4 > ~/TFM/crispr/tables/cd-hit_clustering_results.tsv


rm ~/TFM/crispr/tables/cdhit*
