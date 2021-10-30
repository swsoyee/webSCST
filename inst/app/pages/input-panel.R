fluidPage(
  fluidRow(
    column(
      width = 4,
      box(
        width = 12,
        solidHeader = TRUE,
        status = "primary",
        collapsible = FALSE,
        div(id = "upload_file_alert"),
        title = tagList(
          "File Upload"
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
      )
    ),
    column(
      width = 8,
      box(
        width = 12,
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
)
