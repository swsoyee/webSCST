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
    all_col <- colnames(global_data$gsva_stRNA@meta.data)
    not_choices <- c(
      "orig.ident",
      "nCount_RNA",
      "nFeature_RNA",
      "nCount_SCT",
      "nFeature_SCT",
      "SCT_snn_res.0.8",
      "seurat_clusters",
      "SCT_snn_res.0.3",
      "SCT_snn_res.0.5"
    )

    choices <- all_col[!(all_col %in% not_choices)]
    pickerInput(
      inputId = "selected_cell_type_gsva",
      label = "Name of Cell Type",
      choices = choices
    )
  }
})

observeEvent(input$run_gsva, {
  if (!is.null(global_data$marker) && !is.null(global_data$stRNA)) {
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

    tryCatch(
      {
        es.matrix <- gsva(
          expr,
          top20.list,
          kcdf = "Poisson",
          method = "ssgsea",
          abs.ranking = T,
          parallel.sz = 3
        )

        es.matrix <- as.data.frame(t(es.matrix))
        stRNA <- AddMetaData(stRNA, es.matrix)

        global_data$gsva_stRNA <- stRNA
        global_data$gsva_done <- TRUE

        closeSweetAlert(session = session)
      },
      error = function(cond) {
        show_alert(
          session = session,
          title = "Error",
          text = cond,
          type = "error"
        )
      }
    )
  }
})

observeEvent(input$selected_cell_type_gsva, {
  output$selected_cell_type_gsva_featureplot <- renderPlot({
    stRNA <- global_data$gsva_stRNA

    FeaturePlot(stRNA, features = input$selected_cell_type_gsva)
  })
})
