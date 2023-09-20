#!/bin/sh
#SBATCH --job-name check_lib_type
#SBATCH --mem 10G
#SBATCH --mail-user todd.kennedi@mayo.edu
#SBATCH --mail-type END,FAIL
#SBATCH --output logs/%x.%N.%j.stdout
#SBATCH --error logs/%x.%N.%j.stderr
#SBATCH --partition cpu-med
#SBATCH --tasks 15
#SBATCH --time 02:00:00 ## HH:MM:SS

# salmon was installed in it's own environment to work properly
# activate environment
source $HOME/.bash_profile
conda activate salmon

# salmon version
salmon -v

# validate mappings
# note this same sample has other lanes but this should be sufficient to check
salmon quant --libType A \
             --index /research/labs/neurology/fryer/projects/references/human/salmonIndexEnsemblGRCh38 \
             --mates1 /research/labs/neurology/fryer/projects/sepsis/human/meningitis/Mayo_43_P_S17_L002_R1_001.fastq.gz \
             --mates2 /research/labs/neurology/fryer/projects/sepsis/human/meningitis/Mayo_43_P_S17_L002_R2_001.fastq.gz \
             --output ../../refs/transcript_quant \
             --threads 15 \
             --validateMappings

# Key
# --libType A is for autodetect library type
# --index Salmon index

# Results
# Automatically detected most likely library type as ISR

# Job stats
