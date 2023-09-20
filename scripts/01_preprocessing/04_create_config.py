#!/usr/bin/python3

# create a new output file
outfile = open('../../refs/config.json', 'w')

# get all file names
allSamples = list()
meningesSamples = list()
parietalSamples = list()
read = ["R1", "R2"]
numSamples = 0

with open('../../refs/fastq_headers.tsv', 'r') as infile:
    for line in infile:
        numSamples += 1
        split = line.split()
        fileName = split[0]  # Mayo_43_P_S17_L001_R1_001.fastq.gz, for each sample there are 2 reads in 2 lanes (4 files)
        allSamples.append(fileName.replace("_L001_R1_001.fastq.gz", ""))
        if line.__contains__("_M_"):
            meningesSamples.append(fileName.replace("_L001_R1_001.fastq.gz", ""))
        if line.__contains__("_P_"):
            parietalSamples.append(fileName.replace("_L001_R1_001.fastq.gz", ""))

# create header and write to outfile
header = '''{{
    "DIRECTORIES",
    "rawReads" : "/research/labs/neurology/fryer/projects/sepsis/human/meningitis/",
    "rawQC" : "rawQC/",
    "trimmedReads" : "trimmedReads/",
    "trimmedQC" : "trimmedQC/",
    "starAligned" : "starAligned/",
    "featureCounts" : "featureCounts/",
    "genomeDir" : "/research/labs/neurology/fryer/projects/references/human/T2T_CHM13v2.0/chm13v2.0_STAR_default/",

    "FILES",
    "Hsapiens.gtf" : "/research/labs/neurology/fryer/projects/references/human/T2T_CHM13v2.0/chm13v2.0_RefSeq_Liftoff_v5.1.gff3",
    "Hsapiens.fa" : "/research/labs/neurology/fryer/projects/references/human/T2T_CHM13v2.0/chm13v2.0.fa",

    "SAMPLE INFORMATION",
    "allSamples": {0},
    "meningesSamples": {1},
    "parietalSamples": {2},
    "femaleSamples": ['Mayo_11_M_S42','Mayo_11_P_S21','Mayo_12_M_S33','Mayo_12_P_S20','Mayo_14_M_S49','Mayo_14_P_S19','Mayo_16_M_S40','Mayo_16_P_S4', 'Mayo_17_M_S46','Mayo_17_P_S81','Mayo_18_M_S47','Mayo_18_P_S32','Mayo_19_M_S74','Mayo_19_P_S35','Mayo_21_M_S76','Mayo_21_P_S54','Mayo_27_M_S71','Mayo_27_P_S38','Mayo_30_M_S28','Mayo_30_P_S27','Mayo_33_M_S22','Mayo_33_P_S16','Mayo_35_M_S59','Mayo_35_P_S14','Mayo_42_M_S70','Mayo_42_P_S77','Mayo_43_M_S31','Mayo_43_P_S17'],
    "maleSamples": ['Mayo_01_M_S36','Mayo_01_P_S55','Mayo_02_M_S43','Mayo_02_P_S84','Mayo_03_M_S5', 'Mayo_03_P_S2', 'Mayo_04_M_S41','Mayo_04_P_S30','Mayo_05_M_S60','Mayo_05_P_S6', 'Mayo_06_M_S26','Mayo_06_P_S12','Mayo_07_M_S79','Mayo_07_P_S80','Mayo_08_M_S57','Mayo_08_P_S63','Mayo_09_M_S52','Mayo_09_P_S65','Mayo_10_M_S58','Mayo_10_P_S11','Mayo_13_M_S24','Mayo_13_P_S48','Mayo_15_M_S7', 'Mayo_15_P_S39','Mayo_20_M_S23','Mayo_20_P_S9', 'Mayo_22_M_S10','Mayo_22_P_S29','Mayo_23_M_S62','Mayo_23_P_S68','Mayo_24_M_S73','Mayo_24_P_S64','Mayo_25_M_S34','Mayo_25_P_S78','Mayo_26_M_S82','Mayo_26_P_S83','Mayo_28_M_S13','Mayo_28_P_S56','Mayo_29_M_S61','Mayo_29_P_S45','Mayo_31_M_S72','Mayo_31_P_S37','Mayo_34_M_S69','Mayo_34_P_S25','Mayo_36_M_S15','Mayo_36_P_S50','Mayo_37_M_S51','Mayo_37_P_S67','Mayo_38_M_S75','Mayo_38_P_S53','Mayo_39_M_S8', 'Mayo_39_P_S3', 'Mayo_40_M_S18','Mayo_40_P_S66','Mayo_41_M_S1', 'Mayo_41_P_S44'],
    "read": {3},

    "CLUSTER INFORMATION",
    "threads" : "20",
'''
outfile.write(header.format(allSamples, meningesSamples, parietalSamples, read))

# config formatting
counter = 0
with open('../../refs/fastq_headers.tsv', 'r') as infile:
    for line in infile:
        counter += 1

        # store sample name and info, Mayo_43_P_S17_L001_R1_001.fastq.gz, for each sample there is 2 reads in 2 lanes (4 files)
        split = line.split()
        lane1read1 = split[0].replace(".fastq.gz", "")
        lane1read2 = lane1read1.replace("R1", "R2")
        lane2read1 = lane1read1.replace("L001","L002")
        lane2read2 = lane1read2.replace("L001","L002")
        baseName = lane1read1.replace("_L001_R1_001", "")
        sampleInfo = split[1]

        # break down fastq file info
        # @A00127:312:HVNLJDSXY:2:1101:2211:1000
        # @<instrument>:<run number>:<flowcell ID>:<lane>:<tile>:<x-pos>:<y-pos>
        sampleInfo = sampleInfo.split(':')
        instrument = sampleInfo[0]
        instrument = instrument.replace("@", "")
        runNumber = sampleInfo[1]
        flowCell = sampleInfo[2]

        out = '''
    "{0}":{{
        "lane1read1": "{1}",
        "lane2read1": "{2}",
        "lane1read2": "{3}",
        "lane2read2": "{4}",
        "instrument": "{5}",
        "runNumber": "{6}",
        "flowCell": "{7}"
        '''
        outfile.write(out.format(baseName, lane1read1, lane2read1, lane1read2, lane2read2, instrument, runNumber, flowCell))
        if (counter == numSamples):
            outfile.write("}\n}")
        else:
            outfile.write("},\n")
outfile.close()

