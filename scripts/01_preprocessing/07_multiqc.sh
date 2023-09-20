#!/bin/sh

# activate conda environment
source $HOME/.bash_profile
conda activate meningitis

# run multiqc on rawQC
cd ../../rawQC
multiqc *.zip --interactive --filename raw_reads_multiqc
cp raw_reads_multiqc.html ../results/multiQC_reports/

# run multiqc on trimmedQC
cd ../trimmedQC
multiqc *.zip --interactive --filename trimmed_reads_multiqc
cp trimmed_reads_multiqc.html ../results/multiQC_reports/
