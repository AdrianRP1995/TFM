#!/bin/python
#This script filters the results of the first autoblast to only take into account the results that are not autohits and that don't belong to a known array

file = open("/home/alopez/TFM/mapping/results/contigs/reports/processed_auto_blast.blast", "r")
tsv = open("/home/alopez/TFM/mapping/results/contigs/autoblast_filtered_results.tsv", "w+")
array = open("/home/alopez/TFM/gene_prediction/lists/prodigal_casette_coordinates.tsv", "r")
report = open("/home/alopez/TFM/mapping/results/contigs/autoblast_filtering_report.txt", "w+")


array_coord = {}


for line in array.readlines():
    line = line.strip()
    array_contigid, array_start, array_end = line.split('\t')
    array_coord.update({array_contigid : range(int(array_start)-1, int(array_end)-1)})


for line in file.readlines():
    line = line.strip()
    spacerid, contigid, id_perc, a, b, c, d, e, start, end, evalue, bitscore = line.split('\t')
    if spacerid != contigid:        #First check: if the id of the hit is equal to the contig, ignore it
        if contigid in array_coord:     #If the contig hit is in a contig with detected arrays, we'll check if it's inside some array
            if int(start) in array_coord[contigid] or int(end) in array_coord[contigid]: #If the hit is inside a known array (range), ignore
                report.write(contigid+" is a known array!\n")
            else:       #If the hit is outside any known array, we save it
                if int(start) < int(end):        #We order the coordinates of hits that are in the complementary chain (start>end)
                    tsv.write(spacerid+'\t'+contigid+'\t'+start+'\t'+end+'\n')
                if int(start) > int(end):
                    tsv.write(spacerid+'\t'+contigid+'\t'+end+'\t'+start+'\n')
        else:       #If the hit isn't inside a contig with arrays we save it
            if int(start) < int(end):       #We order the coordinates of hits that are in the complementary chain (start>end)
                tsv.write(spacerid+'\t'+contigid+'\t'+start+'\t'+end+'\n')
            if int(start) > int(end):
                tsv.write(spacerid+'\t'+contigid+'\t'+end+'\t'+start+'\n')
    else:
        report.write(spacerid+" is equal to "+contigid+"!!!!!\n")

file.close()
tsv.close()
array.close()
report.close()
