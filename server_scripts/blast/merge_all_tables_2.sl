#!/bin/bash
#This script fuses all blast and clustering results into one .tsv file, that contains all info for each potential CRISPR array



paste ~/TFM/crispr/tables/u-clust_clustering_results.tsv ~/TFM/crispr/tables/cd-hit_clustering_results.tsv | cut -f 1,2,3,5,6 > ~/TFM/crispr/tables/clustering_definitive_results.tsv

paste ~/TFM/crispr/tables/clustering_definitive_results.tsv ~/TFM/blast/tables/blast_definitive_results.tsv | cut -f 1,2,3,4,5,7,8,9,10,11,12 > ~/TFM/metadata/results/array_filtering_results.tsv
