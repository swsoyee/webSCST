fluidPage(
  fluidRow(
    box(
      width = 12,
      id = "violin_plot_and_feature_scatter",
      solidHeader = TRUE,
      status = "primary",
      label = boxLabel(
        "Step 1",
        status = "white"
      ),
      maximizable = TRUE,
      title = tagList(
        "1. Violin Plot and Feature Scatter"
      ),
      fluidRow(
        column(
          width = 3,
          numericInputIcon(
            inputId = "quality_control_min_gene",
            label = "Minimum Gene",
            value = 500,
            step = 1
          )
        ),
        column(
          width = 3,
          numericInputIcon(
            inputId = "quality_control_max_gene",
            label = "Maximum Gene",
            value = 4000,
            step = 1
          )
        ),
        column(
          width = 3,
          numericInputIcon(
            inputId = "quality_control_pctmt",
            label = "Percent MT",
            value = 15,
            step = 1
          )
        ),
        column(
          width = 3,
          tags$br(),
          actionBttn(
            inputId = "apply_quality_control_filter",
            label = "Apply Filter",
            color = "primary",
            icon = icon("play"),
            size = "sm",
            style = "fill",
            block = TRUE
          )
        )
      ),
      textOutput("quality_control_plot_description"),
      fluidRow(
        downloadBttn(
          outputId = "download_quality_control_violin_plot_png",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_quality_control_violin_plot_pdf",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      withSpinner(plotOutput("quality_control_violin_plot")),
      fluidRow(
        downloadBttn(
          outputId = "download_quality_control_feature_scatter_plot_png",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_quality_control_feature_scatter_plot_pdf",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      withSpinner(plotOutput("quality_control_feature_scatter")),
      actionBttn(
        inputId = "go_to_quality_control_normalization",
        label = "Go to Normalization",
        color = "primary",
        icon = icon("play"),
        size = "sm",
        style = "fill",
        block = TRUE
      )
    )
  ),
  fluidRow(
    box(
      id = "normailization_and_scaling",
      width = 12,
      label = boxLabel(
        "Step 2",
        status = "white"
      ),
      solidHeader = TRUE,
      collapsed = TRUE,
      maximizable = TRUE,
      status = "primary",
      title = tagList(
        "2. Normailization and Scaling"
      ),
      fluidRow(
        column(
          width = 3,
          numericInputIcon(
            inputId = "normalize_scale_factor",
            label = "Normalize Scale Factor",
            value = 10000,
            step = 1
          )
        ),
        column(
          width = 3,
          numericInputIcon(
            inputId = "features_count",
            label = "Feature Count",
            value = 2000,
            step = 1
          )
        ),
        column(
          width = 3,
          numericInputIcon(
            inputId = "top_gene_count",
            label = "Top Variables Genes",
            value = 10,
            step = 1
          )
        ),
        column(
          width = 3,
          tags$br(),
          actionBttn(
            inputId = "apply_quality_control_normalize",
            label = "Apply Normalization",
            color = "primary",
            icon = icon("play"),
            size = "sm",
            style = "fill",
            block = TRUE
          )
        )
      ),
      uiOutput("normalization_plot_wrapper"),
      uiOutput("go_to_quality_control_clustering")
    )
  ),
  fluidRow(
    column(
      width = 12,
      uiOutput("clustering_box"),
      style = "padding:0px;"
    )
  ),
  fluidRow(
    box(
      width = 12,
      solidHeader = TRUE,
      status = "primary",
      label = boxLabel(
        "Step 4",
        status = "white"
      ),
      title = tagList(
        "Export Data"
      ),
      fluidRow(
        column(
          width = 6,
          downloadBttn(
            outputId = "save_object_as_rds",
            label = "Save Clean Dataset",
            color = "primary",
            size = "sm",
            style = "fill",
            block = TRUE
          )
        ),
        column(
          width = 6,
          downloadBttn(
            outputId = "find_marker_and_save",
            label = "Find Markers and Save",
            color = "primary",
            size = "sm",
            style = "fill",
            block = TRUE
          )
        )
      )
    )
  )
)
