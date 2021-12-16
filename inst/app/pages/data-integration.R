fluidPage(
  fluidRow(
    box(
      title = "Species and Organ",
      solidHeader = TRUE,
      status = "primary",
      label = boxLabel(
        "Step 1",
        status = "white"
      ),
      width = 12,
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
  ),
  fluidRow(
    tabBox(
      id = "select-dataset-and-markders",
      width = 12,
      solidHeader = TRUE,
      status = "primary",
      title = tagList(
        "Dataset and Markers"
      ),
      label = boxLabel(
        "Step 2",
        status = "white"
      ),
      side = "right",
      type = "tabs",
      tabPanel(
        title = "Upload",
        value = "upload",
        fluidRow(
          column(
            width = 6,
            fileInput(
              inputId = "upload_seurat_object_file",
              label = "Dataset (rds)",
            )
          ),
          column(
            width = 6,
            fileInput(
              inputId = "upload_markers_file",
              label = "Markers (rds)",
            )
          ),
          actionBttn(
            inputId = "submit_rds_file",
            label = "Submit",
            color = "primary",
            icon = icon("play"),
            size = "sm",
            style = "fill",
            block = TRUE
          )
        )
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
