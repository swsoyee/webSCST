output$submit_clean_sc_data <- renderUI({
  if (!is.null(input$upload_seurat_object_file$datapath) && !is.null(input$upload_markers_file$datapath)) {
    actionBttn(
      inputId = "submit_rds_file",
      label = "Submit",
      color = "primary",
      icon = icon("play"),
      size = "sm",
      style = "fill",
      block = TRUE
    )
  }
})

observeEvent(input$submit_rds_file, {
  if (!is.null(input$upload_seurat_object_file$datapath) && !is.null(input$upload_markers_file$datapath)) {
    progressSweetAlert(
      session = session,
      id = "loading-rds",
      title = "Loading dataset...",
      display_pct = TRUE,
      value = 10,
    )
    global_data$scRNA_filter_1 <- readRDS(input$upload_seurat_object_file$datapath)

    updateProgressBar(
      session = session,
      id = "loading-rds",
      title = "Loading markers",
      value = 50
    )
    global_data$marker <- readRDS(input$upload_markers_file$datapath)

    updateProgressBar(
      session = session,
      id = "loading-rds",
      title = "Loading finished.",
      value = 100
    )

    closeSweetAlert(session = session)
    show_alert(
      session = session,
      title = "Done",
      text = "Loading dataset finished.",
      type = "success"
    )
  } else {
    show_alert(
      session = session,
      title = "Error",
      text = "Please upload your dataset file first.",
      type = "error"
    )
  }
})

output$load_qc_result <- renderUI({
  if (global_data$quality_control_process_done && global_data$normalized_done) {
    actionBttn(
      inputId = "load_qc_result",
      label = "Load QC Result",
      color = "primary",
      icon = icon("play"),
      size = "sm",
      style = "fill",
      block = TRUE
    )
  } else {
    tagList(
      tags$p("It is not detected that you have completed the Quality Control (QC) steps. You can choose to upload the raw data in File Upload tab for QC or simply upload your dataset which is already quality controlled."),
      fluidRow(
        column(
          width = 4,
          actionBttn(
            inputId = "go_to_raw_file_upload_tab",
            label = "Upload Raw Data",
            color = "primary",
            icon = icon("play"),
            size = "sm",
            style = "fill",
            block = TRUE
          )
        ),
        column(
          width = 4,
          actionBttn(
            inputId = "go_to_qc_tab",
            label = "Finish QC Step",
            color = "primary",
            icon = icon("play"),
            size = "sm",
            style = "fill",
            block = TRUE
          )
        ),
        column(
          width = 4,
          actionBttn(
            inputId = "go_to_file_upload_tab",
            label = "Upload Quality-Controlled Data",
            color = "primary",
            icon = icon("play"),
            size = "sm",
            style = "fill",
            block = TRUE
          )
        )
      )
    )
  }
})

observeEvent(input$go_to_file_upload_tab, {
  updateTabsetPanel(
    session,
    "select-dataset-and-markders",
    selected = "upload"
  )
})

observeEvent(input$go_to_raw_file_upload_tab, {
  updateTabItems(
    session,
    "main_sidebar",
    selected = "file-upload"
  )
})

observeEvent(input$go_to_qc_tab, {
  updateTabItems(
    session,
    "main_sidebar",
    selected = "quality_control"
  )
})

observeEvent(input$load_qc_result, {
  progressSweetAlert(
    session = session,
    id = "loading-data-integration",
    title = "Loading dataset...",
    display_pct = TRUE,
    value = 10,
  )

  if (is.null(global_data$marker)) {
    updateProgressBar(
      session = session,
      id = "loading-data-integration",
      title = "Finding markers...",
      value = 50
    )

    scRNA <- global_data$scRNA_filter_1
    Idents(scRNA) <- scRNA$cell_type
    sc.marker <- FindAllMarkers(scRNA, only.pos = TRUE, min.pct = 0.25)
    global_data$marker <- sc.marker
  }

  updateProgressBar(
    session = session,
    id = "loading-data-integration",
    title = "Loading finished.",
    value = 100
  )

  Sys.sleep(1)
  closeSweetAlert(session = session)
})

observeEvent(input$load_clean_sc_data_demo, {
  progressSweetAlert(
    session = session,
    id = "loading-rds",
    title = "Loading dataset...",
    display_pct = TRUE,
    value = 10,
  )
  global_data$scRNA_filter_1 <- readRDS("./db/scRNA_demo.rds")

  updateProgressBar(
    session = session,
    id = "loading-rds",
    title = "Loading markers",
    value = 50
  )
  global_data$marker <- readRDS("./db/Markers_demo.rds")

  updateProgressBar(
    session = session,
    id = "loading-rds",
    title = "Loading finished.",
    value = 100
  )

  closeSweetAlert(session = session)
  show_alert(
    session = session,
    title = "Done",
    text = "Loading dataset finished.",
    type = "success"
  )
})
