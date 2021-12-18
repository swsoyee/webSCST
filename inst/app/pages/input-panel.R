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
      tags$p("Don't know how to get started? You can load our demo to experience it first."),
      fluidRow(
        column(
          width = 6,
          actionBttn(
            inputId = "loading_sample_data",
            label = "Load Demo",
            color = "success",
            icon = icon("play"),
            size = "sm",
            style = "fill",
            block = "TRUE"
          )
        ),
        column(
          width = 6,
          downloadBttn(
            outputId = "download_demo_dataset",
            label = "Download Demo",
            color = "success",
            size = "sm",
            style = "fill",
            block = "TRUE"
          )
        )
      ),
      tags$hr(),
      uiOutput("upload_raw_data_file_input"),
      tags$hr(),
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
