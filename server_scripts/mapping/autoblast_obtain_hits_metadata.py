#!/bin/python


import numpy as np
import pandas as pd


metadata_df = pd.read_csv("/home/alopez/TFM/mapping/metadata/sorted_metadata_vg.tsv", sep='\t')
seqs = open("/home/alopez/TFM/mapping/results/auto_blast_2/auto_blast_2_hits_list.txt", "r")


seq_list = []
for line in seqs.readlines():
    line = line.strip()
    seq_list.append(line)


hits_mtdt = []

for hit in seq_list:
    hit_row = metadata_df.loc[metadata_df['seq_id'] == hit]
    hits_mtdt.append(hit_row)


hits_mtdt = pd.concat(hits_mtdt)


output = open("/home/alopez/TFM/mapping/metadata/autoblast_hits_metadata.tsv", "w+")
tsv = hits_mtdt.to_csv(index=False, sep='\t')
output.write(tsv)
output.close()
