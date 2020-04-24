#!/bin/python
#This script counts the number of "NA" in each entry of the virus metadata file and adds the count as a new column of the .tsv

file = open("/home/adrian/TFM/mapping/metadata/processed_metadata.tsv", "r")
new_file = open("/home/adrian/TFM/mapping/metadata/virus_metadata_weighted.tsv", "w+")


for line in file.readlines():
    line = line.strip()
    seqid, tax, host, env = line.split('\t')
    NA_count = 0
    if seqid == "NA":
        NA_count = NA_count + 1
    if tax == "NA":
        NA_count = NA_count + 1
    if host == "NA":
        NA_count = NA_count + 1
    if env == "NA":
        NA_count = NA_count + 1
    new_file.write(seqid+"\t"+tax+"\t"+host+"\t"+env+"\t"+str(NA_count)+"\n")


file.close()
new_file.close()
