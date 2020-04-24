#!/bin/bash

#SBATCH --mem=4G


ml BLAST+/2.9.0-gompi-2019a


srun ~/TFM/mapping/scripts/contigs_auto_blast_parallel.sl $SLURM_ARRAY_TASK_ID
