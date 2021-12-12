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
      ),
      fluidRow(
        column = 12,
        plotOutput("database_sample_dimplot")
      )
    )
  )
})

observeEvent(input$database_sample, {
  dataset_id <- input$show_details
  dataset_files_name <- grep(paste0("^", dataset_id, ".*", input$database_sample, ".*Rds"), list.files("./db"), value = TRUE)
  position_sub_sub <- grep("position", dataset_files_name, value = TRUE)
  st <- grep("st", dataset_files_name, value = TRUE)

  position <- readRDS(paste0("./db/", position_sub_sub))
  st <- readRDS(paste0("./db/", st))

  embed_umap2 <- data.frame(
    UMAP_1 = position$row,
    UMAP_2 = position$col,
    row.names = rownames(position)
  )

  st@reductions$umap@cell.embeddings <- as.matrix(embed_umap2)
  output$database_sample_dimplot <- renderPlot({
    DimPlot(st) + xlab("ST1") + ylab("ST2")
  })
})
