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
        ". Users could upload their raw single-cell RNA-seq data, after processing and automatically matching with the spatial transcriptome datasets we manually collected, finally got the predicted spatial information for each cell type.",
        tags$br(),
        tags$br(),
        tags$h2("How does webSCST work?"),
        tags$li("Step 1. Users first upload their raw single-cell RNA-seq data, webSCST could interactively process the dataset."),
        tags$li("Step 2. Processed single-cell data could be automatically matched with the spatial transcriptome data we manually curated according to the organ and species. Users may also choose any spatial transcriptome datasets for integration they like collected in the database by ID. Currently, we have manually curated 43 spatial transcriptome datasets (136 sub-datasets), which will be constantly added according to the increasing of publicly available spatial transcriptome datasets."),
        tags$li("Step 3. Currently, four popular integration methods have been included in webSCST. Users could interactively select any method and download the integration results they are interested in."),
        tags$br(),
        tags$h2("Cite webSCST"),
        "Zilong Zhang, Feifei Cui, Wei Su, Chen Cao, Quan Zou*. webSCST: an interactive web application for single-cell RNA-seq data and spatial transcriptome data integration.",
        tags$br(),
        tags$br(),
        tags$h2("Contact"),
        "For questions and suggestions, please contact:",
        tags$br(),
        "System Designer:", tags$b("Zilong Zhang"), "(zhangzilong@bi.a.u-tokyo.ac.jp) or ", tags$b("Quan Zou"), " (quanzou@nclab.net)",
        tags$br(),
        "Appliction Developer: ", tags$b("Wei Su"), " (suwei@bi.a.u-tokyo.ac.jp)"
      )
    )
  )
)
