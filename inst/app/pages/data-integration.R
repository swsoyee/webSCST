fluidPage(
  fluidRow(
    tabBox(
      id = "select-dataset-and-markders",
      width = 12,
      solidHeader = TRUE,
      status = "primary",
      title = tagList(
        "1. Load Clean Single-cell Data"
      ),
      label = boxLabel(
        "Step 1",
        status = "white"
      ),
      side = "right",
      type = "tabs",
      tabPanel(
        title = tagList(
          icon("upload"),
          "Upload"
        ),
        value = "upload",
        "Don't know how to get started? You can load our demo to experience it first.",
        tags$br(),
        "The demo here is obtained after the ",
        actionLink(
          inputId = "go_to_qc_from_sc_demo",
          label = "Quality Control",
          icon = icon("clipboard-check")
        ),
        " of the previous steps using the original dataset in ",
        actionLink(
          inputId = "go_to_file_upload_from_sc_demo",
          label = "File Upload",
          icon = icon("upload")
        ),
        " Tab.",
        tags$br(),
        tags$br(),
        actionBttn(
          inputId = "load_clean_sc_data_demo",
          label = "Load Demo",
          color = "success",
          icon = icon("play"),
          size = "sm",
          style = "fill",
          block = TRUE
        ),
        tags$hr(),
        uiOutput("sc_data_file_input"),
      ),
      tabPanel(
        title = tagList(
          icon("history"),
          "Load QC Result"
        ),
        value = "load-qc-result",
        uiOutput("load_qc_result")
      )
    )
  ),
  fluidRow(
    tabBox(
      id = "choose-species-and-organ",
      title = tagList(
        "2. Match Spatial Data"
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
        title = tagList(
          icon("robot"),
          "Match Spatial Dataset Automatically"
        ),
        value = "match-spatial-dataset-automatically",
        tags$p("The DEMO data here is a matched spatail data as an example."),
        actionBttn(
          inputId = "load_spatial_dataset_demo",
          label = "Load Demo",
          color = "success",
          icon = icon("play"),
          size = "sm",
          style = "fill",
          block = TRUE
        ),
        tags$hr(),
        "You could match your own spatial data automatically by choose species and organs or mannually select any replicate you liked in our ",
        actionLink(
          inputId = "go_to_match_spatial_dataset_manually",
          label = "database"
        ),
        ".",
        tags$br(),
        uiOutput("species_and_organ_file_input")
      ),
      tabPanel(
        title = tagList(
          icon("tasks"),
          "Match Spatial Dataset Manually"
        ),
        value = "match-spatial-dataset-manually",
        reactableOutput("species_and_organ_selector_table"),
        tags$hr(),
        actionBttn(
          inputId = "sample_selection",
          label = "Submit",
          color = "primary",
          icon = icon("check-circle"),
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
        "3. Integration"
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
        title = tagList(
          icon("medal"),
          "AddModuleScore"
        ),
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
            ),
            plotOutput("add_module_score_1")
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
            ),
            plotOutput("add_module_score_2")
          )
        ),
      ),
      tabPanel(
        title = tagList(
          icon("compress-arrows-alt"),
          "Multimodal intersection analysis (MIA)"
        ),
        uiOutput("run_mia"),
        tags$hr(),
        plotOutput("mia_heatmap"),
        plotOutput("mia_dimplot")
      ),
      tabPanel(
        title = tagList(
          icon("buromobelexperte"),
          "ssGSEA"
        ),
        uiOutput("run_gsva"),
        uiOutput("cell_type_selector_gsva"),
        plotOutput("selected_cell_type_gsva_featureplot")
      ),
      tabPanel(
        title = tagList(
          icon("expand-arrows-alt"),
          "RCTD"
        ),
        uiOutput("run_rctd"),
        tags$br(),
        uiOutput("download_button_rctd_result")
      )
    )
  )
)
