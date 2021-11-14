output$cell_type_selector_strna <- renderUI({
  if (!is.null(global_data$marker)) {
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
        width = 6,
        pickerInput(
          inputId = "selected_cell_type_scrna_featureplot_cluster_method",
          label = "Clustering Method",
          choices = list(
            "PCA" = "pca",
            "t-SNE" = "tsne",
            "UMAP" = "umap"
          )
        )
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
  if (!is.null(global_data$marker)) {
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

    stRNA <- AddModuleScore(stRNA, features = score_list, name = input$selected_cell_type_strna)

    output$selected_cell_type_strna_violin <- renderPlot({
      ggviolin(
        data = stRNA@meta.data,
        x = "SCT_snn_res.0.8",
        y = paste0(input$selected_cell_type_strna, "1"),
        fill = "SCT_snn_res.0.8"
      )
    })

    output$selected_cell_type_strna_featureplot <- renderPlot({
      FeaturePlot(stRNA, features = paste0(input$selected_cell_type_strna, "1"))
    })
  }
})

observeEvent(input$selected_cell_type_scrna, {
  if (!is.null(global_data$st_marker)) {
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

    scRNA <- AddModuleScore(scRNA, features = score_list, name = input$selected_cell_type_scrna)

    output$selected_cell_type_scrna_violin <- renderPlot({
      ggviolin(
        data = scRNA@meta.data,
        x = "cell_type",
        y = paste0(input$selected_cell_type_scrna, "1"),
        fill = "cell_type"
      )
    })

    output$selected_cell_type_scrna_featureplot <- renderPlot({
      # TODO === before FeaturePlot, something is missing
      if (input$selected_cell_type_scrna_featureplot_cluster_method == "pca") {
        scRNA <- RunPCA(scRNA, features = VariableFeatures(scRNA))
      }
      if (input$selected_cell_type_scrna_featureplot_cluster_method == "tsne") {
        pc.num <- 1:15
        scRNA <- FindNeighbors(scRNA, dims = pc.num)
        scRNA <- FindClusters(scRNA, resolution = 0.5)
        scRNA <- RunTSNE(scRNA, dims = pc.num)
      }
      if (input$selected_cell_type_scrna_featureplot_cluster_method == "umap") {
        pc.num <- 1:15
        scRNA <- RunUMAP(scRNA, dims = pc.num)
      }
      # TODO ===

      FeaturePlot(
        scRNA,
        features = paste0(input$selected_cell_type_scrna, "1"),
        label = TRUE
      )
    })
  }
})
