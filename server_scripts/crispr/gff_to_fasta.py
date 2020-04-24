#!/bin/python
import sys


file = open(sys.argv[1], "r")

fasta = open(sys.argv[2], "w+")


for line in file.readlines():
    name, program, region, a, b, c, d, e, CRISPRID = line.split('\t')
    ID, b, c, sequence = CRISPRID.split(';')
    fasta.write('>'+name+'_'+ID+'\n'+sequence)


file.close()
fasta.close()
