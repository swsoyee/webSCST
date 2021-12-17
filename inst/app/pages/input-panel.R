fluidPage(
  fluidRow(
    box(
      width = 4,
      solidHeader = TRUE,
      status = "primary",
      collapsible = FALSE,
      div(id = "upload_file_alert"),
      title = tagList(
        "Single-cell Sequencing Data Upload"
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
      tags$hr(),
      fileInput(
        inputId = "upload_matrix_file",
        label = "Gene expression matrix in mtx format",
      ),
      fileInput(
        inputId = "upload_feature_file",
        label = "Gene names in tsv format"
      ),
      fileInput(
        inputId = "upload_cell_file",
        label = "Cell names in tsv format"
      ),
      fileInput(
        inputId = "upload_cell_type_file",
        label = "Cell type annotation in txt format"
      ),
      uiOutput("create_seurat_object_submit_button")
    ),
    box(
      width = 8,
      solidHeader = TRUE,
      status = "primary",
      collapsible = FALSE,
      title = tagList(
        "Data Preview"
      ),
      id = "upload-data-preview",
      tabPanel(
        title = "Matrix",
        uiOutput("upload_data_preview_matrix")
      )
    )
  )
)
