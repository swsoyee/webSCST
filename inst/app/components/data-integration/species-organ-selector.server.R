output$species_and_organ_selector_table <- renderReactable({
  col_def <- list(
    "id" = colDef(
      name = "ID",
      maxWidth = 50,
      show = FALSE
    ),
    "title" = colDef(
      name = "Title"
    ),
    "organ" = colDef(
      name = "Organ",
      maxWidth = 100
    ),
    "species" = colDef(
      name = "Species",
      maxWidth = 100
    ),
    "journal" = colDef(
      name = "Journal",
      maxWidth = 100,
      show = FALSE
    ),
    "year" = colDef(
      name = "Year",
      maxWidth = 100,
      show = FALSE
    ),
    "show" = colDef(
      show = FALSE
    ),
    "sample_name" = colDef(
      name = "Sample",
      aggregate = "frequency"
    )
  )

  reactable(
    species_and_organ_table(),
    columns = col_def,
    bordered = TRUE,
    highlight = TRUE,
    striped = TRUE,
    onClick = "select",
    selection = "single",
    rowStyle = list(cursor = "pointer"),
    showPageSizeOptions = TRUE,
    theme = reactableTheme(
      rowSelectedStyle = list(
        backgroundColor = "#eee",
        boxShadow = "inset 5px 0 0 0 #007bff"
      )
    ),
    groupBy = c("species", "organ", "title")
  )
})

selected_data_from_database <- reactive(getReactableState("species_and_organ_selector_table", "selected"))

observeEvent(input$sample_selection, {
  if (!is.null(selected_data_from_database())) {
    global_data$sample_name_of_file <- selected_data_from_database()
  }
  if (is.null(global_data$sample_name_of_file)) {
    show_alert(
      session = session,
      title = "Error",
      text = "Please select a sample first.",
      type = "error"
    )
  }
  if (!is.null(global_data$sample_name_of_file)) {
    progressSweetAlert(
      session = session,
      id = "loading-background-dataset",
      title = "Loading dataset...",
      display_pct = TRUE,
      value = 10,
    )
    row <- species_and_organ_table()[selected_data_from_database()]
    database_path <- "./db/"
    position_file_name <- paste0(
      database_path,
      as.character(row$id),
      "_position_",
      row$sample_name,
      ".Rds"
    )
    updateProgressBar(
      session = session,
      id = "loading-background-dataset",
      title = "Loading position dataset.",
      value = 40
    )
    global_data$position_sub_sub <- readRDS(position_file_name)
    position_sub_sub <- global_data$position_sub_sub

    st_file_name <- paste0(
      database_path,
      as.character(row$id),
      "_st_",
      row$sample_name,
      ".Rds"
    )
    updateProgressBar(
      session = session,
      id = "loading-background-dataset",
      title = "Loading stRNA dataset.",
      value = 60
    )
    stRNA <- readRDS(st_file_name)
    embed_umap2 <- data.frame(
      UMAP_1 = position_sub_sub$row,
      UMAP_2 = position_sub_sub$col,
      row.names = rownames(position_sub_sub)
    )
    stRNA@reductions$umap@cell.embeddings <- as.matrix(embed_umap2)
    global_data$stRNA <- stRNA

    updateProgressBar(
      session = session,
      id = "loading-background-dataset",
      title = "Loading marker dataset.",
      value = 80
    )
    marker_file_name <- paste0(
      database_path,
      as.character(row$id),
      "_marker_",
      row$sample_name,
      ".Rds"
    )
    global_data$st_marker <- readRDS(marker_file_name)

    closeSweetAlert(session = session)
    show_alert(
      session = session,
      title = "Done",
      text = "Loading dataset finished.",
      type = "success"
    )
  }
})

output$species_selector <- renderUI({
  pickerInput(
    inputId = "species_selector",
    label = "Species",
    choices = unique(species_and_organ_table()$species)
  )
})

observeEvent(input$species_selector, {
  output$organ_selector <- renderUI({
    pickerInput(
      inputId = "organ_selector",
      label = "Organ",
      choices = unique(species_and_organ_table()[species == input$species_selector, ]$organ)
    )
  })
})

observeEvent(input$sample_selection_auto, {
  entry <- head(
    species_and_organ_table()[
      species == input$species_selector &
        organ == input$organ_selector,
    ],
    1
  )
  sample_name <- entry$sample_name
  id <- entry$id

  progressSweetAlert(
    session = session,
    id = "loading-background-dataset",
    title = "Loading dataset...",
    display_pct = TRUE,
    value = 10,
  )

  database_path <- "./db/"
  position_file_name <- paste0(
    database_path,
    as.character(id),
    "_position_",
    sample_name,
    ".Rds"
  )
  updateProgressBar(
    session = session,
    id = "loading-background-dataset",
    title = "Loading position dataset.",
    value = 40
  )
  global_data$position_sub_sub <- readRDS(position_file_name)
  position_sub_sub <- global_data$position_sub_sub

  st_file_name <- paste0(
    database_path,
    as.character(id),
    "_st_",
    sample_name,
    ".Rds"
  )
  updateProgressBar(
    session = session,
    id = "loading-background-dataset",
    title = "Loading stRNA dataset.",
    value = 60
  )
  stRNA <- readRDS(st_file_name)
  embed_umap2 <- data.frame(
    UMAP_1 = position_sub_sub$row,
    UMAP_2 = position_sub_sub$col,
    row.names = rownames(position_sub_sub)
  )
  stRNA@reductions$umap@cell.embeddings <- as.matrix(embed_umap2)
  global_data$stRNA <- stRNA

  updateProgressBar(
    session = session,
    id = "loading-background-dataset",
    title = "Loading marker dataset.",
    value = 80
  )
  marker_file_name <- paste0(
    database_path,
    as.character(id),
    "_marker_",
    sample_name,
    ".Rds"
  )
  global_data$st_marker <- readRDS(marker_file_name)

  closeSweetAlert(session = session)
  show_alert(
    session = session,
    title = "Done",
    text = "Loading dataset finished.",
    type = "success"
  )
})
