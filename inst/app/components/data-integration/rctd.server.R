output$run_rctd <- renderUI({
  if (!is.null(global_data$scRNA_filter_1) &&
    !is.null(global_data$stRNA) &&
    !is.null(global_data$position_sub_sub)
  ) {
    actionBttn(
      inputId = "run_rctd",
      label = "Run RCTD",
      color = "primary",
      icon = icon("play"),
      size = "sm",
      style = "fill",
      block = TRUE
    )
  } else {
    tagList(
      tags$br(),
      tags$p("No dataset has been provided.")
    )
  }
})

observeEvent(input$run_rctd, {
  position_sub_sub <- global_data$position_sub_sub
  stRNA <- global_data$stRNA
  scRNA <- global_data$scRNA_filter_1

  progressSweetAlert(
    session = session,
    id = "run-rctd",
    title = "Creating reference...",
    display_pct = TRUE,
    value = 10,
  )
  counts <- as.matrix(scRNA@assays$RNA@counts)
  meta_data <- scRNA@meta.data
  cell_types <- meta_data$cell_type
  names(cell_types) <- rownames(meta_data)
  cell_types <- as.factor(cell_types)
  nUMI <- meta_data$nCount_RNA
  names(nUMI) <- rownames(meta_data)
  reference <- Reference(counts, cell_types, nUMI)

  coords <- position_sub_sub[, 1:2]
  spatialcounts <- as.matrix(stRNA@assays$RNA@counts)
  nUMI <- stRNA@meta.data$nCount_RNA
  names(nUMI) <- rownames(stRNA@meta.data)
  puck <- SpatialRNA(coords, spatialcounts, nUMI)

  updateProgressBar(
    session = session,
    id = "run-rctd",
    title = "Running RCTD...",
    value = 30
  )

  Sys.sleep(1)
  updateProgressBar(
    session = session,
    id = "run-rctd",
    title = "The calculation may take several minutes...",
    value = 35
  )

  myRCTD <- create.RCTD(puck, reference, max_cores = 8)
  myRCTD <- run.RCTD(myRCTD, doublet_mode = "doublet")

  results <- myRCTD@results
  # normalize the cell type proportions to sum to 1.
  norm_weights <- sweep(results$weights, 1, rowSums(data.frame(results$weights)), "/")

  # list of cell type names
  cell_type_names <- myRCTD@cell_type_info$info[[2]]
  spatialRNA <- myRCTD@spatialRNA

  resultsdir <- tempdir(check = TRUE)
  # make the plots
  # Plots the confident weights for each cell type as in full_mode (saved as
  # 'results/cell_type_weights_unthreshold.pdf')
  plot_weights(cell_type_names, spatialRNA, resultsdir, norm_weights)
  # Plots all weights for each cell type as in full_mode. (saved as
  # 'results/cell_type_weights.pdf')
  plot_weights_unthreshold(cell_type_names, spatialRNA, resultsdir, norm_weights)
  # Plots the weights for each cell type as in doublet_mode. (saved as
  # 'results/cell_type_weights_doublets.pdf')
  plot_weights_doublet(
    cell_type_names,
    spatialRNA,
    resultsdir,
    results$weights_doublet,
    results$results_df
  )

  plot_cond_occur(cell_type_names, resultsdir, norm_weights, spatialRNA)

  pdf_files <- dir(resultsdir, pattern = ".pdf", full.names = TRUE)
  output_file_name <- "RCTD_result.pdf"

  pdf_combine(input = pdf_files, output = paste0(resultsdir, "/" , output_file_name))

  closeSweetAlert(session = session)

  output$rctd_result <- downloadHandler(
    filename = function() {
      output_file_name
    },
    content = function(file) {
      file.copy(paste0(resultsdir, "/" , output_file_name), file)
    }
  )

  output$download_button_rctd_result <- renderUI({
    downloadBttn(
      outputId = "rctd_result",
      label = "Download RCTD result",
      color = "primary",
      size = "sm",
      style = "fill",
      block = TRUE
    )
  })

  show_alert(
    session = session,
    title = "Done",
    text = "You could download your result now.",
    type = "success"
  )
})
