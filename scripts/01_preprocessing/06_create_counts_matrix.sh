# Kennedi Todd
# August 15, 2023

# go to counts folder
cd ../../featureCounts

# MENINGES DEFAULT COUNT MATRIX
#-----------------------------------------------------------------------------------------

# create list of meninges gene featureCount count files
ls -1 | grep _M_ | grep default | grep gene.counts$ > meninges_count_files.txt

# store number of files in variable
n=$(cat meninges_count_files.txt | wc -l)

# if there are at least two files
if [ $n -ge 2 ]
then 
	# get Geneid and counts column of first file
	firstFile=$(head -n 1 meninges_count_files.txt)
	tail -n+2 $firstFile | cut -f1,7 > file1.txt
	
	# get counts column of remaining files
	i=2
	for file in $(tail -n+2 meninges_count_files.txt)
	do
		tail -n+2 $file | cut -f7 > file$i;
		let "i+=1"
	done

	# paste files together
	paste -d "\t" file* > meninges_default_counts_matrix.tsv					

	# rename columns
	sed -i 's,starAligned/,,g' meninges_default_counts_matrix.tsv
	sed -i 's,.Aligned.sortedByCoord.out.bam,,g' meninges_default_counts_matrix.tsv
	sed -i 's/Geneid/ID/g' meninges_default_counts_matrix.tsv

	# cleanup
	rm file*
	
	# print
	echo "Default meninges counts matrix successfully generated."
else
	echo "Could not generate default meninges counts matrix. You need at least two samples to generate this tissue matrix."
fi

# cleanup
rm meninges_count_files.txt


# MENINGES SEX SPECIFIC COUNT MATRIX
#-----------------------------------------------------------------------------------------

# create list of meninges gene featureCount count files
ls -1 | grep _M_ | grep sex_specific | grep gene.counts$ > meninges_count_files.txt

# store number of files in variable
n=$(cat meninges_count_files.txt | wc -l)

# if there are at least two files
if [ $n -ge 2 ]
then 
	# get Geneid and counts column of first file
	firstFile=$(head -n 1 meninges_count_files.txt)
	tail -n+2 $firstFile | cut -f1,7 > file1.txt
	
	# get counts column of remaining files
	i=2
	for file in $(tail -n+2 meninges_count_files.txt)
	do
		tail -n+2 $file | cut -f7 > file$i;
		let "i+=1"
	done

	# paste files together
	paste -d "\t" file* > meninges_sex_specific_counts_matrix.tsv					

	# rename columns
	sed -i 's,starAligned/,,g' meninges_sex_specific_counts_matrix.tsv
	sed -i 's,.Aligned.sortedByCoord.out.bam,,g' meninges_sex_specific_counts_matrix.tsv
	sed -i 's/Geneid/ID/g' meninges_sex_specific_counts_matrix.tsv

	# cleanup
	rm file*
	
	# print
	echo "Sex specific meninges counts matrix successfully generated."
else
	echo "Could not generate sex specific meninges counts matrix. You need at least two samples to generate this tissue matrix."
fi

# cleanup
rm meninges_count_files.txt


# PARIETAL DEFAULT COUNT MATRIX
#-----------------------------------------------------------------------------------------

# create list of parietal gene featureCount count files
ls -1 | grep _P_ | grep default | grep gene.counts$ > parietal_count_files.txt

# store number of files in variable
n=$(cat parietal_count_files.txt | wc -l)

# if there are at least two files
if [ $n -ge 2 ]
then 
	# get Geneid and counts column of first file
	firstFile=$(head -n 1 parietal_count_files.txt)
	tail -n+2 $firstFile | cut -f1,7 > file1.txt
	
	# get counts column of remaining files
	i=2
	for file in $(tail -n+2 parietal_count_files.txt)
	do
		tail -n+2 $file | cut -f7 > file$i;
		let "i+=1"
	done

	# paste files together
	paste -d "\t" file* > parietal_default_counts_matrix.tsv					

	# rename columns
	sed -i 's,starAligned/,,g' parietal_default_counts_matrix.tsv
	sed -i 's,.Aligned.sortedByCoord.out.bam,,g' parietal_default_counts_matrix.tsv
	sed -i 's/Geneid/ID/g' parietal_default_counts_matrix.tsv

	# cleanup
	rm file*
	
	# print
	echo "Default parietal counts matrix successfully generated."
else
	echo "Could not generate default parietal counts matrix. You need at least two samples to generate this tissue matrix."
fi

# cleanup
rm parietal_count_files.txt



# PARIETAL SEX SPECIFIC COUNT MATRIX
#-----------------------------------------------------------------------------------------

# create list of parietal gene featureCount count files
ls -1 | grep _P_ | grep sex_specific | grep gene.counts$ > parietal_count_files.txt

# store number of files in variable
n=$(cat parietal_count_files.txt | wc -l)

# if there are at least two files
if [ $n -ge 2 ]
then 
	# get Geneid and counts column of first file
	firstFile=$(head -n 1 parietal_count_files.txt)
	tail -n+2 $firstFile | cut -f1,7 > file1.txt
	
	# get counts column of remaining files
	i=2
	for file in $(tail -n+2 parietal_count_files.txt)
	do
		tail -n+2 $file | cut -f7 > file$i;
		let "i+=1"
	done

	# paste files together
	paste -d "\t" file* > parietal_sex_specific_counts_matrix.tsv					

	# rename columns
	sed -i 's,starAligned/,,g' parietal_sex_specific_counts_matrix.tsv
	sed -i 's,.Aligned.sortedByCoord.out.bam,,g' parietal_sex_specific_counts_matrix.tsv
	sed -i 's/Geneid/ID/g' parietal_sex_specific_counts_matrix.tsv

	# cleanup
	rm file*
	
	# print
	echo "Sex specific parietal counts matrix successfully generated."
else
	echo "Could not generate sex specific parietal counts matrix. You need at least two samples to generate this tissue matrix."
fi

# cleanup
rm parietal_count_files.txt
