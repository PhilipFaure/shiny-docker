# video_utils.R

video_viewer <- function(src, width = "100%", height = "auto", id = NULL) {
  if (!requireNamespace("digest", quietly = TRUE)) {
    stop("Package 'digest' is required. Please install it with install.packages('digest').")
  }
  
  id <- id %||% paste0("video_", digest::digest(src))
  
  htmltools::tags$div(
    id = paste0(id, "_container"),
    style = paste0("width:", width, "; height:", height, ";"),
    htmltools::tags$video(
      id = id,
      src = src,
      type = "video/mp4",
      controls = NA,
      style = "width:100%; height:auto;"
    ),
    htmltools::tags$div(
      style = "margin-top: 5px;",
      htmltools::tags$button("Play", onclick = sprintf("document.getElementById('%s').play()", id)),
      htmltools::tags$button("Pause", onclick = sprintf("document.getElementById('%s').pause()", id)),
      htmltools::tags$button("Skip +10s", onclick = sprintf("document.getElementById('%s').currentTime += 10", id)),
      htmltools::tags$button("Back -10s", onclick = sprintf("document.getElementById('%s').currentTime -= 10", id))
    )
  )
}

# Safe null fallback
`%||%` <- function(x, y) if (!is.null(x)) x else y
