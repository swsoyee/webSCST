fluidPage(
  fluidRow(
    box(
      width = 12,
      solidHeader = TRUE,
      collapsible = FALSE,
      status = "primary",
      title = tagList(
        "Welcome!"
      ),
      tagList(
        tags$img(
          src = "./home_fig.svg",
          style = "width:100%;"
        ),
        tags$h1("What is WebSCST?"),
        tags$hr(),
        "WebSCST is the first web service for single-cell RNA-seq data and spatial transcriptome integration. The user-friendly interactive interface provides three main functions:",
        actionLink(
          inputId = "sc_data_uploading_and_processing",
          label = "single-cell data uploading and processing",
          icon = icon("upload")
        ),
        ",",
        actionLink(
          inputId = "spatial_transcriptome_database",
          label = "spatial transcriptome database",
          icon = icon("database")
        ),
        "and",
        actionLink(
          inputId = "go_to_integration_tab",
          label = "integration",
          icon = icon("object-group")
        ),
        "."
      )
    )
  )
)
