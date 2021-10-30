output$upload_data_preview_matrix <- renderUI({
  tagList(
    tags$br(),
    textOutput("upload_data_preview_matrix_description"),
    tags$hr(),
    callout(
      title = "Structure Preview",
      width = 12,
      status = "info",
      withSpinner(verbatimTextOutput("upload_data_preview_matrix_structure"))
    )
  )
})

output$upload_data_preview_matrix_description <- renderText({
  if (is.null(global_data$upload_matrix_file)) {
    return("Please upload your matrix file first. A matrix file has the following structure:")
  } else {
    return("Your matrix file has the following structure:")
  }
})

output$upload_data_preview_matrix_structure <- renderText({
  return(global_data$matrix_preview)
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

  out <- capture.output(
    str(global_data$upload_matrix_file)
  )
  out_with_newline <- paste(out, collapse = "\n")
  global_data$matrix_preview <- out_with_newline
  closeSweetAlert(session = session)
})
