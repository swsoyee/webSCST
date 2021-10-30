output$upload_data_preview_feature <- renderUI({
  tagList(
    tags$br(),
    textOutput("upload_data_preview_feature_description"),
    tags$hr(),
    withSpinner(uiOutput("upload_data_preview_feature_table"))
  )
})

output$upload_data_preview_feature_description <- renderText({
  if (is.null(global_data$upload_feature_file)) {
    return("Please upload your feature file first.")
  } else {
    return("Loading feature file successed.")
  }
})

output$upload_data_preview_feature_table <- renderUI({
  if (!is.null(global_data$upload_feature_file)) {
    reactable(
      global_data$upload_feature_file
    )
  }
})

observeEvent(input$upload_feature_file, {
  closeAlert(id = "upload_file_alert")

  file <- input$upload_feature_file
  ext <- tools::file_ext(file$datapath)

  req(file)

  if (!(ext %in% c("csv", "tsv"))) {
    createAlert(
      id = "upload_file_alert",
      options = list(
        closable = TRUE,
        width = 12,
        elevations = 4,
        status = "danger",
        content = "Feature should be a csv/tsv file."
      )
    )
  }

  validate(
    need(ext %in% c("csv", "tsv"), "Please upload a csv/tsv file.")
  )

  progressSweetAlert(
    session = session,
    id = "reading-feature-file",
    title = "Reading feature file",
    display_pct = TRUE,
    value = 10,
  )
  global_data$upload_feature_file <- fread(file$datapath)
  updateProgressBar(
    session = session,
    id = "reading-feature-file",
    value = 100
  )

  closeSweetAlert(session = session)
})
