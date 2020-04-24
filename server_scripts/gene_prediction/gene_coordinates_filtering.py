#!/bin/python


#This script takes genes coordinate file, which is the processed output from Prodigal, and filters it using an array coordinate file
#The threshold for filtering is 5Kb upstream and downstream from the start and end of the array, respectively


import numpy as np
import pandas as pd
#We import the modules that we will gene_prediction


genes_df = pd.read_csv("/home/alopez/TFM/gene_prediction/lists/prodigal_gene_results.tsv", sep='\t')
#We open the gene file and turn it into a dataframe


array = open("/home/alopez/TFM/gene_prediction/lists/prodigal_casette_coordinates.tsv", "r")
#We open the array file as usual


contig_start = {}
contig_end = {}
#We open an empty dictionary for both beginnig and end coordinates of the array


for line in array.readlines():
    line = line.strip()
    contigid, start, end = line.split('\t')
    contig_start.update({contigid : start})
    contig_end.update({contigid : end})
#We parse the arrays file and introduce it in the dictionaries, using the contig ID as key


start_genes = []


for contig in contig_start:
    contig_df = genes_df.loc[genes_df["Name"] == contig]
    start_filter_contig_df = contig_df.loc[contig_df["Start"].between(int(contig_start[contig])-5000, int(contig_start[contig]))]
    start_genes.append(start_filter_contig_df)

start_genes = pd.concat(start_genes)
#We select subsects of the dataframe using the contig name, then we select the results that are inside a given range (array start-5000, array start, note the .between() method to create a range in Pandas)
#The results are appended to a new dataframe


end_genes = []


for contig in contig_end:
    contig_df = genes_df.loc[genes_df["Name"] == contig]
    end_filter_contig_df = contig_df.loc[contig_df["End"].between(int(contig_end[contig]), int(contig_end[contig])+5000)]
    end_genes.append(end_filter_contig_df)

end_genes = pd.concat(end_genes)
#We do the same but using the information of the ending of the arrays. The threshold this time is (array end, array end + 5000)


selected_genes = start_genes.append(end_genes)
#We append both dataframes with filtered genes. The repetitive data will be erased in the main .sl script


tsv = selected_genes.to_csv(index=False, sep='\t')
#We output the final dataframe into .TSV format


output = open("/home/alopez/TFM/gene_prediction/lists/prodigal_filtered_genes_coordinates.tsv", "w+")
#We open a new file that will contain the .TSV information


output.write(tsv)
#We write the information into the files


output.close()
