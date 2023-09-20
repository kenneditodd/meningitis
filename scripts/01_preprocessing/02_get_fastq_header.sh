#!/bin/bash

# This script will output to standard out.

# set variables
files=/research/labs/neurology/fryer/m214960/meningitis/refs/fastq_file_list.txt

# go to fastq dir
cd /research/labs/neurology/fryer/projects/sepsis/human/meningitis

# print fastq file name + header
cat $files | while read file
do
  header=$(zcat $file | head -1)
  echo -n $file && echo -ne '\t' && echo $header
done