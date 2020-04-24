#!/bin/bash
#This script uses the metadata from all databases to make a homogeneous .tsv file with all relevant data (ID, taxonomy,host and environment)


rm ~/TFM/mapping/metadata/IMG_* ~/TFM/mapping/metadata/NCBI_*


#IMG/VR METADATA


cut -f 1,8,13,17,18,19,20,21 ~/TFM/mapping/metadata/original_files/IMGVR_all_Sequence_information.tsv | sed '1d' > ~/TFM/mapping/metadata/IMG_virus_genomes_metadata.tsv
cut -f 1,8,13,17,18,19,20,21 ~/TFM/mapping/metadata/original_files/IMGVR_Sequence_information.tsv | sed '1d' >> ~/TFM/mapping/metadata/IMG_virus_genomes_metadata.tsv
cut -f 1,8,13,17,18,19,20,21 ~/TFM/mapping/metadata/original_files/IMGVR_Sequence_information1.tsv | sed '1d' >> ~/TFM/mapping/metadata/IMG_virus_genomes_metadata.tsv

cut -f 1 ~/TFM/mapping/metadata/IMG_virus_genomes_metadata.tsv > ~/TFM/mapping/metadata/IMG_virus_genomes_metadata_1.tsv
cut -f 3 ~/TFM/mapping/metadata/IMG_virus_genomes_metadata.tsv > ~/TFM/mapping/metadata/IMG_virus_genomes_metadata_3.tsv
cut -f 2 ~/TFM/mapping/metadata/IMG_virus_genomes_metadata.tsv > ~/TFM/mapping/metadata/IMG_virus_genomes_metadata_4.tsv

cut -f 4,5,6,7,8 ~/TFM/mapping/metadata/IMG_virus_genomes_metadata.tsv | sed 's/\t/|/g' > ~/TFM/mapping/metadata/IMG_virus_genomes_metadata_2.tsv

paste ~/TFM/mapping/metadata/IMG_virus_genomes_metadata_1.tsv ~/TFM/mapping/metadata/IMG_virus_genomes_metadata_2.tsv ~/TFM/mapping/metadata/IMG_virus_genomes_metadata_3.tsv ~/TFM/mapping/metadata/IMG_virus_genomes_metadata_4.tsv > ~/TFM/mapping/metadata/IMG_virus_genomes_metadata.tsv


#NCBI GENOMES METADATA


cut -f 1 ~/TFM/mapping/metadata/original_files/NCBI_genomes_virus.tab > ~/TFM/mapping/metadata/NCBI_genomes_virus_metadata_1.tsv
cut -f 3 ~/TFM/mapping/metadata/original_files/NCBI_genomes_virus.tab | sed 's/$/\tNA/' > ~/TFM/mapping/metadata/NCBI_genomes_virus_metadata_3.tsv
cut -f 4 ~/TFM/mapping/metadata/original_files/NCBI_genomes_virus.tab > ~/TFM/mapping/metadata/NCBI_genomes_virus_metadata_2.tsv

paste ~/TFM/mapping/metadata/NCBI_genomes_virus_metadata_1.tsv ~/TFM/mapping/metadata/NCBI_genomes_virus_metadata_2.tsv ~/TFM/mapping/metadata/NCBI_genomes_virus_metadata_3.tsv | sed '1d' | sed '1d' > ~/TFM/mapping/metadata/NCBI_genomes_virus_metadata.tsv


#NCBI VIRUS METADATA

sed -E 's/,,/,NA,/g' ~/TFM/mapping/metadata/original_files/NCBI_virus.csv | sed -zE 's/,\n/,NA\n/g' > ~/TFM/mapping/metadata/NCBI_virus_processed.csv

sed 's/,/\t/g' ~/TFM/mapping/metadata/NCBI_virus_processed.csv > ~/TFM/mapping/metadata/NCBI_virus.tsv

cut -f 1,2,4,5 ~/TFM/mapping/metadata/NCBI_virus.tsv | sed '1d' > ~/TFM/mapping/metadata/NCBI_virus_metadata.tsv




#MERGE ALL FILES


cat ~/TFM/mapping/metadata/IMG_virus_genomes_metadata.tsv ~/TFM/mapping/metadata/NCBI_genomes_virus_metadata.tsv ~/TFM/mapping/metadata/NCBI_virus_metadata.tsv | sort > ~/TFM/mapping/metadata/virus_genomes_metadata.tsv

sort -u ~/TFM/mapping/metadata/virus_genomes_metadata.tsv > ~/TFM/mapping/metadata/sorted_virus_metadata.tsv


rm ~/TFM/mapping/metadata/IMG_* ~/TFM/mapping/metadata/NCBI_*


#FIX METADATA REDUNDANCIES


sed 's/NA||||//g' ~/TFM/mapping/metadata/sorted_virus_metadata.tsv > ~/TFM/mapping/metadata/processed_virus_metadata.tsv
#We erase fake filled slots

sed -iE 's/\t\t/\tNA\t/g' ~/TFM/mapping/metadata/processed_virus_metadata.tsv
sed -iE 's/\t\t/\tNA\t/g' ~/TFM/mapping/metadata/processed_virus_metadata.tsv
#We substitute empty spaces for "NA"
#Yes, we had to do it twice

sed -zE 's/\t\n/\tNA\n/g' ~/TFM/mapping/metadata/processed_virus_metadata.tsv > ~/TFM/mapping/metadata/processed_metadata.tsv
#We fill the last blank spaces with "NA"

cut -f 1 ~/TFM/mapping/metadata/processed_metadata.tsv | sort -u > ~/TFM/mapping/metadata/virus_metadata_id_list.txt
#With this list of entries we will be able to access each group of entries

#Now, we can go to python:
~/TFM/mapping/scripts/count_NA.py
#This Python script reads the .tsv and counts the number of NA in each entry, and writes a new file with the count


for entry in $(cat ~/TFM/mapping/metadata/virus_metadata_id_list.txt); do
	grep $entry ~/TFM/mapping/metadata/virus_metadata_weighted.tsv | sort -t \t -n -k 5  | head -1 | cut -f 1,2,3,4 >> ~/TFM/mapping/metadata/metadata_virus_genomes.tsv
done
#Taking into account the NA counts, we choose the entry for each ID with less NA, and therefore more information


sort -u ~/TFM/mapping/metadata/metadata_virus_genomes.tsv > ~/TFM/mapping/metadata/sorted_metadata_vg.tsv


sed -i '1i \seq_id\ttaxonomy\thost\tenvironment' ~/TFM/mapping/metadata/sorted_metadata_vg.tsv


rm ~/TFM/mapping/metadata/virus_metadata_weighted.tsv ~/TFM/mapping/metadata/processed_metadata.tsv ~/TFM/mapping/metadata/processed_virus_metadata.tsv ~/TFM/mapping/metadata/sorted_virus_metadata.tsv
