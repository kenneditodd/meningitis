configfile: "refs/config.json"


# VARIABLES
#-----------------------------------------------------------------------------------------
rawReadsDir = config["rawReads"]
trimmedReadsDir = config["trimmedReads"]
rawQCDir = config["rawQC"]
trimmedQCDir = config["trimmedQC"]
starDir = config["starAligned"]
countsDir = config["featureCounts"]
gtfFile = config["Hsapiens.gtf"]


# RULE ALL
#-----------------------------------------------------------------------------------------
rule all:
	input:
		expand(rawQCDir + "{sample}_L001_R1_001_fastqc.html", sample = config["allSamples"]),
		expand(rawQCDir + "{sample}_L001_R2_001_fastqc.html", sample = config["allSamples"]),
		expand(rawQCDir + "{sample}_L002_R1_001_fastqc.html", sample = config["allSamples"]),
		expand(rawQCDir + "{sample}_L002_R2_001_fastqc.html", sample = config["allSamples"]),
		expand(rawQCDir + "{sample}_L001_R1_001_fastqc.zip", sample = config["allSamples"]),
		expand(rawQCDir + "{sample}_L001_R2_001_fastqc.zip", sample = config["allSamples"]),
		expand(rawQCDir + "{sample}_L002_R1_001_fastqc.zip", sample = config["allSamples"]),
		expand(rawQCDir + "{sample}_L002_R2_001_fastqc.zip", sample = config["allSamples"]),
		expand(trimmedReadsDir + "{sample}_L1_R1_trim.fastq.gz", sample = config["allSamples"]),
		expand(trimmedReadsDir + "{sample}_L1_R2_trim.fastq.gz", sample = config["allSamples"]),
		expand(trimmedReadsDir + "{sample}_L2_R1_trim.fastq.gz", sample = config["allSamples"]),
		expand(trimmedReadsDir + "{sample}_L2_R2_trim.fastq.gz", sample = config["allSamples"]),
		expand(trimmedQCDir + "{sample}_L1_R1_trim_fastqc.html", sample = config["allSamples"]),
		expand(trimmedQCDir + "{sample}_L1_R2_trim_fastqc.html", sample = config["allSamples"]),
		expand(trimmedQCDir + "{sample}_L2_R1_trim_fastqc.html", sample = config["allSamples"]),
		expand(trimmedQCDir + "{sample}_L2_R2_trim_fastqc.html", sample = config["allSamples"]),
		expand(trimmedQCDir + "{sample}_L1_R1_trim_fastqc.zip", sample = config["allSamples"]),
		expand(trimmedQCDir + "{sample}_L1_R2_trim_fastqc.zip", sample = config["allSamples"]),
		expand(trimmedQCDir + "{sample}_L2_R1_trim_fastqc.zip", sample = config["allSamples"]),
		expand(trimmedQCDir + "{sample}_L2_R2_trim_fastqc.zip", sample = config["allSamples"]),
		expand(starDir + "{sample}_default.Aligned.sortedByCoord.out.bam", sample = config["allSamples"]),
		expand(starDir + "{female_sample}_XX.Aligned.sortedByCoord.out.bam", female_sample = config["femaleSamples"]),
		expand(starDir + "{male_sample}_XY.Aligned.sortedByCoord.out.bam", male_sample = config["maleSamples"]),
		expand(countsDir + "{sample}_default_gene.counts", sample = config["allSamples"]),
		expand(countsDir + "{female_sample}_sex_specific_XX_gene.counts", female_sample = config["femaleSamples"]),
		expand(countsDir + "{male_sample}_sex_specific_XY_gene.counts", male_sample = config["maleSamples"])


# RAW FASTQC
#-----------------------------------------------------------------------------------------
rule raw_fastqc:
	input:
		L1R1 = lambda wildcards: rawReadsDir + config[wildcards.sample]["lane1read1"] + ".fastq.gz",
		L1R2 = lambda wildcards: rawReadsDir + config[wildcards.sample]["lane1read2"] + ".fastq.gz",
		L2R1 = lambda wildcards: rawReadsDir + config[wildcards.sample]["lane2read1"] + ".fastq.gz",
		L2R2 = lambda wildcards: rawReadsDir + config[wildcards.sample]["lane2read2"] + ".fastq.gz"
	output:
		html1 = rawQCDir + "{sample}_L001_R1_001_fastqc.html",
		html2 = rawQCDir + "{sample}_L001_R2_001_fastqc.html",
		html3 = rawQCDir + "{sample}_L002_R1_001_fastqc.html",
		html4 = rawQCDir + "{sample}_L002_R2_001_fastqc.html",
		zip1 = rawQCDir + "{sample}_L001_R1_001_fastqc.zip",
		zip2 = rawQCDir + "{sample}_L001_R2_001_fastqc.zip",
		zip3 = rawQCDir + "{sample}_L002_R1_001_fastqc.zip",
		zip4 = rawQCDir + "{sample}_L002_R2_001_fastqc.zip"
	params:
		outDir = rawQCDir,
		threads = config["threads"]
	shell:
		"""
		fastqc {input.L1R1} --outdir {params.outDir} --threads {params.threads};
		fastqc {input.L1R2} --outdir {params.outDir} --threads {params.threads};
		fastqc {input.L2R1} --outdir {params.outDir} --threads {params.threads};
		fastqc {input.L2R2} --outdir {params.outDir} --threads {params.threads};
		"""


# TRIM BBDUK
#-----------------------------------------------------------------------------------------
rule trim_bbduk:
	input:
		L1R1 = lambda wildcards: rawReadsDir + config[wildcards.sample]["lane1read1"] + ".fastq.gz",
		L1R2 = lambda wildcards: rawReadsDir + config[wildcards.sample]["lane1read2"] + ".fastq.gz",
		L2R1 = lambda wildcards: rawReadsDir + config[wildcards.sample]["lane2read1"] + ".fastq.gz",
		L2R2 = lambda wildcards: rawReadsDir + config[wildcards.sample]["lane2read2"] + ".fastq.gz"
	output:
		trim1 = (trimmedReadsDir + "{sample}_L1_R1_trim.fastq.gz"),
		trim2 = (trimmedReadsDir + "{sample}_L1_R2_trim.fastq.gz"),
		trim3 = (trimmedReadsDir + "{sample}_L2_R1_trim.fastq.gz"),
		trim4 = (trimmedReadsDir + "{sample}_L2_R2_trim.fastq.gz")
	params:
	  adapters = "refs/adapters.fa",
	  threads = config["threads"]
	shell:
		"""
		bbduk.sh -Xmx3g in1={input.L1R1} in2={input.L1R2} out1={output.trim1} out2={output.trim2} ref={params.adapters} ktrim=r k=23 mink=11 hdist=1 tpe tbo threads={params.threads} trimpolyg=1 trimpolya=1
		bbduk.sh -Xmx3g in1={input.L2R1} in2={input.L2R2} out1={output.trim3} out2={output.trim4} ref={params.adapters} ktrim=r k=23 mink=11 hdist=1 tpe tbo threads={params.threads} trimpolyg=1 trimpolya=1
		"""


# TRIMMED FASTQC
#-----------------------------------------------------------------------------------------
rule trimmed_fastqc:
	input:
		trim1 = (trimmedReadsDir + "{sample}_L1_R1_trim.fastq.gz"),
		trim2 = (trimmedReadsDir + "{sample}_L1_R2_trim.fastq.gz"),
		trim3 = (trimmedReadsDir + "{sample}_L2_R1_trim.fastq.gz"),
		trim4 = (trimmedReadsDir + "{sample}_L2_R2_trim.fastq.gz")
	output:
		html1 = trimmedQCDir + "{sample}_L1_R1_trim_fastqc.html",
		html2 = trimmedQCDir + "{sample}_L1_R2_trim_fastqc.html",
		html3 = trimmedQCDir + "{sample}_L2_R1_trim_fastqc.html",
		html4 = trimmedQCDir + "{sample}_L2_R2_trim_fastqc.html",
		zip1 = trimmedQCDir + "{sample}_L1_R1_trim_fastqc.zip",
		zip2 = trimmedQCDir + "{sample}_L1_R2_trim_fastqc.zip",
		zip3 = trimmedQCDir + "{sample}_L2_R1_trim_fastqc.zip",
		zip4 = trimmedQCDir + "{sample}_L2_R2_trim_fastqc.zip"
	params:
		outDir = trimmedQCDir,
		threads = config["threads"]
	shell:
		"""
		fastqc {input.trim1} --outdir {params.outDir} --threads {params.threads};
		fastqc {input.trim2} --outdir {params.outDir} --threads {params.threads};
		fastqc {input.trim3} --outdir {params.outDir} --threads {params.threads};
		fastqc {input.trim4} --outdir {params.outDir} --threads {params.threads};
		"""


# ALIGN READS
#-----------------------------------------------------------------------------------------
rule align_default_reads:
	input:
		trim1 = rules.trim_bbduk.output.trim1, # L1 R1
		trim2 = rules.trim_bbduk.output.trim2, # L1 R2
		trim3 = rules.trim_bbduk.output.trim3, # L2 R1
		trim4 = rules.trim_bbduk.output.trim4, # L2 R2
		genomeDir = config["genomeDir"]
	output:
		aligned = (starDir + "{sample}_default.Aligned.sortedByCoord.out.bam")
	params:
		prefix = (starDir + "{sample}_default."),
		threads = config["threads"]
	shell:
		"""
		STAR --genomeDir {input.genomeDir} --runThreadN {params.threads} --readFilesCommand zcat --limitBAMsortRAM 31000000000 --readFilesIn {input.trim1},{input.trim3} {input.trim2},{input.trim4} --outFileNamePrefix {params.prefix} --outSAMtype BAM SortedByCoordinate
		"""
		
rule align_XX_reads:
	input:
		trim1 = trimmedReadsDir + "{female_sample}_L1_R1_trim.fastq.gz", # L1 R1
		trim2 = trimmedReadsDir + "{female_sample}_L1_R2_trim.fastq.gz", # L1 R2
		trim3 = trimmedReadsDir + "{female_sample}_L2_R1_trim.fastq.gz", # L2 R1
		trim4 = trimmedReadsDir + "{female_sample}_L2_R2_trim.fastq.gz", # L2 R2
		genomeDir = config["genomeDir"]
	output:
		aligned = (starDir + "{female_sample}_XX.Aligned.sortedByCoord.out.bam")
	params:
		prefix = (starDir + "{female_sample}_XX."),
		threads = config["threads"]
	shell:
		"""
		STAR --genomeDir {input.genomeDir} --runThreadN {params.threads} --readFilesCommand zcat --limitBAMsortRAM 31000000000 --readFilesIn {input.trim1},{input.trim3} {input.trim2},{input.trim4} --outFileNamePrefix {params.prefix} --outSAMtype BAM SortedByCoordinate
		"""

rule align_XY_reads:
	input:
		trim1 = trimmedReadsDir + "{male_sample}_L1_R1_trim.fastq.gz", # L1 R1
		trim2 = trimmedReadsDir + "{male_sample}_L1_R2_trim.fastq.gz", # L1 R2
		trim3 = trimmedReadsDir + "{male_sample}_L2_R1_trim.fastq.gz", # L2 R1
		trim4 = trimmedReadsDir + "{male_sample}_L2_R2_trim.fastq.gz", # L2 R2
		genomeDir = config["genomeDir"]
	output:
		aligned = (starDir + "{male_sample}_XY.Aligned.sortedByCoord.out.bam")
	params:
		prefix = (starDir + "{male_sample}_XY."),
		threads = config["threads"]
	shell:
		"""
		STAR --genomeDir {input.genomeDir} --runThreadN {params.threads} --readFilesCommand zcat --limitBAMsortRAM 31000000000 --readFilesIn {input.trim1},{input.trim3} {input.trim2},{input.trim4} --outFileNamePrefix {params.prefix} --outSAMtype BAM SortedByCoordinate
		"""

# FEATURE COUNTS
#-----------------------------------------------------------------------------------------	
rule gene_count_default:
	input:
		bam = rules.align_default_reads.output.aligned,
		gtf = gtfFile
	output:
		feature = (countsDir + "{sample}_default_gene.counts")
	params:
	  threads = config["threads"]
	shell:
		"""
		featureCounts -p --primary -t gene -g ID -T {params.threads} -s 2 -a {input.gtf} -o {output.feature} {input.bam}
		
		# KEY
		# -p specify that input data contains paired-end reads
		# --primary count primary alignments only, primary alignments are identified using bit 0x100 in SAM/BAM FLAG field
		# -t specify feature type in annotation, exon by default
		# -g specify attribute type in annotation, gene_id by default, used for read counting
		# -T number of the threads, 1 by default
		# -s specify strandedness, 0 = unstranded, 1 = stranded, 2 = reversely stranded
		# -a name of an annotation file. GTF/GFF format by default
		# -o name of output file including read counts
		"""

rule gene_count_XX:
	input:
		bam = starDir + "{female_sample}_XX.Aligned.sortedByCoord.out.bam",
		gtf = gtfFile
	output:
		feature = countsDir + "{female_sample}_sex_specific_XX_gene.counts"
	params:
	  threads = config["threads"]
	shell:
		"""
		featureCounts -p --primary -t gene -g ID -T {params.threads} -s 2 -a {input.gtf} -o {output.feature} {input.bam}
		
		# KEY
		# -p specify that input data contains paired-end reads
		# --primary count primary alignments only, primary alignments are identified using bit 0x100 in SAM/BAM FLAG field
		# -t specify feature type in annotation, exon by default
		# -g specify attribute type in annotation, gene_id by default, used for read counting
		# -T number of the threads, 1 by default
		# -s specify strandedness, 0 = unstranded, 1 = stranded, 2 = reversely stranded
		# -a name of an annotation file. GTF/GFF format by default
		# -o name of output file including read counts
		"""

rule gene_count_XY:
	input:
		bam = starDir + "{male_sample}_XY.Aligned.sortedByCoord.out.bam",
		gtf = gtfFile
	output:
		feature = countsDir + "{male_sample}_sex_specific_XY_gene.counts"
	params:
	  threads = config["threads"]
	shell:
		"""
		featureCounts -p --primary -t gene -g ID -T {params.threads} -s 2 -a {input.gtf} -o {output.feature} {input.bam}
		
		# KEY
		# -p specify that input data contains paired-end reads
		# --primary count primary alignments only, primary alignments are identified using bit 0x100 in SAM/BAM FLAG field
		# -t specify feature type in annotation, exon by default
		# -g specify attribute type in annotation, gene_id by default, used for read counting
		# -T number of the threads, 1 by default
		# -s specify strandedness, 0 = unstranded, 1 = stranded, 2 = reversely stranded
		# -a name of an annotation file. GTF/GFF format by default
		# -o name of output file including read counts
		"""