# setup
setwd(".")

# read sample info
meta <- read.delim("../../refs/brain_bank_sample_info.tsv",
                   header = TRUE,
                   sep = "\t")

# get rid of all upper cases
colnames(meta) <- tolower(colnames(meta))

# change periods to underscores
colnames(meta) <- gsub("\\.", "_", colnames(meta))

# mayo ID
meta$mayo_id <- gsub(" ", "_", meta$mayo_id)

# LBD - add NAs
for (i in 1:nrow(meta)) {
  value <- meta[i,"lbd"]
  if(value == "") {
    meta[i,"lbd"] <- NA
  }
}

# sex 
meta$sex <- gsub("M","male",meta$sex)
meta$sex <- gsub("F","female",meta$sex)

# tissue available
colnames(meta)[c(12,13)] <- c("meninges_tissue", "parietal_tissue")


# AD subtype
for (i in 1:nrow(meta)) {
  value <- meta[i,"ad_subtype"]
  if(value == "") {
    meta[i,"ad_subtype"] <- NA
  }
}

# APOE
for (i in 1:nrow(meta)) {
  value <- meta[i,"apoe"]
  if(value == "") {
    meta[i,"apoe"] <- NA
  }
}

# MAPT
for (i in 1:nrow(meta)) {
  value <- meta[i,"mapt"]
  if(value == "") {
    meta[i,"mapt"] <- NA
  }
}

# group
# 1-25 are controls, 26 - 43 are meningitis cases (according to Joe's email and clinical notes)
meta$group <- c(rep("control", 25), rep("meningitis",18))
meta <- meta[,c(1,21,2:20)]

# subset by available tissue and remove columns
meta <- meta[meta$meninges_tissue == "yes",]
meta <- meta[meta$parietal_tissue == "yes",]
meta$meninges_tissue <- NULL
meta$parietal_tissue <- NULL

# add file info
files <- read.delim2("../../refs/fastq_file_list.txt", header = FALSE)
colnames(files) <- "filename"
files$filename <- gsub("_L001_R1_001.fastq.gz", "", files$filename)

# extract mayo_id
files$mayo_id <- str_match(files$filename, "(Mayo_[0-9]+)_[MP]")[,2]

# join tables
df <- left_join(files, meta, by = "mayo_id")

# add RIN info
rin <- read.delim2("../../refs/Mayo_Clinic_GAC_RIN.tsv", sep = "\t")
rin$notes <- gsub(" ", "_", rin$notes)

# join tables
df <- left_join(df, rin, by = "filename")

# change class
df$RIN <- as.numeric(df$RIN)

# add tissue type
tissue <- df$filename
df$tissue <- str_match(tissue, "Mayo_[0-9]+_([MP])")[,2]
df$tissue <- gsub("M","meninges",df$tissue)
df$tissue <- gsub("P","parietal",df$tissue)

# remove NA values
df$lbd[is.na(df$lbd)] <- "unknown/NA"
df$tdp_43[is.na(df$tdp_43)] <- "unknown/NA"
df$disease_duration[is.na(df$disease_duration)] <- "unknown/NA"
df$ad_subtype[is.na(df$ad_subtype)] <- "unknown/NA"
df$apoe[is.na(df$apoe)] <- "unknown/NA"
df$mapt[is.na(df$mapt)] <- "unknown/NA"
df$dob[is.na(df$dob)] <- "unknown/NA"

# add alignmnet info
star <- read.delim("../../refs/unique_mapped_all_files.txt", header = FALSE, sep = "|")
colnames(star) <- c("filename","star_unique_mapped")
star$filename <- gsub("                        Uniquely mapped reads %","", star$filename)
star$filename <- gsub(" ","", star$filename)
star$star_unique_mapped <- gsub("\t","", star$star_unique_mapped)
star$filename <- str_match(star$filename, "(Mayo_[0-9]+_[MP]_S[0-9]+)_")[,2]

# join tables
df <- left_join(df, star, by = "filename")

# save
write.table(df, "../../refs/metadata.tsv", quote = FALSE, row.names = FALSE, 
            sep = "\t")
remove(files,meta,rin,star)

# print female samples for Snakefile
females <- subset(df, sex == "female")
females$filename

# print female samples for Snakefile
males <- subset(df, sex == "male")
males$filename

# view tables
df <- subset(df, tissue == "meninges")
# donor specific info
df$sex_group <- paste0(df$sex,"_",df$group)
table(df$group)
table(df$sex)
table(df$sex_group)
table(df$lbd)
table(df$braak)
table(df$thal)
table(df$tdp_43)
table(df$disease_duration)
summary(df$age_at_death)
table(df$ad_subtype)
summary(df$brain_wt)
table(df$race)
table(df$apoe)
table(df$mapt)






