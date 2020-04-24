#!/bin/bash

#This script takes the output of MinCED program (script "extract_spacers.sl")
#This output is evaluated by clustering (UCLust) with an identity value of 0.9 and 0.8, to differentiatie between arrays that contain repeated spacers and the ones that don't
#When all sequences are evaluated, a TSV is made, with information for every array


rm ~/TFM/crispr/tables/uclust*


rm -r ~/TFM/crispr/clusters/uclust
mkdir ~/TFM/crispr/clusters/uclust
#We create a folder to contain all our data from uclust


##### CLUSTERING WITH COVERAGE AND IDENTITY = 90 % #####

for file in $(ls -p ~/TFM/crispr/spacers | grep -v /); do
  mkdir ~/TFM/crispr/clusters/uclust/$file;
done
#We create a folder for each sample


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    mkdir ~/TFM/crispr/clusters/uclust/$file/$array
  done
done
#We create a folder for each array in each sample folder


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
      ~/TFM/crispr/usearch -cluster_fast ~/TFM/crispr/spacers/candidate_arrays/"$file"/"$array" -sort length -id 0.9 -clusters ~/TFM/crispr/clusters/uclust/$file/"$array"/
  done
done
#We apply UClust on each candidate array, and store the resulting clusters in each array folder
#The program output is a FASTA containing clustered sequences


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    for cluster in $(ls ~/TFM/crispr/clusters/uclust/$file/"$array" | egrep -wo "[0-9]*"); do
      echo "$cluster = $(cat ~/TFM/crispr/clusters/uclust/$file/"$array"/$cluster | grep ">" | wc -l) sequences" >> ~/TFM/crispr/clusters/uclust/$file/"$array"/"cluster_seq_count_$array.txt"
    done
  done
done
#We cout the sequences in each cluster and write the report to a .txt


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    cat ~/TFM/crispr/clusters/uclust/$file/"$array"/"cluster_seq_count_$array.txt" | grep -v "= 1 sequences" > ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"
  done
done
#We look for the sequences that have more that one sequence, this is, repeated spacers


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    sed -ie "s/ = [0-9]* sequences//g" ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"
  done
done
#Once we've looked for the information, we erase the sequence info and stay just with the names


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    for cluster in $(cat ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"); do
      cat ~/TFM/crispr/clusters/uclust/$file/"$array"/$cluster >> ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_spacers_$array.fasta"
    done
  done
done
#We extract headers and sequences from the arrays that have repeated sequences, one per array


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    grep ">" ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_spacers_$array.fasta" >> ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_$array.txt"
  done
done
#We extract the headers from their respective _all_sequences, in order to make a list of the arrays that contain repeated sequences


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    for cluster in $(cat ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"); do
      sed -iE "s/_spacer_[0-9]*//g" ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_$array.txt"
    done
  done
done


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    for cluster in $(cat ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"); do
      sed -i "s/>//g" ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_$array.txt"
    done
  done
done
#We format the headers until only the array name is left
#


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    uniq ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_$array.txt" >> ~/TFM/crispr/tables/uclust90_repeated_arrays.txt
  done
done
#We use uniq to filtrate the repetitions of arrays that contain more than one cluster with more than one sequence, and make a definite list of repeated arrays


cat ~/TFM/crispr/spacers/spacers_entries/merged_arrays_names.txt | grep -vf ~/TFM/crispr/tables/uclust90_repeated_arrays.txt > ~/TFM/crispr/tables/uclust90_not_repeated_arrays.txt
#We use the list of repeated arrays to extract the list of not repeated candidate_arrays


sed -i "s/>//g" ~/TFM/crispr/tables/uclust90_not_repeated_arrays.txt
#We process the not repeated list in a simmilar manner, to leave only the array names


echo "Total numer of arrays: $(cat ~/TFM/crispr/spacers/spacers_entries/merged_arrays_names.txt | wc -l)"
echo "Non-repetitive arrays with UClust 90: $(wc -l ~/TFM/crispr/tables/uclust90_not_repeated_arrays.txt)"
echo "Repetitive arrays with UClust 90: $(wc -l ~/TFM/crispr/tables/uclust90_repeated_arrays.txt)"
#We count the number of arrays as a sanity-check of the script


echo "Making table of results..."


sed -i 's/$/\tTrue/' ~/TFM/crispr/tables/uclust90_not_repeated_arrays.txt
sed -i 's/$/\tFalse/' ~/TFM/crispr/tables/uclust90_repeated_arrays.txt
#We start a column for a TSV with the info of repeated or not repeated arrays
#We add True for not-repeated arrays and False for the repeated ones


cat ~/TFM/crispr/tables/uclust90_not_repeated_arrays.txt > ~/TFM/crispr/tables/uclust90_table.tsv
cat ~/TFM/crispr/tables/uclust90_repeated_arrays.txt >> ~/TFM/crispr/tables/uclust90_table.tsv
#We merge both lists to a TSV


sort -t \t -k3 ~/TFM/crispr/tables/uclust90_table.tsv > ~/TFM/crispr/tables/uclust90_sorted_table.tsv
sed -ie '1i\Sample\tUClust 90 Unique Spacers' ~/TFM/crispr/tables/uclust90_sorted_table.tsv
#We sort the results in order to march the rest of tables and add a header


echo "Done"


##### CLUSTERING WITH COVERAGE AND IDENTITY = 80 % #####

rm -r ~/TFM/crispr/clusters/uclust
mkdir ~/TFM/crispr/clusters/uclust


for file in $(ls -p ~/TFM/crispr/spacers | grep -v /); do
  mkdir ~/TFM/crispr/clusters/uclust/$file;
done
#We create a folder for each sample


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    mkdir ~/TFM/crispr/clusters/uclust/$file/$array
  done
done
#We create a folder for each array in each sample folder


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    ~/TFM/crispr/usearch -cluster_fast ~/TFM/crispr/spacers/candidate_arrays/$file/$array -sort length -id 0.8 -clusters ~/TFM/crispr/clusters/uclust/$file/"$array"/
  done
done
#We apply UClust on each candidate array, and store the resulting clusters in each array folder
#The program output is a FASTA containing clustered sequences


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    for cluster in $(ls ~/TFM/crispr/clusters/uclust/$file/"$array" | egrep -wo "[0-9]*"); do
      echo "$cluster = $(cat ~/TFM/crispr/clusters/uclust/$file/"$array"/$cluster | grep ">" | wc -l) sequences" >> ~/TFM/crispr/clusters/uclust/$file/"$array"/"cluster_seq_count_$array.txt"
    done
  done
done
#We cout the sequences in each cluster and write the report to a .txt


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    cat ~/TFM/crispr/clusters/uclust/$file/"$array"/"cluster_seq_count_$array.txt" | grep -v "= 1 sequences" > ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"
  done
done
#We look for the sequences that have more that one sequence, this is, repeated spacers


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    sed -ie "s/ = [0-9]* sequences//g" ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"
  done
done
#Once we've looked for the information, we erase the sequence info and stay just with the names


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    for cluster in $(cat ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"); do
      cat ~/TFM/crispr/clusters/uclust/$file/"$array"/$cluster >> ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_spacers_$array.fasta"
    done
  done
done
#We extract headers and sequences from the arrays that have repeated sequences, one per array


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    grep ">" ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_spacers_$array.fasta" >> ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_$array.txt"
  done
done
#We extract the headers from their respective _all_sequences, in order to make a list of the arrays that contain repeated sequences


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    for cluster in $(cat ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"); do
      sed -iE "s/_spacer_[0-9]*//g" ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_$array.txt"
    done
  done
done


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    for cluster in $(cat ~/TFM/crispr/clusters/uclust/$file/"$array"/"not_unique_sequences_clusters_$array.txt"); do
      sed -i "s/>//g" ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_$array.txt"
    done
  done
done
#We format the headers until only the array name is left
#


for file in $(ls ~/TFM/crispr/clusters/uclust); do
  for array in $(ls ~/TFM/crispr/spacers/candidate_arrays/$file); do
    uniq ~/TFM/crispr/clusters/uclust/$file/"$array"/"uclust_not_unique_$array.txt" >> ~/TFM/crispr/tables/uclust80_repeated_arrays.txt
  done
done
#We use uniq to filtrate the repetitions of arrays that contain more than one cluster with more than one sequence, and make a definite list of repeated arrays
#

cat ~/TFM/crispr/spacers/spacers_entries/merged_arrays_names.txt | grep -vf ~/TFM/crispr/tables/uclust80_repeated_arrays.txt > ~/TFM/crispr/tables/uclust80_not_repeated_arrays.txt
#We use the list of repeated arrays to extract the list of not repeated candidate_arrays


sed -i "s/>//g" ~/TFM/crispr/tables/uclust80_not_repeated_arrays.txt
#We process the not repeated list in a simmilar manner, to leave only the array names


echo "Total numer of arrays: $(cat ~/TFM/crispr/spacers/spacers_entries/merged_arrays_names.txt | wc -l)"
echo "Non-repetitive arrays with UClust 80: $(wc -l ~/TFM/crispr/tables/uclust80_not_repeated_arrays.txt)"
echo "Repetitive arrays with UClust 80: $(wc -l ~/TFM/crispr/tables/uclust80_repeated_arrays.txt)"
#We count the number of arrays as a sanity-check of the script


echo "Making table of results..."


sed -i 's/$/\tTrue/' ~/TFM/crispr/tables/uclust80_not_repeated_arrays.txt
sed -i 's/$/\tFalse/' ~/TFM/crispr/tables/uclust80_repeated_arrays.txt
#We start a column for a TSV with the info of repeated or not repeated arrays
#We add True for not-repeated arrays and False for the repeated ones


cat ~/TFM/crispr/tables/uclust80_not_repeated_arrays.txt > ~/TFM/crispr/tables/uclust80_table.tsv
cat ~/TFM/crispr/tables/uclust80_repeated_arrays.txt >> ~/TFM/crispr/tables/uclust80_table.tsv
#We merge both lists to a TSV


sort -t \t -k3 ~/TFM/crispr/tables/uclust80_table.tsv > ~/TFM/crispr/tables/uclust80_sorted_table.tsv
sed -ie '1i\Sample\tUClust 80 Unique Spacers' ~/TFM/crispr/tables/uclust80_sorted_table.tsv
#We sort the results in order to march the rest of tables and add a header


echo "Done"


#### MERGING ALL TABLES OF RESULTS ####


paste ~/TFM/crispr/tables/uclust90_sorted_table.tsv ~/TFM/crispr/tables/uclust80_sorted_table.tsv | cut -f 1,2,4 > ~/TFM/crispr/tables/u-clust_clustering_results.tsv


rm ~/TFM/crispr/tables/uclust*
