observeEvent(input$main_sidebar, {
  if (input$main_sidebar == "quality_control" &&
    !global_data$quality_control_process_done &&
    !is.null(global_data$scRNA)) {
    scRNA <- global_data$scRNA

    scRNA[["percent.mt"]] <- PercentageFeatureSet(scRNA, pattern = "^MT-")
    HB.genes <- global_data$HBgenes
    HB_m <- match(HB.genes, rownames(scRNA@assays$RNA))
    HB.genes <- rownames(scRNA@assays$RNA)[HB_m]
    HB.genes <- HB.genes[!is.na(HB.genes)]
    scRNA[["percent.HB"]] <- PercentageFeatureSet(scRNA, features = HB.genes)

    global_data$scRNA <- scRNA
    global_data$scRNA_filter_1 <- scRNA
    global_data$quality_control_process_done <- TRUE
  }
})

observeEvent(input$apply_quality_control_filter, {
  if (global_data$quality_control_process_done) {
    global_data$scRNA_filter_1 <- subset(
      global_data$scRNA,
      subset = nFeature_RNA > input$quality_control_min_gene &
        nFeature_RNA < input$quality_control_max_gene & percent.mt < input$quality_control_pctmt
    )
  }
})

output$quality_control_violin_plot <- renderPlot({
  if (global_data$quality_control_process_done) {
    col.num <- length(levels(global_data$scRNA_filter_1@active.ident))

    p <- VlnPlot(
      global_data$scRNA_filter_1,
      features = c("nFeature_RNA", "nCount_RNA", "percent.mt", "percent.HB"),
      cols = rainbow(col.num),
      pt.size = 0.01,
      ncol = 4
    ) +
      theme(
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()
      )

    quality_control_violin_plot$plot <- p
    p
  }
})

quality_control_violin_plot <- reactiveValues()

output$download_quality_control_violin_plot_png <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-quality-control-violin.png"),
  content = function(file) {
    ggsave(file, plot = quality_control_violin_plot$plot)
  }
)

output$download_quality_control_violin_plot_pdf <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-quality-control-violin.pdf"),
  content = function(file) {
    ggsave(file, plot = quality_control_violin_plot$plot, device = "pdf")
  }
)

output$quality_control_feature_scatter <- renderPlot({
  if (global_data$quality_control_process_done) {
    scRNA <- global_data$scRNA_filter_1
    p1 <- FeatureScatter(scRNA, feature1 = "nCount_RNA", feature2 = "percent.mt")
    p2 <- FeatureScatter(scRNA, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
    p3 <- FeatureScatter(scRNA, feature1 = "nCount_RNA", feature2 = "percent.HB")
    p <- p1 + p2 + p3 + plot_layout(ncol = 3) & theme(legend.position = "none")

    quality_control_feature_scatter_plot$plot <- p
    p
  }
})

quality_control_feature_scatter_plot <- reactiveValues()

output$download_quality_control_feature_scatter_plot_png <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-quality-control-feature-scatter-plot.png"),
  content = function(file) {
    ggsave(file, plot = quality_control_feature_scatter_plot$plot)
  }
)

output$download_quality_control_feature_scatter_plot_pdf <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-quality-control-feature-scatter-plot.pdf"),
  content = function(file) {
    ggsave(file, plot = quality_control_feature_scatter_plot$plot, device = "pdf")
  }
)

output$quality_control_plot_description <- renderText({
  # it will take too much time when using `all.equal` to do the comparison
  if (object.size(global_data$scRNA_filter_1) == object.size(global_data$scRNA)) {
    return("The figures of the raw data results are shown below:")
  } else {
    return("The figures of the filtered data results are shown below:")
  }
})

observeEvent(input$go_to_quality_control_normalization, {
  updateBox(
    id = "normailization_and_scaling",
    action = "toggle"
  )
  updateBox(
    id = "violin_plot_and_feature_scatter",
    action = "toggle"
  )
})

output$normalization_plot <- renderPlot({
  if (input$apply_quality_control_normalize == 0) {
    return()
  }
  isolate({
    if (global_data$quality_control_process_done) {
      scRNA <- global_data$scRNA_filter_1

      scRNA <- NormalizeData(
        scRNA,
        normalization.method = "LogNormalize",
        scale.factor = input$normalize_scale_factor
      )

      scRNA <- FindVariableFeatures(
        scRNA,
        selection.method = "vst",
        nfeatures = input$features_count
      )

      global_data$normalized_done <- TRUE

      top <- head(
        VariableFeatures(scRNA),
        input$top_gene_count
      )
      plot1 <- VariableFeaturePlot(scRNA)
      plot2 <- LabelPoints(
        plot = plot1,
        points = top,
        repel = TRUE,
        size = 2.5
      )

      scale.genes <- rownames(scRNA)
      scRNA <- ScaleData(scRNA, features = scale.genes)
      global_data$scRNA_filter_1 <- scRNA
      p <- plot1 + plot2 + plot_layout(ncol = 2) & theme(legend.position = "bottom")
      normalization_plot$plot <- p
      p
    }
  })
})

normalization_plot <- reactiveValues()

output$download_normalization_plot_png <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-quality-control-normalization-plot.png"),
  content = function(file) {
    ggsave(file, plot = normalization_plot$plot)
  }
)

output$download_normalization_plot_pdf <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-quality-control-normalization-plot.pdf"),
  content = function(file) {
    ggsave(file, plot = normalization_plot$plot, device = "pdf")
  }
)

output$normalization_plot_wrapper <- renderUI({
  if (input$apply_quality_control_normalize == 0) {
    return()
  } else {
    tagList(
      fluidRow(
        downloadBttn(
          outputId = "download_normalization_plot_png",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_normalization_plot_pdf",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      tags$br(),
      withSpinner(plotOutput("normalization_plot"))
    )
  }
})

observeEvent(input$apply_quality_control_normalize, {
  output$go_to_quality_control_clustering <- renderUI({
    actionBttn(
      inputId = "go_to_quality_control_clustering",
      label = "Go to Clustering",
      color = "primary",
      icon = icon("play"),
      size = "sm",
      style = "fill",
      block = TRUE
    )
  })

  output$clustering_box <- renderUI({
    box(
      id = "clustering",
      width = 12,
      title = tagList(
        "3. Clustering"
      ),
      label = boxLabel(
        "Step 3",
        status = "white"
      ),
      solidHeader = TRUE,
      collapsed = TRUE,
      maximizable = TRUE,
      status = "primary",
      withSpinner(plotOutput("clustering_pca")),
      sliderInput(
        inputId = "pc_num",
        label = "PC Number",
        min = 1,
        max = 30,
        value = 15
      ),
      fluidRow(
        column(
          width = 6,
          withSpinner(plotOutput("clustering_tsne"))
        ),
        column(
          width = 6,
          withSpinner(plotOutput("clustering_umap"))
        )
      )
    )
  })
})

observeEvent(input$go_to_quality_control_clustering, {
  updateBox(
    id = "normailization_and_scaling",
    action = "toggle"
  )
  updateBox(
    id = "clustering_box",
    action = "toggle"
  )
})

output$clustering_pca <- renderPlot({
  if (input$go_to_quality_control_clustering == 0) {
    return()
  }
  isolate({
    if (global_data$quality_control_process_done) {
      scRNA <- global_data$scRNA_filter_1

      scRNA <- RunPCA(scRNA, features = VariableFeatures(scRNA))
      plot1 <- DimPlot(scRNA, reduction = "pca", group.by = "orig.ident")
      plot2 <- ElbowPlot(scRNA, ndims = 20, reduction = "pca")
      global_data$scRNA_filter_1 <- scRNA

      plot1 + plot2
    }
  })
})

output$clustering_tsne <- renderPlot({
  if (input$go_to_quality_control_clustering == 0) {
    return()
  }

  pc.num <- 1:input$pc_num

  isolate({
    if (global_data$quality_control_process_done) {
      progressSweetAlert(
        session = session,
        id = "calculating-tsne",
        title = "Generating plot...",
        display_pct = TRUE,
        value = 10,
      )
      scRNA <- global_data$scRNA_filter_1
      updateProgressBar(
        session = session,
        id = "calculating-tsne",
        title = "Finding Neighbors...",
        value = 80
      )
      scRNA <- FindNeighbors(scRNA, dims = pc.num)
      updateProgressBar(
        session = session,
        id = "calculating-tsne",
        title = "Finding Cluster...",
        value = 80
      )
      scRNA <- FindClusters(scRNA, resolution = 0.5)

      metadata <- scRNA@meta.data
      cell_cluster <- data.frame(
        cell_ID = rownames(metadata),
        cluster_ID = metadata$seurat_clusters
      )

      Idents(scRNA) <- scRNA$cell_type
      scRNA <- RunTSNE(scRNA, dims = pc.num)
      global_data$scRNA_filter_1 <- scRNA

      closeSweetAlert(session = session)
      DimPlot(scRNA, reduction = "tsne", label = T)
    }
  })
})

output$clustering_umap <- renderPlot({
  if (input$go_to_quality_control_clustering == 0) {
    return()
  }

  pc.num <- 1:input$pc_num

  isolate({
    if (global_data$quality_control_process_done) {
      scRNA <- global_data$scRNA_filter_1

      progressSweetAlert(
        session = session,
        id = "calculating-umap",
        title = "Runing UMAP...",
        display_pct = TRUE,
        value = 10,
      )
      Idents(scRNA) <- scRNA$cell_type
      updateProgressBar(
        session = session,
        id = "calculating-umap",
        title = "Runing UMAP...",
        value = 50
      )
      scRNA <- RunUMAP(scRNA, dims = pc.num)
      global_data$scRNA_filter_1 <- scRNA

      closeSweetAlert(session = session)
      DimPlot(scRNA, reduction = "umap", label = T)
    }
  })
})

output$save_object_as_rds <- downloadHandler(
  filename = function() {
    paste("scRNA_", Sys.Date(), ".rds", sep = "")
  },
  content = function(con) {
    progressSweetAlert(
      session = session,
      id = "create-seurat-object-to-rds",
      title = "Generating Dataset...",
      display_pct = TRUE,
      value = 15,
    )
    saveRDS(global_data$scRNA_filter_1, con)
    progressSweetAlert(
      session = session,
      id = "create-seurat-object-to-rds",
      title = "Done",
      display_pct = TRUE,
      value = 100,
    )
    Sys.sleep(1)
    closeSweetAlert(session = session)
  }
)

output$find_marker_and_save <- downloadHandler(
  filename = function() {
    paste("Markers_", Sys.Date(), ".rds", sep = "")
  },
  content = function(con) {
    scRNA <- global_data$scRNA_filter_1
    progressSweetAlert(
      session = session,
      id = "create-seurat-object-to-rds",
      title = "Finding markers...",
      display_pct = TRUE,
      value = 15,
    )
    Idents(scRNA) <- scRNA$cell_type
    sc.marker <- FindAllMarkers(scRNA, only.pos = TRUE, min.pct = 0.25)
    saveRDS(sc.marker, con)

    global_data$marker <- sc.marker
    global_data$scRNA_filter_1 <- scRNA

    progressSweetAlert(
      session = session,
      id = "create-seurat-object-to-rds",
      title = "Done",
      display_pct = TRUE,
      value = 100,
    )
    Sys.sleep(1)
    closeSweetAlert(session = session)
  }
)

observeEvent(input$go_to_quality_control_clustering, {
  updateBox(
    id = "normailization_and_scaling",
    action = "toggle"
  )
  updateBox(
    id = "clustering",
    action = "toggle"
  )
})
