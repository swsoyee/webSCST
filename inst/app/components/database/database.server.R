output$database_table <- renderReactable({

  col_def <- list(
      "id" = colDef(
          name = "ID",
          maxWidth = 50
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
          maxWidth = 100
      ),
      "year" = colDef(
          name = "Year",
          maxWidth = 100
      )
  )

  reactable(
      global_data$database,
      columns = col_def,
      bordered = TRUE,
      highlight = TRUE,
      searchable = TRUE,
      striped = TRUE,
      showPageSizeOptions = TRUE,
  )
})
