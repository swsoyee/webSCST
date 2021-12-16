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
        row <- species_and_organ_table()[selected_data_from_database()]
        position_file_name <- paste0(as.character(row$id), "_position_", row$sample_name, ".Rds")
        st_file_name <- paste0(as.character(row$id), "_st_", row$sample_name, ".Rds")
    }
})
