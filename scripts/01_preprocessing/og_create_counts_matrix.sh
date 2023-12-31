#!/bin/sh

# change to featureCounts directory
cd ../featureCounts

# SUMMED EXONS
#-----------------------------------------------------------------------------------------

# create list of exon featureCount files
ls -1 | grep exon.counts$ > exon_files.txt

# store number of files
n=$(cat exon_files.txt | wc -l)

# if there is at least 1 file
if [ $n -ge 1 ]
then
	# get name of one file
	exonFile=$(ls -1 | grep exon.counts$ | head -n 1)
	
	# store the Geneid and length (summed exons) column
	tail -n+2 $exonFile | cut -f1,6 > summed_exons.tsv

	# change Geneid to gene_id
	sed -i 's/Geneid/gene_id/g' summed_exons.tsv
	sed -i 's/Length/exonic_length/g' summed_exons.tsv

	# print
	echo "Length of summed exons successfully generated"
else
	echo "Cannot create summed_exons.txt file.  No exon featureCount files exist."
fi

# cleanup
rm exon_files.txt


# BRAIN COUNT MATRIX
#-----------------------------------------------------------------------------------------

# create list of brain gene featureCount count files
ls -1 | grep gene.counts$ > brain_count_files.txt

# store number of files in variable
n=$(cat brain_count_files.txt | wc -l)

# if there are at least two files
if [ $n -ge 2 ]
then 
	# get Geneid and counts column of first file
	firstFile=$(head -n 1 brain_count_files.txt)
	tail -n+2 $firstFile | cut -f1,7 > file1.txt
	
	# get counts column of remaining files
	i=2
	for file in $(tail -n+2 brain_count_files.txt)
	do
		tail -n+2 $file | cut -f7 > file$i;
		let "i+=1"
	done

	# paste files together
	paste -d "\t" file* > brain_counts_matrix.tsv					

	# rename columns
	sed -i 's,starAligned/,,g' brain_counts_matrix.tsv
	sed -i 's,.Aligned.sortedByCoord.out.bam,,g' brain_counts_matrix.tsv
	sed -i 's/Geneid/gene_id/g' brain_counts_matrix.tsv

	# cleanup
	rm file*
	
	# print
	echo "Brain counts matrix successfully generated."
else
	echo "Could not generate brain counts matrix. You need at least two brain samples to generate this tissue matrix."
fi

# cleanup
rm brain_count_files.txt

