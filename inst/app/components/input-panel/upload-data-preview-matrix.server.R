output$upload_data_preview_matrix <- renderUI({
  tagList(
    textOutput("upload_data_preview_description"),
    tags$hr(),
    uiOutput("seurat_object_summary_pie_wrapper"),
    reactableOutput("seurat_object_summary_table")
  )
})

output$upload_raw_data_file_input <- renderUI({
  if (global_data$show_upload_raw_file_input) {
    tagList(
      fileInput(
        inputId = "upload_matrix_file",
        label = "Gene expression matrix in mtx format"
      ),
      fileInput(
        inputId = "upload_feature_file",
        label = "Gene names in tsv format"
      ),
      fileInput(
        inputId = "upload_cell_file",
        label = "Cell names in tsv format"
      ),
      fileInput(
        inputId = "upload_cell_type_file",
        label = "Cell type annotation in txt format"
      )
    )
  } else {
    tagList(
      tags$p("I already know how to use it. Reset and upload my own data for analysis."),
      actionBttn(
        inputId = "reset_upload_raw_data_file_input",
        label = "Reset",
        color = "primary",
        icon = icon("plus"),
        size = "sm",
        style = "fill",
        block = "TRUE"
      )
    )
  }
})

observeEvent(input$reset_upload_raw_data_file_input, {
  global_data$show_upload_raw_file_input <- TRUE
})

observeEvent(input$loading_sample_data, {
  closeAlert(id = "upload_file_alert")

  progressSweetAlert(
    session = session,
    id = "loading-demo",
    title = "Loading MTX file",
    display_pct = TRUE,
    value = 10,
  )
  global_data$upload_matrix_file <- readMM("./db/count_example.mtx")

  updateProgressBar(
    session = session,
    id = "loading-demo",
    title = "Loading features file",
    value = 50
  )
  global_data$upload_feature_file <- fread(
    "./db/features_example.tsv",
    header = FALSE
  )[[1]]

  updateProgressBar(
    session = session,
    id = "loading-demo",
    title = "Loading cell file",
    value = 60
  )
  global_data$upload_cell_file <- fread(
    "./db/cell_example.tsv",
    header = FALSE
  )[[1]]

  updateProgressBar(
    session = session,
    id = "loading-demo",
    title = "Loading cell type file",
    value = 90
  )
  global_data$upload_cell_type_file <- fread(
    "./db/cell_type_example.txt",
    fill = TRUE,
    header = FALSE
  )[[1]]

  updateProgressBar(
    session = session,
    id = "loading-demo",
    title = "Loading finished",
    value = 100
  )
  global_data$show_upload_raw_file_input <- FALSE

  closeSweetAlert(session = session)
  show_alert(
    session = session,
    title = "Done",
    text = "Loading demo dataset complete.",
    type = "success"
  )
})

output$upload_data_preview_description <- renderText({
  if (is.null(global_data$scRNA)) {
    return("When all data are  submitted, you will get summary information below.")
  } else {
    return("The summary information for your dataset is as follows:")
  }
})

observeEvent(input$upload_matrix_file, {
  closeAlert(id = "upload_file_alert")

  file <- input$upload_matrix_file
  ext <- tools::file_ext(file$datapath)

  req(file)

  if (ext != "mtx") {
    createAlert(
      id = "upload_file_alert",
      options = list(
        closable = TRUE,
        width = 12,
        elevations = 4,
        status = "danger",
        content = "Matrix should be a mtx file."
      )
    )
  }
  validate(
    need(ext == "mtx", "Please upload a mtx file.")
  )

  progressSweetAlert(
    session = session,
    id = "reading-matrix-file",
    title = "Reading MTX file",
    display_pct = TRUE,
    value = 10,
  )
  global_data$upload_matrix_file <- readMM(file$datapath)
  updateProgressBar(
    session = session,
    id = "reading-matrix-file",
    value = 100
  )

  closeSweetAlert(session = session)
})

output$download_demo_dataset <- downloadHandler(
  filename = "Demo.zip",
  content = function(file) {
    file.copy("www/demo.zip", file)
  }
)
