#!/bin/python
#This script substitutes the spacers id of our BLAST results for its spacer_clustering_id


import sys

clusters_file = open("/home/adrian/TFM/mapping/tables/clustering_results.tsv", "r")
blast_results = open(sys.argv[1], "r")


cluster_ids = {}


for line in clusters_file.readlines():
    line = line.strip()
    scid, spacers = line.split("\t")
    for spacer in spacers.split(","):
        cluster_ids[spacer] = scid
#We make a dictionary with each cluster as a key and a list with the spacers in that cluster as value


mapped_file = open(sys.argv[2], "w+")


for line in blast_results.readlines():
    line = line.strip()
    sub, obj, tax, host, env = line.split("\t")
    mapped_file.write(cluster_ids[sub]+"\t"+obj+"\t"+tax+"\t"+host+"\t"+env+"\n")
#We just rewrite the file using the values from the dictionary instead of the spacer id


clusters_file.close()
blast_results.close()
mapped_file.close()
