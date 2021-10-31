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
    global_data$quality_control_process_done <- TRUE
  }
})

observeEvent(input$apply_quality_control_filter, {
  if (global_data$quality_control_process_done) {
    global_data$scRNA <- subset(
      global_data$scRNA,
      subset = nFeature_RNA > input$quality_control_min_gene &
        nFeature_RNA < input$quality_control_max_gene & percent.mt < input$quality_control_pctmt
    )
  }
})

output$quality_control_violin_plot <- renderPlot({
  if (global_data$quality_control_process_done) {
    col.num <- length(levels(global_data$scRNA@active.ident))

    VlnPlot(
      global_data$scRNA,
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
  }
})

output$quality_control_feature_scatter <- renderPlot({
  if (global_data$quality_control_process_done) {
    p1 <- FeatureScatter(global_data$scRNA, feature1 = "nCount_RNA", feature2 = "percent.mt")
    p2 <- FeatureScatter(global_data$scRNA, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
    p3 <- FeatureScatter(global_data$scRNA, feature1 = "nCount_RNA", feature2 = "percent.HB")
    p1 + p2 + p3 + plot_layout(ncol = 3) & theme(legend.position = "none")
  }
})

output$quality_control_plot_description <- renderText({
  if (is.null(input$apply_quality_control_filter)) {
    return("The figures of the raw data results are shown below:")
  } else {
    return("The figures of the filtered data results are shown below:")
  }
})
