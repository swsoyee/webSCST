observeEvent(input$submit_rds_file, {
  progressSweetAlert(
    session = session,
    id = "loading-rds",
    title = "Loading dataset...",
    display_pct = TRUE,
    value = 10,
  )
  global_data$scRNA_filter_1 <- readRDS(input$upload_seurat_object_file$datapath)

  updateProgressBar(
    session = session,
    id = "loading-rds",
    title = "Loading markers",
    value = 50
  )
  global_data$marker <- readRDS(input$upload_markers_file$datapath)
  global_data$st_marker <- readRDS("./db/st_marker.Rds")

  updateProgressBar(
    session = session,
    id = "loading-rds",
    title = "Loading position database...",
    value = 80
  )
  load("./db/position.Rds")
  global_data$position_sub_sub <- position_sub_sub
  load("./db/stRNA.rds")

  embed_umap2 <- data.frame(
    UMAP_1 = position_sub_sub$x,
    UMAP_2 = position_sub_sub$y,
    row.names = rownames(position_sub_sub)
  )

  stRNA@reductions$umap@cell.embeddings <- as.matrix(embed_umap2)

  global_data$stRNA <- stRNA
  updateProgressBar(
    session = session,
    id = "loading-rds",
    title = "Loading finished.",
    value = 100
  )

  Sys.sleep(1)
  closeSweetAlert(session = session)
})
