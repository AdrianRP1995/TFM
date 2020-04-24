#!/bin/bash


ml prodigal/2.6.3-GCCcore-8.2.0
#ml BEDTools/2.28.0-GCC-8.2.0-2.31.1
ml SAMtools/1.9-GCC-8.2.0-2.31.1
ml Python/3.7.2-GCCcore-8.2.0
ml SciPy-bundle/2019.03-foss-2019a


#This script uses the .TSV file with info from the first filtering to make a gene prediction of the contigs that don't have any blast hit
#We will mainly use the contigs that contain arrays with non-repetitive spacers, but also the ones that appear to have repetitive spacers


rm ~/TFM/gene_prediction/merged_files/merged_candidate_contigs.fasta
rm ~/TFM/gene_prediction/results/*
rm ~/TFM/gene_prediction/lists/*


cat ~/TFM/metadata/results/array_filtering_results.tsv | cut -f 1,6,8 | egrep "False\sFalse" | egrep -o "\w*_contigs.fna_[0-9]*" > ~/TFM/gene_prediction/lists/candidate_contigs.txt
#We first make a list of the contigs that contain arrays and no hit in any BLAST database


for file in $(ls ~/TFM/crispr/contigs/uncompressed); do
  grep -A 1 -wf ~/TFM/gene_prediction/lists/candidate_contigs.txt ~/TFM/crispr/contigs/uncompressed/$file | sed -z "s/--\n//g" >> ~/TFM/gene_prediction/merged_files/merged_candidate_contigs.fasta
done
#With this list we extract the information from our contigs and merge them into one big FASTA file


~/TFM/gene_prediction/prodigal -i ~/TFM/gene_prediction/merged_files/merged_candidate_contigs.fasta -p meta -f gff -o ~/TFM/gene_prediction/results/prodigal_results.gff -a ~/TFM/gene_prediction/results/prodigal_traductions.fasta
#This command uses the Prodigal program to create a GFF file with coordinate information of the predicted genes
#We will extract the coordinate information from this output


grep -oe "^\w*_contigs.fna_[0-9]*" ~/TFM/gene_prediction/results/prodigal_results.gff > ~/TFM/gene_prediction/results/gene_id.txt
#We extract the ID of the contigs that appear in the GFF file


grep -oe "CDS\s[0-9]*\s[0-9]*" ~/TFM/gene_prediction/results/prodigal_results.gff | sed 's/CDS//g' > ~/TFM/gene_prediction/results/gene_coordinates.txt
#We extracte the coordinates of the genes


paste ~/TFM/gene_prediction/results/gene_id.txt ~/TFM/gene_prediction/results/gene_coordinates.txt | sed -e 's/\t\t/\t/g' > ~/TFM/gene_prediction/lists/prodigal_gene_results.tsv
#We merge both lists to obtain a list of the predicted genes with the ID of the contigs and their coordinates


rm ~/TFM/gene_prediction/results/*.txt
#We erase all the files we don't need anymore


for file in $(ls ~/TFM/crispr/gff_files); do
  grep -f ~/TFM/gene_prediction/lists/candidate_contigs.txt ~/TFM/crispr/gff_files/$file | cut -f 1,4,5 >> ~/TFM/gene_prediction/lists/prodigal_casette_coordinates.tsv
done
#We make a list with the coordinates of the candidate CRISPR arrays, since we will keep the genes that appear to be 5 Kb upstreams or downstream from these casettes


sed -i '1i \Name\tStart\tEnd' ~/TFM/gene_prediction/lists/prodigal_gene_results.tsv
#We make a header for the genes list, as we will need it to convert it to a dataframe


rm ~/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.tsv


python ~/TFM/gene_prediction/scripts/gene_coordinates_filtering.py
#This Python script uses the information from the genes coordinates and filters them, keeping only the genes that are 5Kb upwards and downwards from the array of each contig
#Its output is a .TSV file that must be processed


sort ~/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.tsv > ~/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.tsv.tmp
mv ~/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.tsv.tmp ~/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.tsv
#We sort the file


grep -v Name ~/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.tsv > ~/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.bed
#We remove the headers to produce a BED file


#bedtools getfasta -fi ~/TFM/gene_prediction/merged_files/merged_candidate_contigs.fasta -bed ~/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.bed -fo ~/TFM/gene_prediction/merged_files/merged_filtered_genes.fasta
#We use Bedtools to extract the gene sequences we just filtered


sed -E 's/(\w*_contigs.fna_[0-9]*)\s([0-9]*)\s([0-9]*)/\1_[0-9]* # \2 # \3/g' ~/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.bed > ~/TFM/gene_prediction/lists/cas_proteins_reg_exp.txt


IFS=$'\n'
set -f
for expression in $(cat ~/TFM/gene_prediction/lists/cas_proteins_reg_exp.txt); do
  egrep "$expression" ~/TFM/gene_prediction/results/prodigal_traductions.fasta | egrep -o "\w*_contigs.fna_[0-9]*_[0-9]*" >> ~/TFM/gene_prediction/lists/cas_proteins_id.txt
done


samtools faidx ~/TFM/gene_prediction/results/prodigal_traductions.fasta

for id in $(cat ~/TFM/gene_prediction/lists/cas_proteins_id.txt); do
  samtools faidx ~/TFM/gene_prediction/results/prodigal_traductions.fasta $id >> ~/TFM/gene_prediction/merged_files/merged_filtered_protreins.fasta
done
