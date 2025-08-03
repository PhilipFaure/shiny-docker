# library(shiny)
# 
# ui <- fluidPage(
#   titlePanel("Hello Shiny!"),
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("obs", "Number of observations:", 1, 100, 50)
#     ),
#     mainPanel(
#       plotOutput("distPlot")
#     )
#   )
# )
# 
# server <- function(input, output) {
#   output$distPlot <- renderPlot({
#     hist(rnorm(input$obs))
#   })
# }
# 
# shinyApp(ui = ui, server = server)
library(shiny)
library(DT)
library(shinyFiles)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),
  titlePanel("Video Viewer"),
  sidebarLayout(
    sidebarPanel(
      shinyDirButton("folder", "Choose Folder", "Select a folder with videos"),
      verbatimTextOutput("folderPath"),
      DTOutput("videoTable")
    ),
    mainPanel(
      uiOutput("videoPlayer")
    )
  )
)

server <- function(input, output, session) {
  volumes <- c(Home = normalizePath("~"))
  shinyDirChoose(input, "folder", roots = volumes, session = session)
  
  folderPath <- reactiveVal(NULL)
  videoFiles <- reactiveVal(NULL)
  
  observeEvent(input$folder, {
    path <- parseDirPath(volumes, input$folder)
    if (length(path) > 0 && dir.exists(path)) {
      folderPath(path)
      vids <- list.files(path, pattern = "\\.(mp4|webm|ogg)$", full.names = TRUE, ignore.case = TRUE)
      if (length(vids) > 0) {
        videoFiles(data.frame(Filename = basename(vids), FullPath = vids, stringsAsFactors = FALSE))
      } else {
        videoFiles(NULL)
      }
    }
  })
  
  output$folderPath <- renderText({
    req(folderPath())
    paste("Selected folder:", folderPath())
  })
  
  output$videoTable <- renderDT({
    req(videoFiles())
    datatable(videoFiles()[, "Filename", drop = FALSE], selection = 'single', rownames = FALSE)
  })
  
  output$videoPlayer <- renderUI({
    vids <- videoFiles()
    req(vids)
    selected <- input$videoTable_rows_selected
    if (length(selected) == 1) {
      filePath <- vids$FullPath[selected]
      tags$video(
        src = normalizePath(filePath, winslash = "/"),
        type = "video/mp4",
        controls = NA,
        width = "100%",
        autoplay = NA
      )
    } else {
      h4("Select a video to view")
    }
  })
}

shinyApp(ui, server)
