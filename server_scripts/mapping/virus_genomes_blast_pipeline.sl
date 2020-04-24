#!/bin/bash

#In this list of scripts we describe the pipeline made to use the CRISPR spacers we confirmed in the previous step to make a Blast agains a virus genomes database, and then display the results


#First of all, we need to download the databases and their metadata.
#We used the IMG/VR database, the NCBI Virus (only genomes) database, and the NCBI Genomes (only virus) database
#We merged the databases using a nice and simple cat command

####PROCESS METADATA####

~/TFM/mapping/scripts/process_metadata.sl
  #This script filters all unnecesary information from the different metadata files and merges them with a same format
  #The general format is ID, Taxonomy, Host and Environment



####BLAST CONFIRMED SPACERS####
#The first search we'll do is comparing our confirmed spacers against the virus genomes database

~/TFM/mapping/scripts/blast_virus_genomes.sl
  #This script contains the information which is necessary to make the Blast of the confirmed spacers against our database.
  #The Blast command was quoted, since that program had to be ran in a different way with our specific computational cluster


~/TFM/mapping/scripts/big_array_blast_vg.sl
  #This script paralelizes Blast


~/TFM/mapping/scripts/process_results_virus_genomes.sl
  #This script takes the results of metadata processing and Blast and makes a .tsv with all the hits and the most relevant information from the sequences


####CONTIGS AUTO BLAST####
  #The second search will consist on comparing our confirmed spacers against our own contigs database, to find other possible viral sequences that are outside confirmed CRISPR arrays

~/TFM/mapping/scripts/contigs_auto_blast.sl
  #This scripts prepares the database and makes lists that will be necessary to make the Blast search and then process it


~/TFM/mapping/scripts/big_array_autoblast.sl
  #This script must be called to paralelize the Blast search in the cluster


~/TFM/mapping/scripts/auto_blast_result_process.sl
  #This script uses the results of this first Blast to filter autohits, hits from other known arrays, and extract the remaining hits and a 5 Kb neighbourhood from the contigs fasta file


~/TFM/mapping/scripts/big_array_autoblast_2.sl
  #This script makes a Blast search of our neighbourhoods against our virus genomes database


~/TFM/mapping/scripts/process_results_auto_blast.sl
  #This script takes the results of metadata processing and Blast and makes a .tsv with all the hits and the most relevant information from the sequences


####CLUSTERING OF SEQUENCES####
  #We want to know how redundant is our list of spacers, so we do a clustering based in a BLAST search
  #We also want to use the clusters already made in our virus database, to use these as OTUs


~/TFM/mapping/scripts/blast_spacer_clustering.sl
  #This script prepares the data and makes the BLAST search of the confirmed spacers against themselves


~/TFM/mapping/scripts/spacer_clustering.sl
  #This script takes the results of the BLAST search and outputs a .TSV file with the clustering ids and the spacers assigned to each one


~/TFM/mapping/scripts/spacer_mapping.sl
  #This script maps all the results from virus genomes BLAST and autoblast and substitutes the spacer ids for the clustering ids they belong to


#NOT STARTED~/TFM/mapping/scripts/virus_clustering.sl
