setwd(".")
library(limma)

plot_MDS <- function(tissue = "meninges", filter = "10CPM_in_17_samples", 
                     units = "log2cpm", label = "mayo_id", colorBy = "group", 
                     numGenes = 100, dimension = c(1,2)) {
  
  # read data
  obj <- readRDS(paste0("../../shiny/rObjects/", tissue, '_dge_', filter, ".rds"))
  if (units == "log2cpm") {
    data <- cpm(obj$counts, log = TRUE)
  } else {
    data <- cpm(dge$counts)
  }
  
  # set labels and colors for plot
  names <- obj$samples[, label]
  colors <- c("darkorange","blue")[obj$samples[, colorBy]]
  
  # plot MDS
  plotMDS(
    data, 
    top = numGenes, 
    labels = names,
    cex = 1, 
    dim.plot = dimension, 
    plot = TRUE, 
    col = colors
  )
  title(paste0(tissue, "_", filter, "_", numGenes, "_genes"))
  legend("topleft",
         legend = unique(names),
         pch = 16,
         col = unique(sex_color),
         cex = 1
         )
  
}

plot_MDS(tissue = "meninges", filter = "raw", units = "log2cpm", 
         label = "mayo_id", colorBy = "group")


