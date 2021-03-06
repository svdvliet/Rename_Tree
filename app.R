
# Check if Package "ape" is installed otherwise install
is.installed <- function(checkinstall) is.element(checkinstall, installed.packages()[,1])
if (is.installed("ape"))
{
} else {
  install.packages("ape")
}

# Set option to open app in browser window
options(shiny.launch.browser = T)

## Only run examples in interactive R sessions
if (interactive()) {

  ui <- fluidPage(

    fluidRow(
      column( width = 12,


    fileInput("file1", "Load Tree File in Newick Format",
              accept = c(
                "text",
                "tre",
                "tree")),
    tags$hr(),
    fileInput("file2", "Load .csv Naming File",
              accept = c(
                "text/csv",
                "text/comma-separated-values,text/plain",
                ".csv")),
    checkboxInput("header", "Headers", TRUE),
    tags$hr(),
    selectInput("seperator", "Seperator", c(";",","), multiple = FALSE,
                selectize = TRUE, width = "50px", size = NULL),
    tags$hr(),
    uiOutput("download")

  )
  )
  )

  server <- function(input, output) {

    values <- reactiveValues()

      observeEvent(input$file1,{
        values$tree<- ape::read.tree(input$file1$datapath)
    })

      observeEvent(input$file2,{
        values$names <- read.csv(input$file2$datapath, sep = input$seperator , header = input$header, stringsAsFactors = F)
        values$names <- values$names[match(values$tree$tip.label, values$names[,1]),] #reorders name pair fail to order in tree
        values$tree$tip.label <- values$names[,2] #replaces names in tree

        })


      output$download <- renderUI({
        if(!is.null(input$file1) & !is.null(input$file2)) {
          downloadButton("downloadData", "Download Renamed Tree")
        }
      })

    output$downloadData <- downloadHandler(

      filename = function() {
        basename(input$file1$name)
      },
      content = function(file) {
        ape::write.tree(values$tree, file)
      }
    )
  }

  shinyApp(ui, server)
}
