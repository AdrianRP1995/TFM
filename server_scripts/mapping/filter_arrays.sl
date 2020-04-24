#!/bin/bash

#This script uses the definitive table of arrays and filters them to obtain a list of the confirmed arrays
#We will consider confirmed arrays:
	#The ones whose repeats have hits in any repeats database, even if they have repeated spacers
	#The ones that don't have any hit in a repeats database but have confirmed Cas genes in the array's neighbourhood (+- 5Kb)



rm ~/TFM/metadata/results/confirmed_arrays.txt

cat ~/TFM/metadata/results/array_filtering_results.tsv | cut -f 1,6 | grep "True" | cut -f 1 > ~/TFM/metadata/results/confirmed_arrays.txt

cat ~/TFM/metadata/results/array_filtering_results.tsv | cut -f 1,8 | grep "True" | cut -f 1 >> ~/TFM/metadata/results/confirmed_arrays.txt

cat ~/TFM/metadata/results/array_filtering_results.tsv | cut -f 1,10 | grep "True" | cut -f 1 >> ~/TFM/metadata/results/confirmed_arrays.txt

cat ~/TFM/metadata/results/array_filtering_results.tsv | cut -f 1,11 | grep "True" | cut -f 1 >> ~/TFM/metadata/results/confirmed_arrays.txt


sort -u ~/TFM/metadata/results/confirmed_arrays.txt > ~/TFM/mapping/lists/confirmed_arrays.txt
