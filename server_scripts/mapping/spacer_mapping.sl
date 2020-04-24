#!/bin/bash
#This script substitutes the spacer ids in our BLAST seraches result tables for its clustering id


rm ~/TFM/mapping/tables/virus_genomes_cropped_table.tsv ~/TFM/mapping/tables/autoblast_cropped_table.tsv

rm ~/TFM/mapping/tables/virus_genomes_mapped_results.tsv ~/TFM/mapping/tables/autoblast_mapped_results.tsv


####MAPPING VIRUS GENOMES RESULTS####


tail -n +2 ~/TFM/mapping/tables/virus_genomes_results_table.tsv > ~/TFM/mapping/tables/virus_genomes_cropped_table.tsv


python ~/TFM/mapping/scripts/spacer_cluster_mapping.py ~/TFM/mapping/tables/virus_genomes_cropped_table.tsv ~/TFM/mapping/tables/virus_genomes_mapped_results.tsv


sed -i '1i \spacer_cluster_id\tvirus_genomes_db_hit\ttaxonomy\thost\tenvironment' ~/TFM/mapping/tables/virus_genomes_mapped_results.tsv


rm ~/TFM/mapping/tables/virus_genomes_cropped_table.tsv


#####MAPPING AUTOBLAST RESULTS#####
##CHECK FILENAMES


tail -n +2 ~/TFM/mapping/tables/autoblast_results_table.tsv > ~/TFM/mapping/tables/autoblast_cropped_table.tsv


python ~/TFM/mapping/scripts/spacer_cluster_mapping.py ~/TFM/mapping/tables/autoblast_cropped_table.tsv ~/TFM/mapping/tables/autoblast_mapped_results.tsv


sed -i '1i \spacer_cluster_id\tvirus_genomes_db_hit\ttaxonomy\thost\tenvironment' ~/TFM/mapping/tables/autoblast_mapped_results.tsv


rm ~/TFM/mapping/tables/autoblast_cropped_table.tsv
