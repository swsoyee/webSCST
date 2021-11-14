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

observeEvent(input$selected_cell_type_strna, {
  if (!is.null(global_data$marker)) {
      sc.marker <- global_data$marker
      stRNA <- global_data$stRNA
    all.markers = sc.marker %>%
        select(gene, everything()) %>%
        subset(p_val_adj<0.05)

    top10 = all.markers %>%
      group_by(cluster) %>%
      top_n(n = 10, wt = avg_log2FC) %>%
      filter(cluster == input$selected_cell_type_strna)

    score_list <- list(gene=top10$gene)

    stRNA <- AddModuleScore(stRNA, features = score_list,name = input$selected_cell_type_strna)

    output$selected_cell_type_strna_violin <- renderPlot({
        ggviolin(data = stRNA@meta.data,
             x="SCT_snn_res.0.8",
             y= paste0(input$selected_cell_type_strna, "1"),
             fill = "SCT_snn_res.0.8")
    })

    output$selected_cell_type_strna_featureplot <- renderPlot({
        FeaturePlot(stRNA,features = paste0(input$selected_cell_type_strna, "1"))
    })
  }
})


# output$single_cell_in_position_
