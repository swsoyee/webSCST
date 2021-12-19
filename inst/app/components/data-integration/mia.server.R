output$run_mia <- renderUI({
  if (!is.null(global_data$marker) && !is.null(global_data$st_marker)) {
    actionBttn(
      inputId = "run_mia",
      label = "Run MIA",
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

observeEvent(input$run_mia, {
  if (!is.null(global_data$marker) && !is.null(global_data$st_marker)) {
    sc.marker <- global_data$marker
    st.marker <- global_data$st_marker

    progressSweetAlert(
      session = session,
      id = "calculating-mia",
      title = "Generating plot...",
      display_pct = TRUE,
      value = 10,
    )
    sc.marker2 <- sc.marker %>%
      group_by(cluster) %>%
      subset(avg_log2FC > 0.5)
    st.marker2 <- st.marker %>%
      group_by(cluster) %>%
      subset(avg_log2FC > 0.5)

    p.data <- data.frame(sc = NA, st = NA, p = NA)

    updateProgressBar(
      session = session,
      id = "calculating-mia",
      title = "Generating plot...",
      value = 80
    )
    for (i in unique(sc.marker2$cluster)) {
      sub_cluster <- subset(sc.marker2, cluster == i)
      gene <- sub_cluster$gene
      gene_l <- length(gene)

      for (j in unique(st.marker2$cluster)) {
        sub_cluster_st <- subset(st.marker2, cluster == j)
        gene_st <- sub_cluster_st$gene
        gene_st_l <- length(gene_st)
        gene_inter_l <- length(intersect(gene_l, gene_st_l))

        p <- -log10(1 - phyper(
          gene_inter_l,
          gene_st_l,
          12309 - gene_st_l,
          gene_l
        ))

        p.demo.data <- data.frame(
          sc = paste0(i, "(", gene_l, ")"),
          st = paste0(j, "(", gene_st_l, ")"), p = p
        )

        p.data <- rbind(p.demo.data, p.data)
        p.data <- na.omit(p.data)
      }
    }

    p.data$group <- p.data$st

    p.data <- as_tibble(p.data)

    output$mia_heatmap <- renderPlot({
      p.data %>%
        tidyHeatmap::heatmap(
          .column = st,
          .row = sc,
          .value = p,
          .scale = "both",
          show_column_names = FALSE,
          palette_value = c("#1B4584", "white", "#660621"),
          palette_grouping = list(c("red", "blue")),
          rect_gp = grid::gpar(col = "black", lwd = 1),
          row_names_side = "left",
          cluster_rows = FALSE,
          cluster_columns = FALSE
        ) %>%
        add_tile(group)
    })

    closeSweetAlert(session = session)
  }

  if (!is.null(global_data$stRNA) && !is.null(global_data$position_sub_sub)) {
    stRNA <- global_data$stRNA
    position_sub_sub <- global_data$position_sub_sub
    embed_umap2 <- data.frame(
      UMAP_1 = position_sub_sub$row,
      UMAP_2 = position_sub_sub$col,
      row.names = rownames(position_sub_sub)
    )

    stRNA@reductions$umap@cell.embeddings <- as.matrix(embed_umap2)

    output$mia_dimplot <- renderPlot({
      DimPlot(stRNA) +
        xlab("ST1") +
        ylab("ST2")
    })
  }
})

observeEvent(input$run_mia, {
  output$mia_plot_wrapper <- renderUI({
    if (!is.null(global_data$stRNA) && !is.null(global_data$position_sub_sub)) {
      tagList(
        plotOutput("mia_heatmap"),
        bs4Callout(
          title = "",
          width = 12,
          status = "info",
          "The heatmap shows the gene expression for each cell type in each spatial cluster."
        ),
        plotOutput("mia_dimplot"),
        bs4Callout(
          title = "",
          width = 12,
          status = "info",
          "The clustering results for spatial transcriptome sequencing data."
        )
      )
    }
  })
})
