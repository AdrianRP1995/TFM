#!/bin/python

#This script makes the clustering of the spacers, and outputs a .txt file with clusters and the spacers that are part of them


results = open("/home/alopez/TFM/mapping/results/spacers_clustering/spacers_clustering_results.tsv", "r")
clustered_list = open("/home/alopez/TFM/mapping/results/spacers_clustering/clustering_initial_DF.tsv", "r")


clusters = {}       #This will be the initial clusters dictionary, which will contain the initial hits for each spacer, including repeated ones
clustered_info = {}     #This dictionary will keep information about whether a spacer is already clustered or not


for line in results.readlines():
    line = line.strip()
    sub, obj = line.split("\t")
    if sub in clusters:     #As the results are displayed as 1 to 1, we create the provisional clusters as the program checks each line of the file
        clusters[sub].append(obj)       #If a spacer is already clustered, its hit is appended to the existing dictionary entry. If not, a new entry is created
    else:
        clusters[sub] = [obj]


for line in clustered_list.readlines():
    line = line.strip()
    seq, clustered = line.split("\t")
    clustered_info[seq] = clustered
#We just start the dictionary with info about clustering, which at the start will be "NAN" for each cluster


good_clusters = {}      #This dictionary which contain the clusters with hits for each spacer and also hits' hits until no new information is loaded into the cluster

for seq in clusters:
    if clustered_info[seq] == "NAN":
        newlist = []
        appendlist = []
        for element in clusters[seq]:
            appendlist.append(element)
        while len(newlist) != len(appendlist):
            newlist = appendlist
            for hit in appendlist:
                for a in clusters[hit]:
                    appendlist.append(a)
                    clustered_info[a] = "YES"
                appendlist = list(set(appendlist))
                newlist = list(set(newlist))
        good_clusters[seq] = appendlist
    else: print(seq+" is already clustered!")

#The conditions for clustering can be explained this way:
    #1) Iterate over each cluster and check if it's been clustered already
    #2) If it's not, we start a blank list (appendlist) and append each hit to it
    #3) Then, we start a loop which will stop when no new hit is added to appendlist. We make this using two lists, one that will contain the hits that we had
    #   at the start of the loop (newlist) and other that will contain these ones and the newly added hits (appendlist). When they are equal, the loop will stop
    #4) For each hit, we look for its hits and append them to appendlist, and also change the clustering information to "YES", so that the initial loop ignores it
    #5) We remove repeated hits from each list and the loop iterates until they are equal at this stage
    #6) When the loop ends, the list of hits is appended to the dictionary using the starting sequence as key



cluster_results = open("/home/alopez/TFM/mapping/tables/clustering_results.txt", "w+")


for key in good_clusters:
    cluster_results.write(str(set(good_clusters[key]))+"\n")
#We write each list of spacers to a .txt file 
