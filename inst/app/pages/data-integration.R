fluidPage(
  fluidRow(
    box(
      width = 12,
      solidHeader = TRUE,
      status = "primary",
      collapsible = FALSE,
      title = tagList(
        "Upload Dataset and Markers"
      ),
      fluidRow(
        column(
          width = 6,
          fileInput(
            inputId = "upload_seurat_object_file",
            label = "Dataset (rds)",
          )
        ),
        column(
          width = 6,
          fileInput(
            inputId = "upload_markers_file",
            label = "Markers (rds)",
          )
        ),
        actionBttn(
          inputId = "submit_rds_file",
          label = "Submit",
          color = "primary",
          icon = icon("play"),
          size = "sm",
          style = "fill",
          block = TRUE
        )
      )
    )
  )
)
