output$run_gsva <- renderUI({
  if (!is.null(global_data$marker)) {
    actionBttn(
      inputId = "run_gsva",
      label = "Run ssGSEA",
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

output$cell_type_selector_gsva <- renderUI({
  if (!is.null(global_data$marker) && global_data$gsva_done) {
    pickerInput(
      inputId = "selected_cell_type_gsva",
      label = "Name of Cell Type",
      choices = unique(as.character(global_data$marker$cluster))
    )
  }
})

observeEvent(input$run_gsva, {
  if (!is.null(global_data$marker)) {
    stRNA <- global_data$stRNA
    sc.marker <- global_data$marker

    progressSweetAlert(
      session = session,
      id = "run-gsva",
      title = "Estimating ssGSEA scores...",
      display_pct = TRUE,
      value = 10,
    )

    all.markers <- sc.marker %>%
      select(gene, everything()) %>%
      subset(p_val_adj < 0.05)

    top20 <- all.markers %>%
      group_by(cluster) %>%
      top_n(
        n = 20,
        wt = avg_log2FC
      )

    top20.list <- data.frame(
      term = top20$cluster,
      gene = top20$gene
    )

    top20.list <- top20.list %>%
      split(.$term) %>%
      lapply("[[", 2)

    expr <- as.matrix(stRNA@assays$RNA@counts)

    es.matrix <- gsva(
      expr,
      top20.list,
      kcdf = "Poisson",
      method = "ssgsea",
      abs.ranking = T, 
      parallel.sz = 3
    )

    es.matrix <- as.data.frame(t(es.matrix))
    stRNA <- AddMetaData(stRNA, es.matrix) # TODO Warning: Invalid name supplied, making object name syntactically valid.

    global_data$gsva_stRNA <- stRNA
    global_data$gsva_done <- TRUE

    updateProgressBar(
      session = session,
      id = "run-gsva",
      title = "Estimating finished.",
      value = 100
    )
    Sys.sleep(1)
    closeSweetAlert(session = session)
  }
})

observeEvent(input$cell_type_selector_gsva, {
  output$selected_cell_type_gsva_featureplot <- renderPlot({
    stRNA <- global_data$gsva_stRNA

    FeaturePlot(stRNA, features = input$selected_cell_type_gsva)
  })
})
