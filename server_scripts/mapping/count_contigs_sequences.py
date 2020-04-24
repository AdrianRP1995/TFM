#!/bin/python
#This script uses BioPython to write a .tsv with info about the length of our contigs


from Bio import SeqIO

file = open("/home/alopez/TFM/mapping/results/contigs/filtered_contigs_lenght.txt", "w+")

for seq_record in SeqIO.parse("/home/alopez/TFM/mapping/merged_files/autoblast_contigs_test.fasta", "fasta"):
    file.write(seq_record.id+"\t"+str((len(seq_record)))+"\n")

file.close()
