fluidPage(
  fluidRow(
    box(
      width = 4,
      solidHeader = TRUE,
      status = "primary",
      collapsible = FALSE,
      div(id = "upload_file_alert"),
      title = tagList(
        "File Upload"
      ),
      actionBttn(
        inputId = "loading_sample_data",
        label = "Load Demo",
        color = "primary",
        icon = icon("play"),
        size = "sm",
        style = "fill",
        block = "TRUE"
      ),
      fileInput(
        inputId = "upload_matrix_file",
        label = "Matrix (mtx)",
      ),
      tags$hr(),
      fileInput(
        inputId = "upload_feature_file",
        label = "Feature"
      ),
      fileInput(
        inputId = "upload_cell_file",
        label = "Cell"
      ),
      fileInput(
        inputId = "upload_cell_type_file",
        label = "Cell Type"
      ),
      uiOutput("create_seurat_object_submit_button")
    ),
    box(
      width = 8,
      solidHeader = TRUE,
      status = "primary",
      collapsible = FALSE,
      title = tagList(
        "Matrix Preview"
      ),
      id = "upload-data-preview",
      tabPanel(
        title = "Matrix",
        uiOutput("upload_data_preview_matrix")
      )
    )
  )
)
