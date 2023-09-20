
library(ComplexUpset) # intersection_size()
library(UpSetR)       # fromList()

gtf.file <- "/research/labs/neurology/fryer/projects/references/human/T2T_CHM13v2.0/chm13v2.0_RefSeq_Liftoff_v5.1.gff3"
t2t <- rtracklayer::import(gtf.file)
t2t <- as.data.frame(t2t)
t2t <- t2t[t2t$type == "gene",]
table(t2t$gene_biotype)
#t2t <- t2t[t2t$gene_biotype == "protein_coding",]

gtf.file <- "/research/labs/neurology/fryer/projects/references/human/gencode.v38.annotation.gtf"
h38 <- rtracklayer::import(gtf.file)
h38 <- as.data.frame(h38)
h38 <- h38[h38$type == "gene",]
h38 <- h38[h38$gene_type == "protein_coding",]

t2t_genes <- t2t$gene
t2t_genes <- t2t_genes[!is.na(t2t_genes)]
t2t_genes <- t2t_genes[!duplicated(t2t_genes)]
h38_genes <- h38$gene_name
h38_genes <- h38_genes[!is.na(h38_genes)]
h38_genes <- h38_genes[!duplicated(h38_genes)]

# remove gene_version due to duplicate gene names
#str_match(h38_unique, "(.+)\\.[0-9]+")
#h38_genes <- str_match(h38_genes, "(.+).[0-9]+")[,2]

list_input <- list("T2T protein coding genes" = t2t_genes,
                   "GRCh38 protein coding genes" = h38_genes)
data <- fromList(list_input)

# store names
names <- c("GRCh38 protein coding genes","T2T protein coding genes")

# plot
upset_gene <- ComplexUpset::upset(
  data,
  names,
  set_sizes=(upset_set_size() 
             + geom_text(aes(label=..count..), hjust=1.1, stat='count')
             + expand_limits(y=25000)),
  queries = list(upset_query("T2T protein coding genes", fill = "red"),
                 upset_query("GRCh38 protein coding genes", fill = "blue")),
  base_annotations = list('Intersection size' = (
    intersection_size(bar_number_threshold=1, width=0.5)
    + scale_y_continuous(expand=expansion(mult=c(0, 0.05)),limits = c(0,21000)) # space on top
    + theme(# hide grid lines
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      # show axis lines
      axis.line=element_line(colour='black')))),
  stripes = upset_stripes(
    geom=geom_segment(size=12),  # make the stripes larger
    colors=c('grey95', 'white')),
  # to prevent connectors from getting the colorured
  # use `fill` instead of `color`, together with `shape='circle filled'`
  matrix = intersection_matrix(
    geom=geom_point(
      shape='circle filled',
      size=3,
      stroke=0.45)),
  sort_sets=FALSE,
  sort_intersections='descending'
)

upset_gene <- upset_gene + ggtitle("Annotation Comparison")
upset_gene

both <- h38_genes[h38_genes %in% t2t_genes]
length(both)
View(as.data.frame(both))

t2t_unique <- t2t_genes[!t2t_genes %in% h38_genes]
table(startsWith(t2t_unique,"LOC"))
t2t_unique <- t2t_unique[!startsWith(t2t_unique,"LOC")]
View(as.data.frame(t2t_unique))

h38_unique <- h38_genes[!h38_genes %in% t2t_genes]
h38_unique <- h38_unique[!startsWith(h38_unique,"RP")]
View(as.data.frame(h38_unique))



