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
source("video_utils.R")  

ui <- fluidPage(
  titlePanel("Video Viewer App"),
  sidebarLayout(
    sidebarPanel(
      shinyDirButton("folder", "Choose Folder", "Select folder with videos"),
      verbatimTextOutput("folderPath"),
      DTOutput("videoTable")
    ),
    mainPanel(
      uiOutput("videoPlayer")
    )
  )
)

server <- function(input, output, session) {
  volumes <- c(Videos = "/videos")
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
      rel_path <- vids$FullPath[selected]
      rel_url <- file.path("videos", basename(rel_path))  # expects video to be symlinked/mounted in www/videos/
      video_viewer(rel_url)
    } else {
      h4("Select a video to view")
    }
  })
}

shinyApp(ui, server)

