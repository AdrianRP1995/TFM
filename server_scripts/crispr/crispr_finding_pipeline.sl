#!/bin/bash


	####FIRST STEPS####

  #The first step is to download the files from the db and change the headers of each sequence to match with the name of the sample
  #This step is not scripted, but could be in the future


	####FIND POTENTIAL ARRAYS####

~/TFM/crispr/scripts/minced.sl
	#This script uses MinCED program to detect potential CRISPR cassettes in our sequences
	#Input: contigs FASTA files
	#Output: FASTA file with candidate spacers (one for each sample file) and GFF3 with representative sequence of repeats


	####FILTER FALSE POSITIVES####

~/TFM/crispr/scripts/extract_spacers.sl
	#This script separates the FASTA files into one FASTA file for each CRISPR array
	#This allows us to test whether an array has repeated sequences or not
  #The function of adding each FASTA in a folder was added to improve performance when the sample list is longer than 1000


		##CHECK FOR REPEATED SPACERS##

~/TFM/crispr/scripts/create_clusters_uclust.sl

~/TFM/crispr/scripts/create_clusters_cdhit.sl
  #This scripts use the processed output of MinCED program and tests whether an array has repeated spacers or not.
  #Two different clustering programs are used, UClust and CD-Hit, in order to compare results. Different thresholds of % of identity and coverage are tested (0.8 and 0.9)
  #Its output is a table for each program, which informs about the uniqueness of the spacers of each array.


		##COMPARE REPEATS WITH A CRISPR DATABASE##

~/TFM/crispr/scripts/obtain_fasta_repeats.sl
	#This script turns the potential repeat data in a BLAST readable format(FASTA)
	#Input: GFF3 files from MinCED (repeat data)
	#Output: FASTA files with the representative sequence from each array

~/TFM/blast/scripts/blast_crispr_ws.sl

~/TFM/blast/scripts/blast_shmakov_repeats.sl
  #These two scripts use BLAST to check if our extracted repeats (from obtain_fasta_repeats.sl) find any hit in the available databases.
  #The two databases are the CRISPR Web Service Database of confirmed CRISPR arrays, from which we use the repeat data, and aa .TSV file made by Shmakov et al. of confirmed repeats from their studies
  #The output of this script is a .txt file with a report of the number of hits for each array for each sample, in comparison with the total number of arrays
  #The script also produces a list of the arrays containing hits. This will be used in the next step to produce a .TSV with the results

~/TFM/blast/scripts/make_tables.sl
  #This script uses the list of results of the blast scripts and makes a .TSV file with info about whether an array has a hit in each database and how many mismatches each hit took


	####DISPLAYING RESULT OF THE FILTERING####

~/TFM/blast/scripts/merge_all_tables.sl
  #This script takes all the .tsv files produced in the filtering and merges them to produce a .tsv with info of all analysis together
  #The table uses the list of arrays as a common key


	####CHECKING CONFLICTING RESULTS####

#Once we have our table of results, we can use this information for further analysis

		##GENE PREDICTION IN ARRAYS WITH UNIQUE SPACERS AND UNKNOWN REPEATS##

#We will select the arrays that don't contain repeated spacers but don't have any hit in BLAST, to try to find CAS genes surrounding the CRISPR array

~/TFM/gene_prediction/scripts/gene_prediction.sl
  #This script extracts the complete contigs that don't contain repeated spacers but also don't have any hit in BLAST (repeats). We will use this FASTA file to do our gene prediction
  #With Prodigal program we predict the genes, translate them, and then filter them to keep only the proteins that are 5 Kb upstream or downstream from our candidate CRISPR arrays

~/TFM/blast/scripts/blast_cas_predicted_genes.sl
  #We make a PSI-Blast to compare a confirmed Cas genes database (Makarova et al. 2019) with our predicted proteins
  #The script returns a list with the contigs that contain arrays with close Cas genes

~/TFM/blast/scripts/blast_new_repeats_cas_genes.sl
  #We use the list of confirmed arrays by Cas genes prediction and make a Blast against our own repeats collection

		##BLAST IN ARRAYS WITH KNOWN REPEATS AND REPEATED SPACERS##

#We will check whether the non-unique spacers of arrays that had hits in BLAST (repeats) give any significative hit in NCBI whole database

#~/TFM/blast/scripts/blast_repeated_spacers_conf_repeats.sl
  #This script extracts the arrays that have the characteristics named above in one FASTA file


#The next step is to use this FASTA file to do a BLASTn against all NCBI database online: https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch
#All default specifications were kept, except the max number of hits (50)
#The results must be downloaded in .txt format


#~/TFM/blast/scripts/process_blastonline_resulst.sl
  #This script uses the results file of the online BLAST and makes them more readable.
  #It confirms that many arrays that contain suposedly repeated spacers have hits with viral and bacterial, so we will keep them all


  ####DISPLAYING RESULT OF THE FILTERING####

~/TFM/blast/scripts/make_tables_2.sl

~/TFM/blast/scripts/merge_all_tables_2.sl
  #After this second filtering, we make the definitive table with all the information


  ####FILTERING CONFIRMED ARRAYS####

~/TFM/mapping/scripts/filter_arrays.sl


