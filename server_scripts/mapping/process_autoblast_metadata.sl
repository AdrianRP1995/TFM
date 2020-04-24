#!/bin/bash
#This script uses the output of the blast_virus_genomes.sl script, and makes a list of all hits with important info about host, taxonomy and ambient of the sequence from the database


ml Python/3.7.2-GCCcore-8.2.0
ml SciPy-bundle/2019.03-foss-2019a


#First step, to sort -u the merged blast files
#Also it would be helpful to make sure that the metadata file is sorted and unique (sort -u)

cut -f 1,2 ~/TFM/mapping/results/auto_blast_2/sorted_auto_blast_2.blast | sed 's/REF://g'| sort -u | sort -k 2 > ~/TFM/mapping/results/auto_blast_2/auto_blast_2_results.tsv
#We extract the subject and object sequences, change their name so that they match with the metadata entries. sort them by object sequences and send them to other file


sed -i '1i \sub_seq_id\tobj_seq_id' ~/TFM/mapping/results/auto_blast_2/auto_blast_2_results.tsv
#We add a header to the results file, to convert it into a dataframe in the future


cut -f 2 ~/TFM/mapping/results/auto_blast_2/auto_blast_2_results.tsv > ~/TFM/mapping/results/auto_blast_2/auto_blast_2_hits_list.txt
#We extract a list of the object sequences


python ~/TFM/mapping/scripts/autoblast_obtain_hits_metadata.py
#This script makes a tsv file which contains the metadata informarion for each hit in blast


paste ~/TFM/mapping/results/auto_blast_2/auto_blast_2_results.tsv ~/TFM/mapping/metadata/autoblast_hits_metadata.tsv | cut -f 1,2,4,5,6 > ~/TFM/mapping/tables/autoblast_results_table.tsv
#We merge both results and metadata tables and cut out the repeated columns
