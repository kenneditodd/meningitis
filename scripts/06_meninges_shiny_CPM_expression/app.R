# load libraries
library(shiny)
library(stringr)
library(ggplot2)

# set global plot params
theme_set(theme_classic())
theme_update(text = element_text(size=20))

# function to plot boxplot
plotBoxplot <- function(counts, gene) {
  
  # create df
  names <- colnames(counts)
  group <- str_match(names,"([cntrlmgs]+)")[,2]
  value <- as.numeric(subset(counts, rownames(counts) == gene))
  df <- data.frame(sample = names,
                   group = factor(group),
                   value = as.vector(value))
  rownames(df) <- 1:nrow(df)
  
  # Visualize the distribution of genes detected per sample via boxplot
  sample_colors <- c("cornflowerblue","orange")
  b <- ggplot(df, aes(x = group, y = value, fill = group)) +
    geom_boxplot(outlier.shape = NA) +
    geom_jitter() + 
    #theme_classic() +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
    theme(plot.title = element_text(hjust = 0.5, face="bold")) +
    ggtitle(gene) +
    scale_color_manual(values = sample_colors) +
    scale_fill_manual(values = sample_colors) +
    ylab("CPM") + xlab("Group")
  b
} # end boxplot function


# function to plot bar graph
plotBar <- function(counts, gene) {
  
  # create df
  names <- colnames(counts)
  group <- str_match(names,"([cntrlmgs]+)")[,2]
  value <- as.numeric(subset(counts, rownames(counts) == gene))
  df <- data.frame(sample = names,
                   group = factor(group),
                   value = as.vector(value))
  rownames(df) <- 1:nrow(df)
  
  # Visualize the distribution of genes detected per sample via boxplot
  sample_colors <- c("cornflowerblue","orange")
  b <- ggplot(df, aes(x = names, y = value, fill = group)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
    theme(plot.title = element_text(hjust = 0.5, face="bold")) +
    ggtitle(gene) +
    scale_color_manual(values = sample_colors) +
    scale_fill_manual(values = sample_colors) +
    ylab("CPM") + xlab("Sample")
  b
} # end boxplot function


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Meninges CPM"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          
          # Select tissue
          selectInput(inputId = "tissue", 
                      label = "Select tissue",
                      choices = "meninges",
                      selected = "meninges"),
          
          # Populate gene options based on selected tissue
          uiOutput(
            outputId = "geneOptions"
          )
          
        ), # end sidebarPanel

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("boxplot"),
           plotOutput("bar")
        )
        
  ) # end SidebarLayout
) # end ui fluid page

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # read CPM table
  cpm <- reactive({
    req(input$tissue)
    read.table(paste0(input$tissue, "_CPM_before_filtering_and_normalization.tsv"))
  })
  
  # get gene options from input table
  options(shiny.maxRequestSize = 30 * 1024^2)
  output$geneOptions <- renderUI({
    req(input$tissue)
    selectizeInput(inputId = "goi",
                   label = "Select a gene",
                   choices = rownames(cpm()),
                   options = list(maxOptions = 5))
  })
  
  # boxplot
  output$boxplot <- renderPlot({
    req(input$tissue)
    req(input$goi)
    plotBoxplot(counts = cpm(), gene = input$goi)
  })
  
  # boxplot
  output$bar <- renderPlot({
    req(input$tissue)
    req(input$goi)
    plotBar(counts = cpm(), gene = input$goi)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
