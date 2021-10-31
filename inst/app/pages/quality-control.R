fluidPage(
  box(
    width = 12,
    solidHeader = TRUE,
    status = "primary",
    title = tagList(
      "Violin Plot and Feature Scatter"
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
          label = "Submit",
          color = "primary",
          icon = icon("play"),
          size = "sm",
          style = "fill",
          block = TRUE
        )
      )
    ),
    textOutput("quality_control_plot_description"),
    withSpinner(plotOutput("quality_control_violin_plot")),
    withSpinner(plotOutput("quality_control_feature_scatter"))
  )
)
