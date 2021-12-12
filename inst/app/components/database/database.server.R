output$database_table <- renderReactable({
  data <- cbind(
    global_data$database[show == TRUE, ],
    details = NA
  )

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
    ),
    "show" = colDef(
      show = FALSE
    ),
    "details" = colDef(
      name = "",
      sortable = FALSE,
      maxWidth = 150,
      cell = function() htmltools::tags$button("Show details", class = "action-button bttn bttn-fill bttn-sm bttn-primary bttn-block bttn-no-outline shiny-bound-input")
    )
  )

  reactable(
    data,
    columns = col_def,
    bordered = TRUE,
    highlight = TRUE,
    searchable = TRUE,
    striped = TRUE,
    showPageSizeOptions = TRUE,
    onClick = htmlwidgets::JS("function(rowInfo, colInfo) {
        if (colInfo.id !== 'details') {
            return
        }

        if (window.Shiny) {
            Shiny.setInputValue('show_details', { index: rowInfo.index + 1 }, { priority: 'event' })
        }
    }")
  )
})

observeEvent(input$show_details, {
  dataset_id <- input$show_details

  dataset_files_name <- grep(paste0("^", dataset_id, "_.+\\.Rds"), list.files("./db"), value = TRUE)

  rm_prefix_files_name <- gsub("^.+[position|st]_", "", dataset_files_name)

  choices <- unique(gsub(".Rds$", "", rm_prefix_files_name))
  choices <- choices[order(nchar(choices), choices)]

  showModal(
    modalDialog(
      title = "Visualization Dataset",
      fluidRow(
        column = 6,
        pickerInput(
          inputId = "database_sample",
          label = "Name of Sample",
          choices = choices
        )
      )
    )
  )
})
