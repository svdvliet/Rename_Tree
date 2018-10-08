is.installed <- function(checkinstall) is.element(checkinstall, installed.packages()[,1])
if (is.installed("ape"))
{
  library(ape)
} else {
  install.packages("ape")
  library(ape)
}

## Only run examples in interactive R sessions
if (interactive()) {

  ui <- fluidPage(
    fileInput("file1", "Load Tree File in Newick format",
              accept = c(
                "text",
                "tre",
                ".tree")),
    tags$hr(),
    fileInput("file2", "Load CSV naming File",
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv")),
    checkboxInput("header", "Headers", TRUE),
    tags$hr(),
    selectInput("seperator", "Seperator", c(";",","), , multiple = FALSE,
                selectize = TRUE, width = "50px", size = NULL),
    tags$hr(),
    downloadButton("downloadData", "Download")

  )

  server <- function(input, output) {

    values <- reactiveValues()

      observeEvent(input$file1,{
        values$tree<- read.tree(input$file1$datapath)
    })

      observeEvent(input$file2,{
        values$names <- read.csv(input$file2$datapath, sep = input$seperator , header = input$header, stringsAsFactors = F)
        values$names <- values$names[match(values$tree$tip.label, values$names[,1]),] #reorders name pair fail to order in tree
        values$tree$tip.label <- values$names[,2] #replaces names in tree

        })




    output$downloadData <- downloadHandler(
      filename = function() {
        basename(input$file1$datapath)
      },
      content = function(file) {
        write.tree(values$tree, file)
      }
    )
  }

  shinyApp(ui, server)
}
