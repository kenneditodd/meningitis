#!/bin/sh
#SBATCH --job-name run_snakemake
#SBATCH --mem 2G
#SBATCH --mail-user todd.kennedi@mayo.edu
#SBATCH --mail-type END,FAIL
#SBATCH --output logs/%x.%j.stdout
#SBATCH --error logs/%x.%j.stderr
#SBATCH --partition cpu-short
#SBATCH --time 08:00:00 ## HH:MM:SS

# activate conda environment
source $HOME/.bash_profile
conda activate meningitis # contains snakemake, star, fastqc, multiqc, subread, bbmap

# change directory to where Snakefile is located
cd ../..
pwd

# run snakemake
# dry run: snakemake -nr
snakemake -s Snakefile -j 20 --rerun-incomplete --latency-wait 20 --cluster "sbatch --mem=40G --output=scripts/01_preprocessing/logs/snakemake_job_logs/%x.%N.%j.stdout --error=scripts/snakemake/logs/%x.%N.%j.stderr --partition=cpu-short --tasks=20 --time 05:00:00"
