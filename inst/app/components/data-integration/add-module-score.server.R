output$cell_type_selector_strna <- renderUI({
  if (!is.null(global_data$marker) && !is.null(global_data$stRNA)) {
    pickerInput(
      inputId = "selected_cell_type_strna",
      label = "Name of Cell Type",
      choices = unique(as.character(global_data$marker$cluster))
    )
  } else {
    tagList(
      tags$br(),
      tags$p("No dataset has been provided.")
    )
  }
})

output$cell_type_selector_scrna <- renderUI({
  if (!is.null(global_data$st_marker) && !is.null(global_data$marker)) {
    fluidRow(
      column(
        width = 6,
        pickerInput(
          inputId = "selected_cell_type_scrna",
          label = "Name of Cluster",
          choices = unique(as.character(global_data$st_marker$cluster))
        )
      ),
      column(
        width = 6
      )
    )
  } else {
    tagList(
      tags$br(),
      tags$p("No dataset has been provided.")
    )
  }
})

observeEvent(input$selected_cell_type_strna, {
  if (!is.null(global_data$marker) && !is.null(global_data$stRNA)) {
    sc.marker <- global_data$marker
    stRNA <- global_data$stRNA
    all.markers <- sc.marker %>%
      select(gene, everything()) %>%
      subset(p_val_adj < 0.05)

    top10 <- all.markers %>%
      group_by(cluster) %>%
      top_n(n = 10, wt = avg_log2FC) %>%
      filter(cluster == input$selected_cell_type_strna)

    score_list <- list(gene = top10$gene)

    stRNA <- suppressWarnings( # if there is space in the name, it will convert the space to dot
      AddModuleScore(
        stRNA,
        features = score_list,
        name = input$selected_cell_type_strna
      )
    )

    name <- gsub(" ", ".", input$selected_cell_type_strna)
    feature_name <- paste0(name, "1")

    output$selected_cell_type_strna_violin <- renderPlot({
      ggviolin(
        data = stRNA@meta.data,
        x = "SCT_snn_res.0.8",
        y = feature_name,
        fill = "SCT_snn_res.0.8"
      )
    })

    output$selected_cell_type_strna_featureplot <- renderPlot({
      FeaturePlot(stRNA, features = feature_name) +
        xlab("ST1") +
        ylab("ST2")
    })
  }
})

observeEvent(input$selected_cell_type_scrna, {
  if (!is.null(global_data$st_marker) && !is.null(global_data$scRNA_filter_1)) {
    st.marker <- global_data$st_marker
    scRNA <- global_data$scRNA_filter_1

    all.markers <- st.marker %>%
      select(gene, everything()) %>%
      subset(p_val_adj < 0.05)

    top50 <- all.markers %>%
      group_by(cluster) %>%
      top_n(n = 50, wt = avg_log2FC) %>%
      filter(cluster == input$selected_cell_type_scrna)

    score_list <- list(gene = top50$gene)

    progressSweetAlert(
      session = session,
      id = "distribution-of-spatial-cell-populations-in-single-cells",
      title = "Adding module score...",
      display_pct = TRUE,
      value = 10,
    )

    tryCatch(
      {
        scRNA <- AddModuleScore(scRNA, features = score_list, name = "ST_cluster")
      },
      error = {}
    )

    output$selected_cell_type_scrna_violin <- renderPlot({
      ggviolin(
        data = scRNA@meta.data,
        x = "cell_type",
        y = "ST_cluster1",
        ylab = paste0("ST_cluster", input$selected_cell_type_scrna),
        fill = "cell_type"
      ) +
        theme(
          axis.text.x = element_text(
            angle = 90,
            hjust = 1,
            vjust = 0
          ),
          legend.position = "none"
        )
    })

    output$selected_cell_type_scrna_featureplot <- renderPlot({
      updateProgressBar(
        session = session,
        id = "distribution-of-spatial-cell-populations-in-single-cells",
        title = "Runing PCA...",
        value = 50
      )
      scRNA <- RunPCA(scRNA, features = VariableFeatures(scRNA))
      pc.num <- 1:15
      Idents(scRNA) <- scRNA$cell_type
      updateProgressBar(
        session = session,
        id = "distribution-of-spatial-cell-populations-in-single-cells",
        title = "Runing UMAP...",
        value = 50
      )
      scRNA <- RunUMAP(scRNA, dims = pc.num)

      closeSweetAlert(session = session)
      FeaturePlot(
        scRNA,
        features = "ST_cluster1",
        label = TRUE
      ) +
        labs(
          title = paste0("ST_cluster", input$selected_cell_type_scrna)
        )
    })
  }
})

output$add_module_score_1 <-
  output$add_module_score_2 <- renderPlot({
    if (!is.null(global_data$stRNA) && !is.null(global_data$position_sub_sub)) {
      stRNA <- global_data$stRNA
      position_sub_sub <- global_data$position_sub_sub
      embed_umap2 <- data.frame(
        UMAP_1 = position_sub_sub$row,
        UMAP_2 = position_sub_sub$col,
        row.names = rownames(position_sub_sub)
      )

      stRNA@reductions$umap@cell.embeddings <- as.matrix(embed_umap2)
      DimPlot(stRNA) +
        xlab("ST1") +
        ylab("ST2")
    }
  })
