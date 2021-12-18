fluidPage(
  fluidRow(
    tabBox(
      id = "select-dataset-and-markders",
      width = 12,
      solidHeader = TRUE,
      status = "primary",
      title = tagList(
        "Load Clean Single-cell Data"
      ),
      label = boxLabel(
        "Step 1",
        status = "white"
      ),
      side = "right",
      type = "tabs",
      tabPanel(
        title = "Upload",
        value = "upload",
        tags$p("Don't know how to get started? You can load our demo to experience it first."),
        actionBttn(
          inputId = "load_clean_sc_data_demo",
          label = "Load Demo",
          color = "primary",
          icon = icon("play"),
          size = "sm",
          style = "fill",
          block = TRUE
        ),
        tags$hr(),
        uiOutput("sc_data_file_input"),
      ),
      tabPanel(
        title = "Load QC Result",
        value = "load-qc-result",
        uiOutput("load_qc_result")
      )
    )
  ),
  fluidRow(
    tabBox(
      id = "choose-species-and-organ",
      title = tagList(
        "Match Spatial Data"
      ),
      solidHeader = TRUE,
      status = "primary",
      side = "right",
      type = "tabs",
      label = boxLabel(
        "Step 2",
        status = "white"
      ),
      width = 12,
      tabPanel(
        title = "Match Spatial Dataset Automatically",
        value = "match-spatial-dataset-automatically",
        actionBttn(
          inputId = "load_spatial_dataset_demo",
          label = "Load Demo",
          color = "primary",
          icon = icon("play"),
          size = "sm",
          style = "fill",
          block = TRUE
        ),
        tags$hr(),
        uiOutput("species_and_organ_file_input")
      ),
      tabPanel(
        title = "Match Spatial Dataset Manually",
        value = "match-spatial-dataset-menually",
        reactableOutput("species_and_organ_selector_table"),
        tags$hr(),
        actionBttn(
          inputId = "sample_selection",
          label = "Load Data",
          color = "primary",
          icon = icon("play"),
          size = "sm",
          style = "fill",
          block = TRUE
        )
      )
    )
  ),
  fluidRow(
    tabBox(
      id = "data-integration-method-and-result",
      width = 12,
      title = tagList(
        "Integration"
      ),
      label = boxLabel(
        "Step 3",
        status = "white"
      ),
      side = "right",
      solidHeader = TRUE,
      collapsed = FALSE, # TODO default set to TRUE
      maximizable = TRUE,
      status = "primary",
      type = "tabs",
      tabPanel(
        title = "AddModuleScore",
        tabsetPanel(
          tabPanel(
            title = "Spatial Location of Single-cell Data",
            uiOutput("cell_type_selector_strna"),
            fluidRow(
              column(
                width = 6,
                plotOutput("selected_cell_type_strna_violin")
              ),
              column(
                width = 6,
                plotOutput("selected_cell_type_strna_featureplot")
              )
            )
          ),
          tabPanel(
            title = "Distribution of spatial cell populations in single cells",
            uiOutput("cell_type_selector_scrna"),
            fluidRow(
              column(
                width = 6,
                plotOutput("selected_cell_type_scrna_violin")
              ),
              column(
                width = 6,
                plotOutput("selected_cell_type_scrna_featureplot")
              )
            )
          )
        ),
      ),
      tabPanel(
        title = "Multimodal intersection analysis (MIA)",
        uiOutput("run_mia"),
        tags$hr(),
        plotOutput("mia_heatmap"),
        plotOutput("mia_dimplot")
      ),
      tabPanel(
        title = "ssGSEA",
        uiOutput("run_gsva"),
        uiOutput("cell_type_selector_gsva"),
        plotOutput("selected_cell_type_gsva_featureplot")
      )
    )
  )
)
