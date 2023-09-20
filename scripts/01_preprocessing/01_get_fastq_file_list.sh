#!/bin/bash

# Get fastq file list
# Each sample has 6 files (L1R1, L1R2, L2R1, L2R2, I1, I2) 
# So, only grab lane 1 read 1 files.
cd /research/labs/neurology/fryer/projects/sepsis/human/meningitis
out=/research/labs/neurology/fryer/m214960/meningitis/refs/fastq_file_list.txt
ls -1 | grep L001_R1_001.fastq.gz > $out