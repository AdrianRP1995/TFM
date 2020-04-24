#!/bin/python

#This script writes a .BED file with the coordinates of neighbourhoods of autoblast hits

file = open("/home/alopez/TFM/mapping/results/contigs/autoblast_filtered_results.tsv", "r")
contigs = open("/home/alopez/TFM/mapping/results/contigs/filtered_contigs_lenght.txt", "r")
bedfile = open("/home/alopez/TFM/mapping/results/contigs/filtered_neighbourhoods.bed", "w+")


contigs_length = {}
#We make a dictionary of the lenght of each contig, since we'll need it afterwards so out neighbourhoods don't exceed this lengths

for line in contigs.readlines():
    line = line.strip()
    contig, length = line.split('\t')
    contigs_length.update({contig : int(length)})



for line in file.readlines():
    line = line.strip()
    spacerid, contigid, start, end = line.split('\t')
    new_start = int(start)-5000     #We just add 5000 downwards and upwards to our hits
    new_end = int(end)+5000
    if new_start < 0:       #First check: if the hit - 5000 is lower than 0, the coordinate is set to 0
        new_start = 0
    if new_end > contigs_length[contigid]:      #Second chech: if the hit + 5000 exceedes the lenght of the contig, the coordinate is set to the end of the contig
        new_end = contigs_length[contigid]
    bedfile.write(contigid+"\t"+str(new_start)+"\t"+str((new_end))+"\n")


file.close()
bedfile.close()
contigs.close()
