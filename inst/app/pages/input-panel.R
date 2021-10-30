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
        fileInput(
          inputId = "upload_feature_file",
          label = "Feature"
        ),
        fileInput(
          inputId = "upload-cell-file",
          label = "Cell",
          accept = "csv"
        ),
        fileInput(
          inputId = "upload-cell-type-file",
          label = "Cell Type",
          accept = "csv"
        )
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
          "Data Preview"
        ),
        tabsetPanel(
          id = "upload-data-preview",
          tabPanel(
            title = "Matrix",
            uiOutput("upload_data_preview_matrix")
          ),
          tabPanel(
            title = "Feature",
            uiOutput("upload_data_preview_feature")
          )
        )
      )
    )
  )
)
