output$create_seurat_object_submit_button <- renderUI({
  if (
    !is.null(global_data$upload_matrix_file) &&
      !is.null(global_data$upload_feature_file) &&
      !is.null(global_data$upload_cell_file) &&
      !is.null(global_data$upload_cell_type_file)
  ) {
    actionBttn(
      inputId = "create_seurat_object",
      label = "Submit",
      color = "primary",
      icon = icon("check-circle"),
      size = "sm",
      style = "fill",
      block = "TRUE"
    )
  }
})

observeEvent(input$create_seurat_object, {
  progressSweetAlert(
    session = session,
    id = "create-seurat-object",
    title = "Handle count matrix",
    display_pct = TRUE,
    value = 15,
  )
  counts <- global_data$upload_matrix_file
  rownames(counts) <- global_data$upload_feature_file
  colnames(counts) <- global_data$upload_cell_file
  scRNA.counts <- as.data.frame(counts)

  updateProgressBar(
    session = session,
    id = "create-seurat-object",
    title = "Create dataset",
    value = 30
  )
  scRNA <- CreateSeuratObject(scRNA.counts)
  scRNA@meta.data$cell_type <- global_data$upload_cell_type_file
  global_data$scRNA <- scRNA

  updateProgressBar(
    session = session,
    id = "create-seurat-object",
    title = "Finish building dataset",
    value = 100
  )

  output$seurat_object_summary_table <- renderReactable({
    reactable(
      data.frame(
        "Indicator" = c(
          "Gene",
          "Cell",
          "Cell Type"
        ),
        "Count" = c(
          nrow(scRNA),
          ncol(scRNA),
          length(table(scRNA$cell_type))
        )
      )
    )
  })

  show_alert(
    session = session,
    title = "Submit finished",
    text = "Go to Quality Control tab to proceed data.",
    type = "success"
  )
})

output$seurat_object_summary_pie <- renderPlot({
  if (!is.null(global_data$scRNA)) {
    scRNA <- global_data$scRNA
    cell_type <- as.data.frame(table(scRNA$cell_type))

    colnames(cell_type) <- c("cell_types", "freq")
    pie <- ggplot(
      cell_type,
      aes(x = "", y = freq, fill = factor(cell_types))
    ) +
      geom_bar(
        width = 1,
        stat = "identity"
      ) +
      theme(
        axis.line = element_blank(),
        plot.title = element_text(hjust = 0.5)
      ) +
      labs(
        fill = "cell_types",
        x = NULL,
        y = NULL,
        title = "Pie Chart of cell types"
      )

    p <- pie + coord_polar(theta = "y", start = 0)
    seurat_object_summary_pie_chart$plot <- p

    p
  }
})

seurat_object_summary_pie_chart <- reactiveValues()

output$download_data_preview_pie_png <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-data-summary-pie.png"),
  content = function(file) {
    ggsave(file, plot = seurat_object_summary_pie_chart$plot)
  }
)

output$download_data_preview_pie_pdf <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-data-summary-pie.pdf"),
  content = function(file) {
    ggsave(file, plot = seurat_object_summary_pie_chart$plot, device = "pdf")
  }
)

output$seurat_object_summary_pie_wrapper <- renderUI({
  if (!is.null(global_data$scRNA)) {
    tagList(
      fluidRow(
        downloadBttn(
          outputId = "download_data_preview_pie_png",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_data_preview_pie_pdf",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      plotOutput("seurat_object_summary_pie")
    )
  } else {
    plotOutput("seurat_object_summary_pie", height = "1px")
  }
})

observeEvent(input$upload_feature_file, {
  closeAlert(id = "upload_file_alert")

  file <- input$upload_feature_file
  ext <- tools::file_ext(file$datapath)

  req(file)

  if (!(ext %in% c("csv", "tsv", "txt"))) {
    createAlert(
      id = "upload_file_alert",
      options = list(
        closable = TRUE,
        width = 12,
        elevations = 4,
        status = "danger",
        content = "The Feature file must be in text format with a separate line for each ID."
      )
    )
  }

  validate(
    need(ext %in% c("csv", "tsv", "txt"), "The cell file must be in text format with a separate line for each ID.")
  )

  progressSweetAlert(
    session = session,
    id = "reading-feature-file",
    title = "Reading feature file",
    display_pct = TRUE,
    value = 10,
  )
  global_data$upload_feature_file <- fread(
    file$datapath,
    header = FALSE
  )[[1]]
  updateProgressBar(
    session = session,
    id = "reading-feature-file",
    value = 100
  )

  Sys.sleep(1)
  closeSweetAlert(session = session)
})

observeEvent(input$upload_cell_file, {
  closeAlert(id = "upload_file_alert")

  file <- input$upload_cell_file
  ext <- tools::file_ext(file$datapath)

  req(file)

  if (!(ext %in% c("csv", "tsv", "txt"))) {
    createAlert(
      id = "upload_file_alert",
      options = list(
        closable = TRUE,
        width = 12,
        elevations = 4,
        status = "danger",
        content = "The cell file must be in text format with a separate line for each ID."
      )
    )
  }

  validate(
    need(ext %in% c("csv", "tsv", "txt"), "The cell file must be in text format with a separate line for each ID.")
  )

  progressSweetAlert(
    session = session,
    id = "reading-cell-file",
    title = "Reading cell file",
    display_pct = TRUE,
    value = 10,
  )
  global_data$upload_cell_file <- fread(
    file$datapath,
    header = FALSE
  )[[1]]
  updateProgressBar(
    session = session,
    id = "reading-cell-file",
    value = 100
  )

  Sys.sleep(1)
  closeSweetAlert(session = session)
})

observeEvent(input$upload_cell_type_file, {
  closeAlert(id = "upload_file_alert")

  file <- input$upload_cell_type_file
  ext <- tools::file_ext(file$datapath)

  req(file)

  if (!(ext %in% c("csv", "tsv", "txt"))) {
    createAlert(
      id = "upload_file_alert",
      options = list(
        closable = TRUE,
        width = 12,
        elevations = 4,
        status = "danger",
        content = "The cell type ile must be in text format with a separate line for each ID."
      )
    )
  }

  validate(
    need(ext %in% c("csv", "tsv", "txt"), "The cell type file must be in text format with a separate line for each ID.")
  )

  progressSweetAlert(
    session = session,
    id = "reading-cell-type-file",
    title = "Reading cell type file",
    display_pct = TRUE,
    value = 10,
  )
  global_data$upload_cell_type_file <- fread(
    file$datapath,
    fill = TRUE,
    header = FALSE
  )[[1]]
  updateProgressBar(
    session = session,
    id = "reading-cell-type-file",
    value = 100
  )

  Sys.sleep(1)
  closeSweetAlert(session = session)
})
