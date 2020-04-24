#!/bin/python


file = open("/home/alopez/TFM/blast/shmakov_repeats.tsv", "r")

fasta = open("/home/alopez/TFM/blast/databases/fastas/shmakov_repeats.fasta", "w+")


for line in file.readlines():
    a, contig, c, d, e, sequence, g, h, i, j, species, l, m, n = line.split("\t")
    fasta.write('>'+species+'|'+contig+'\n'+sequence+'\n')

file.close()
fasta.close()
