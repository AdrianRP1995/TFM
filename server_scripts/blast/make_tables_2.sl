#!/bin/bash

#This script uses all the lists with blast results and makes a .tsv showing the results for each array
#We will make two tables, one reporting if an array has any hit, and other reporting the number of mismatches


rm ~/TFM/blast/tables/*


#SHMAKOV TABLE


for file in $(ls ~/TFM/crispr/crispr_finds); do
  grep -A 1 -e "# [^0] hits found" ~/TFM/blast/results/shmakov/$file.blast | grep "contigs" | cut -f 1,5 >> ~/TFM/blast/tables/shmakov_repeats_mismatches.tsv
done
#We extract a .tsv file with the number of mismatches


sed 's/$/\tTrue/' ~/TFM/blast/results/lists/shmakov_repeats_hits.txt > ~/TFM/blast/tables/shmakov_repeats_hits.tsv
#We make a .tsv file with the confirmed repeats from this database


grep -vf ~/TFM/blast/results/lists/shmakov_repeats_hits.txt ~/TFM/crispr/merged_files/all_repeats_arrays.txt | sed 's/$/\tFalse/' > ~/TFM/blast/tables/shmakov_repeats_misses.tsv
#We search all the files that are not in the list of hists and do other .tsv


grep -vf ~/TFM/blast/results/lists/shmakov_repeats_hits.txt ~/TFM/crispr/merged_files/all_repeats_arrays.txt | sed 's/$/\tNA/' > ~/TFM/blast/tables/shmakov_repeats_misses_mismatches.tsv
#We do the same to get our list of mismatches


echo "Total number of arrays: $(wc -l ~/TFM/crispr/merged_files/all_repeats_arrays.txt)"
echo "Arrays with hits: $(wc -l ~/TFM/blast/tables/shmakov_repeats_hits.tsv)"
echo "Arrays with no hit: $(wc -l ~/TFM/blast/tables/shmakov_repeats_misses.tsv)"
#We check the number of arrays to confirm that the numbers are complementary, and therefore there isn't any missing entry or overlapping


echo "Making tables"


cat ~/TFM/blast/tables/shmakov_repeats_hits.tsv > ~/TFM/blast/tables/shmakov_hits_table.tsv
cat ~/TFM/blast/tables/shmakov_repeats_misses.tsv >> ~/TFM/blast/tables/shmakov_hits_table.tsv
#We merge both tables


sed -i 's/>//g' ~/TFM/blast/tables/shmakov_hits_table.tsv


sort -t \t -k3 ~/TFM/blast/tables/shmakov_hits_table.tsv  > ~/TFM/blast/tables/shmakov_hits_sorted_table.tsv
sed -ie '1i\Sample\tShmakov Repeats DB' ~/TFM/blast/tables/shmakov_hits_sorted_table.tsv
#We sort the table and give it a header


cat ~/TFM/blast/tables/shmakov_repeats_misses_mismatches.tsv > ~/TFM/blast/tables/shmakov_mismatches_table.tsv
cat ~/TFM/blast/tables/shmakov_repeats_mismatches.tsv >> ~/TFM/blast/tables/shmakov_mismatches_table.tsv


sed -i 's/>//g' ~/TFM/blast/tables/shmakov_mismatches_table.tsv

sort -t \t -k3 ~/TFM/blast/tables/shmakov_mismatches_table.tsv  > ~/TFM/blast/tables/shmakov_mismatches_sorted_table.tsv
sed -ie '1i\Sample\tShmakov Mismatches' ~/TFM/blast/tables/shmakov_mismatches_sorted_table.tsv
#We repeat the procedure with the mismatches tables


echo "Merging tables"


paste ~/TFM/blast/tables/shmakov_hits_sorted_table.tsv ~/TFM/blast/tables/shmakov_mismatches_sorted_table.tsv | cut -f 1,2,4 > ~/TFM/blast/tables/shmakov_results_table.tsv


echo "Done"


#CRISPR WEB SERVICE DATABASE


for file in $(ls ~/TFM/crispr/crispr_finds); do
  grep -A 1 "# 1 hits found"  ~/TFM/blast/results/crispr_ws/repeats/$file.blast | grep "contigs" | cut -f 1,5 >> ~/TFM/blast/tables/crispr_ws_repeats_mismatches.tsv
done
#We extract a .tsv file with the number of mismatches


sed 's/$/\tTrue/' ~/TFM/blast/results/lists/crispr_ws_repeats_hits.txt > ~/TFM/blast/tables/crispr_ws_repeats_hits.tsv
#We make a .tsv file with the confirmed repeats from this database


grep -vf ~/TFM/blast/results/lists/crispr_ws_repeats_hits.txt ~/TFM/crispr/merged_files/all_repeats_arrays.txt | sed 's/$/\tFalse/'> ~/TFM/blast/tables/crispr_ws_repeats_misses.tsv
#We search all the files that are not in the list of hists and do other .tsv


grep -vf ~/TFM/blast/results/lists/crispr_ws_repeats_hits.txt ~/TFM/crispr/merged_files/all_repeats_arrays.txt | sed 's/$/\tNA/'> ~/TFM/blast/tables/crispr_ws_repeats_misses_mismatches.tsv


echo "Total number of arrays: $(wc -l ~/TFM/crispr/merged_files/all_repeats_arrays.txt)"
echo "Arrays with hits: $(wc -l ~/TFM/blast/tables/crispr_ws_repeats_hits.tsv)"
echo "Arrays with no hit: $(wc -l ~/TFM/blast/tables/crispr_ws_repeats_misses.tsv)"
#We check the number of arrays to confirm that the numbers are complementary, and therefore there isn't any missing entry or overlapping


echo "Making tables"


cat ~/TFM/blast/tables/crispr_ws_repeats_hits.tsv > ~/TFM/blast/tables/crispr_ws_repeats_table.tsv
cat ~/TFM/blast/tables/crispr_ws_repeats_misses.tsv >> ~/TFM/blast/tables/crispr_ws_repeats_table.tsv
#We merge both tables


cat ~/TFM/blast/tables/crispr_ws_repeats_misses_mismatches.tsv > ~/TFM/blast/tables/crispr_ws_repeats_mismatches_table.tsv
cat ~/TFM/blast/tables/crispr_ws_repeats_mismatches.tsv >> ~/TFM/blast/tables/crispr_ws_repeats_mismatches_table.tsv
#We do the same for the mismatches tables


sed -i 's/>//g' ~/TFM/blast/tables/crispr_ws_repeats_table.tsv


sort -t \t -k3 ~/TFM/blast/tables/crispr_ws_repeats_table.tsv  > ~/TFM/blast/tables/crispr_ws_repeats_sorted_table.tsv
sed -ie '1i\Sample\tCRISPR WS Repeats DB' ~/TFM/blast/tables/crispr_ws_repeats_sorted_table.tsv
#We sort the table and give it a header


sort -t \t -k3 ~/TFM/blast/tables/crispr_ws_repeats_mismatches_table.tsv  > ~/TFM/blast/tables/crispr_ws_repeats_mismatches_sorted_table.tsv
sed -ie '1i\Sample\tCRISPR WS Repeats Mismatches' ~/TFM/blast/tables/crispr_ws_repeats_mismatches_sorted_table.tsv


echo "Merging tables"


paste ~/TFM/blast/tables/crispr_ws_repeats_sorted_table.tsv ~/TFM/blast/tables/crispr_ws_repeats_mismatches_sorted_table.tsv | cut -f 1,2,4 > ~/TFM/blast/tables/crispr_ws_repeats_results_table.tsv


echo "Done"


# MAKAROVA CAS GENES DATABASE

rm ~/TFM/blast/results/lists/cas_genes_hits.txt

for file in $(ls ~/TFM/crispr/crispr_finds); do
  grep -f ~/TFM/blast/results/lists/cas_genes_hits_contigs.txt ~/TFM/crispr/crispr_finds/$file | sed 's/>//g' >> ~/TFM/blast/results/lists/cas_genes_hits.txt
done
#We translate the confirmed contigs into arrays and make a list in .txt


sed 's/$/\tTrue/' ~/TFM/blast/results/lists/cas_genes_hits.txt > ~/TFM/blast/tables/cas_genes_hits.tsv
#We make a .tsv file with the confirmed arrays from this database


grep -vf ~/TFM/blast/results/lists/cas_genes_hits.txt ~/TFM/crispr/merged_files/all_repeats_arrays.txt | sed 's/$/\tFalse/' | sed 's/>//g' > ~/TFM/blast/tables/cas_genes_misses.tsv
#We search all the files that are not in the list of hists and do other .tsv


echo "Total number of arrays: $(wc -l ~/TFM/crispr/merged_files/all_repeats_arrays.txt)"
echo "Arrays with hits: $(wc -l ~/TFM/blast/tables/cas_genes_hits.tsv)"
echo "Arrays with no hit: $(wc -l ~/TFM/blast/tables/cas_genes_misses.tsv)"
#We check the number of arrays to confirm that the numbers are complementary, and therefore there isn't any missing entry or overlapping


echo "Making tables"


cat ~/TFM/blast/tables/cas_genes_hits.tsv > ~/TFM/blast/tables/cas_genes_table.tsv
cat ~/TFM/blast/tables/cas_genes_misses.tsv >> ~/TFM/blast/tables/cas_genes_table.tsv
#We merge both tables


sort  ~/TFM/blast/tables/cas_genes_table.tsv  > ~/TFM/blast/tables/cas_genes_sorted_table.tsv
sed -ie '1i\Sample\tCas Genes Makarova DB' ~/TFM/blast/tables/cas_genes_sorted_table.tsv
#We sort the table and give it a header


echo "Done"


#CAS CONFIRMED REPEATS AUTO SEARCH


sed 's/$/\tTrue/' ~/TFM/blast/results/lists/sorted_cas_genes_confirmed_repeats_hits.txt > ~/TFM/blast/tables/cas_genes_confirmed_repeats_hits.tsv
#We make a .tsv file with the confirmed arrays from this database


grep -vf ~/TFM/blast/results/lists/sorted_cas_genes_confirmed_repeats_hits.txt ~/TFM/crispr/merged_files/all_repeats_arrays.txt | sed 's/$/\tFalse-NA/' | sed 's/>//g' > ~/TFM/blast/tables/cas_genes_confirmed_repeats_misses.tsv
#We search all the files that are not in the list of hists and do other .tsv


echo "Total number of arrays: $(wc -l ~/TFM/crispr/merged_files/all_repeats_arrays.txt)"
echo "Arrays with hits: $(wc -l ~/TFM/blast/tables/cas_genes_confirmed_repeats_hits.tsv)"
echo "Arrays with no hit: $(wc -l ~/TFM/blast/tables/cas_genes_confirmed_repeats_misses.tsv)"
#We check the number of arrays to confirm that the numbers are complementary, and therefore there isn't any missing entry or overlapping


echo "Making tables"


cat ~/TFM/blast/tables/cas_genes_confirmed_repeats_hits.tsv > ~/TFM/blast/tables/cas_genes_confirmed_repeats_table.tsv
cat ~/TFM/blast/tables/cas_genes_confirmed_repeats_misses.tsv >> ~/TFM/blast/tables/cas_genes_confirmed_repeats_table.tsv
#We merge both tables


sort  ~/TFM/blast/tables/cas_genes_confirmed_repeats_table.tsv  > ~/TFM/blast/tables/cas_genes_confirmed_repeats_sorted_table.tsv
sed -ie '1i\Sample\tCas Confirmed Repeats Auto Search' ~/TFM/blast/tables/cas_genes_confirmed_repeats_sorted_table.tsv
#We sort the table and give it a header


#MERGING ALL TABLES


paste ~/TFM/blast/tables/shmakov_results_table.tsv ~/TFM/blast/tables/crispr_ws_repeats_results_table.tsv ~/TFM/blast/tables/cas_genes_sorted_table.tsv ~/TFM/blast/tables/cas_genes_confirmed_repeats_sorted_table.tsv| cut -f 1,2,3,5,6,8,10 > ~/TFM/blast/tables/blast_definitive_results.tsv


rm ~/TFM/blast/tables/*shmakov* ~/TFM/blast/tables/*crispr* ~/TFM/blast/tables/*.tsve ~/TFM/blast/tables/cas*
