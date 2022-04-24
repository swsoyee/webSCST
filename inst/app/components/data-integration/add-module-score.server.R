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

add_module_score <- reactiveValues()

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
      p <- ggviolin(
        data = stRNA@meta.data,
        x = "SCT_snn_res.0.8",
        y = feature_name,
        fill = "SCT_snn_res.0.8"
      )
      add_module_score$violin_plot <- p
      p
    })

    output$selected_cell_type_strna_featureplot <- renderPlot({
      p <- FeaturePlot(stRNA, features = feature_name) +
        xlab("ST1") +
        ylab("ST2")
      add_module_score$feature_plot <- p
      p
    })
  }
})

output$download_add_module_score_violin_plot_png <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-violin-plot.png"),
  content = function(file) {
    ggsave(file, plot = add_module_score$violin_plot)
  }
)

output$download_add_module_score_violin_plot_pdf <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-violin-plot.pdf"),
  content = function(file) {
    ggsave(file, plot = add_module_score$violin_plot, device = "pdf")
  }
)

output$selected_cell_type_strna_violin_wrapper <- renderUI({
  if (!is.null(global_data$marker) && !is.null(global_data$stRNA)) {
    tagList(
      fluidRow(
        downloadBttn(
          outputId = "download_add_module_score_violin_plot_png",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_add_module_score_violin_plot_pdf",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      plotOutput("selected_cell_type_strna_violin"),
      bs4Callout(
        title = "",
        width = 12,
        status = "info",
        "Violin plot shows the gene expression distribution of spatail clusters for the specific cell-type you select."
      )
    )
  }
})

output$download_add_module_score_feature_plot_png <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-violin-plot.png"),
  content = function(file) {
    ggsave(file, plot = add_module_score$feature_plot)
  }
)

output$download_add_module_score_feature_plot_pdf <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-violin-plot.pdf"),
  content = function(file) {
    ggsave(file, plot = add_module_score$feature_plot, device = "pdf")
  }
)

output$selected_cell_type_strna_featureplot_wrapper <- renderUI({
  if (!is.null(global_data$marker) && !is.null(global_data$stRNA)) {
    tagList(
      fluidRow(
        downloadBttn(
          outputId = "download_add_module_score_feature_plot_png",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_add_module_score_feature_plot_pdf",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      plotOutput("selected_cell_type_strna_featureplot"),
      bs4Callout(
        title = "",
        width = 12,
        status = "info",
        "The spatail gene expression for the specific cell-type you select."
      )
    )
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
      p <- ggviolin(
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

      add_module_score$cell_type_violin_plot <- p
      p
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
      p <- FeaturePlot(
        scRNA,
        features = "ST_cluster1",
        label = TRUE
      ) +
        labs(
          title = paste0("ST_cluster", input$selected_cell_type_scrna)
        )
      add_module_score$cell_type_feature_plot <- p
      p
    })
  }
})

output$download_add_module_score_cell_type_violin_plot_png <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-cell-type-violin-plot.png"),
  content = function(file) {
    ggsave(file, plot = add_module_score$cell_type_violin_plot)
  }
)

output$download_add_module_score_cell_type_violin_plot_pdf <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-cell-type-violin-plot.pdf"),
  content = function(file) {
    ggsave(file, plot = add_module_score$cell_type_violin_plot, device = "pdf")
  }
)

output$selected_cell_type_scrna_violin_wrapper <- renderUI({
  if (!is.null(global_data$st_marker) && !is.null(global_data$scRNA_filter_1)) {
    tagList(
      fluidRow(
        downloadBttn(
          outputId = "download_add_module_score_cell_type_violin_plot_png",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_add_module_score_cell_type_violin_plot_pdf",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      plotOutput("selected_cell_type_scrna_violin"),
      bs4Callout(
        title = "",
        width = 12,
        status = "info",
        "Violin plot shows the gene expression distribution of cell types for the specific spatail cluster you select."
      )
    )
  }
})

output$download_add_module_score_cell_type_feature_plot_png <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-cell-type-feature-plot.png"),
  content = function(file) {
    ggsave(file, plot = add_module_score$cell_type_feature_plot)
  }
)

output$download_add_module_score_cell_type_feature_plot_pdf <- downloadHandler(
  filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-cell-type-feature-plot.pdf"),
  content = function(file) {
    ggsave(file, plot = add_module_score$cell_type_feature_plot, device = "pdf")
  }
)

output$selected_cell_type_scrna_featureplot_wrapper <- renderUI({
  if (!is.null(global_data$st_marker) && !is.null(global_data$scRNA_filter_1)) {
    tagList(
      fluidRow(
        downloadBttn(
          outputId = "download_add_module_score_cell_type_feature_plot_png",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_add_module_score_cell_type_feature_plot_pdf",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      plotOutput("selected_cell_type_scrna_featureplot"),
      bs4Callout(
        title = "",
        width = 12,
        status = "info",
        "The single-cell UMAP plot shows gene expression for the specific spatail cluster you select."
      )
    )
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
      p <- DimPlot(stRNA) +
        xlab("ST1") +
        ylab("ST2")
      add_module_score$cluster_result_plot <- p
      p
    }
  })

output$download_cluster_result_plot_png_1 <-
  output$download_cluster_result_plot_png_2 <- downloadHandler(
    filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-cluster-result-plot.png"),
    content = function(file) {
      ggsave(file, plot = add_module_score$cluster_result_plot)
    }
  )

output$download_cluster_result_plot_pdf_1 <-
  output$download_cluster_result_plot_pdf_2 <- downloadHandler(
    filename = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-add-module-score-cluster-result-plot.pdf"),
    content = function(file) {
      ggsave(file, plot = add_module_score$cluster_result_plot, device = "pdf")
    }
  )


output$add_module_score_1_wrapper <- renderUI({
  if (!is.null(global_data$stRNA) && !is.null(global_data$position_sub_sub)) {
    tagList(
      fluidRow(
        downloadBttn(
          outputId = "download_cluster_result_plot_png_1",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_cluster_result_plot_pdf_1",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      plotOutput("add_module_score_1"),
      bs4Callout(
        title = "",
        width = 12,
        status = "info",
        "The clustering results for spatial transcriptome sequencing data."
      )
    )
  }
})


output$add_module_score_2_wrapper <- renderUI({
  if (!is.null(global_data$stRNA) && !is.null(global_data$position_sub_sub)) {
    tagList(
      fluidRow(
        downloadBttn(
          outputId = "download_cluster_result_plot_png_2",
          label = "PNG",
          size = "sm",
          style = "fill"
        ),
        HTML("&nbsp;"),
        downloadBttn(
          outputId = "download_cluster_result_plot_pdf_2",
          label = "PDF",
          size = "sm",
          style = "fill"
        ),
      ),
      plotOutput("add_module_score_2"),
      bs4Callout(
        title = "",
        width = 12,
        status = "info",
        "The clustering results for spatial transcriptome sequencing data."
      )
    )
  }
})
