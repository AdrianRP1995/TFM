#!/bin/python


from Bio import SeqIO

contigs = open("/home/alopez/TFM/mapping/lists/filtered_autoblasts_contigs.txt", "r")
fasta = open("/home/alopez/TFM/mapping/merged_files/autoblast_contigs.fasta", "w+")


contigs_list = []


for line in contigs.readlines():
    line = line.strip()
    contigs_list.append(line)


for seq_record in SeqIO.parse("/home/alopez/TFM/mapping/databases/fastas/merged_contigs.fasta", "fasta"):
    if seq_record in contigs_list:
        fasta.write(">"+seq_record.id+"\n"+seq_record.seq+"\n")


contigs.close()
fasta.close()
