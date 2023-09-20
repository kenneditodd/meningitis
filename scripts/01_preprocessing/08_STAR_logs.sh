#!/bin/sh

# copy STAR logs over to results
cd ../../starAligned
cp *.Log.final.out ../results/STAR_logs

# print uniquely mapped line for each file
cd ../results/STAR_logs
FILES=$(ls -1 | grep _X)
for file in $FILES; do
  echo -n $file
  awk '{if(NR==10) print $0}' $file
done