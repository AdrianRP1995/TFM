#!/bin/bash
#This script uses the results of the spacers BLAST and outputs a .tsv file with each clustering id and a comma-separated list for each cluster's spacers


cut -f 1,2 ~/TFM/mapping/results/spacers_clustering/spacers_clustering.blast > ~/TFM/mapping/results/spacers_clustering/spacers_clustering_results.tsv
#We extract the id columns of the BLAST results


cut -f 1 ~/TFM/mapping/results/spacers_clustering/spacers_clustering.blast | sort -u > ~/TFM/mapping/results/spacers_clustering/clustering_secs_list.txt
#We make a unique list of spacers to input it in Python later


sed 's/$/\tNAN/' ~/TFM/mapping/results/spacers_clustering/clustering_secs_list.txt > ~/TFM/mapping/results/spacers_clustering/clustering_initial_DF.tsv
#We are going to use a label system to keep track of the clustering. As an initial state, we will use a not-numerical value to state that the spacer is not clustered


rm ~/TFM/mapping/tables/clustering_results.txt


python ~/TFM/mapping/scripts/spacers_clustering.py
#This Python script is the one that does the clustering, and outputs a .tsv file with each cluster


sed -i -e 's/{//g' -e 's/}//g' -e "s/'//g" -e "s/, /,/g" ~/TFM/mapping/tables/clustering_results.txt
#We remove the unnecesary info from the cluster list


rm ~/TFM/mapping/tables/clustering_ids.txt


END=$(wc -l ~/TFM/mapping/tables/clustering_results.txt | sed 's@/home/alopez/TFM/mapping/tables/clustering_results.txt@@g')

for i in $(seq 1 $END); do
  echo "$i" >> ~/TFM/mapping/tables/clustering_ids.txt
done
#We make a simple numeric list based on the lenght of the cluster list, using it as a variable of a range


paste ~/TFM/mapping/tables/clustering_ids.txt ~/TFM/mapping/tables/clustering_results.txt > ~/TFM/mapping/tables/clustering_results.tsv
#We merge both numerical and clusters list to assign an id to each cluster


rm ~/TFM/mapping/tables/clustering_ids.txt
rm ~/TFM/mapping/results/spacers_clustering/clustering_secs_list.txt ~/TFM/mapping/results/spacers_clustering/clustering_initial_DF.tsv
